//
//  MultiButtonModifier.swift
//  Azelf
//
//  Created by Chamomile on 13/07/22.
//

import SwiftUI

struct Multi: ViewModifier {
    let correctness: Int
    
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .foregroundColor(.white)
            .frame(width: 155, height: 60)
            .background(
                correctness == 0 ? nil :
                    (correctness == 3 ? nil :
                    correctness == 1 ? Color.correct :
                    Color.incorrect
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.white, lineWidth: 3)
            )
            .opacity(
                correctness == 0 ? 1 :
                    (correctness == 3 ? 0.3 :
                    correctness == 1 ? 1 :
                    0.8
                    )
            )
            .padding(3)
            .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    
    init(_ correctness: Int) {
        self.correctness = correctness
    }
}

extension View {
    func multi(_ correctness: Int) -> some View {
        modifier(Multi(correctness))
    }
}
