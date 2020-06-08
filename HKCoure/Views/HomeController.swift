//
//  Home.swift
//  HKCoure
//
//  Created by Sebastian on 2/28/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI

struct HomeController: View {
    
    @EnvironmentObject var store: Store
    
    @State private var email: String = ""
    @State private var pass: String = ""
    

    
    var body: some View {
        ZStack {
            Group {
                if self.store.isLogged  && self.store.isPacient == false{
                    if self.store.showSubscriptionForm {
                        SubscriptionForm()
                            .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                            .animation(.customSpring)
                    }
                    else if self.store.serachView{
                        SearchView()
                        .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                        .animation(.customSpring)
                    }
                    else if self.store.addPacien{
                        FormView()
                        .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                        .animation(.customSpring)
                    }
                    else if self.store.showPacienteDetail {
                        PacienteDetailView()
                        .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                        .animation(.customSpring)
                    }
                    else if self.store.speechView {
                        SpeechView()
                        .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                        .animation(.customSpring)
                    }
                    else if self.store.listView{
                        PacientesListView()
                        .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                            .animation(.customSpring)
                    }
                    else if self.store.preguntasDemograficasView {
                        AnalyticsView()
                       .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                           .animation(.customSpring)
                    }
                    else if self.store.alarmView {
                            AlarmView()
                           .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                               .animation(.customSpring)
                    }
                    else if self.store.searchPacientDetail{
                        SearchPacienteDetailView()
                            .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                        .animation(.customSpring)
                    }
                    else if self.store.tiposAnalyticsView{
                        TiposAnaliticaView()
                            .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                        .animation(.customSpring)
                    }
                    else if self.store.preguntasOperativasView{
                        PreguntasOperativasView()
                            .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                        .animation(.customSpring)
                    }
                    else if self.store.preguntasSistemaView{
                        PreguntasSistemasViews()
                        .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                        .animation(.customSpring)
                    }
                    else {
                        HomeView(usuario: self.email)
                            .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                            .animation(.customSpring)
                            .edgesIgnoringSafeArea(.all)
                    }
                }
                else if self.store.isLogged && self.store.isPacient
                {
                    PacienteRolView()
                    .transition(AnyTransition.move(edge: .trailing).combined(with: AnyTransition.opacity))
                        .animation(.customSpring)
                }
                else {
                    Group {
                        LoginView()
                            .edgesIgnoringSafeArea(.all)
                    }
                    .transition(.move(edge: .leading))
                    .animation(.default)
                }
            }
        }
    }
    
}


