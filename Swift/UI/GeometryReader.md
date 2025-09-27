## What is ```GeometryReader```
```GeometryReader``` is a container view which measures the size and positions of the views it contains, relative to its parent.

This is passed down to child views which allows you to dynamically adjust your layout based on the available space.

The following properties can be accessed:
- ```Size``` (width and height)
- ```Position``` (frame origin)

## How ```GeometryReader``` Works
When wrapping a view inside ```GeometryReader```, it takes a closure which provides a ```GeometryProxy``` object, which provides information about the container such as its size and position, which can be used to customise the layout.

```
GeometryReader { geometry in  
	VStack {  
		Text("Width: \(geometry.size.width)")  
		Text("Height: \(geometry.size.height)")  
	}  
}
```

- **```geometry```**: This is the ```GeometryProxy``` object passed into the closure
- **```geometry.size.width```**: Represents the width of the enclosing view
- **```geometry.size.height```**: Represents the height of the enclosing view

## Practical Example of Using ```GeometryReader```
The following code is an example of making a circle that automatically resizes based on the available screen size:

```
struct ResponsiveCircleView: View {  
	var body: some View {  
		GeometryReader { geometry in  
			Circle()  
				.fill(Color.blue)  
				.frame(
					width: geometry.size.width * 0.5, 
					height: geometry.size.width * 0.5
				)  
				.position(
					x: geometry.size.width / 2, 
					y: geometry.size.height / 2
				)  
			}  
		.background(Color.gray.opacity(0.2)) // Background to see the bounds 
	}  
}
```

- **Dynamic sizing**: The ```.frame``` of the circle is set to be half of the width of the available space, using ```geometry.size.width```, which makes the circle responsive to the size of the parent view
- **Positioning**: The position of the circle is at the centre of ```GeometryReader```'s frame using the ```.position``` modifier

Another example is this view below, where a rectangle needs to take up 70% of the screen's width and is centred horizontally:

```
struct ResponsiveRectangleView: View {  
	var body: some View {  
		GeometryReader { geometry in  
			Rectangle()  
				.fill(Color.green)  
				.frame(
					width: geometry.size.width * 0.7, 
					height: 100
				)  
				.position(
					x: geometry.size.width / 2, 
					y: geometry.size.height / 2
				)  
			}  
		.background(Color.orange.opacity(0.2))  
	}  
}
```

## Why do we use ```GeometryReader```
The key reason it is used it to create dynamic and responsive layouts, and it particularly useful where the following conditions are true:
- **Different Screen Sizes**: When creating layouts for iPhones, iPads, or multi-window support, `GeometryReader` ensures that your views adapt correctly based on the available space.
- **Orientation Changes**: With devices that can rotate, like iPhones and iPads, the view needs to react to different orientations, and `GeometryReader` can help adjust the layout accordingly.
- **Flexible, Adaptive UI**: For cases where UI elements need to change size or position based on the parent container (such as a view being half the size of its parent), `GeometryReader` is the ideal tool.

# Limitations of `GeometryReader`
While `GeometryReader` is extremely powerful, it also has a few limitations:
- **Infinite Size**: `GeometryReader` asks its parent for as much space as possible. If used in a context where the size is undefined (e.g., inside a `ScrollView`), it might take up all available space, which may not always be the desired behavior.
- **Performance**: Overuse of `GeometryReader` in complex layouts may lead to performance bottlenecks, as it requires calculating and passing layout information down the hierarchy.