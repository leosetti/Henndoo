//
//  PopUpWindow.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-08-05.
//

import SwiftUI

enum PopUpWindowType {
    case success
    case warning
    case error
}

struct PopUpWindow: View {
    typealias Handler = () -> Void
    
    var type: PopUpWindowType = .error
    var message: LocalizedStringKey
    var buttonText: String
    let cancelButtonText: LocalizedStringKey = "cancel"
    var handler: Handler
    
    @Binding var show: Bool
    @State var topImage: Image = Image(systemName: "exclamationmark.circle")
    @State var topImageColor: Color = Color.red
    @State var dividerColor: Color = lightRedColor
    @State var textForegroundColor: Color = Color.red
    @State var buttonColor: Color = darkRedColor
    @State var cancelButtonColor: Color = darkRedColor
    @State var buttonTextColor: Color = Color.white
    @State var cancelButtonTextColor: Color = Color.white
    @State var borderColor: Color = Color.red

    var body: some View {
        ZStack {
            if show {
                // PopUp background color
                Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)

                // PopUp Window
                VStack(alignment: .center, spacing: 0) {
                    topImage
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding()
                        .foregroundColor(topImageColor)
                    
                    Divider()
                     .frame(height: 1)
                     .padding(.horizontal, 30)
                     .background(dividerColor)

                    Text(message)
                        .multilineTextAlignment(.center)
                        .font(Font.system(size: 16, weight: .semibold))
                        .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
                        .foregroundColor(textForegroundColor)

                    Button(action: {
                        // Dismiss the PopUp
                        handler()
                        withAnimation(.linear(duration: 0.3)) {
                            show = false
                        }
                    }, label: {
                        Text(buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54, alignment: .center)
                            .foregroundColor(buttonTextColor)
                            .background(buttonColor)
                            .font(Font.system(size: 23, weight: .semibold))
                    }).buttonStyle(PlainButtonStyle())
                    
                    if type == .warning {
                        Button(action: {
                            // Dismiss the PopUp
                            withAnimation(.linear(duration: 0.3)) {
                                show = false
                            }
                        }, label: {
                            Text(cancelButtonText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54, alignment: .center)
                                .foregroundColor(cancelButtonTextColor)
                                .background(cancelButtonColor)
                                .font(Font.system(size: 23, weight: .semibold))
                        }).buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(maxWidth: 300)
                .border(borderColor, width: 2)
                .background(lightGreyColor)
                .onAppear() {
                    switch type {
                    case .success:
                        topImage = Image(systemName: "checkmark.circle")
                        topImageColor = Color.green
                        dividerColor = lightGreenColor
                        textForegroundColor = Color.green
                        buttonColor = darkGreenColor
                        buttonTextColor = Color.white
                        borderColor = Color.green
                    case .warning:
                        topImage = Image(systemName: "info.circle")
                        topImageColor = Color.yellow
                        dividerColor = lightYellowColor
                        textForegroundColor = Color.gray
                        buttonColor = darkYellowColor
                        buttonTextColor = Color.gray
                        borderColor = Color.yellow
                    case .error:
                        topImage = Image(systemName: "exclamationmark.circle")
                        topImageColor = Color.red
                        dividerColor = lightRedColor
                        textForegroundColor = Color.red
                        buttonColor = darkRedColor
                        buttonTextColor = Color.white
                        borderColor = Color.red
                    }
                }
            }
        }
       
    }
}

struct PopUpWindow_Previews: PreviewProvider {
    static var previews: some View {
        PopUpWindow(type: .warning, message: "Sorry, that email address is already used!", buttonText: "OK", handler: {}, show: .constant(true))
    }
}
