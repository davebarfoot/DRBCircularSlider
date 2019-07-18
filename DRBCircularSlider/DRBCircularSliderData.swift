//
//  DRBCircularSliderData.swift
//  DRBCircularSlider
//
//  Created by DBarfoot on 19/06/2019.
//  Copyright © 2019 Dave Barfoot. All rights reserved.
//

import Combine
import SwiftUI

class DRBCircularSliderData: BindableObject {
  
  var willChange = PassthroughSubject<Void, Never>()
  
  // All the data with defaults
  var center = CGPoint(x: 0.0,y: 0.0) { didSet { update() } }
  var radius: CGFloat = 0.0 { didSet { update() } }
  var handleAngle: Angle = Angle(degrees: 0.0) { didSet { update() } }
  var handlePos: CGPoint = CGPoint(x:0, y:0) { didSet { update() } }
  var size: CGFloat = 150.0 { didSet { reInit() } }
  var stroke: CGFloat = 10.0 { didSet { reInit() } }
  var indicatorColor: Color = .blue { didSet { reInit() } }
  var handleColor: Color = .red { didSet { reInit() } }
  var initial: Double = 0.0 { didSet { reInit() } }
  var startAngle: Double = 0.0 { didSet { reInit() } }
  var endAngle: Double = 360.0 { didSet { reInit() } }
  var minValue: Double = 0.0 { didSet { reInit() } }
  var maxValue: Double = 360.0 { didSet { reInit() } }
  var value: Double = 0.0 { didSet { update() } }
  var colors: [ColorChange] = [] { didSet { update() } }
  
  var useColor: Color = Color.blue
  
  // Initialize everything, all with a default so parameters can
  // be left out. Don't try changing the order though.
  init(center: CGPoint = CGPoint(x: 0.0,y: 0.0),
       radius: CGFloat = 0.0,
       handleAngle: Angle = Angle(degrees: 0.0),
       handlePos: CGPoint = CGPoint(x:0, y:0),
       size: CGFloat = 150.0,
       stroke: CGFloat = 10.0,
       indicatorColor: Color = .blue,
       handleColor: Color = .red,
       initial: Double = 0.0,
       startAngle: Double = 0.0,
       endAngle: Double = 0.0,
       minValue: Double = 0.0,
       maxValue: Double = 360.0,
       value: Double = 0.0
  )
  {
    self.center = center
    self.radius = radius
    self.handleAngle = handleAngle
    self.handlePos = handlePos
    self.size = size
    self.stroke = stroke
    self.indicatorColor = indicatorColor
    self.handleColor = handleColor
    self.initial = initial
    self.startAngle = startAngle
    self.endAngle = endAngle
    self.minValue = minValue
    self.maxValue = maxValue
    self.value = value
    
    // The center is, unsurprisingly, calculated from the size. This is an
    // assumption that the control itself uses size for its frame definition
    self.center = CGPoint(x: self.size/2.0,y: self.size/2.0)
    
    // Stroke is centered on circumference so we lose half a stroke each side via radius
    // We take a full stroke off to allow for the handle to be 2*stroke wide
    // take a pixel each side for safety - this probably needs revisiting
    self.radius = (self.size/2.0) - (self.stroke) - 2.0
    
    // If we specified an initial value less than the minimum possible, correct it
    if(self.initial<self.minValue) { self.initial=self.minValue }
    
    // Convert the 'top' of the circle to be the angle chosen via rotation. This
    // assumes that a 0deg rotation puts 0deg at the top.
    self.handleAngle = Angle(degrees: self.initial - 180.0)
    
    // Calculate the value the current position represents
    calcValue()
    
    // Find where to draw the handle at startup
    self.handlePos=findPositionOnCircumference(radius: self.radius, angle: self.handleAngle)
    update();
  }
  
  // Calculate color changes required and tell the Views it's time to redraw
  func update() {
    DispatchQueue.main.async {
      self.willChange.send()
      self.chooseColor()
    }
    
  }
  
  func chooseColor() {
    if(colors.count == 0 ) {
      // No alternate colors, so do nothing
      return
    }
    // We have alternate colors, so pick the right one
    //Start with the chosen color
    useColor=indicatorColor
    
    for col in colors {
      if( value >= col.value) {
        useColor=col.color
      }
    }
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
    
    if (ta < ts) { a.degrees = startAngle - 90.0}
    
    if (ta > te) { a.degrees = endAngle - 90.0 }
    
    x = (radius * cos(CGFloat(a.radians))) + center.x
    y = (radius * sin(CGFloat(a.radians))) + center.y
    
    return CGPoint(x: x,y: y)
  }
  
  // Calculate the user facing value from the current position
  func calcValue() {
    let nativeValue = handleAngle.degrees + 180.0
    let nativeRange = endAngle-startAngle
    let targetRange = maxValue-minValue
    
    value = (((nativeValue - startAngle ) * targetRange) / nativeRange ) + minValue
  }
  
  func reInit() {
    // unsurprisingly, the center is in the center
    self.center = CGPoint(x: self.size/2.0,y: self.size/2.0)
    
    // Sroke is centered on circumference so we lose half a stroke each side via radius
    // We take a full stroke off to allow for the handle to be 2*stroke wide
    // take a pixel each side for minimal padding - this probably needs revisiting
    self.radius = (self.size/2.0) - (self.stroke) - 2.0
    
    // Convert std 0deg at top range to what the system uses
    self.handleAngle = Angle(degrees: self.initial - 180.0)
    
    // Calculate the value in the range the current position represents
    self.calcValue()
    
    // Work out where to draw the handle
    self.handlePos=self.findPositionOnCircumference(radius: self.radius, angle: self.handleAngle)
    
    // Set the Color we are using to draw the indicator from the user facing value
    if (self.useColor != self.indicatorColor) {
      self.useColor = self.indicatorColor
    }
    
    // Tell any dependant view that it's time to redraw
    self.update()
  }
  
  struct ColorChange {
    var value: Double
    var color: Color
  }
  
}
