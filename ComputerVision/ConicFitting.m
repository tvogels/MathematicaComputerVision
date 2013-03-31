(* Mathematica Package *)

BeginPackage["ComputerVision`ConicFitting`",{"ComputerVision`Utils`"}]

FitConic::usage = "FitConic[points] fits a conic through at least 5 homogeneous points using linear minimization.";

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

End[] (* End Private Context *)

EndPackage[]