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
}
