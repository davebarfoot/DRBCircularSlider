# DRBCircularSlider

*BEWARE: This is me learning/experimenting with SwiftUI and Swift at the same time.
I fully expect to have to refactor this code as I realize the mistakes I've made.*

I have now got this code to a point where I am reasonably happy to start using it.

This doesn't mean there isn't lots about it I think needs changing, and the way a
few things are implemented feel not quite right, but will need some more thought
and learning so I don't lurch from one bad implementation ot another.

When the time presents itself, I will document this better and turn it into a
package.

For now, the code is in DRBCircularSliderViewData and DRBCircularSliderView.swift
and example of how to instantiate it are in ContentView.swift.

Color changes dependant on the value are set in the onAppear and I'm not sure I
won't change that at some point. At the moment the color changes *must* be specified
in ascending order if you want them to work as you'd expect. I hope to fix that
at some point. The color used below the first color change value is that set for
the indicator color.


## Some Examples

![alt tag](https://github.com/davebarfoot/DRBCircularSlider/raw/master/resources/DRBCircularSliderExample1.jpg)
 - DRBCircularSlider with various parameters altered

## Some basic info

* Data and parameters are created as ObjectBinding instances of a separate class
* It treats 0 degrees as top center of the circle
* By default, the value returned is 0.0-360.0.
* Start angle and end angle are specified by absolute degree angles
* You can specify the size of the control. A single value used for both width and height
* You can specify the stroke width for the indicator track
* You can specify the colors of the indicator track and the drag handle
* You can specify the initial value of the indicator
* You can specify the min value and max value of a new output range
* You can set the initial value at any point programmatically to update the slider
* You can add color change value/color entries via a function call in onAppear
* You can also set any of the above parameters at any time

## Where Are We Going

* I would like the make the indicator track/handle a bit more nuanced colorwize.
* I feel the handle size is good for smaller stroke widths, but looks unwieldy at larger sizes

If it gets to a point where I've happy with it, I'll turn it into a package

Feel free to use it if you think it might be useful to you. An attribution might
be nice if you use it in anything published.

Dave Barfoot  
2019-06-28
