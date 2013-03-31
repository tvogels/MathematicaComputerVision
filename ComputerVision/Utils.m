(* Mathematica Package *)

BeginPackage["ComputerVision`Utils`"]

Hgc::usage = "Hgc[x] converts a list x representing a point in n-dimensional space 
  to homogeneous coordinates by appending a 1.";

Nc::usage = "Nc[x] converts a list x representing a point in homogeneous coordinates
  to non-homogeneous coordinates by stripping the last element and dividing by it.
If the point lies on infintiy, a warning is thrown.";

Intersect::usage = "Intersect[l,m] returns the intersection the homogeneous 2d lines l and m.";

LineThrough::usage = "LineThrough[p,q] returns the line joining the homogeneous 2d points p and q.";

LineDirection::usage = "LineDirection[l] returns the direction of the line l.";

RQ::usage = "RQ[A] is a variant of the QR Decomposition such that A=R.Q, and R is upper triangular and Q orthogonal.";

Rxyz::usage = "Rxyz[a,b,c] gives a 3x3 rotation matrix that first translates a in the x-direction, then b in the y direction and c in the z-direction.";

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

LineDirection[l_] :=
	If[l[[2]]==0,
		ArcTan[ComplexInfinity],
		ArcTan[-l[[1]]/l[[2]]]
	];

RQ[A_] := 
	Module[{m, n, rA, q, r},
		{m, n} = Dimensions[A];
		rA = Reverse[A];
		{q, r} = N[QRDecomposition[rA\[Transpose]]];
		r = Reverse[Reverse[r\[Transpose]]\[Transpose]]\[Transpose];
		q = Reverse[q];
		{r, q}
	];

Rx[a_] := ( {
    {1, 0, 0},
    {0, Cos[a], -Sin[a]},
    {0, Sin[a], Cos[a]}
   } );
Ry[b_] := ( {
    {Cos[b], 0, Sin[b]},
    {0, 1, 0},
    {-Sin[b], 0, Cos[b]}
   } );
Rz[c_] := ( {
    {Cos[c], -Sin[c], 0},
    {Sin[c], Cos[c], 0},
    {0, 0, 1}
   } );
Rxyz[a_, b_, c_] := Rz[c].Ry[b].Rx[a];
DecomposeRotation[R_] := {
   ArcTan[R[[3, 3]], R[[3, 2]]],
   -ArcSin[R[[3, 1]]],
   ArcTan[R[[1, 1]], R[[2, 1]]]
   };

End[] (* End Private Context *)

EndPackage[]