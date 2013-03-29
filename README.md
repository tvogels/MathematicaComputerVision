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
</table>

### Homographies

### Miscelaneous