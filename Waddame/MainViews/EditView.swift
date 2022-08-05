//
//  EditView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-08-05.
//

import SwiftUI

struct EditView: View {
    @Binding var rootIsActive : Bool
    
    var body: some View {
        ScrollView{
            VStack {
                EditText()
                UserForm(rootIsActive: self.$rootIsActive, type:.edit)
            }.padding()
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(rootIsActive: .constant(false))
    }
}

fileprivate struct EditText: View {
    var label: LocalizedStringKey = "edit_profile"
    var body: some View {
        Text(label)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}
