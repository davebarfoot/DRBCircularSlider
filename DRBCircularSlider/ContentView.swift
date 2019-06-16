//
//  ContentView.swift
//  DRBCircSlider
//
//  Created by Dave Barfoot on 13/06/2019.
//  Copyright © 2019 Dave Barfoot. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @State var Slidervalue: Double = 0.0
    @State var Slidervalue2: Double = 0.0
    @State var Slidervalue3: Double = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                DRBCircSlider(size: 100.0, stroke: 5.0, initial: 45.0, value: $Slidervalue)
                Text(String(format: "%.2f",self.Slidervalue))
                
            }
            ZStack {
                DRBCircSlider(size: 200.0, stroke: 10.0, initial: 72.0, value: $Slidervalue2)
                Text(String(format: "%.2f",self.Slidervalue2))
                
            }
            ZStack {
                DRBCircSlider(size: 300.0, stroke: 15.0, initial: 135.0, value: $Slidervalue3)
                Text(String(format: "%.2f",self.Slidervalue3))
                
            }
        }

    }
}


struct DRBCircSlider : View {
    @State private var center = CGPoint(x: 0.0,y: 0.0)
    @State private var radius: CGFloat = 0.0
    @State private var handleAngle: Angle = Angle(degrees: 0.0)
    @State private var handlePos: CGPoint = CGPoint(x:0, y:0)
    @State var size: CGFloat
    @State var stroke: CGFloat
    @State var initial: Double
    @Binding var value: Double
    
    func calcValue() {
        self.value = self.handleAngle.degrees + 180.0
        print("value: \(value)")
    }
    
    func findAngleCentreToPoint(center: CGPoint, selected: CGPoint) -> Angle {
        var sideOpp: Double, sideAdj: Double
        var a: Double
        var r: Angle
        
        sideAdj = Double(selected.x)
        sideOpp = Double(selected.y)
        a = atan2(sideAdj, sideOpp)
        r = Angle(radians: -a)
        r.degrees = r.degrees
        return r
    }
    
    func findPositionOnCircumference(radius: CGFloat, angle: Angle) -> CGPoint {
        var x,y: CGFloat
        let a = Angle(degrees: angle.degrees + 90.0)
        
        
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
                    path.addArc(center: center, radius: radius, startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 360.0), clockwise: false)
                    }.stroke(Color.gray, lineWidth: 4.0)
                // The main track showing the current value
                Path { path in
                    path.addArc(center: center, radius: radius, startAngle: Angle(degrees: -90.0), endAngle: Angle(degrees: handleAngle.degrees + 90.0), clockwise: false)
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

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
