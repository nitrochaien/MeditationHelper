//
//  CircleView.swift
//  SimpleUIKit
//
//  Created by Nam Dinh Vu on 1/6/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit

let pi:CGFloat = CGFloat(Double.pi)

enum NumberOfNumerals:Int
{
    case two = 2, four = 4, twelve = 12
}

class CircleView: UIView
{
    override func draw(_ rect: CGRect)
    {
        //obtain context
        if let context = UIGraphicsGetCurrentContext() {
            let endAngle:CGFloat = 2*pi
            let lineWidth:CGFloat = 4.0
            
            //decide on radius
            let rad:CGFloat = rect.width/2-lineWidth
            
            //add the circle to the context
            context.addArc(center: CGPoint(x: rect.midX,
                                           y: rect.midY),
                           radius: rect.width/2 - lineWidth/2,
                           startAngle: 0,
                           endAngle: endAngle,
                           clockwise: true)
            
            context.setFillColor(UIColor.clear.cgColor) //background
            context.setStrokeColor(UIColor.clear.cgColor) //border
            context.setLineWidth(lineWidth)
            
            //draw the path
            context.drawPath(using: .fillStroke)
            
            //draw markers
            for i in 1...60
            {
                //save the original position and origin
                context.saveGState()
                //make translation
                context.translateBy(x: rect.midX, y: rect.midY)
                //make rotation
                context.rotate(by: degreeToRadian(degree: CGFloat(i)*6))
                
                if i%5 == 0
                {
                    //draw hour marker longer
                    drawSecondMarker(context: context,
                                     x: rad-15,
                                     y: 0,
                                     radius: rad,
                                     color: .white,
                                     lineWidth: 3.0)
                }
                else
                {
//                    drawSecondMarker(context: context,
//                                     x: rad-10,
//                                     y: 0,
//                                     radius: rad,
//                                     color: .white,
//                                     lineWidth: 1.5)
                }
                
                //restore state before next translation
                context.restoreGState()
            }
            
            let myTime = timeCoords(x: rect.midX,
                                    y: rect.midY,
                                    time: time(),
                                    radius: rad/2)
            
            //draw hour
            let hourLayer = CAShapeLayer()
            hourLayer.frame = CGRect(x: 0,
                                     y: 0,
                                     width: rect.width,
                                     height: rect.height)
            let hourPath = CGMutablePath()
            
            hourPath.move(to: CGPoint(x: rect.midX, y: rect.midY))
            hourPath.addLine(to: CGPoint(x: myTime.h.x, y: myTime.h.y))
            
            hourLayer.path = hourPath
            hourLayer.lineWidth = 4
            hourLayer.lineCap = kCALineCapRound
            hourLayer.strokeColor = UIColor.white.cgColor
            hourLayer.rasterizationScale = UIScreen.main.scale
            hourLayer.shouldRasterize = true
            
            self.layer.addSublayer(hourLayer)
            rotateLayer(currentLayer: hourLayer, duration: 43200, smooth: true)
            
            //draw minutes
            let minuteLayer = CAShapeLayer()
            minuteLayer.frame = CGRect(x: 0,
                                       y: 0,
                                       width: rect.width,
                                       height: rect.height)
            let minutePath = CGMutablePath()
            
            minutePath.move(to: CGPoint(x: rect.midX, y: rect.midY))
            minutePath.addLine(to: CGPoint(x: myTime.m.x, y: myTime.m.y))
            
            minuteLayer.path = minutePath
            minuteLayer.lineWidth = 3
            minuteLayer.lineCap = kCALineCapRound
            minuteLayer.strokeColor = UIColor.white.cgColor
            minuteLayer.rasterizationScale = UIScreen.main.scale
            minuteLayer.shouldRasterize = true
            
            self.layer.addSublayer(minuteLayer)
            rotateLayer(currentLayer: minuteLayer, duration: 3600, smooth: true)
            
            //draw seconds
            let secondLayer = CAShapeLayer()
            secondLayer.frame = CGRect(x: 0,
                                       y: 0,
                                       width: rect.width,
                                       height: rect.height)
            let secondPath = CGMutablePath()
            
            secondPath.move(to: CGPoint(x: rect.midX, y: rect.midY))
            secondPath.addLine(to: CGPoint(x: myTime.s.x, y: myTime.s.y))
            
            secondLayer.path = secondPath
            secondLayer.lineWidth = 1
            secondLayer.lineCap = kCALineCapRound
            secondLayer.strokeColor = UIColor.red.cgColor
            secondLayer.rasterizationScale = UIScreen.main.scale
            secondLayer.shouldRasterize = true
            
            self.layer.addSublayer(secondLayer)
//            rotateLayer(currentLayer: secondLayer, duration: 60, smooth: false)
            rotateLayer(currentLayer: secondLayer, duration: 1, smooth: false)
            
            //center
            let centerPiece = CAShapeLayer()
            let circle = UIBezierPath(arcCenter: CGPoint(x: rect.midX,
                                                         y: rect.midY),
                                      radius: 4.5,
                                      startAngle: 0,
                                      endAngle: endAngle,
                                      clockwise: true)
            centerPiece.path = circle.cgPath
            centerPiece.fillColor = UIColor.red.cgColor
            self.layer.addSublayer(centerPiece)
            
//            Draw numbers
//                        drawText(rect: rect,
//                                 ctx: context,
//                                 x: rect.midX,
//                                 y: rect.midY,
//                                 radius: rad,
//                                 sides: .twelve,
//                                 color: .white)
        }
    }
    
    fileprivate func degreeToRadian(degree: CGFloat) -> CGFloat
    {
        return pi * degree/180
    }
    
    fileprivate func drawSecondMarker(context: CGContext,
                                      x: CGFloat,
                                      y: CGFloat,
                                      radius: CGFloat,
                                      color: UIColor,
                                      lineWidth: CGFloat)
    {
        //generate a path
        let path = CGMutablePath()
        //move to starting point on edge of circle
        path.move(to: CGPoint(x: radius, y: 0))
        //draw line of required length
        path.addLine(to: CGPoint(x: x, y: y))
        path.closeSubpath()
        //add path to context
        context.addPath(path)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color.cgColor)
        context.strokePath()
    }
    
    fileprivate func time() -> (h: Int, m: Int, s: Int)
    {
        var hms = [Int]()
        
        let calendar = Calendar.current
        let date = Date()
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        hms.append(hour)
        hms.append(minute)
        hms.append(second)

        return (h: hms[0], m: hms[1], s: hms[2])
    }
    
    /*Calculate the coordinates at which the hands are to be drawn from and to.
     The from is simple, it is the centre of the clock, which is also the centre of the UIView subclass.
     To calculate the "to position", we have to convert hours and minutes to a seconds representation
     and find the position along the circumference of a circle divided into 60 positions evenly spaced.
     */
    fileprivate func timeCoords(x: CGFloat,
                                y: CGFloat,
                                time: (h:Int, m:Int, s:Int),
                                radius: CGFloat,
                                adjustment: CGFloat=90) -> (h:CGPoint, m: CGPoint, s: CGPoint)
    {
        let cX = x
        let cY = y
        var r  = radius
        var points = [CGPoint]()
        var angle = degreeToRadian(degree: 6)
        
        func newPoint(t: Int)
        {
            let xPos = cX - r*cos(angle*CGFloat(t)+self.degreeToRadian(degree: adjustment))
            let yPos = cY - r*sin(angle*CGFloat(t)+self.degreeToRadian(degree: adjustment))
            points.append(CGPoint(x: xPos, y: yPos))
        }
        
        //hours
        var hours = time.h
        if hours > 12
        {
            hours = hours-12
        }
        let hoursInSeconds = time.h*3600 + time.m*60 + time.s
        newPoint(t: hoursInSeconds*5/3600)
        
        //minutes
        r = radius * 1.5
        let minutesInSeconds = time.m*60 + time.s
        newPoint(t: minutesInSeconds/60)
        
        //seconds
        r = radius * 1.8
        newPoint(t: time.s)
        
        return (h: points[0], m: points[1], s: points[2])
    }
    
    fileprivate func rotateLayer(currentLayer: CALayer,
                                 duration: TimeInterval,
                                 smooth: Bool)
    {
        let angle = degreeToRadian(degree: 360)
        if smooth
        {
            let theAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            theAnimation.duration = duration
            theAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            theAnimation.fromValue = 0
            theAnimation.repeatCount = Float.infinity
            theAnimation.toValue = angle
            //add animation to layer
            currentLayer.add(theAnimation, forKey: "rotate")
        }
        else
        {
            var currentAngle:CGFloat = 0
            if #available(iOS 10.0, *) {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                    currentAngle += self.degreeToRadian(degree: 6)
                    if currentAngle == 2*pi
                    {
                        currentAngle = 0
                    }
                    currentLayer.setAffineTransform(CGAffineTransform(rotationAngle: currentAngle))
                })
            } else {
                // Fallback on earlier versions
                
            }
        }
    }
    
    fileprivate func drawText(rect:CGRect,
                              ctx:CGContext,
                              x:CGFloat,
                              y:CGFloat,
                              radius:CGFloat,
                              sides:NumberOfNumerals,
                              color:UIColor)
    {
        
        ctx.translateBy(x: 0.0, y: rect.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        // dictates on how inset the ring of numbers will be
        let inset:CGFloat = radius/3.5
        // An adjustment of 270 degrees to position numbers correctly
        let points = circleCircumferencePoints(sides: sides.rawValue,x: x,y: y,radius: radius-inset,adjustment:270)
        // multiplier enables correcting numbering when fewer than 12 numbers are featured, e.g. 4 sides will display 12, 3, 6, 9
        let multiplier = 12/sides.rawValue
        
        for p in points.enumerated()
        {
            if p.offset > 0
            {
                // Font name must be written exactly the same as the system stores it (some names are hyphenated, some aren't) and must exist on the user's device. Otherwise there will be a crash. (In real use checks and fallbacks would be created.) For a list of iOS 7 fonts see here: http://support.apple.com/en-us/ht5878
                let aFont = UIFont(name: "DamascusBold", size: radius/5)
                // create a dictionary of attributes to be applied to the string
                let attr:CFDictionary = [NSFontAttributeName:aFont!,NSForegroundColorAttributeName:UIColor.white] as CFDictionary
                // create the attributed string
                let str = String(p.offset*multiplier)
                let text = CFAttributedStringCreate(nil, str as CFString!, attr)
                // create the line of text
                let line = CTLineCreateWithAttributedString(text!)
                // retrieve the bounds of the text
                let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useOpticalBounds)
                // set the line width to stroke the text with
                ctx.setLineWidth(1.5)
                // set the drawing mode to stroke
                ctx.setTextDrawingMode(.stroke)
                // Set text position and draw the line into the graphics context, text length and height is adjusted for
                let xn = p.element.x - bounds.width/2
                let yn = p.element.y - bounds.midY
                ctx.textPosition = CGPoint(x: xn, y: yn)
                // draw the line of text
                CTLineDraw(line, ctx)
            }
        }
    }
    
    fileprivate func circleCircumferencePoints(sides:Int,
                                               x:CGFloat,
                                               y:CGFloat,
                                               radius:CGFloat,
                                               adjustment:CGFloat=0) -> [CGPoint]
    {
        let angle = degreeToRadian(degree: 360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides
        {
            let xpo = cx - r * cos(angle * CGFloat(i)+degreeToRadian(degree: adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i)+degreeToRadian(degree: adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i -= 1
        }
        return points
    }
    
    func clear()
    {
        for view in self.subviews
        {
            view.removeFromSuperview()
        }
    }
}
