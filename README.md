MathematicaComputerVision
=========================

A library for functions related to multiple view geometry in Mathematica.

* Author: Thijs Vogels
* Supervisor: Dr. Richard van den Doel
* Roosevelt University College, Middelbuger, Netherlands

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

### Miscelaneous