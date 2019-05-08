//
//  GameScene.swift
//  Consolidation7
//
//  Created by Weirup, Chris on 2019-05-02.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var clockLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var clock = 60 {
        didSet {
            clockLabel.text = "Time Remaining: \(clock)"
        }
    }
    
    let possibleTargets = ["good", "bad", "ugly"]
    let yPositions = [200, 400, 600]
    let potentialBitMasks = [1, 2, 4, 8, 16, 32, 64]
    
    var targetTimer: Timer?
    var gameTimer: Timer?
    
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        // We are going to put an image of a haunted house in the front
        // and only allow people to hit the target when they pass through a window.
        
        scoreLabel = SKLabelNode(fontNamed: "Baskerville")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0

        physicsWorld.gravity = .zero
        
        targetTimer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
    }
    
    @objc func createTarget() {
        guard let target = possibleTargets.randomElement() else { return }
        
        // Need random x position and x velocity
        // X position is either 1200 or -300
        // If X position is 1200, velocity is negative
        // If X position is -300, velocity is positive
        let theRandom = Int.random(in: 0...1)
        var xPosition: Int
        var xVelocity: Int
        if theRandom == 0 {
            xPosition = 1200
            xVelocity = Int.random(in: 100...500) * -1
        } else {
            xPosition = -300
            xVelocity = Int.random(in: 100...500)
        }
        
        let sprite = SKSpriteNode(imageNamed: target)
        sprite.position = CGPoint(x: xPosition, y: yPositions.randomElement()!)
        sprite.name = target
        addChild(sprite)
        
        // Need to randomize the categoryBitMask, collisionBitMask, and zPosition
        let targetBitMask = UInt32(potentialBitMasks.randomElement()!)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.collisionBitMask = 0
        sprite.physicsBody?.categoryBitMask = 1
        sprite.zPosition = CGFloat(targetBitMask)
        sprite.physicsBody?.velocity = CGVector(dx: xVelocity, dy: 0)
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            //guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            
            if node.name == "bad" {
                score += 1
            } else if node.name == "ugly" {
                score += 2
                //run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "good" {
                score -= 1
            }
            
            //Set an emitter
            node.isHidden = true
            node.removeFromParent()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 || node.position.x > 1200 {
                node.removeFromParent()
            }
        }
    }
    
}
