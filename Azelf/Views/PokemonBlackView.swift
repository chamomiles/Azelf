//
//  PokemonBlackView.swift
//  Azelf
//
//  Created by Chamomile on 11/07/22.
//

import SwiftUI

struct PokemonBlackView: View {
    let image: String
    let pokemonRevealed: Bool
    
    var body: some View {
        ZStack {
            RadialGradient(colors: [.white, .blue], center: .center, startRadius: 100, endRadius: 200)
                .frame(width: 331, height: 331)
                .clipShape(RoundedRectangle(cornerRadius: 70))
            
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .padding()
                .colorMultiply(pokemonRevealed ? .primary : .black)
                .shadow(radius: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 70, style: .continuous)
                        .stroke(.primary, lineWidth: 2.5)
                )
    }
}
    
    init(image: String, pokemonRevealed: Bool) {
        self.image = image
        self.pokemonRevealed = pokemonRevealed
    }
}



struct PokemonBlackView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonBlackView(image: "482", pokemonRevealed: false)
            .preferredColorScheme(.dark)
    }
}
