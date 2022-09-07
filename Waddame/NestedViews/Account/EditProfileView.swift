//
//  EditProfileView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-08-10.
//

import SwiftUI

struct EditProfileView: View {
    var editlabel: LocalizedStringKey = "edit_profile"
    var changepwdlabel: LocalizedStringKey = "change_password"
    
    var body: some View {
        List{
            NavView(content: {ChangePassword()}, text: changepwdlabel)
            NavView(content: {EditView()}, text: editlabel)
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
