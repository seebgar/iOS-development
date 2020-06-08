//
//  ProfileView.swift
//  HKCoure
//
//  Created by Sebastian on 2/29/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                VStack {
                    Text("Julián Echavarría").font(.system(size: 32))
                        .foregroundColor(.primaryBlack)
                    Text("julianeche").font(.subheadline)
                        .foregroundColor(.offBlack)
                }
                .frame(maxWidth: .infinity)
                .offset(y: -20)
                
//                MenuRow(forIcon: "square.and.pencil", withLabel: "Una opción")
//                Divider()
//                MenuRow(forIcon: "creditcard", withLabel: "Otra opción")
//                Divider()
                MenuRow(forIcon: "person.circle", withLabel: "Cerrar sesión").onTapGesture {
                    self.store.isLogged = false
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 380)
            .background(Color.primaryWhite)
            .shadow(radius: 20)
            .overlay(ProfileImage().offset(x: 0, y: -190))
        }
        .padding(.bottom, -40)
    }
}


struct MenuRow: View {
    var label: String
    var icon: String
    
    init(forIcon icon: String, withLabel label: String) {
        self.label = label
        self.icon = icon
    }
    
    var body: some View {
        HStack (spacing: 16) {
            Image(systemName: self.icon)
                .font(.system(size: 20, weight: .regular))
                .imageScale(.large)
                .frame(width: 32, height: 32)
                .foregroundColor(.offRed)
            
            Text(self.label)
                .font(.system(size: 16))
                .frame(width: 120, alignment: .leading)
                .foregroundColor(.primaryBlack)
        }
    }
}

struct ProfileImage: View {
    var body: some View {
//        Image("profile")
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//            .frame(width: 120, height: 120, alignment: .center)
//            .clipShape(Circle())
//            .overlay(Circle().stroke(Color.secondaryRed, lineWidth: 4))
//            .shadow(radius: 10)
        VStack {
            Spacer()
        }
    }
}
