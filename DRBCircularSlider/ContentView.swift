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
                DRBCircularSlider(size: 100.0, stroke: 5.0, initial: 45.0, startAngle: 45.0, endAngle: 315.0, value: $Slidervalue)
                Text(String(format: "%.2f",self.Slidervalue))
                
            }
            ZStack {
                DRBCircularSlider(size: 200.0, stroke: 10.0, initial: 72.0, startAngle: 20.0, endAngle: 340.0, value: $Slidervalue2)
                Text(String(format: "%.2f",self.Slidervalue2))
                
            }
            ZStack {
                DRBCircularSlider(size: 300.0, stroke: 20.0, initial: 135.0, startAngle: 90.0, endAngle: 270.0,value: $Slidervalue3)
                Text(String(format: "%.2f",self.Slidervalue3))
                
            }
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
