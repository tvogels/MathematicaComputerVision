(* Mathematica Package *)

BeginPackage["ComputerVision`Homographies`",{"ComputerVision`Utils`"}]

Homography2D::usage = "Homography2D[x,y] calculates a homography between two sets of homogeneous 2D points x and y
  using the Direct Linear Transformation algorithm (Hartley&Zisserman, p.89).
For optimal results the Gold Standard algorithm should be used.";


NormalizePoints::usage = "Normalize[pts_] a set of non-homogeneous or non-infinite homogeneous 2d points such that:
	- their centroid is in the origin
	- their mean distance from the origin is sqrt(2)
Returns the normalized set of points and the transformation that transforms a set of homogeneous points to the normalized ones (for denormalization purposes)";

Begin["`Private`"] (* Begin Private Context *) 

Homography2D[q1_List,q2_List] :=
	Module[ {T1,T2,A,Ai,H,p1,p2},
		(* Normalize both sets of points *)
		{p1,T1}=NormalizePoints[q1];
		{p2,T2}=NormalizePoints[q2];
		(* Construct A_i for one corresponding pair of points x,x' *)
		Ai[x_,xp_] := {
			{0,0,0,-xp[[3]]x[[1]],-xp[[3]]x[[2]],-xp[[3]]x[[3]],xp[[2]]x[[1]],xp[[2]]x[[2]],xp[[2]]x[[3]]},
			{xp[[3]]x[[1]],xp[[3]]x[[2]],xp[[3]]x[[3]],0,0,0,-xp[[1]]x[[1]],-xp[[1]]x[[2]],-xp[[1]]x[[3]]}
		};
		(* Make one matrix out of them *)
		A = Flatten[Ai @@@ Transpose[{p1,p2}],1];
		(* Find H using a SVD *)
		H = Partition[
				SingularValueDecomposition[A][[3,All,-1]]
			,3];
		(* Denormalize and return *)
		H = Inverse[T2].H.T1
	];
	
NormalizePoints[points_List] := 
	Module[{mu, ps2, dist, ps3, m,npoints,columns,scale,pts},
		{npoints,columns} = Dimensions[points];
		
		(* Use normal coordinates *)
		If[columns==3,
			pts = Nc/@points,
			pts = points
		];
		
		(* Make sure centroid is in origin *)
		mu = N[Mean[pts]];
		ps2 = (# - mu) & /@ pts;
	
		(* Make sure rms norm is Sqrt[2] *)
		dist = N[RootMeanSquare[Norm /@ ps2]];
		scale = Sqrt[2]/dist;
		ps3 = scale ps2;
	
		(* What matrix does these actions? *)
		m = {{scale,   0, 	-scale mu[[1]]},
			 {  0, 	 scale, -scale mu[[2]]},
			 {  0, 	   0, 	      1       }};
		
		(* Output homogeneous points *)
		ps3 = Hgc/@ps3;
		
		(* Return the values *)
		{ps3, m}
	];

End[] (* End Private Context *)

EndPackage[]