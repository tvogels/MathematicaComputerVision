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
		<td><code>LineDirection[l]</code></td>
		<td>returns the direction of the line l.</td>
	</tr>
	<tr>
		<td><code>RQ[M]</code></td>
		<td>is a variant of the QR Decomposition such that A=R.Q, and R is upper triangular and Q orthogonal.</td>
	</tr>
	<tr>
		<td><code>Rxyz[α,β,γ]</code></td>
		<td>gives a 3x3 rotation matrix that first translates a in the x-direction, then b in the y direction and c in the z-direction.</td>
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

### Camera Matrix
<table>
	<tr>
		<td><code>CameraMatrixFromCorrespondences[corr]</code></td>
		<td>gives the camera matrix for >=6 {world,pixel} correspondences (homogeneous coordinates) using a DLT method.</td>
	</tr>
	<tr>
		<td><code>DecomposeCamera[P]</code></td>
		<td>decomposes the camera into {K,R,t} such that P = K.R.[I | -t].</td>
	</tr>
	<tr>
		<td><code>DrawCamera[P]</code></td>
		<td>gives a 3D object showing the camera orientation. To be used inside a Graphics3D environment. It uses the img for its dimensions.
<code>DrawCamera[P,size]</code> does the same with a given size.
<code>DrawCamera[P,size,img]</code> let's you specify an image used to find correct the width and height of the screen.</td>
	</tr>
</table>

### Camera Calibration
Based on images of three black squares on a contrasting background.
<table>
	<tr>
		<td><code>SeparateSquares[img,nsquares]</code></td>
		<td>takes an image of n black squares (on a constrasting background) and returns n white images of those squares on a black background.
	It defaults to 3 squares.</td>
	</tr>
	<tr>
		<td><code>CornerInQuadrangleImage[square]</code></td>
		<td>calculates the four corner points in an image of a quadrangle by first finding the edges and intersecting those.
	Returns the points in non-homogeneous coordinates.</td>
	</tr>
	<tr>
		<td><code>CameraCalibrationFromImagedSquares[squares]</code></td>
		<td>returns the internal camera parameters K from the (non-homogeneous) corner points of (at least) three imaged squares. It identifies the image of the absolute conic, and uses a Cholesky decomposition to derive K from omega.</td>
	</tr>
	<tr>
		<td><code>CameraCalibrationFromImagedSquaresAssertingZeroSkew[squares]</code></td>
		<td>returns the internal camera parameters K from the (non-homogeneous) corner points of (at least) three imaged squares. It identifies the image of the absolute conic, and uses a Cholesky decomposition to derive K from omega. It asserts zero skew.</td>
	</tr>
</table>

### Fundamental Matrix
<table>
	<tr>
		<td><code>FFromCorrespondences[corr]</code></td>
		<td>gives a fundamental from a list of point correspondences using a DLT algorithm.</td>
	</tr>
	<tr>
		<td><code>EFromFK[F,K]</code></td>
		<td>gives the essential matrix corresponding to a fundamental matrix F and a calibration matrix K.</td>
	</tr>
	<tr>
		<td><code>DecomposeE[E]</code></td>
		<td>returns four possible second camera matrices that form a couple with [I|0] based on an essential matrix E.</td>
	</tr>
</table>

### Scene Reconstruction
<table>
	<tr>
		<td><code>Triangulate[corr,P1,P2]</code></td>
		<td>gives a DLT-estimate of the 3D-location of corresponding image point correlations in two images and the two camera matrices.</td>
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

### Least squares fitting
<table>
	<tr>
		<td><code>FitConic[points]</code></td>
		<td>fits a conic through at least 5 homogeneous points using linear minimization.</td>
	</tr>
	<tr>
		<td><code>FitLine[points]</code></td>
		<td>gives a least squares fit of a line to a set of points.</td>
	</tr>
</table>

### RANSAC
<table>
	<tr>
		<td><code>RANSAC[x, fittingfn, distfn, degenfn, s, t, feedback, maxDataTrials, maxTrials]</td>
		<td>is a general RANSAC implementation. The last three arguments are optional.</td>
	</tr>
</table>

### File System
<table>
	<tr>
		<td><code>LoadImagesInDirectory[dir]</code></td>
		<td>returns all images in a directory.</td>
	</tr>
</table>

### Miscelaneous
<table>
	<tr>
		<td><code>BressenhamPoints[A,B]</code></td>
		<td>gives a list of the pixel-points on the line segment between A and B.</td>
	</tr>
</table>



