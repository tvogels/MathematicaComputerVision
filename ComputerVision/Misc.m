(* Mathematica Package *)

BeginPackage["ComputerVision`Misc`"]

BressenhamPoints::usage = "BressenhamPoints[A,B] gives a list of the pixel-points on the line segment between A and B.";

BressenhamPoints[A_, B_] := 
	Module[{a, b, c, pixels, cp, d, i, p, q, slope, mirror, plusminus},
		
		(* Make sure A lies on the left of B, call them p,q *)
		If[B[[1]] > A[[1]],
			{p, q} = {A, B},
			{p, q} = {B, A}
		];

		(* If the slope is negative, make it positive *)
		plusminus = False;
		If[p[[2]] > q[[2]],
			p[[2]] = -p[[2]];
			q[[2]] = -q[[2]];
			plusminus = True;
		];

		(* Find the line as b y - a x - c = 0 *)
		{a, b, c} = {-1, 1, -1}*lineThrough[hgc[p],hgc[q]];

		(* If the slope is larger than one, swap x and y *)
		(* Replace infinity by a big number, to avoid errors *)
		slope = a/Max[b, .000001];
		mirror = False;
		If[slope > 1,
			mirror = True;
			p = {p[[2]], p[[1]]};
			q = {q[[2]], q[[1]]};
			{a, b, c} = {b, a, -c};
		];
		
		(* The algorithm every time tries the point at (currentX+1,currentY+1/2) 
		   and tests if it is above or below the line (this produces a d-value) *)
		pixels = {p};
		cp = p;
		d = b (cp[[2]] + 1/2) - a (cp[[1]] + 1) - c;
		For[i = 2, i <= (q[[1]] - p[[1]] + 1), i++,
			If[d > 0,
				(* d-pixel is above the line, go east *)
				cp = cp + {1, 0};
				pixels = Append[pixels, cp];
				d = d - a; ,
				(* d-pixel is below the line, go north-east *)
				cp = cp + {1, 1};
				pixels = Append[pixels, cp];
				d = d + b - a;
			];
		];
		
		(* If points were mirrored, reverse it *)
		If[mirror, pixels = {#2, #1} & @@@ pixels];
		If[plusminus, pixels = {#1, -#2} & @@@ pixels];
		
		(* Return the pixel coordinates *)
		pixels
	];


Begin["`Private`"] (* Begin Private Context *) 

End[] (* End Private Context *)

EndPackage[]