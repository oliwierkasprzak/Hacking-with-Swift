//
//  WhackSlot.swift
//  Project14
//
//  Created by Oliwier Kasprzak on 23/10/2022.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    var charNote: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint){
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNote = SKSpriteNode(imageNamed: "penguinGood")
        charNote.position = CGPoint(x: 0, y: -90)
        charNote.name = "character"
        cropNode.addChild(charNote)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNote.xScale = 1
        charNote.yScale = 1
        
        charNote.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNote.texture = SKTexture(imageNamed: "penguinGood")
            charNote.name = "charFriend"
        } else {
            charNote.texture = SKTexture(imageNamed: "penguinEvil")
            charNote.name = "charEnemy"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {
            [weak self] in
            self?.hide()
        }
    }
    func hide(){
        if !isVisible { return }
        
        charNote.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    func hit(){
        isHit = true
        if let smokeEffect = SKEmitterNode(fileNamed: "smoke") {
            
            smokeEffect.position = charNote.position
            
            
            let action = SKAction.sequence ([
                
                SKAction.run { [weak self] in self?.addChild(smokeEffect)},
                SKAction.wait(forDuration: 1.25),
                SKAction.run { smokeEffect.removeFromParent()}
                
            ])
            run(action)
               
            
         
           }
        let delay = SKAction.wait(forDuration: 0.25)
        let move = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
        let sequence = SKAction.sequence([delay, move, notVisible])
        
        charNote.run(sequence)
        
       
    }
}
