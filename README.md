![MazeKit](https://raw.githubusercontent.com/aaronjsutton/MazeKit/travis/MazeKit/Media.xcassets/Text.imageset/Text%402x.png?token=AKeWfwaL09Hk84pu8UXTSWD1f8Z3dt_Tks5bOWxiwA%3D%3D)

Generate random mazes using the Depth-First Search algorithm. 

# Installation

## Compatibility

MazeKit is written using the Swift Standard Library&mdash; it does not depend on Foundation. It does however, depend on **Swift 4.2** which is only
availble in Xcode 10 or higher.  

## Embedded Framework

Follow the steps below to integrate MazeKit into your Xcode project. 

* Open Terminal, `cd` into your project's top level source directory. 

* Add MazeKit as a submodule by running: 

```
git submodule add https://github.com/aaronjsutton/MazeKit.git
```

* Inside the newly created `MazeKit` folder, drag or import `MazeKit.xcodeproj` into your project's file navigator. 

* Select the project settings for your main project. Under `Embedded Frameworks and Libraries`, click the `+`, and select MazeKit from the drop down menu. 

```swift
import MazeKit
```
And you're ready to go.

# Usage

Read the [quick start guide](https://docs.aaronjsutton.com/mazekit/quick-start.html) or the full [documentation](https://docs.aaronjsutton.com/mazekit) for details.



