Coaster
========

Coaster is an example app for a fun scroll view I made. Unfortunately newer versions of iOS has broken my scroll view positioning in the corners a bit because it has many finely tuned parameters.

The most interesting code to take a look at is [TrailView.mm](Coaster/TrailView.mm)

### General
The app opens with a bunch of circles lining the left, bottom, and right of your screen with peoples' faces on them (they are just placeholders). There are three physical scroll views, but the left one is the only one that actually holds the circles.

### Scrolling
When you scroll your fingers on the circles you see that they float around the three edges of the screen, and decelerate smoothly like a normal scroll view in any app. The way this happens is that when you tap your finger down on the screen, it registers that scroll view as the master scroll view, and the other two scroll views set their offset based on the master's offset. As the master decelerates because you let your finger off, the other two scroll views just follow suit. Getting this type of behavior took a lot of meddling but it is pretty robust now.

### Reusing
This scroll view has it's own reusing mechanism for the circles because this scroll view is infinite scrolling. Because all the circles are actually only members of the left edge scroll view, when they float off the screen they are repositioned at a different part of the scroll view so that they show back up, but usually with different data unless the total number of viewable circles is a perfect divisor of the number of pieces of data you have populating the circles.
