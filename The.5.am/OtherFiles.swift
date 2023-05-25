//
//  OtherFiles.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 18.05.2023.
//

import Foundation
import SwiftUI


struct ProfileButtonStyle : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25, weight: .medium, design: .rounded))
            .padding()
            .background(gradient)
            .foregroundColor(.black)
            .cornerRadius(10)
        
    }
}

struct InfoText : ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(RoundedTextMedium())
            .padding(.vertical)
            .padding(.horizontal, 20)
            .background(Color(UIColor.systemGray4))
            .clipShape(Capsule(style: .continuous))
            .opacity(0.9)
    }
}


struct ProfileFixtFieldStule : TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .modifier(RoundedTextMedium())
            .padding(.vertical)
            .padding(.horizontal, 20)
            .background(colorScheme == .light ? Color(UIColor.systemGray6) : Color(UIColor.systemGray4))
            .clipShape(Capsule(style: .continuous))
            .opacity(0.9)
    }
}

var gradient = LinearGradient(colors: [Color("5amBlue"), Color("5amYellow"), Color("5amRed")], startPoint: .leading, endPoint: .trailing)



struct RoundedTextLarge : ViewModifier {
    func body(content: Content) -> some View {
        @Environment(\.colorScheme) var colorScheme
        content
            .font(.system(size: 25, weight: .medium, design: .rounded))
    }
}


struct RoundedTextMedium : ViewModifier {
    func body(content: Content) -> some View {
        @Environment(\.colorScheme) var colorScheme
        content
            .font(.system(size: 20, weight: .medium, design: .rounded))
    }
}

struct RoundedTextSmall : ViewModifier {
    func body(content: Content) -> some View {
        @Environment(\.colorScheme) var colorScheme
        content
            .font(.system(size: 17, weight: .medium, design: .rounded))
    }
}


struct ButtonModifire : ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: screen.width * 0.75, height: 70)
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.vertical)
    }
}



func getFirthEightOrderId(id: String) -> String {
    id.components(separatedBy: "-")[0]
}
