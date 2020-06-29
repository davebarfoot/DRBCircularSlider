//
//  ContentView.swift
//  DRBCircSlider
//
//  Created by Dave Barfoot on 13/06/2019.
//  Copyright © 2019 Dave Barfoot. All rights reserved.
//

import Combine
import SwiftUI

// DRBCircularSliderData Parameter Order :-
//    size:stroke:indicatorColor:handleColor:initial:startAngle:endAngle:minValue:maxValue:value:

struct ContentView : View {
    // Define an instance of the DRBCircularSliderData class for each slider
    // Remember angles all reference from 0deg at the top, clockwise
    //
    // These are where we set parameters and read values
    @ObservedObject var sv1: DRBCircularSliderData = DRBCircularSliderData(size:100.0,
                                                                           stroke:5.0,
                                                                           indicatorColor:.green,
                                                                           initial:60.0,
                                                                           startAngle: 45.0,
                                                                           endAngle:315.0,
                                                                           minValue:45.0,
                                                                           maxValue:315.0)
    @ObservedObject var sv2: DRBCircularSliderData = DRBCircularSliderData(size:200.0,
                                                                           stroke:10.0,
                                                                           indicatorColor:.yellow,
                                                                           initial:72.0,
                                                                           startAngle:20.0,
                                                                           endAngle:340.0,
                                                                           minValue:1.0,
                                                                           maxValue:10.0)
    @ObservedObject var sv3: DRBCircularSliderData  = DRBCircularSliderData(size:300.0,
                                                                            stroke:20.0,
                                                                            handleColor:.gray,
                                                                            initial:135.0,
                                                                            startAngle:60.0,
                                                                            endAngle:300.0,
                                                                            minValue:2.5,
                                                                            maxValue:26.0)
    
    var body: some View {
        VStack {
            // Using a ZStack, we can put the value in the middle of the slider
            // Just a suggestion though
            ZStack {
                DRBCircularSlider(data: sv3)
                Text(String(self.sv3.svalue))
            }
            ZStack {
                DRBCircularSlider(data: sv2)
                Text(String(self.sv2.svalue))
                ZStack {
                    VStack {
                        HStack {
                            Button("+") {
                                
                            }
                            Spacer()
                            Button("-") {
                                
                            }.padding(.horizontal)
                        }
                        Spacer()
                    }.frame(width: 200, height: 200)
                }
                
            }
            ZStack {
                DRBCircularSlider(data: sv1)
                Text(String(self.sv1.svalue))
            }.onAppear() {
                self.sv1.colors.append(DRBCircularSliderData.ColorChange(value: 120.0, color: Color.red))
                self.sv1.colors.append(DRBCircularSliderData.ColorChange(value: 190.0, color: Color.purple))
                self.sv3.colors.append(DRBCircularSliderData.ColorChange(value: 13.0, color: Color.pink))
            }
            
            // We can set the initial value at any time to update the current state of the slider
            Button(action: {
                self.sv1.initial = Double(180.0)
                self.sv1.indicatorColor =  .red
                self.sv2.initial = Double(180.0)
                self.sv2.indicatorColor = .green
                self.sv3.initial = Double(180.0)
                self.sv3.indicatorColor = .blue
            }) { Text("180") }
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
