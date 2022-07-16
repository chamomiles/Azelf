//
//  ViewModel.swift
//  Azelf
//
//  Created by Chamomile on 13/07/22.
//

import Combine
import Foundation
import SwiftUI

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        let allPokemon: [Pokemon] = Bundle.main.decode("pokedex.json")
        
        let gens = [
            // gen 8 was not in the repo, I decided to leave that as is
            
            "all": 0...808,
            
            // only one gen
            "1": 0...150,
            "2": 151...250,
            "3": 251...385,
            "4": 386...492,
            "5": 493...648,
            "6": 649...720,
            "7": 721...808,
            
            // up to gen
            "*1": 0...150,
            "*2": 0...250,
            "*3": 0...385,
            "*4": 0...492,
            "*5": 0...648,
            "*6": 0...720,
            "*7": 0...808,
        ]
        
        
        
        
        
        @Published var gen = "*7" //hardcoded to include everyone
        // i was considering a gen picker, but decided it wasn't needed
        
        
        @Published var randomPokemonId = 0
        @Published var nameGuess = ""
        @Published var choices = [0, 3, 6, 25]
        
        @Published var restarts = 0
        @Published var round = 0
        @Published var score = 0
        @Published var alreadyAppeared = [Int]()
        
        @Published var showTips = true
        @Published var tipsCounter = 0
        @Published var showForRounds = 3
        
        @Published var showingAnswer = false
        @Published var pokemonRevealed = false
        
        @Published var gameFinished = false
        
        
        
        
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
            "\(score)/\(round)"
        }
        
        var roundText: String {
            "\(round)"
        }
        
        var pokemonChoices: [String] {
            choices.map { allPokemon[$0].name }
        }
        
        var percent: Int {
            guard round != 0 else { return 0 }
                    
            return Int(Double(score) / Double(round) * 100)
        }
        
        var seal: (String, Color) {
            // can be simpler
            
            if round == 0 { return ("", .primary) }
            
            if percent < 95 {
                if percent < 80 {
                    if percent < 50 {
                        return ("C", .yellow)
                    } else {
                        return ("B", .orange)
                    }
                } else {
                    return ("A", .green)
                }
            } else {
                return ("S", .cyan)
            }
        }
        
        var showingTips: Bool {
            // the logic can be simplified
            
            let roundIsZero = (round == 0)
            let tipCounterLow = (tipsCounter < showForRounds)
            let noRestarts = (restarts == 0)
            
            if roundIsZero {
                return false
            } else {
                if tipCounterLow {
                    if noRestarts {
                        if showTips {
                            return true
                        } else {
                            return false
                        }
                    } else {
                        if showTips {
                            return true
                        } else {
                            return false
                        }
                    }
                } else {
                    return false
                }
            }
        }
        
        var showingRoundText: Bool {
            round > 0
        }
        
        
        
        
        
        
        func startGame() {
            round = 0
            score = 0
            alreadyAppeared = []
            
            updatePokemonAndChoices()
        }
        
        func nextRound() {
            showAnswer()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                self.nextPokemon()
            }
        }
        
        
        func showAnswer() {
            showingAnswer = true
            
            pokemonRevealed = true
            
            // Update score
            if correct {
                score += 1
            }
        }
        
        func roundPlus1() {
            round += 1
        }
        
        
        func nextPokemon() {
            showingAnswer = false
            
            pokemonRevealed = false
            
            // Make pokemon not appear again
            alreadyAppeared.append(randomPokemonId)
            
            if alreadyAppeared.count == gens[gen]!.count - 1 {
                gameFinished = true
            }
            
            updatePokemonAndChoices()
            
            nameGuess = ""
            
            tipsCounter += 1
            if tipsCounter > showForRounds - 1 {
                showTips = false
            }
        }
        
        
        func restart() {
            gameFinished = false
            
            restarts += 1
            startGame()
        }
        
        
        func updatePokemonAndChoices() {
            // Update pokemon
            randomPokemonId = Int.random(in: gens[gen]!) // Force unwrap here!
            while alreadyAppeared.contains(randomPokemonId) {
                randomPokemonId = Int.random(in: gens[gen]!)
            }
            
            // Update multiple choice buttons
            generateChoices()
        }
        
        
        func generateChoices() {
            // can be simpler
            
            var choice1Id = 1
            var choice2Id = 1
            var choice3Id = 1
            
            while !(choice1Id != choice2Id && choice1Id != choice3Id && choice2Id != choice3Id && choice1Id != randomPokemonId && choice2Id != randomPokemonId && choice3Id != randomPokemonId) {
                choice1Id = Int.random(in: gens[gen]!)
                choice2Id = Int.random(in: gens[gen]!)
                choice3Id = Int.random(in: gens[gen]!)
                
                // 739 - longest name for accessibility testing (Crabominable)
            }
            
            choices = [choice1Id, choice2Id, choice3Id, randomPokemonId]
                .shuffled()
        }
        
        
        func choose(_ num: Int) {
            nameGuess = pokemonChoices[num-1]
            nextRound()
        }
        
        
        func choice(_ num: Int) -> String {
            pokemonChoices[num-1]
        }
        
        func correctness(_ option: Int) -> Int {
            if showingAnswer {
                if randomPokemon.name == choice(option) {
                    if nameGuess == choice(option) {
                        return 1
                    } else {
                        return 1
                    }
                } else {
                    if nameGuess == choice(option) {
                        return 2
                    } else {
                        return 3
                    }
                }
            } else { return 0 }
        }
        
        
        func toggleShowTips() {
            showTips.toggle()
            
            tipsCounter = 0
        }
    }
}

