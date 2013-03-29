MathematicaComputerVision
=========================

A library for functions related to multiple view geometry in Mathematica.

* Author: Thijs Vogels
* Supervisor: Dr. Richard van den Doel
* Roosevelt University College, Middelburg, Netherlands

## Installation
1. Download the application zip-file
2. Go to File>Install in Mathematica and select the zip.

## Documentation
The application documentation will be integrated in the native Mathematica docs.

## Available functions

### Utilities
<table>
	<tr>
		<td><code>Hgc[x]</code></td>
		<td>converts a list x representing a point in n-dimensional space 
  to homogeneous coordinates by appending a 1.</td>
	</tr>
	<tr>
		<td><code>Nc[x]</code></td>
		<td>converts a list x representing a point in homogeneous coordinates
  to non-homogeneous coordinates by stripping the last element and dividing by it.
If the point lies on infintiy, a warning is thrown.</td>
	</tr>
	<tr>
		<td><code>Intersect[l,m]</code></td>
		<td>returns the intersection the homogeneous 2d lines l and m.</td>
	</tr>
	<tr>
		<td><code>LineThrough[p,q]</code></td>
		<td>returns the line joining the homogeneous 2d points p and q.</td>
	</tr>
	<tr>
		<td><code>LineRep[l]</code></td>
		<td>represents a homogeneous line {a,b,c} as a x + b y + c ==0
for use in functions like ContourPlot.</td>
	</tr>
	<tr>
		<td><code>LineDirection[l]</code></td>
		<td>returns the direction of the line l.</td>
	</tr>
</table>

### Homographies
<table>
	<tr>
		<td><code>NormalizePoints[pts]</code></td>
		<td>normalizes a set of non-homogeneous or non-infinite homogeneous 2d points such that:
* their centroid is in the origin
* their mean distance from the origin is sqrt(2)
Returns the normalized set of points <b>and</b> the transformation that transforms a set of homogeneous points to the normalized ones (for denormalization purposes)</td>
	</tr>
	<tr>
		<td><code>NormalizePoints3D[pts]</code></td>
		<td>normalizes a set of non-homogeneous or non-infinite homogeneous 3d points such that:
* their centroid is in the origin
* their mean distance from the origin is sqrt(3)
Returns the normalized set of points <b>and</b> the transformation that transforms a set of homogeneous points to the normalized ones (for denormalization purposes)</td>
	</tr>
	<tr>
		<td><code>Homography2D[x,y]</code></td>
		<td>calculates a homography between two sets of homogeneous 2D points x and y using the Direct Linear Transformation algorithm (Hartley&amp;Zisserman, p.89). For optimal results the Gold Standard algorithm should be used.</td>
	</tr>
</table>

### Image Manipulation
<table>
	<tr>
		<td><code>ImageCoordinateToDataPoint[p,img]</code></td>
		<td>converts image coordinates (origin left-bottom) to a corresponding data point (origin left-top)</td>
	</tr>
	<tr>
		<td><code>ImageColorAtCoordinate[p,img]</code></td>
		<td>returns the color at coordinate p (origin left-bottom)</td>
	</tr>
	<tr>
		<td><code>LinePointsInImage[l,img]</code></td>
		<td>gives the two extreme points on an image of a homogeneous line (snapped to pixel-positions)<br>
NOT TESTED for lines that lie completely outside the image</td>
	</tr>
	<tr>
		<td><code>LineInImage[l,img]</code></td>
		<td>takes the points from LinePointsInImage and makes it a Graphics primitive.</td>
	</tr>
</table>

### Miscelaneous
<table>
	<tr>
		<td><code>BressenhamPoints[A,B]</code></td>
		<td>gives a list of the pixel-points on the line segment between A and B.</td>
	</tr>
</table>



