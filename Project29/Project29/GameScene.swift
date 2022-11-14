//
//  GameScene.swift
//  Project29
//
//  Created by Oliwier Kasprzak on 09/11/2022.
//

import SpriteKit
enum CollisionType: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}
var scoreLabelP1: SKLabelNode!
var scoreLabelP2: SKLabelNode!
var scoreP1 = 0 {
    didSet {
        scoreLabelP1.text = "Score: \(scoreP1)"
    }
}
var scoreP2 = 0 {
    didSet {
        scoreLabelP2.text = "Score: \(scoreP2)"
    }
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    var buildings = [BuildingNode]()
    weak var viewController: GameViewController?
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    var player1Wins: SKLabelNode!
    var player2Wins: SKLabelNode!
    var wind: SKLabelNode!
  
    
    var windXForce = Int.random(in: 50...175)
    var windYForce = 0
    
    var windBlowingRight = true {
        didSet {
            if windBlowingRight {
                wind.text = "Wind blowing right at speed: \(windXForce)"
            } else {
                wind.text = "Wind blowing left at speed: \(windXForce)"
            }
        }
    }
    
    
   
    
    var currentPlayer = 1
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        createBuilding()
        createPlayers()
        isGameOver()
        
        physicsWorld.contactDelegate = self
     
        scoreLabelP1 = SKLabelNode(fontNamed: "chalkduster")
        scoreLabelP1.position = CGPoint(x: 16, y: 16)
        scoreLabelP1.text = "Score: \(scoreP1)"
        scoreLabelP1.horizontalAlignmentMode = .left
        scoreLabelP1.zPosition = 10
        scoreLabelP1.fontSize = CGFloat(40)
        scoreLabelP1.fontColor = UIColor.black
        addChild(scoreLabelP1)
        
        scoreLabelP2 = SKLabelNode(fontNamed: "chalkduster")
        scoreLabelP2.position = CGPoint(x: 1000, y: 16)
        scoreLabelP2.text = "Score: \(scoreP2)"
        scoreLabelP2.horizontalAlignmentMode = .right
        scoreLabelP2.zPosition = 10
        scoreLabelP2.fontSize = CGFloat(40)
        scoreLabelP2.fontColor = UIColor.black
        addChild(scoreLabelP2)
        
        wind = SKLabelNode()
        wind.position = CGPoint(x: 100, y: 100)
        wind.zPosition = 1
        wind.text = "Wind blowing"
        addChild(wind)
    }
    
    func createBuilding() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    func launch(angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10
        let radians = deg2rad(degrees: angle)
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionType.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionType.building.rawValue | CollisionType.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionType.building.rawValue | CollisionType.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
            
        } else {
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player2.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
            
        }
        
        if windBlowingRight {
                       banana.physicsBody?.applyForce(CGVector(dx: windXForce, dy: windYForce))
                   } else {
                       banana.physicsBody?.applyForce(CGVector(dx: -windXForce, dy: windYForce))
                   }
        
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionType.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionType.banana.rawValue
        player1.physicsBody?.isDynamic = false

        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)

        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionType.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionType.banana.rawValue
        player2.physicsBody?.isDynamic = false

        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }
    
    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * .pi / 180
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }

        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }

        if firstNode.name == "banana" && secondNode.name == "player1" {
            destroy(player: player1)
            scoreP2 += 1
        }

        if firstNode.name == "banana" && secondNode.name == "player2" {
            destroy(player: player2)
            scoreP1 += 1
        }
    }
    
    func destroy(player: SKSpriteNode){
        if let emitter = SKEmitterNode(fileNamed: "hitPlayer") {
            emitter.position = player.position
            addChild(emitter)
        }
        player.removeFromParent()
        banana.removeFromParent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
         
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController?.currentGame = newGame
        
            self.changePlayers()
            newGame.currentPlayer = self.currentPlayer
           
            
            let transition = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: transition)
            
        }
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        changePlayers()
    }
    
    func changePlayers() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        viewController?.activatePlayer(number: currentPlayer)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayers()
        }
    }
    
    func isGameOver() {
        if scoreP1 == 3 {
            removeAllActions()
            viewController?.angleLabel?.isHidden = true
            viewController?.angleSlider?.isHidden = true
            viewController?.velocityLabel?.isHidden = true
            viewController?.velocitySlider?.isHidden = true
            viewController?.launchButton.isHidden = true
            viewController?.playerNumber.isHidden = true
            removeAllChildren()
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.size = CGSize(width: 400, height: 200)
            gameOver.zPosition = 2
            addChild(gameOver)
            
            player1Wins = SKLabelNode()
            player1Wins.text = "Player 1 wins!"
            player1Wins.position = CGPoint(x: 512, y: 200)
            player1Wins.fontSize = CGFloat(40)
            addChild(player1Wins)
        } else if scoreP2 == 3 {
            removeAllActions()
            viewController?.angleLabel?.isHidden = true
            viewController?.angleSlider?.isHidden = true
            viewController?.velocityLabel?.isHidden = true
            viewController?.velocityLabel?.isHidden = true
            viewController?.launchButton.isHidden = true
            viewController?.playerNumber.isHidden = true
            removeAllChildren()
           
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.size = CGSize(width: 400, height: 200)
            gameOver.zPosition = 2
            addChild(gameOver)
            
            player2Wins = SKLabelNode()
            player2Wins.text = "Player 2 wins!"
            player2Wins.position = CGPoint(x: 512, y: 200)
            player2Wins.fontSize = CGFloat(40)
            addChild(player2Wins)
        }
    }
}
