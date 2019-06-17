//
//  DRBCircularSliderView.swift
//  DRBCircularSlider
//
//  Created by DBarfoot on 17/06/2019.
//  Copyright © 2019 Dave Barfoot. All rights reserved.
//

import SwiftUI

struct DRBCircularSlider : View {
    @State private var center = CGPoint(x: 0.0,y: 0.0)
    @State private var radius: CGFloat = 0.0
    @State private var handleAngle: Angle = Angle(degrees: 0.0)
    @State private var handlePos: CGPoint = CGPoint(x:0, y:0)
    @State var size: CGFloat
    @State var stroke: CGFloat
    @State var initial: Double
    @State var startAngle: Double
    @State var endAngle: Double
    @Binding var value: Double
    
    func calcValue() {
        self.value = self.handleAngle.degrees + 180.0
        print("value: \(value)")
    }
    
    func findAngleCentreToPoint(center: CGPoint, selected: CGPoint) -> Angle {
        var sideOpp: Double, sideAdj: Double
        var a: Double
        var r: Angle
        var ta: Double, ts: Double, te: Double
        
        sideAdj = Double(selected.x)
        sideOpp = Double(selected.y)
        a = atan2(sideAdj, sideOpp)
        r = Angle(radians: -a)
        
        // Ensure we are positive for ease of calculations - A kludge for now
        ta = r.degrees + 360.0
        ts = startAngle + 360.0 - 180.0
        te = endAngle + 360.0 - 180.0
        
        if (ta < ts) { r.degrees = startAngle - 180.0 }
        if (ta > te) { r.degrees = endAngle - 180.0 }
        
        return r
    }
    
    func findPositionOnCircumference(radius: CGFloat, angle: Angle) -> CGPoint {
        var x,y: CGFloat
        var ta: Double, ts: Double, te: Double
        var a = Angle(degrees: angle.degrees + 90.0)
        
        // Ensure we are positive for ease of calculations - A kludge for now
        ta = a.degrees + 360.0
        ts = startAngle + 360.0 - 90.0
        te = endAngle + 360.0 - 90.0
        
        if (ta < ts) { a.degrees = startAngle - 90.0 }
        
        if (ta > te) { a.degrees = endAngle - 90.0 }
        
        print("a: \(ta) start: \(ts) end: \(te)")
        
        
        x = (radius * cos(CGFloat(a.radians))) + center.x
        y = (radius * sin(CGFloat(a.radians))) + center.y
        print("radius: \(radius) x: \(x) y: \(y)")
        
        return CGPoint(x: x,y: y)
    }
    
    var body: some View {
        VStack {
            ZStack {
                // Background track. We should make this less in your face
                Path { path in
                    path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startAngle-90.0), endAngle: Angle(degrees: endAngle-90.0), clockwise: false)
                    }.stroke(Color.gray, lineWidth: 2.0)
                    .opacity(0.25)
                // The main track showing the current value
                Path { path in
                    path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startAngle-90.0), endAngle: Angle(degrees: handleAngle.degrees + 90.0), clockwise: false)
                    }.stroke(Color.blue, style: StrokeStyle(lineWidth: stroke, lineCap: .round))
                // The handle
                Path { path in
                    path.addArc(center: CGPoint(x: handlePos.x, y: handlePos.y), radius: stroke, startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 360.0), clockwise: true)
                    }.fill(Color.red)
            }
            }
            .frame(width: size, height: size, alignment: .center)
            .gesture(
                // Deal with dragging the handle
                DragGesture(minimumDistance: 1)
                    .onChanged() { v in
                        //print("x: \(v.location.x) y: \(v.location.y)")
                        // Find the angle between our touch point and the center of the circle
                        self.handleAngle = self.findAngleCentreToPoint(center: self.center, selected: CGPoint(x: v.location.x-self.center.x, y: v.location.y-self.center.y))
                        // Turn that andle into a user facing value
                        self.calcValue()
                        //print("drag angle: \(self.handleAngle.degrees) value: \(self.value)")
                        // Use the angle to find out where to draw the handle and update the circles on screen
                        self.handlePos=self.findPositionOnCircumference(radius: self.radius, angle: self.handleAngle)
                        //self.calcValue()
            })
            .onAppear() {
                // This runs when the display is first shown so we init stuff here
                
                // Center is the middle of the control - obviously
                self.center = CGPoint(x: self.size/2.0,y: self.size/2.0)
                // Sroke is centered on circumference so we lose half a stroke each side via radius
                // We take a full stroke off to allow for the handle to be 2*stroke wide
                // take a pixel each side for safety - this needs revisiting
                self.radius = (self.size/2.0) - (self.stroke) - 2.0
                // Convert std 0deg at top range to what the system uses
                self.handleAngle = Angle(degrees: self.initial - 180.0)
                // Function to turn machine angle back to 0deg at top for human use
                self.calcValue()
                // Find where to draw the handle at startup
                self.handlePos=self.findPositionOnCircumference(radius: self.radius, angle: self.handleAngle)
        }
    }
}
