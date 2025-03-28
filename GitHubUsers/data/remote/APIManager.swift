//
//  APIManager.swift
//  GitHubUsers
//
//  Created by Nguyen Tien Duc on 28/3/25.
//

import Foundation

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

struct ErrorModel: Decodable {
    let message: String
    let documentation_url: String?
}

enum APIError: Error {
    case invalidURL
    case requestFailed(statusCode: Int, error: ErrorModel?)
    case invalidData
    case decodingError(Error)
    case other(Error)
}

protocol APIManager {
    func get<T: Decodable>(url: URL, headers: [String: String]?) async throws -> T

    func post<T: Decodable>(url: URL, body: Data?, headers: [String: String]?) async throws -> T

    func put<T: Decodable>(url: URL, body: Data?, headers: [String: String]?) async throws -> T

    func patch<T: Decodable>(url: URL, body: Data?, headers: [String: String]?) async throws -> T

    func delete<T: Decodable>(url: URL, headers: [String: String]?) async throws -> T
}


class APIManagerImpl : APIManager {
    static let shared = APIManagerImpl()

    private init() {}

    private func makeRequest(url: URL, method: HTTPMethod, body: Data? = nil, headers: [String: String]? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        if body != nil && headers?["Content-Type"] == nil {
            request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }

    private func handleErrorResponse(statusCode: Int, data: Data) throws -> Never {
        if (400...499).contains(statusCode) {
            do {
                let errorModel = try JSONDecoder().decode(ErrorModel.self, from: data)
                throw APIError.requestFailed(statusCode: statusCode, error: errorModel)
            } catch {
                throw APIError.requestFailed(statusCode: statusCode, error: nil)
            }
        }
        throw APIError.requestFailed(statusCode: statusCode, error: nil)
    }

    func fetchData<T: Decodable>(url: URL, method: HTTPMethod = .get, body: Data? = nil, headers: [String: String]? = nil) async throws -> T {
        let request = makeRequest(url: url, method: method, body: body, headers: headers)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidData
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            try handleErrorResponse(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw APIError.decodingError(error)
        }
    }
}

// impl APIManager
extension APIManagerImpl {
    func get<T: Decodable>(url: URL, headers: [String: String]? = nil) async throws -> T {
        return try await fetchData(url: url, method: .get, headers: headers)
    }

    func post<T: Decodable>(url: URL, body: Data?, headers: [String: String]? = nil) async throws -> T {
        return try await fetchData(url: url, method: .post, body: body, headers: headers)
    }

    func put<T: Decodable>(url: URL, body: Data?, headers: [String: String]? = nil) async throws -> T {
        return try await fetchData(url: url, method: .put, body: body, headers: headers)
    }

    func patch<T: Decodable>(url: URL, body: Data?, headers: [String: String]? = nil) async throws -> T {
        return try await fetchData(url: url, method: .patch, body: body, headers: headers)
    }

    func delete<T: Decodable>(url: URL, headers: [String: String]? = nil) async throws -> T {
        return try await fetchData(url: url, method: .delete, headers: headers)
    }
}
