//
//  GameScene.swift
//  p06_npradha2
//
//  Created by Nimesh on 4/6/17.
//  Copyright © 2017 npradha2. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var circle = SKShapeNode()
    
    
    static  let circleBody : UInt32 = 0x1 << 1

    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        circle = SKShapeNode(circleOfRadius: 70 )
        circle.physicsBody = SKPhysicsBody(circleOfRadius: 70)
        circle.physicsBody?.categoryBitMask = GameScene.circleBody
       circle.physicsBody?.affectedByGravity = false
       circle.physicsBody?.isDynamic = true
        circle.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        circle.fillColor = UIColor.cyan
        self.addChild(circle)

    }
    
    func randomNumber(min : Int, max : Int) -> Int {
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
    
    func touchDown(atPoint pos : CGPoint) {
   
    }
    
    func touchMoved(toPoint pos : CGPoint) {
      
    }
    
    func touchUp(atPoint pos : CGPoint) {
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
