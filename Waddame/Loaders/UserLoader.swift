//
//  UserLoader.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-23.
//

import Foundation
import SwiftUI

class UserLoader: ObservableObject {
    enum UserError: Error {
        case loading
        case fetching
        case encoding
        case data(String)
        case unauthorized
    }
    
    typealias Handler = (Result<User, Error>) -> Void
    
    @AppStorage("tokenString") private var tokenString = ""
    private let cache = Cache<String, User>()
    private var configuration = Configuration()
    
    func getUserToken() -> UserToken? {
        do {
            let tokenDictionary = try decode(jwtToken: tokenString)
            let jsonToken = try JSONSerialization.data(withJSONObject: tokenDictionary)
            let tokenObject = try JSONDecoder().decode(UserToken.self, from: jsonToken)
            return tokenObject
        } catch {
            return nil
        }
    }
    
    func findUser(id: String, completion: @escaping (Bool) -> Void) {
        getUser(withID: id, then: { result in
            if case .success = result {
                DispatchQueue.main.async() {
                    completion(true)
                }
            }
            if case .failure = result {
                DispatchQueue.main.async() {
                    completion(false)
                }
            }
        })
    }
    
    func getUser(withID id: String,
        then handler: @escaping Handler) {

        if let cached = cache[id] {
            return handler(.success(cached))
        }else{
            try? self.cache.readFromDisk(withName: "users", andInitializer: {
                data in
                do {
                    let user = try User.init(data: data)
                    return user
                } catch {
                    if AppUtil.isInDebugMode {
                        print(error)
                    }
                }
                return nil
            })
            if let cached = cache[id] {
                return handler(.success(cached))
            }else{
                return handler(.failure(UserError.loading))
            }
        }
    }
    
    func createUser(withObject object:[String: Any], then handler: @escaping Handler) {
        let jsonData = try? JSONSerialization.data(withJSONObject: object)

        let urlString = configuration.environment.apiURL + "users"
        if AppUtil.isInDebugMode {
            print("URLString = \(urlString)")
        }
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if AppUtil.isInDebugMode {
                print("-----> data: \(String(describing: data))")
                print("-----> error: \(String(describing: error))")
            }
            
            if let httpUrlResponse = response as? HTTPURLResponse
            {
                if let bearer:String = httpUrlResponse.allHeaderFields["Authorization"] as? String{
                    let bearerComponents = bearer.components(separatedBy: " ")
                    if (bearerComponents.count > 1){
                        let token = bearerComponents[1]
                        DispatchQueue.main.async() {
                            self.tokenString = token
                        }
                    }
                }
            }
              
            guard let data = data, error == nil else {
                if AppUtil.isInDebugMode {
                    print(error?.localizedDescription ?? "No data")
                }
                handler(.failure(UserError.fetching))
                return
            }

            do {
                let userModel = try JSONDecoder().decode(User.self, from: data)
                self.cache["self"] = userModel
                try self.cache.saveToDisk(withName: "users")
                handler(.success(userModel))
                
            } catch let err as EncodingError {
                if AppUtil.isInDebugMode {
                    print("JSON encoding error: \(err.localizedDescription)")
                }
                handler(.failure(UserError.encoding))
                return
            } catch let jsonError as NSError {
                if AppUtil.isInDebugMode {
                    print("JSON decode failed: \(jsonError.localizedDescription)")
                }
                handler(.failure(UserError.fetching))
                return
            }
        }
          
        task.resume()
    }
    
    func editUser(withObject object:[String: Any], then handler: @escaping Handler) {
        let jsonData = try? JSONSerialization.data(withJSONObject: object)

        let urlString = configuration.environment.apiURL + "users"
        if AppUtil.isInDebugMode {
            print("URLString = \(urlString)")
        }
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenString)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if AppUtil.isInDebugMode {
                print("-----> data: \(String(describing: data))")
                print("-----> error: \(String(describing: error))")
            }
            
            if let httpUrlResponse = response as? HTTPURLResponse
            {
                if let bearer:String = httpUrlResponse.allHeaderFields["Authorization"] as? String{
                    let bearerComponents = bearer.components(separatedBy: " ")
                    if (bearerComponents.count > 1){
                        let token = bearerComponents[1]
                        DispatchQueue.main.async() {
                            self.tokenString = token
                        }
                    }
                }
            }
              
            guard let data = data, error == nil else {
                if AppUtil.isInDebugMode {
                    print(error?.localizedDescription ?? "No data")
                }
                handler(.failure(UserError.fetching))
                return
            }

            do {
                let userModel = try JSONDecoder().decode(User.self, from: data)
                self.cache["self"] = userModel
                try self.cache.saveToDisk(withName: "users")
                handler(.success(userModel))
                
            } catch let err as EncodingError {
                if AppUtil.isInDebugMode {
                    print("JSON encoding error: \(err.localizedDescription)")
                }
                handler(.failure(UserError.encoding))
                return
            } catch let jsonError as NSError {
                if AppUtil.isInDebugMode {
                    print("JSON decode failed: \(jsonError.localizedDescription)")
                }
                handler(.failure(UserError.fetching))
                return
            }
        }
          
        task.resume()
    }
    
    func deleteUser(then handler: @escaping Handler) {
        let urlString = configuration.environment.apiURL + "users"
        if AppUtil.isInDebugMode {
            print("URLString = \(urlString)")
        }
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(tokenString)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if AppUtil.isInDebugMode {
                print("-----> data: \(String(describing: data))")
                print("-----> error: \(String(describing: error))")
            }
              
            guard let data = data, error == nil else {
                if AppUtil.isInDebugMode {
                    print(error?.localizedDescription ?? "No data")
                }
                handler(.failure(UserError.fetching))
                return
            }

            do {
                let userModel = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async() {
                    self.tokenString = ""
                }
                self.cache["self"] = nil
                try self.cache.saveToDisk(withName: "users")
                handler(.success(userModel))
            } catch let err as EncodingError {
                if AppUtil.isInDebugMode {
                    print("JSON encoding error: \(err.localizedDescription)")
                }
                handler(.failure(UserError.encoding))
                return
            } catch let jsonError as NSError {
                if AppUtil.isInDebugMode {
                    print("JSON decode failed: \(jsonError.localizedDescription)")
                }
                handler(.failure(UserError.fetching))
                return
            }
        }
          
        task.resume()
    }
    
    func logoutUser() {
        self.tokenString = ""
        self.cache.removeValue(forKey: "self")
        
        do {
            try self.cache.saveToDisk(withName: "users")
        } catch let jsonError as NSError {
            if AppUtil.isInDebugMode {
                print("JSON decode failed: \(jsonError.localizedDescription)")
            }
        }
    }
    
    func loginUser(withObject object:[String: Any], then handler: @escaping Handler) {
        let jsonData = try? JSONSerialization.data(withJSONObject: object)

        let urlString = configuration.environment.apiURL + "user"
        if AppUtil.isInDebugMode {
            print("URLString = \(urlString)")
        }
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if(data != nil){
                do {
                    let errorModel = try JSONDecoder().decode(MongooseError.self, from: data!)
                    if let path = errorModel.details.first?.path[0] {
                        handler(.failure(UserError.data(path)))
                        return
                    }
                } catch  {}
            }
            
            if let httpUrlResponse = response as? HTTPURLResponse
            {
                if httpUrlResponse.statusCode != 200 {
                    if httpUrlResponse.statusCode == 401 {
                        handler(.failure(UserError.unauthorized))
                    }else{
                        handler(.failure(UserError.fetching))
                    }
                    return
                }
                
                if let bearer:String = httpUrlResponse.allHeaderFields["Authorization"] as? String{
                    let bearerComponents = bearer.components(separatedBy: " ")
                    DispatchQueue.main.async() {
                        if (bearerComponents.count > 1){
                        let token = bearerComponents[1]
                            self.tokenString = token
                        }
                    }
                }
            }
              
            guard let data = data, error == nil else {
                if AppUtil.isInDebugMode {
                    print(error?.localizedDescription ?? "No data")
                }
                handler(.failure(UserError.fetching))
                return
            }

            do {
                let userModel = try JSONDecoder().decode(User.self, from: data)
                self.cache["self"] = userModel
                try self.cache.saveToDisk(withName: "users")
                handler(.success(userModel))
                
            } catch let err as EncodingError {
                if AppUtil.isInDebugMode {
                    print("JSON encoding error: \(err.localizedDescription)")
                }
                handler(.failure(UserError.encoding))
                return
            } catch let jsonError as NSError {
                if AppUtil.isInDebugMode {
                    print("JSON decode failed: \(jsonError.localizedDescription)")
                }
                handler(.failure(UserError.fetching))
                return
            }
        }
          
        task.resume()
    }
}
