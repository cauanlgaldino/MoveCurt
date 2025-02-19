//
//  CurtainViewModel.swift
//  Basics
//
//  Created by Cauan Lopes Galdino on 16/01/25.
//

import Foundation

class CurtainViewModel: ObservableObject, Observable {
    
    @Published var totalAnimationTime: CGFloat = 3.0 // em segundos
    @Published var leftOffsets: [CGFloat] = Array(repeating: 0, count: 5)
    @Published var rightOffsets: [CGFloat] = Array(repeating: 0, count: 5)
    @Published var leftOpeningPercentage: CGFloat = 0 // Abertura lado esquerdo (0 a 100%)
    @Published var rightOpeningPercentage: CGFloat = 0 // Abertura lado direito (0 a 100%)
    @Published var leftTargetOpening: CGFloat = 0 // Abertura lado esquerdo (0 a 100%)
    @Published var rightTargetOpening: CGFloat = 0 // Abertura lado direito (0 a 100%)
    @Published var leftAnimationDuration: CGFloat = 0 // Abertura lado esquerdo (0 a 100%)
    @Published var rightAnimationDuration: CGFloat = 0 // Animação lado esquerdo
    @Published var rightIsMoving = false
    @Published var leftIsMoving = false
    @Published var rightSliderEditing = false
    @Published var leftSliderEditing = false
    @Published var isOpening: Bool = true
    
    let numPieces = 5 // Número de pares de peças P e G por lado
    
    func updateOffsets(isLeft: Bool) {
        let openingPercentage = isLeft ? leftOpeningPercentage : rightOpeningPercentage
        var offsets = isLeft ? leftOffsets : rightOffsets
        
        if openingPercentage < 20 {
            offsets[isLeft ? 4 : 0] = isLeft ? -(openingPercentage / 100) : (openingPercentage / 100)
            offsets[isLeft ? 3 : 1] = 0
            offsets[isLeft ? 2 : 2] = 0
            offsets[isLeft ? 1 : 3] = 0
            offsets[isLeft ? 0 : 4] = 0
        }
        
        else if openingPercentage < 40 {
            offsets[isLeft ? 4 : 0] = isLeft ? -(openingPercentage / 100) : (openingPercentage / 100)
            offsets[isLeft ? 3 : 1] = isLeft ? -(openingPercentage - 20) / 100 : (openingPercentage - 20) / 100
            offsets[isLeft ? 2 : 2] = 0
            offsets[isLeft ? 1 : 3] = 0
            offsets[isLeft ? 0 : 4] = 0
        }
        
        else if openingPercentage < 60 {
            offsets[isLeft ? 4 : 0] = isLeft ? -(openingPercentage / 100) : (openingPercentage / 100)
            offsets[isLeft ? 3 : 1] = isLeft ? -(openingPercentage - 20) / 100 : (openingPercentage - 20) / 100
            offsets[isLeft ? 2 : 2] = isLeft ? -(openingPercentage - 40) / 100 : (openingPercentage - 40) / 100
            offsets[isLeft ? 1 : 3] = 0
            offsets[isLeft ? 0 : 4] = 0
        }
        
        else if openingPercentage < 80 {
            offsets[isLeft ? 4 : 0] = isLeft ? -(openingPercentage / 100) : (openingPercentage / 100)
            offsets[isLeft ? 3 : 1] = isLeft ? -(openingPercentage - 20) / 100 : (openingPercentage - 20) / 100
            offsets[isLeft ? 2 : 2] = isLeft ? -(openingPercentage - 40) / 100 : (openingPercentage - 40) / 100
            offsets[isLeft ? 1 : 3] = isLeft ? -(openingPercentage - 60) / 100 : (openingPercentage - 60) / 100
            offsets[isLeft ? 0 : 4] = 0
        }
        
        else {
            offsets[isLeft ? 4 : 0] = isLeft ? -(openingPercentage / 100) : (openingPercentage / 100)
            offsets[isLeft ? 3 : 1] = isLeft ? -(openingPercentage - 20) / 100 : (openingPercentage - 20) / 100
            offsets[isLeft ? 2 : 2] = isLeft ? -(openingPercentage - 40) / 100 : (openingPercentage - 40) / 100
            offsets[isLeft ? 1 : 3] = isLeft ? -(openingPercentage - 60) / 100 : (openingPercentage - 60) / 100
            offsets[isLeft ? 0 : 4] = isLeft ? -(openingPercentage - 80) / 100 : (openingPercentage - 80) / 100
        }
        
        // Atualiza os offsets reais
        if isLeft {
            leftOffsets = offsets
        } else {
            rightOffsets = offsets
        }
    }
    
    func animateOpening(to target: CGFloat, toLeft: Bool, moveSlider: Bool) {
        let currentPercentage = toLeft ? leftOpeningPercentage : rightOpeningPercentage
        let percentageDifference = abs(target - currentPercentage)
        
        // Calcula a duração proporcional para a diferença de abertura
        let animationDuration = totalAnimationTime * (percentageDifference / 100.0)
        
        // Define o número de passos baseado em 60 FPS
        let steps: Int = Int(animationDuration * 60)
        guard steps > 0 else { return }
        
        // Incremento por passo e tempo por passo
        let stepValue = (target - currentPercentage) / CGFloat(steps)
        let stepTime = animationDuration / CGFloat(steps)
        
        // Cria um Timer para atualizar gradualmente o valor
        var currentStep = 0
        
        
        if target - currentPercentage > 0 {
            isOpening = true // Se for negativo está abrindo
        } else {
            isOpening = false // Se for positivo está fechando
        }
        
        if toLeft {
            leftIsMoving = true // Esquerda está se movendo
        } else {
            rightIsMoving = true // Direita está se movendo
        }
        
        Timer.scheduledTimer(withTimeInterval: stepTime, repeats: true) { timer in
            if currentStep >= steps || (toLeft ? self.leftIsMoving == false : self.rightIsMoving == false) {
                timer.invalidate() // Para o Timer quando terminar
                
                if toLeft {
                    self.leftIsMoving = false
                } else {
                    self.rightIsMoving = false // para o movimento
                }
                
                if self.leftOpeningPercentage < 0.1 || self.rightOpeningPercentage < 0.1  {
                    self.isOpening = true
                }
                if self.leftOpeningPercentage > 99.9 || self.rightOpeningPercentage > 99.9 { // verifica se o curso foi completado
                    self.isOpening = false
                }
                
                return
            }
            
            currentStep += 1
            
            if toLeft {
                self.leftOpeningPercentage += stepValue
                if moveSlider {
                    self.leftTargetOpening += stepValue
                }
            } else {
                self.rightOpeningPercentage += stepValue
                if moveSlider {
                    self.rightTargetOpening += stepValue
                }
            }
        }
    }
}



