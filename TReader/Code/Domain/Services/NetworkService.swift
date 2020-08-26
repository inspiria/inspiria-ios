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
    let url: String
    private let disposeBag = DisposeBag()
    private let authorization: Authorization?

    init(url: String, authorization: Authorization? = nil) {
        self.url = url
        self.authorization = authorization
    }

    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }

    enum ContentType: String {
        case json = "application/json"
        case urlencoded = "application/x-www-form-urlencoded"
    }

    func request<T>(path: String,
                    method: HTTPMethod = .get,
                    contentType: ContentType = .json,
                    data: Encodable? = nil) -> Single<T> where T: Decodable {
        if let auth = authorization {
            return auth.accessToken()
                .flatMap { token -> Single<T> in
                    self.request(path: path,
                                 method: method,
                                 contentType: contentType,
                                 data: data,
                                 authorizationToken: token)
            }
        } else {
            return request(path: path, method: method, contentType: contentType, data: data, authorizationToken: nil)
        }
    }

    func request<T>(path: String,
                    method: HTTPMethod,
                    contentType: ContentType,
                    data: Encodable?,
                    authorizationToken: String?) -> Single<T> where T: Decodable {

        let urlComponents = URLComponents(string: "\(self.url)/\(path)", method: method, data: data)!
        var req = URLRequest(url: urlComponents.url!)
        req.httpMethod = method.rawValue
        req.httpBody = data?.httpBody(method: method, contentType: contentType)
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        if let token = authorizationToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return Single.create { single in
            URLSession.shared.dataTask(with: req) { data, response, error in
                do {
                    if let error = error {
                        throw error
                    }
                    guard let response = response as? HTTPURLResponse else {
                        throw NetworkError.response("Not HTTPURLResponse")
                    }
                    if response.statusCode < 200 || response.statusCode >= 300 {
                        let str = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                        throw NetworkError.HTTPCode(response.statusCode, str)
                    }
                    guard let data = data else {
                        throw NetworkError.response("Failed to retrieve response data")
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
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
    }

    func fileRequest(path: String) -> Observable<FileProgress> {
        let url = URLComponents(string: "\(self.url)/\(path)")!.url!
        var req = URLRequest(url: url)
        req.httpMethod = HTTPMethod.get.rawValue
        var observation: NSKeyValueObservation?

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)

        return Observable.create { observable in
            let task = session.dataTask(with: req) { data, response, error in
                do {
                    if let error = error {
                        throw error
                    }
                    guard let response = response as? HTTPURLResponse else {
                        throw NetworkError.response("Not HTTPURLResponse")
                    }
                    if response.statusCode < 200 || response.statusCode >= 300 {
                        let str = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                        throw NetworkError.HTTPCode(response.statusCode, str)
                    }
                    guard let data = data else {
                        throw NetworkError.response("Failed to retrieve response data")
                    }
                    let file = FileProgress(progress: 1.0, data: data)
                    observable.onNext(file)
                    observable.onCompleted()
                } catch {
                    observable.onError(error)
                }
            }
            observation = task.progress.observe(\.fractionCompleted) { progress, _ in
                if progress.fractionCompleted < 1.0 {
                    observable.onNext(FileProgress(progress: progress.fractionCompleted, data: nil))
                }
            }
            task.resume()
            return Disposables.create()
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
    }
}

fileprivate extension String {
    static func fromAny(any: Any) -> String? {
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

fileprivate extension Encodable {
    func httpBody(method: NetworkService.HTTPMethod, contentType: NetworkService.ContentType) -> Data? {
        switch method {
        case .post, .put, .delete:
            switch contentType {
            case .json:
                return self.jsonDataOrNil()
            case .urlencoded:
                var components = URLComponents()
                components.queryItems = self.asQueryItems()
                let str = components.url?.absoluteString.dropFirst()
                return str?.data(using: .utf8)
            }
        default:
            return nil
        }
    }

    func asQueryItems() -> [URLQueryItem]? {
        let data = try? self.asDictionary()
        return data?.compactMap { pair -> URLQueryItem? in
            guard let value = String.fromAny(any: pair.value) else { return nil }
            return URLQueryItem(name: pair.key, value: value)
        }
    }
}

fileprivate extension URLComponents {
    init?(string: String, method: NetworkService.HTTPMethod, data: Encodable?) {
        self.init(string: string)
        switch method {
        case .get:
            self.queryItems = data?.asQueryItems()
        default:
            break
        }
    }
}
