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
    
 ///   var path_1 = SKAction()
    //var snake1 = SKShapeNode()
    var snake1 = Array<SKShapeNode>()

    
    static  let circleBody : UInt32 = 0x1 << 1

    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0...4
        {
            var circle2 = SKShapeNode()
            circle2 = self.snake()
            circle2.position.x = circle2.position.x + CGFloat(i * 15)
            self.snake1.append(circle2)
        }
        
        NSLog("%d", snake1.count)
        if(!snake1.isEmpty){
            for i in 0...snake1.count-1
            {
                NSLog("adding snake")
                if(i == 0)
                {
                    let path1 = SKAction.moveBy(x: 50, y: 50, duration: 2)
                    let path2 = SKAction.moveBy(x: -50, y: 50, duration: 2)
                    let path3 = SKAction.moveBy(x: -50, y: -50, duration: 2)
                    let path4 = SKAction.moveBy(x: 50, y: -50, duration: 2)
                    
                    let path5 = SKAction.sequence([path1,path2,path3,path4])
                    let path6 = SKAction.repeatForever(path5)
                    self.snake1[0].run(path6)
                }
                else
                {
                    let path1 = SKAction.moveTo(x: snake1[i-1].position.x, duration: 1)
                    let path2 = SKAction.moveTo(y: snake1[i-1].position.y, duration: 1)
                    let path3 = SKAction.group([path1,path2])
                    
                    let path5 = SKAction.follow(snake1[i-1].path!, asOffset: false, orientToPath: false, duration: 2)
              //    let path5 = SKAction.move(to: snake1[i-1].position, duration: 2)
                    let path4 = SKAction.repeatForever(path3)
                    
                    self.snake1[i].run(path4)
                }
                self.addChild(snake1[i])
                //snake1[i].run(path_1)
            }
        }
    }
    

    func snake() -> SKShapeNode
    {
        self.circle = SKShapeNode(circleOfRadius: 10 )
        self.circle.physicsBody = SKPhysicsBody(circleOfRadius: 70)
        self.circle.physicsBody?.categoryBitMask = GameScene.circleBody
        self.circle.physicsBody?.affectedByGravity = false
        self.circle.physicsBody?.isDynamic = false
        self.circle.position = CGPoint(x: 200, y:250)
        self.circle.fillColor = UIColor.cyan
        self.circle.strokeColor = UIColor.brown
        
        return self.circle;

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
