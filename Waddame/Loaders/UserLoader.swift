//
//  UserLoader.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-23.
//

import Foundation

class UserLoader: ObservableObject {
    enum UserError: Error {
        case loading
        case fetching
    }
    
    typealias Handler = (Result<User, Error>) -> Void

    private let cache = Cache<String, User>()
    private var configuration = Configuration()

    func getUser(withID id: String,
                     then handler: @escaping Handler) {
        if let cached = cache[id] {
            return handler(.success(cached))
        }else{
            return handler(.failure(UserError.loading))
        }
    }
    
    func createUser(withUsername username: String, withEmail email:String, withPassword password:String, then handler: @escaping Handler) {
        let body: [String: Any] = [
            "username": username,
            "email": email,
            "password": password
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)

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
              
            guard let data = data, error == nil else {
                if AppUtil.isInDebugMode {
                    print(error?.localizedDescription ?? "No data")
                }
                handler(.failure(UserError.fetching))
                return
            }

            do {
              let userModel = try JSONDecoder().decode(User.self, from: data)
                handler(.success(userModel))
                
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
