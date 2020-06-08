//
//  Extensions.swift
//  HKCoure
//
//  Created by Sebastian on 2/28/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI



let deviceBounds = UIScreen.main.bounds

var resultsReady: Bool = false

var recognizedTextResults: [String] = [] {
    didSet {
        resultsReady = true
    }
}


extension Color {
    static func RGB ( red: Double, green: Double, blue: Double ) -> Color {
        return Color(red: red/255, green: green/255, blue: blue/255)
    }
    
    static let primaryRed = Color(#colorLiteral(red: 0.937254902, green: 0.2235294118, blue: 0.1607843137, alpha: 1))
    static let offRed = Color(#colorLiteral(red: 0.937254902, green: 0.3019607843, blue: 0.2392156863, alpha: 1))
    static let secondaryRed = Color(#colorLiteral(red: 1, green: 0.4196078431, blue: 0.3568627451, alpha: 1))
    static let lightRed = Color(#colorLiteral(red: 1, green: 0.4588235294, blue: 0.3960784314, alpha: 1))
    
    static let primaryBlue = Color(#colorLiteral(red: 0, green: 0.1204996991, blue: 0.8137750972, alpha: 1))
    static let offBlue = Color(#colorLiteral(red: 0.1830305225, green: 0.2889157588, blue: 0.9686274529, alpha: 1))
    static let secondaryBlue = Color(#colorLiteral(red: 0.1622640526, green: 0.3483627805, blue: 0.9686274529, alpha: 1))
    static let lightBlue = Color(#colorLiteral(red: 0.1622640526, green: 0.4399670939, blue: 0.9686274529, alpha: 1))
    
    
    static let primaryBlack = Color(#colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1))
    static let offBlack = Color(#colorLiteral(red: 0.2431185544, green: 0.2431511879, blue: 0.2431038618, alpha: 1))
    static let secondaryBlack = Color(#colorLiteral(red: 0.4823191166, green: 0.4823780656, blue: 0.4822927713, alpha: 1))
    
    static let primaryWhite = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    static let offWhite = Color(#colorLiteral(red: 0.9568627451, green: 0.9529411765, blue: 0.9764705882, alpha: 1))
    
}



extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}



struct DarkButtonStyle : ButtonStyle {
    var paddingHorizontal: CGFloat
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, 16)
            .contentShape(Capsule())
            .background(
                DarkBackground(isPressed: configuration.isPressed, shape: Capsule())
        )
    }
}

struct DarkButtonStyle2 : ButtonStyle {
    var paddingHorizontal: CGFloat
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, 16)
            .contentShape(Capsule())
            .background(
                DarkBackground2(isPressed: configuration.isPressed, shape: Capsule())
        )
    }
}


struct CardButtonStyle : ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Group {
            if configuration.isPressed {
                configuration.label
                    .frame(width: deviceBounds.width < 700 ? deviceBounds.width * 0.75 : deviceBounds.width * 0.6 , height: 60)
                .background( Color.primaryWhite.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.offWhite.opacity( 0.2), radius: 10, x: -5, y: -5)
                .shadow(color: Color.offWhite.opacity(0.7), radius: 10, x: 5, y: 5)
                .animation(nil)
            } else {
                configuration.label
                .frame(width: deviceBounds.width < 700 ? deviceBounds.width * 0.75 : deviceBounds.width * 0.6 , height: 60)
                .background( Color.primaryWhite)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                .animation(nil)
            }
        }
    }
}

struct CardButtonStylePequenio : ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Group {
            if configuration.isPressed {
                configuration.label
                    .frame(width: deviceBounds.width < 700 ? deviceBounds.width * 0.3 : deviceBounds.width * 0.3 , height: 40)
                .background( Color.primaryWhite.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.offWhite.opacity( 0.2), radius: 10, x: -5, y: -5)
                .shadow(color: Color.offWhite.opacity(0.7), radius: 10, x: 5, y: 5)
                .animation(nil)
            } else {
                configuration.label
                .frame(width: deviceBounds.width < 700 ? deviceBounds.width * 0.3: deviceBounds.width * 0.3 , height: 40)
                .background( Color.primaryWhite)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.primaryBlack.opacity( 0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.primaryWhite.opacity( 0.7), radius: 10, x: -5, y: -5)
                .animation(nil)
            }
        }
    }
}

extension Animation {
    static let customSpring =  Animation.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)
}



func hideKeyboard() -> Void {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
}



private struct DarkBackground <S: Shape> : View {
    var isPressed: Bool
    var shape: S
    var body: some View {
        ZStack {
            if isPressed {
                shape
                    .fill(LinearGradient(Color.primaryRed, Color.offRed))
                    .overlay(shape.stroke(LinearGradient(Color.primaryRed, Color.primaryRed), lineWidth: 4))
                    .shadow(color: Color.lightRed.opacity(0.7), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.primaryBlack.opacity(0.2), radius: 10, x: -5, y: -5)
            } else {
                shape
                    .fill(LinearGradient(Color.offRed, Color.primaryRed))
                    .overlay(shape.stroke(Color.secondaryRed, lineWidth: 4))
                    .shadow(color: Color.primaryBlack.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.lightRed.opacity(0.7), radius: 10, x: -5, y: -5)
            }
        }
    }
}

private struct DarkBackground2 <S: Shape> : View {
    var isPressed: Bool
    var shape: S
    var body: some View {
        ZStack {
            if isPressed {
                shape
                    .fill(LinearGradient(Color.primaryBlue, Color.offBlue))
                    .overlay(shape.stroke(LinearGradient(Color.primaryBlue, Color.primaryBlue), lineWidth: 4))
            } else {
                shape
                    .fill(LinearGradient(Color.offBlue, Color.primaryBlue))
                    .overlay(shape.stroke(Color.secondaryBlue, lineWidth: 4))
            }
        }
    }
}
