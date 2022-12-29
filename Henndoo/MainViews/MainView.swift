//
//  MainView.swift
//  Henndoo
//
//  Created by Leandro Setti de Almeida on 2022-07-16.
//

import SwiftUI

struct MainView: View {
    var homelabel: LocalizedStringKey = "home"
    var peofilelabel: LocalizedStringKey = "profile"
    @State var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(homelabel, systemImage: "house")
                }.tag("Home")

            AccountView()
                .tabItem {
                    Label(peofilelabel, systemImage: "person.crop.circle")
                }.tag("Account")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
