//
//  DRBCircularSliderView.swift
//  DRBCircularSlider
//
//  Created by DBarfoot on 17/06/2019.
//  Copyright © 2019 Dave Barfoot. All rights reserved.
//

import Combine
import SwiftUI

struct DRBCircularSlider : View {
  // You need to pass in an ObjectBinding instance of a DRBCircularSliderData class
  @ObjectBinding var data: DRBCircularSliderData
  
  var body: some View {
    VStack {
      ZStack {
        // Background track. This has been made less in your face via opacity
        // which may have implications if you ZStack this with other components underneath
        Path { path in
          path.addArc(center: data.center, radius: data.radius, startAngle: Angle(degrees: data.startAngle-90.0), endAngle: Angle(degrees: data.endAngle-90.0), clockwise: false)
          }.stroke(Color.gray, lineWidth: 2.0)
          .opacity(0.25)
        // The main track showing the current value
        Path { path in
          path.addArc(center: data.center, radius: data.radius, startAngle: Angle(degrees: data.startAngle-90.0), endAngle: Angle(degrees: data.handleAngle.degrees + 90.0), clockwise: false)
          }.stroke(data.useColor, style: StrokeStyle(lineWidth: data.stroke, lineCap: .round))
        
        // The handle, centered on the end of the main track
        Path { path in
          path.addArc(center: CGPoint(x: data.handlePos.x, y: data.handlePos.y), radius: data.stroke, startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 360.0), clockwise: true)
          }.fill(data.handleColor)
      }
      }
      // Set the size of the control to that specified
      .frame(width: data.size, height: data.size, alignment: .center)
      .gesture(
        // Deal with dragging the handle
        DragGesture(minimumDistance: 1)
          .onChanged() { v in
            // Find the angle between our touch point and the center of the circle
            self.data.handleAngle = self.data.findAngleCentreToPoint(center: self.data.center, selected: CGPoint(x: v.location.x-self.data.center.x, y: v.location.y-self.data.center.y))
            
            // Turn that angle into a user facing value
            self.data.calcValue()
            
            // Use the angle to find out where to draw the handle and update the circles on screen
            self.data.handlePos=self.data.findPositionOnCircumference(radius: self.data.radius, angle: self.data.handleAngle)
      })
      .onAppear() {
        // This runs when the display is first shown so we init stuff here
        
        // Call the function that sets everything up from the current values
        self.data.reInit()
    }
  }
}
