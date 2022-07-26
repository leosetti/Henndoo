//
//  Configuration.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-26.
//
import UIKit

enum Env: String {
    case Dev = "dev"
    case Testflight = "testflight"
    case Release = "release"

    var apiURL: String {
        switch self {
        case .Dev: return "http://local.waddame.ca:3900/api/"
        case .Testflight: return "https://staging-api.myservice.com"
        case .Release: return "https://api.myservice.com"
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
