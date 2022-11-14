//
//  GameScene.swift
//  Project17
//
//  Created by Oliwier Kasprzak on 25/10/2022.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false
    var timeInterval = 0.0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var numberOfEnemies = 0 {
        didSet{
            if numberOfEnemies.isMultiple(of: 20){
                timeInterval -= 0.15
                gameTimer?.invalidate()
                gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
                
            }
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        var timeInterval = 0.5
            gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
     
        
        
    }
    
    @objc func createEnemy(){
        guard let enemy = possibleEnemies.randomElement() else { return }
        let sprite = SKSpriteNode(imageNamed: enemy)
        if !isGameOver {
            sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
            addChild(sprite)
        } else {
            possibleEnemies.removeAll()
        }
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
   override func update(_ currentTime: TimeInterval) {
       for node in children {
           if node.position.x < -300 {
               node.removeFromParent()
           }
       }
       
       if !isGameOver {
           score += 1
       }
   }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        player.position = location
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let explonsion = SKEmitterNode(fileNamed: "explosion")!
        explonsion.position = player.position
        addChild(explonsion)
        
        player.removeFromParent()
        
        isGameOver = true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let explonsion = SKEmitterNode(fileNamed: "explosion")!
        explonsion.position = player.position
        addChild(explonsion)
        
        player.removeFromParent()
        
        isGameOver = true
        
        
    }
}
