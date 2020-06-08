//
//  TiposAnaliticaView.swift
//  HKCoure
//
//  Created by Pipe on 1/06/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import Foundation
import SwiftUI

struct TiposAnaliticaView: View{
    
    @EnvironmentObject var store: Store
    
    var body: some View{
        VStack{
            HStack{
                Button(action: {
                    self.store.tiposAnalyticsView = false
                    
                }) {
                    Text("Volver").foregroundColor( Color.red)
                }
                Spacer()
            }.padding(.horizontal).padding(.top, 16)
            
            Divider()
            
            Spacer()
            
            VStack(spacing: 50){
                Button(action: {
                    self.store.tiposAnalyticsView = false
                    self.store.preguntasSistemaView = true
                    //self.store.analyticsView = true
                    
                }) {
                    Text("Preguntas de sistema")
                        .foregroundColor(.primaryBlack)
                        .bold()
                }.buttonStyle(CardButtonStyle())
                Button(action: {
                    self.store.tiposAnalyticsView = false
                    self.store.preguntasDemograficasView = true
                    //self.store.analyticsView = true
                    
                }) {
                    Text("Preguntas demográficas")
                        .foregroundColor(.primaryBlack)
                        .bold()
                }.buttonStyle(CardButtonStyle())
                Button(action: {
                    self.store.preguntasOperativasView = true
                    self.store.tiposAnalyticsView = false
                    //self.store.analyticsView = true
                    
                }) {
                    Text("Preguntas operativas")
                        .foregroundColor(.primaryBlack)
                        .bold()
                }.buttonStyle(CardButtonStyle())
            }
            Spacer()
        }
    }
}
