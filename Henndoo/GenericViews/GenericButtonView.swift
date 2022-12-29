//
//  GenericButtonView.swift
//  Henndoo
//
//  Created by Leandro Setti de Almeida on 2022-09-05.
//

import SwiftUI

struct GenericButtonView: View {
    var label: LocalizedStringKey = "signup_action"
    
    var body: some View {
        Text(label)
            .textCase(.uppercase)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

struct GenericButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GenericButtonView()
    }
}
