//
//  AlarmView.swift
//  HKCoure
//
//  Created by Pipe on 26/04/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//
import UIKit
import SwiftUI
import AudioToolbox

struct AlarmView: View {
    
    @EnvironmentObject var store: Store
    
    
    var body: some View {
        VStack{
            Spacer()
            Text("¡Pidiendo ayuda!")
                .foregroundColor(Color.primaryWhite)
                .font(.system(size: 60, weight: .bold))
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: {
                self.store.alarmView = false
            })
            {
                Text("Estoy bien")
                .foregroundColor(Color.black)
            }.buttonStyle(CardButtonStyle())
            Color.primaryRed.edgesIgnoringSafeArea(.all)
            
            }.background(HStack{Color.primaryRed.edgesIgnoringSafeArea(.all)})
            .onAppear{
                self.vibrar()
        }
        
    }
    
    func vibrar(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
