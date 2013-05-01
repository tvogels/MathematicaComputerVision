(* Mathematica Package *)

BeginPackage["ComputerVision`SceneReconstruction`"]
	
Triangulate::usage = "Triangulate[corr,P1,P2] gives a DLT-estimate of the 3D-location of corresponding image point correlations in two images and the two camera matrices.";

Begin["`Private`"] (* Begin Private Context *) 

Triangulate[corr_, P1_, P2_] := 
 Module[{A, X, p1, p2, row1, row2, row3, row4, x1, x2, x3, x4},
  X = {x1, x2, x3, x4};
  p1 = Nc/@corr[[All,1]];
  p2 = Nc/@corr[[All,2]];
  row1 = p1[[1]]P1[[3]]-P1[[1]];
  row2 = p1[[2]]P1[[3]]-P1[[2]];
  row3 = p2[[1]]P2[[3]]-P2[[1]];
  row4 = p2[[2]]P2[[3]]-P2[[2]];
  A = {row1, row2, row3, row4};
  SingularValueDecomposition[A][[3, All, -1]]
  ];

End[] (* End Private Context *)

EndPackage[]