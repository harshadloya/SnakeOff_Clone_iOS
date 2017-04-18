//
//  LoadGameScene.swift
//  p06_npradha2
//
//  Created by Harshad Loya on 4/14/17.
//  Copyright © 2017 npradha2. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameMenuScene: SKScene
{
    var button1 = SKLabelNode()
    var button2 = SKLabelNode()
    
    override func didMove(to view: SKView)
    {
        //adding background
        let background = SKSpriteNode(imageNamed: "bggrid")
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        background.zPosition = 1
        self.addChild(background)
        
        
        button1 = self.createButton()
        button1.text = "One Player"
        self.addChild(button1)
        
        
       //  Add new buttons in similar way for giving options
        button2 = self.createButton()
        button2.position.y -= 50
        button2.text = "Two Players"
        self.addChild(button2)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            if button1.contains(location)
            {
                let gamescene = GameScene()
                gamescene.size = (self.view?.bounds.size)!
                gamescene.scaleMode = .aspectFill
                self.view?.presentScene(gamescene)
            }
            if button2.contains(location)
            {
                let twoPlayerGame = TwoPlayers()
                twoPlayerGame.size = (self.view?.bounds.size)!
                twoPlayerGame.scaleMode = .aspectFill
                self.view?.presentScene(twoPlayerGame)
            }
        }
    }
    
    func createButton() -> SKLabelNode
    {
        //let newButton = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: 40))
        let newButton = SKLabelNode()
        newButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - 150)
        newButton.zPosition = 2
        newButton.fontColor = SKColor.black
        
        return newButton
    }

}
