//
//  Configuration.swift
//  Henndoo
//
//  Created by Leandro Setti de Almeida on 2022-07-26.
//
import UIKit

enum Env: String {
    case Dev = "dev"
    case Testflight = "testflight"
    case Release = "release"
    
    var name: String {
        switch self {
        case .Dev: return "DEV"
        case .Testflight: return "Testflight"
        case .Release: return "RELEASE"
        }
    }

    var apiURL: String {
        switch self {
        case .Dev: return "http://local.henndoo.ca:3900/api/"
        case .Testflight: return "https://dev.henndoo.ca/api/"
        case .Release: return "https://henndoo.ca/api/"
        }
    }
}

struct Configuration {
    lazy var environment: Env = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            if configuration.contains("Dev") {
                return Env.Dev
            }
            if configuration.contains("Testflight") {
                return Env.Testflight
            }
        }

        return Env.Release
    }()
}
