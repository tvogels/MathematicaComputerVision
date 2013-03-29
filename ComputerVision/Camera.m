(* Mathematica Package *)

BeginPackage["ComputerVision`Camera`",{"ComputerVision`Utils`","ComputerVision`Homographies`"}]

CameraMatrixFromCorrespondences::usage = "CameraMatrixFromCorrespondences[corr] gives the camera matrix for >=6 {world,pixel} correspondences (homogeneous coordinates) using a DLT method.";

CameraDecompose::usage = "DecomposeCamera[P] decomposes the camera into {K,R,t} such that P = K.R.[I | -t].";

DrawCamera::usage = "DrawCamera[P,img] gives a 3D object showing the camera orientation. To be used inside a Graphics3D environment. It uses the img for its dimensions.";

Begin["`Private`"] (* Begin Private Context *) 

CameraMatrixFromCorrespondences[corr_] :=
	Module[{world, image, T, U, A, P,corr2},
		(* Normalize the points. *)
		world = Transpose[corr][[1]];
		image = Transpose[corr][[2]];
		{image,T} = NormalizePoints[image];
		{world,U} = NormalizePoints3D[world];
		corr2=Transpose[{world,image}];
		(* Find P for the normalized points. *)
		A = Flatten[
			{
				{0,0,0,0, -#[[2,3]]#[[1,1]],-#[[2,3]]#[[1,2]],-#[[2,3]]#[[1,3]],-#[[2,3]]#[[1,4]], #[[2,2]]#[[1,1]],#[[2,2]]#[[1,2]],#[[2,2]]#[[1,3]],#[[2,2]]#[[1,4]]},
				{#[[2,3]]#[[1,1]],#[[2,3]]#[[1,2]],#[[2,3]]#[[1,3]],#[[2,3]]#[[1,4]], 0,0,0,0, -#[[2,1]]#[[1,1]],-#[[2,1]]#[[1,2]],-#[[2,1]]#[[1,3]],-#[[2,1]]#[[1,4]]}
			}&/@corr2
		,1];
		P = Partition[SingularValueDecomposition[A][[3,All,-1]],4];
		
		(* Denormalize and return. *)
		Inverse[T].P.U
	];

CameraDecompose[P_] :=
	Module[{H,K,R,t},
		(* Define H as the first three columns of P. *)
		H = P[[All,Range[1,3]]];
		(* K and R follow from an RQ decomposition. *)
		{K,R} = RQ[H];
		(* Make sure K[[3,3]] is 1. *)
		K = K/K[[3,3]];
		(* Calculate t. *)
		t = NullSpace[P][[1]];
		(* Return values found. *)
		{K,R,t}
	];

DrawCamera[P_,img_] :=
	Module[{K,R,t,f,Rinv,size,pts,w,h,px,py},
		(* Decompose the camera to get all parameters. *)
		{K,R,t} = CameraDecompose[P];
		(* Take the average value for f. *)
		f = (K[[1,1]]+K[[2,2]])/2;
		(* Convert t to non-homogeneous. *)
		t = Nc[t];
		(* Calculate the inverse rotation matrix. *)
		Rinv = Inverse[R];
		(* The displayed principal point distance is 1 x the sign of f. *)
		size = Sign[f];
		(* Other values *)
		{w,h} = ImageDimensions[img];
		px = K[[1,3]];
		py = K[[2,3]];
		(* Define the points and transform them. *)
		pts = size/f {
			{0, 0, 0},
			{-px, -py, -f},
			{-px, h - py, -f},
			{w - px, h - py, -f},
			{w - px, -py, -f},
			{f, 0, 0},
			{0, f, 0}
		};
		pts = (Rinv.# + t) & /@ pts;
		(* Return the graphics primitives. *)
		{
			 PointSize[Large], Point[pts[[1]]],
			 Polygon[pts[[Range[2, 5]]]],
			 Thick, Red, Arrow[pts[[{1, 6}]]],
			 Green, Arrow[pts[[{1, 7}]]],
			 Gray, Opacity[.2],
			 Polygon[pts[[{1, 2, 3}]]],
			 Polygon[pts[[{1, 3, 4}]]],
			 Polygon[pts[[{1, 4, 5}]]],
			 Polygon[pts[[{1, 5, 1}]]]
		 }
	];

End[] (* End Private Context *)

EndPackage[]