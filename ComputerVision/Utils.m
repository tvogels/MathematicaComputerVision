(* Mathematica Package *)

BeginPackage["ComputerVision`Utils`"]

Hgc::usage = "Hgc[x] converts a list x representing a point in n-dimensional space 
  to homogeneous coordinates by appending a 1.";

Nc::usage = "Nc[x] converts a list x representing a point in homogeneous coordinates
  to non-homogeneous coordinates by stripping the last element and dividing by it.
If the point lies on infintiy, a warning is thrown.";

Intersect::usage = "Intersect[l,m] returns the intersection the homogeneous 2d lines l and m.";

LineThrough::usage = "LineThrough[p,q] returns the line joining the homogeneous 2d points p and q.";

LineRep::usage = "LineRep[l] represents a homogeneous line {a,b,c} as a x + b y + c ==0
for use in functions like ContourPlot";

LineDirection::usage = "LineDirection[l] returns the direction of the line l.";


Begin["`Private`"] (* Begin Private Context *) 

Hgc[x_List] := 
	Append[x,1];

Nc::argx = "The argument of Nc[x] should be a list of at least length 2.";
Nc::infinity = "Cannot convert point at infinity to non-homogeneous coordinates";
Nc[x_List] := 
	Module[{f},
		(* Chop of the last element and divide by it *)
		f = Last[x];
		If[ f == 0, Message[Nc::infinity]; Return[] ];
		N[Take[x,{1,Length[x]-1}]/f]
	];

Intersect[l_List,m_List] :=
	Cross[l,m];

LineThrough[p_,q_] :=
	Cross[p,q]

LineRep[l_] := 
	Evaluate[Simplify[l.{x, y, 1} == 0]];

LineDirection[l_] :=
	If[l[[2]]==0,
		ArcTan[ComplexInfinity],
		ArcTan[-l[[1]]/l[[2]]]
	];

End[] (* End Private Context *)

EndPackage[]