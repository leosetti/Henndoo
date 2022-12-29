//
//  Home.swift
//  Henndoo
//
//  Created by Leandro Setti de Almeida on 2022-07-16.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var popUpObject: PopUpObject
    
    var body: some View {
        var configuration = Configuration()
        var envName:String = ""
        
        VStack {
            Button(action: {
                envName = configuration.environment.name
                popUpObject.type = .info
                popUpObject.message = "popup_about_message \(Bundle.main.releaseVersionAndBuildNumberPretty) \(envName)"
                popUpObject.show.toggle()
                popUpObject.handler = {
                }
            }) {
                InfoLinkContent()
            }
            WelcomeText()
        }
        .padding()
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

fileprivate struct WelcomeText: View {
    var label: LocalizedStringKey = "welcome"
    var body: some View {
        Text(label)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

fileprivate struct InfoLinkContent: View {
    var label: LocalizedStringKey = "about"
    
    var body: some View {
        Text(label)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
    }
}
