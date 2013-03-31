(* Mathematica Package *)

BeginPackage["ComputerVision`LeastSquaresFitting`",{"ComputerVision`Utils`","ComputerVision`Homographies`"}]

FitConic::usage = "FitConic[points] fits a conic through at least 5 homogeneous points using linear minimization.";

FitLine::usage = "FitLine[points] gives a least squares fit of a line to a set of points. ";

Begin["`Private`"] (* Begin Private Context *) 

FitConic[points_] :=
	Module[ {A,Ai,a,b,c,d,e,f},
		(* 	Formulate the constraints as transpose(p).c.p=0
			c is of the form {{a,b/2,d/2},{b/2,c,e/2},{d/2,e/2,f}}.  *)
		Ai[p_] := {
			p[[1]]^2,
			p[[1]]p[[2]],
			p[[2]]^2,
			p[[1]]p[[3]],
			p[[2]]p[[3]],
			p[[3]]^2
		};
		A = Ai/@Hgc/@points;
		{a,b,c,d,e,f} = SingularValueDecomposition[A][[3,All,-1]];
		{{a,b/2,d/2},{b/2,c,e/2},{d/2,e/2,f}}
	];

FitLine[points_] :=
	Module[ {pointsn, npts, rows, T, Cc,pts, theta, k},
		
		{npts, rows} = Dimensions[points];
		
		If[rows==2,
			(* Add homogeneous scale coordinate of 1 *)
			pts = Hgc/@points,
			pts = points
		];
		
		If[ npts < 2,
			Throw["Too few points to fit line"];
			Break[];
		];
		
		(* Normalise points so that centroid is at origin and mean distance from *)
		(* origin is sqrt(2).  This conditions the equations *)
		{pointsn, T} = NormalizePoints[pts];
		
		(* Set up constraint equations of the form  pointsn*C = 0, *)
		(* where C is a column vector of the line coefficients *)
		(* in the form   c(1)*X + c(2)*Y + c(3) = 0. *)
		Cc = SingularValueDecomposition[pointsn][[3,All,-1]];
		
		(* Denormalize the solution *)
		Cc = Cc.T;
		
		(* Rescale coefficients so that perpendicular distance from any points (x,y) to the line is
			r = abs(c(1)*X + c(2)*Y + c(3) *)
		theta = ArcTan[-Cc[[2]],Cc[[1]]];
		If[Abs[Sin[theta]] > Abs[Cos[theta]],
			k = Cc[[1]]/Sin[theta],
			k = -Cc[[2]]/Cos[theta]
		];
		
		Cc = Cc/k
	];


End[] (* End Private Context *)

EndPackage[]