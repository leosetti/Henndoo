//
//  MainView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-16.
//

import SwiftUI

struct MainView: View {
    var homelabel: LocalizedStringKey = "home"
    var peofilelabel: LocalizedStringKey = "profile"
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label(homelabel, systemImage: "house")
                }

            AccountView()
                .tabItem {
                    Label(peofilelabel, systemImage: "person.crop.circle")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
