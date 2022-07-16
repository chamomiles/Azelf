//
//  SealView.swift
//  Azelf
//
//  Created by Chamomile on 13/07/22.
//

import SwiftUI

struct SealView: View {
    let seal: (String, Color)
    let showingTips: Bool
    
    var body: some View {
        if showingTips {
            ZStack {
                Image(systemName: "seal")
                    .font(.system(size: 45))
                    .opacity(seal.0 == "" ? 0 : 1) // hides the seal on first pokemon
                
                Text(seal.0)
                    .font(.title).bold()
                    .foregroundColor(seal.1)
                    .offset(x: 0.5) // centers the letter inside seal
            }
            .tooltip(.top) {
                Text("Your grade")
                    .font(.body).bold()
                    .frame(width: 90, height: 20)
                    .padding(3)
            }
        } else {
            ZStack {
                Image(systemName: "seal")
                    .font(.system(size: 45))
                    .opacity(seal.0 == "" ? 0 : 1)
                
                Text(seal.0)
                    .font(.title).bold()
                    .foregroundColor(seal.1)
                    .offset(x: 0.5)
            }
        }
    }
    
    init(_ seal: (String, Color), showingTips: Bool) {
        self.seal = seal
        self.showingTips = showingTips
    }
}

struct Seal_Previews: PreviewProvider {
    static var previews: some View {
        SealView(("S", .cyan), showingTips: true)
            .preferredColorScheme(.dark)
    }
}
