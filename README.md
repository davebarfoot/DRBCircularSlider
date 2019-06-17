# DRBCircularSlider

BEWARE: This is me learning/experimenting with SwiftUI and Swift at the same time.
I fully expect to have to refactor this code as I realise the mistakes I've made.

It's fairly rough and ready at the moment and I'm actively fiddling with it

## Some basic info

* It treats 0 degrees as top center of the circle
* By default, the vaule returned is 0.0-359.9.
* Start angle and end angle are specified by absolute degree angles
* You can specify the size of the control. A single value used for both width and height
* You can specify the stroke width for the indicator track
* You can specify the color of the indicator track and the drag handle
* You can specify the initial value of the indicator
* You can specify the min value and max value of a new output range
* You can specify a @State variable that will be used to store the selected value

## Where Are We Going

* Parameters are getting unweildy.
  * I'm considering creating a class to store the values which could then be passed more neatly
* I can't see a way of programatically changing the value at the moment.
  * The class for parameters may present a solution for this too.
* I would like to be able to change the color of the indicator track based on the selected value
* I would like the make the indicator track/handle a bit more nuanced colorwize.
* I feel the handle size is good for smaller stroke widths, but looks unwieldy at larger sizes
* I suspect I should be using a GeometryReader. I'm going to investigate soon.

If it gets to a point where I've happy with it, I'll turn it into a package

Feel free to use it if you think it might be useful to you. An attribution might
be nice if you use it in anything published.

Dave Barfoot
209-06-17
