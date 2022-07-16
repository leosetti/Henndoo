//
//  AccountView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-16.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        VStack {
            AccountText()
        }
        .padding()
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

struct AccountText: View {
    var label: LocalizedStringKey = "my_account"
    var body: some View {
        Text(label)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}
