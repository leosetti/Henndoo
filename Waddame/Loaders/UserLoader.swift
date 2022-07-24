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

        let url = URL(string: "http://local.waddame.ca:3900/api/users")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("-----> data: \(String(describing: data))")
            print("-----> error: \(String(describing: error))")
              
              guard let data = data, error == nil else {
                  print(error?.localizedDescription ?? "No data")
                  handler(.failure(UserError.fetching))
                  return
              }

              let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
              print("-----1> responseJSON: \(String(describing: responseJSON))")
            
              if let responseJSON = responseJSON as? User {
                  print("-----2> responseJSON: \(responseJSON)")
                  handler(.success(responseJSON))
              }
          }
          
          task.resume()
    }
}
