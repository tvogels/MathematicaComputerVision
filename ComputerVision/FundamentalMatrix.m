(* Mathematica Package *)

BeginPackage["ComputerVision`FundamentalMatrix`",{"ComputerVision`Homographies`"}]

FFromCorrespondences::usage = "FFromCorrespondences[corr] gives a fundamental from a list of point correspondences using a DLT algorithm.";

EFromFK::usage = "EFromFK[F,K] gives the essential matrix from the fundamental matrix and a calibration matrix."

Begin["`Private`"] (* Begin Private Context *) 

FFromCorrespondences[corr_] :=
	Module[{p1,T1,p2,T2,ncorr,A,F,fu,fd,fv,r,s,t},
		(* Normalize the points *)
		(* The importance of this step should not be underestimated
			(say Hartley&Zisserman) *)
		{p1,T1} = NormalizePoints[Transpose[corr][[1]]];
		{p2,T2} = NormalizePoints[Transpose[corr][[2]]];
		ncorr=Transpose[{p1,p2}];
		(* Combine the linear constraints x' F x = 0 into a matrix A *)
		A = {#[[1, 1]] #[[2, 1]],
			#[[2, 1]] #[[1, 2]],
			#[[2, 1]],
			#[[2, 2]] #[[1, 1]],
			#[[2, 2]] #[[1, 2]],
			#[[2, 2]],
			#[[1, 1]],
			#[[1, 2]],
			1} & /@ ncorr;
		(* Find a solution that is not necessarily singular *)
		F = Partition[SingularValueDecomposition[A][[3,All,-1]],3];
		(* Make sure it is singular by minimizing the Frobenius norm of F-F' *)
		{fu,fd,fv} = SingularValueDecomposition[F];
		{r,s,t} = Diagonal[fd];
		F = fu.DiagonalMatrix[{r,s,0}].Transpose[fv];
		(* Denormalization *)
		Transpose[T2].F.T1
	];

EFromFK[F_,K_] :=
	Transpose[K].F.K;

End[] (* End Private Context *)

EndPackage[]