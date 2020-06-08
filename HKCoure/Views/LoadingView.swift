//
//  LoadingView.swift
//  HKCoure
//
//  Created by Sebastian on 2/29/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Image(systemName: "doc.text.viewfinder")
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
                .foregroundColor(.primaryWhite)
            Text("Procesando").font(.title).foregroundColor(.primaryWhite).bold()
        }
        .frame(maxWidth: .infinity )
        .frame(maxHeight: .infinity)
        .background(Color.offBlack.opacity(0.5))
        .onAppear {
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
