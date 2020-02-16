//
//  NetworkService.swift
//  TReader
//
//  Created by tadas on 2020-02-16.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift

enum NetworkError: LocalizedError {
    case response(String), requestFormat(String), parsingError(DecodingError), HTTPCode(Int, String)

    var errorDescription: String? {
        switch self {
        case .response(let desc): return "Response error: \(desc)"
        case .requestFormat(let desc): return "Request error: \(desc)"
        case .parsingError(let error): return "Response parsing error: \(error)"
        case .HTTPCode(let code, let response): return "Server error code: \(code), response: \(response)"
        }
    }
}


class NetworkService {
    private let url: String
    private let disposeBag = DisposeBag()

    init(url: String) {
        self.url = url
    }

    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }

    func request<T>(path: String,
                    method: HTTPMethod = .get,
                    data: Encodable? = nil) -> Single<T> where T: Decodable {

        var urlComponents = URLComponents(string: "\(self.url)/\(path)")!
        var req = URLRequest(url: urlComponents.url!)
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = method.rawValue

        switch method {
        case .post, .put, .delete:
            req.httpBody = data?.jsonDataOrNil()
        case .get:
            let data = try? data?.asDictionary()
            let queryItems = data?.compactMap { pair -> URLQueryItem? in
                guard let value = String.fromAny(any: pair.value) else { return nil }
                return URLQueryItem(name: pair.key, value: value)
            }
            urlComponents.queryItems = queryItems
            req.url = urlComponents.url!
        }

        return Single.create { single in
            URLSession.shared.dataTask(with: req) { data, response, error in
                do {
                    if let error = error {
                        throw error
                    }
                    guard let code = (response as? HTTPURLResponse)?.statusCode else {
                        throw NetworkError.response("No status code")
                    }
                    guard let data = data, let str = String(data: data, encoding: .utf8) else {
                        throw NetworkError.response("Failed to convert response data to string")
                    }
                    if code < 200 || code >= 300 {
                        throw NetworkError.HTTPCode(code, str)
                    } else if code == 204 {
                        return single(.success(try T(json: "{}")))
                    }
                    do {
                        single(.success(try T(data: data)))
                    } catch {
                        if let error = error as? DecodingError {
                            throw NetworkError.parsingError(error)
                        } else {
                            throw NetworkError.response("Failed to create dto object. Please check reponse.")
                        }
                    }
                } catch {
                    single(.error(error))
                }
            }.resume()
            return Disposables.create()
        }
    }
}

extension String {
    fileprivate static func fromAny(any: Any) -> String? {
        switch any {
        case let any as Int: return String(any)
        case let any as Double: return String(any)
        case let any as Float: return String(any)
        case let any as Bool: return String(any)
        case let any as String: return any
        default: return nil
        }
    }
}
