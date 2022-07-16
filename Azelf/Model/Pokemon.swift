//
//  Pokemon.swift
//  Azelf
//
//  Created by Chamomile on 05/07/22.
//

import Foundation

struct Pokemon: Codable, Identifiable {
    let id: Int
    let name: String
    
    var imageName: String {
        if id < 10 {
            return "00\(id)"
        } else if id < 100 {
            return "0\(id)"
        } else {
            return "\(id)"
        }
    }
    
    var spriteName: String {
        if id < 10 {
            return "00\(id)MS"
        } else if id < 100 {
            return "0\(id)MS"
        } else {
            return "\(id)MS"
        }
    }
    
    static let allPokemon: [Pokemon] = Bundle.main.decode("pokedex.json")
    static let example = allPokemon[0]
}
