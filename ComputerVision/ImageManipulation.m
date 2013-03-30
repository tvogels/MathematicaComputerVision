(* Mathematica Package *)

BeginPackage["ComputerVision`ImageManipulation`",{"ComputerVision`Utils`"}]

ImageCoordinateToDataPoint::usage = "ImageCoordinateToDataPoint[p,img] converts image coordinates (origin left-bottom) to a corresponding data point (origin left-top)";

ImageColorAtCoordinate::usage = "ImageColorAtCoordinate[p,img] returns the color at coordinate p (origin left-bottom)";

LinePointsInImage::usage = "LinePointsInImage[l,img] gives the two extreme points on an image of a homogeneous line (snapped to pixel-positions)
NOT TESTED for lines that lie completely outside the image";

LineInImage::usage = "LineInImage[l,img] takes the points from LinePointsInImage and makes it a Graphics primitive.";

Begin["`Private`"] (* Begin Private Context *) 

ImageCoordinateToDataPoint[{x_, y_}, img_] :=
	Module[{w,h},
		{w,h}=ImageDimensions[img];
		Round[{h + .5 - y, x + .5}]
	];

ImageColorAtCoordinate[point_, img_] := 
	Module[{p},
		p = ImageCoordinateToDataPoint[point, img];
		ImageData[img][[p[[1]], p[[2]]]]
	];

LinePointsInImage[l_, img_] := 
	Module[{w,h,p1, p2, p3, p4, points},
		{w,h} = ImageDimensions[img];
		p1 = Intersect[l, {0, 1, -.5}];
		p2 = Intersect[l, {0, 1, -h + .5}];
		p3 = Intersect[l, {1, 0, -.5}];
		p4 = Intersect[l, {1, 0, -w + 1/2}];
		points = Nc /@ {p1, p2, p3, p4};
		(* 	The middle two in either the x or y direction are the ones that
			intersect with the image *)
		points = SortBy[points, #[[2]] &];
		Take[points, {2, 3}]
	];

LineInImage[l_, img_] := 
	Line[LinePointsInImage[l, img]];

End[] (* End Private Context *)

EndPackage[]