//
//  Pig.swift
//  Hogville
//
//  Created by Cecilia Humlelu on 14/01/15.
//  Copyright (c) 2015 Jean-Pierre Distler. All rights reserved.
//

import SpriteKit

class Pig:SKSpriteNode {
    
    let POINTS_PER_SEC:CGFloat = 80.0
    var wayPoints:[CGPoint] = []
    var velocity = CGPoint(x:0, y:0)
    var moveAnimation:SKAction?
    
    init(imageNamed name: String){
        let texture = SKTexture(imageNamed: name)
        let textures = [SKTexture(imageNamed:"pig_1"), SKTexture(imageNamed:"pig_2"), SKTexture(imageNamed:"pig_3")]
        moveAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.1)
        super.init(texture: texture, color: nil, size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    
    func addMovingPoint(point:CGPoint){
        wayPoints.append(point)
    }
    
    func move(dt:NSTimeInterval){
        
        if(actionForKey("moveAction") == nil){
            runAction(moveAnimation!, withKey: ("moveAction"))
        }
        let currentPosition = position
        var newPosition = position
        if wayPoints.count > 0 {
            let targetPoint = wayPoints[0]
            
            let offset = CGPoint(x:targetPoint.x - currentPosition.x, y:targetPoint.y - currentPosition.y)
            let length = Double(sqrtf(Float(offset.x * offset.x) + Float(offset.y * offset.y)))
            let direction = CGPoint(x:CGFloat(offset.x)/CGFloat(length),y:CGFloat(offset.y)/CGFloat(length))
            
            velocity = CGPoint(x:direction.x * POINTS_PER_SEC, y: direction.y * POINTS_PER_SEC)
            
            newPosition = CGPoint(x:currentPosition.x + velocity.x * CGFloat(dt),y:currentPosition.y + velocity.y * CGFloat(dt))
            
            position = checkBoundaries(newPosition)
                
            if(frame.contains(targetPoint)){
                wayPoints.removeAtIndex(0)
            }
        }
        else {
            newPosition = CGPoint(x: currentPosition.x + velocity.x * CGFloat(dt),
                y: currentPosition.y + velocity.y * CGFloat(dt))
            position = checkBoundaries(newPosition)
        }
        
        zRotation = atan2(CGFloat(velocity.y), CGFloat(velocity.x)) + CGFloat(M_PI_2)
    }

    func createPathToMove()->CGPathRef? {
        if wayPoints.count <= 1 {
            return nil
        }
        
        var ref = CGPathCreateMutable()
        
        for var i = 0; i < wayPoints.count; ++i {
            let p = wayPoints[i]
            
            if i == 0 {
                CGPathMoveToPoint(ref, nil,  p.x, p.y)
            }
            else {
                CGPathAddLineToPoint(ref, nil, p.x, p.y)
            }
        
        }
        
        return ref
    }
    
    func checkBoundaries(position:CGPoint)-> CGPoint {
        var newVelocity = velocity
        var newPosition = position
        
        
        let bottomLeft = CGPoint(x: 0, y: 0)
        let topRight = CGPoint(x:scene!.size.width, y:scene!.size.height)
        
        if newPosition.x <= bottomLeft.x {
            newPosition.x = bottomLeft.x
            newVelocity.x = -newVelocity.x
        } else if newPosition.x >= topRight.x {
            newPosition.x = topRight.x
            newVelocity.x = -newVelocity.x
        }
        
        if newPosition.y <= bottomLeft.y {
            newPosition.y = bottomLeft.y
            newVelocity.y = -newVelocity.y
        } else if newPosition.y >= topRight.y {
            newPosition.y = topRight.y
            newVelocity.y = -newVelocity.y
        }
        
        velocity = newVelocity
        
        return newPosition

        
    }
    
   
}
