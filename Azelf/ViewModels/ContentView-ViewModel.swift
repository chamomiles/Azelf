//
//  RoundView-ViewModel.swift
//  Azelf
//
//  Created by Chamomile on 12/07/22.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        let allPokemon: [Pokemon] = Bundle.main.decode("pokedex.json")
        
        let gens = [
            1: 151,
            2: 251,
            3: 386,
            4: 493,
            5: 649,
            6: 721,
            7: 809
        ]
        
        let gen: Int
        
        @Published var randomPokemonId = 0
        @Published var nameGuess = ""
        @Published var choices = [0, 3, 6, 25]
        
        @Published var roundLength = 20
        @Published var round = -1
        @Published var score = 0
        @Published var alreadyAppeared = [Int]()
        
        let timer = Timer.publish(every: 3, on: .main, in: .common)
        
        
        
        var randomPokemon: Pokemon {
            allPokemon[randomPokemonId]
        }
        
        var randomPokemonImage: String {
            randomPokemon.imageName
        }
        
        var correct: Bool {
            nameGuess == randomPokemon.name
        }
        
        var scoreText: String {
            "Score: \(score)/\(roundLength)"
        }
        
        var pokemonChoices: [String] {
            choices.map { allPokemon[$0].name }
        }
        
        
        
        
        init(gen: Int) {
            self.gen = gen
        }
        
        
        
        func generateChoices() {
            var choice1Id = 1
            var choice2Id = 1
            var choice3Id = 1
            
            while !(choice1Id != choice2Id && choice1Id != choice3Id && choice2Id != choice3Id) {
                choice1Id = Int.random(in: 0..<allPokemon.count)
                choice2Id = Int.random(in: 0..<allPokemon.count)
                choice3Id = Int.random(in: 0..<allPokemon.count)
            }
            
            choices = [choice1Id, choice2Id, choice3Id, randomPokemonId]
                .shuffled()
        }
        
        
        func nextPokemon() {
            // Update score
            if correct {
                score += 1
            }
            
            // End round
            if round == roundLength - 1 {
                endRound()
            }
            
            // Make pokemon not appear again
            alreadyAppeared.append(randomPokemonId)
            
            // Update pokemon
            while alreadyAppeared.contains(randomPokemonId) {
                randomPokemonId = Int.random(in: 0..<(gens[gen] ?? allPokemon.count))
            }
            // Azelf: 481
            // Nihilego: 792
            // Int.random(in: 0..<allPokemon.count)
            
            // Generate multiple choice
            generateChoices()
            
            
            // Reset temps
            nameGuess = ""
            round += 1
        }
        
        
        func endRound() {
            round = 0
            score = 0
            
            alreadyAppeared = []
        }
        
        
        func choose(_ num: Int) {
            nameGuess = pokemonChoices[num-1]
            nextPokemon()
        }
        
        
        func choice(_ num: Int) -> String {
            pokemonChoices[num-1]
        }
    }
}
