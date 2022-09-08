//
//  DeeplinkManager.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-09-08.
//
import Foundation

class DeeplinkManager {
    class DeepLinkConstants {
        static let scheme = "cws"
        static let host = "com.waddame"
        static let detailsPath = "/resetpassword"
        static let query = "token"
    }
    
    func manage(url: URL) -> Screen {
        guard url.scheme == DeepLinkConstants.scheme,
              url.host == DeepLinkConstants.host,
              url.path == DeepLinkConstants.detailsPath,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems
        else { return .login }
        
        let query = queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
        
        guard let id = query[DeepLinkConstants.query] else { return .login }
        
        return .resetPassword(token: id)
    }
}

