//
//  AppUtil.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-26.
//

struct AppUtil {
    /**
     Return true is application is running in `Debug Mode`; otherwise, return false.
     */
    static var isInDebugMode: Bool {
        // I will explain later about this implementation.
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}
