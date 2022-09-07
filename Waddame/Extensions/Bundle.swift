//
//  Bundle.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-09-07.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0")"
    }
    
    var releaseVersionAndBuildNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0") build\(buildVersionNumber ?? "1")"
    }
}


