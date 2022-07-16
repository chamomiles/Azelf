//
//  RoundView.swift
//  Azelf
//
//  Created by Chamomile on 12/07/22.
//

import Combine
import Foundation
import SwiftUI
import SwiftUITooltip

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.gameFinished {
            // Shown when no Pokemon left
            VStack {
                Spacer()
                
                Text("You ran out of Pokémon!")
                    .font(.title).bold()
                
                Spacer()
                
                SealView(viewModel.seal, showingTips: false)
                    .padding(.horizontal, 35)
                    .scaleEffect(2)
                
                Spacer()
                
                Button {
                    viewModel.restart()
                } label: {
                    Text("Restart")
                        .font(.title3).bold()
                        .foregroundColor(.primary.opacity(0.7))
                        .frame(width: 100, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(.white.opacity(0.7), lineWidth: 3)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .padding()
                }
                
                Spacer()
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("This app is not compatible with Voiceover.")
        } else {
            // Shown normally
            VStack {
                Spacer()
                
                // Who's That Pokemon
                Text("Who's That Pokémon?")
                    .font(.title)
                    .bold()
                
                // Pokemon
                PokemonBlackView(image: viewModel.randomPokemonImage, pokemonRevealed: viewModel.pokemonRevealed)
                
                // Multiple Choice Buttons
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                viewModel.choose(1)
                            }
                            
                            viewModel.roundPlus1() // this is to prevent animation 😶
                        } label: {
                            Text(viewModel.choice(1))
                                .bold()
                                .multi(viewModel.correctness(1))
                        }
                        .allowsHitTesting(!viewModel.showingAnswer)
                        
                        Button {
                            withAnimation {
                                viewModel.choose(2)
                            }
                            
                            viewModel.roundPlus1()
                        } label: {
                            Text(viewModel.choice(2))
                                .bold()
                                .multi(viewModel.correctness(2))
                        }
                        .allowsHitTesting(!viewModel.showingAnswer)
                    }
                    
                    HStack {
                        Button {
                            withAnimation {
                                viewModel.choose(3)
                            }
                            
                            viewModel.roundPlus1()
                        } label: {
                            Text(viewModel.choice(3))
                                .bold()
                                .multi(viewModel.correctness(3))
                        }
                        .allowsHitTesting(!viewModel.showingAnswer)
                        
                        Button {
                            withAnimation {
                                viewModel.choose(4)
                            }
                            
                            viewModel.roundPlus1()
                        } label: {
                            Text(viewModel.choice(4))
                                .bold()
                                .multi(viewModel.correctness(4))
                        }
                        .allowsHitTesting(!viewModel.showingAnswer)
                    }
                }
                .padding(.vertical, 25)
                
                Spacer()
                
                ZStack {
                    HStack {
                        if viewModel.showingRoundText {
                            Text(viewModel.roundText)
                                .font(.largeTitle)
                                .padding(.horizontal, 60)
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        SealView(viewModel.seal, showingTips: viewModel.showingTips)
                            .padding(.horizontal, 35)
                            .onTapGesture {
                                viewModel.toggleShowTips()
                            }
                    }
                    
                    Button {
                        viewModel.restart()
                    } label: {
                        Text("Restart")
                            .font(.title3).bold()
                            .foregroundColor(.white.opacity(viewModel.showingAnswer ? 0.2 : 0.7))
                            .frame(width: 100, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(.white.opacity(viewModel.showingAnswer ? 0.2 : 0.7), lineWidth: 3)
                            )
                            .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .disabled(viewModel.showingAnswer)
                }
            }
            .onAppear(perform: viewModel.startGame)
            // i am not sure how to address this warning
            .preferredColorScheme(.dark)
            .accessibilityLabel("This app is not compatible with Voiceover.")
        }
    }
}

struct RoundView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
            
    }
}
