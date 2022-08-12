//
//  String.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-08-12.
//

import SwiftUI

extension LocalizedStringKey {
    //var stringKey: String? {
       // Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value
    //}
}

extension String {
    static func localizedString(for key: String,
                                locale: Locale = .current) -> String {
        
        let language = locale.languageCode
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        
        return localizedString
    }
}

extension LocalizedStringKey {
    //func stringValue(locale: Locale = .current) -> String {
      //  return .localizedString(for: self.stringKey ?? "", locale: locale)
    //}
}
