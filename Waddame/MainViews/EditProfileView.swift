//
//  EditProfileView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-08-10.
//

import SwiftUI

struct EditProfileView: View {
    @Binding var rootIsActive : Bool
    
    var editlabel: LocalizedStringKey = "edit_profile"
    var changepwdlabel: LocalizedStringKey = "change_password"
    
    var body: some View {
        List{
            NavigationLink(destination: ChangePassword(rootIsActive: $rootIsActive)) {
                Text(changepwdlabel)
                    .foregroundColor(.blue)
            }
            NavigationLink(destination: EditView(rootIsActive: $rootIsActive)) {
                Text(editlabel)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(rootIsActive: .constant(false))
    }
}
