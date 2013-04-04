(* Mathematica Package *)

BeginPackage["ComputerVision`CameraCalibration`",{
	"ComputerVision`Utils`",
	"ComputerVision`Homographies`"
}]

SeparateSquares::usage = "SeparateSquares[img,nsquares] takes an image of n black squares (on a constrasting background) and returns n white images of those squares on a black background.
	It defaults to 3 squares.";

CornersInQuadrangleImage::usage = "CornerInQuadrangleImage[square] calculates the four corner points in an image of a quadrangle by first finding the edges and intersecting those.
	Returns the points in non-homogeneous coordinates";

CameraCalibrationFromImagedSquares::usage = "CameraCalibrationFromImagedSquares[squares] returns the internal camera parameters K from the (non-homogeneous) corner points of (at least) three imaged squares. It identifies the image of the absolute conic, and uses a Cholesky decomposition to derive K from omega.";

CameraCalibrationFromImagedSquaresAssertingZeroSkew::usage = "CameraCalibrationFromImagedSquaresAssertingZeroSkew[squares] returns the internal camera parameters K from the (non-homogeneous) corner points of (at least) three imaged squares. It identifies the image of the absolute conic, and uses a Cholesky decomposition to derive K from omega. It asserts zero skew.";

Begin["`Private`"] (* Begin Private Context *) 

(* 	This takes an image of n black squares (on a constrasting background)
	and returns n white images of those squares on a black background.
	It defaults to 3 squares. *)
SeparateSquares[img_]:=SeparateSquares[img,3];
SeparateSquares[img_,n_]:=
	Module[ {bin, noborders,components},
		(* Binarize *)
		bin = ColorNegate[Binarize[img]];
		
		(* Remove border components *)
		noborders = DeleteBorderComponents[bin];
		
		(* Take the n largest components *)
		components = SortBy[
			ComponentMeasurements[noborders, {"Area", "Mask"}][[All, 2]], 
			First
		][[Range[-n,-1],2]];
		
		Image/@components
	];

(*	This calculates the four corner points in an image of a quadrangle by 
	first finding the edges and intersecting those.
	Returns the points in non-homogeneous coordinates *)
CornersInQuadrangleImage[square_] :=
	Module[ {edges,lines,hglines},
		(* Find edges *)
		edges=EdgeDetect[square];
		
		(* Fit lines through them *)
		lines=ImageLines[edges,MaxFeatures->4];
		
		(* Convert them to homogeneous lines *)
		hglines=LineThrough[Hgc[#1],Hgc[#2]]& @@@ lines;
		
		(* Sort by direction to make sure the intersections are cornerpoints *)
		hglines=SortBy[hglines,LineDirection[#]&];
		
		(* Make sure parallel pairs are in position {1,2} and {3,4} *)
		If[	Abs[LineDirection[hglines[[2]]]-LineDirection[hglines[[1]]]]
			>
			Abs[LineDirection[hglines[[3]]]-LineDirection[hglines[[2]]]],
			hglines=RotateRight[hglines,1];
		];
		
		(* Find corner points and return them *)
		Nc /@ {
			Intersect[hglines[[1]],hglines[[3]]],
			Intersect[hglines[[3]],hglines[[2]]],
			Intersect[hglines[[2]],hglines[[4]]],
			Intersect[hglines[[4]],hglines[[1]]]
		}
	];
	
(*	This returns the internal camera parameters K from the (non-homogeneous) corner 
	points of (at least) three imaged squares. It identifies the image of the 
	absolute conic, and uses a Cholesky decomposition to derive K from omega. *)
CameraCalibrationFromImagedSquares[squares_] :=
	Module[ {H,cp,A,a,b,c,d,e,f,omega,K,U},
		(* Find homographies between the "unit-square" and the given quadrangles *)
		cp = {{0, 0, 1}, {0, 1, 1}, {1, 1, 1}, {1, 0, 1}};
		H[i_] := Homography2D[cp,Hgc/@squares[[i]]];
		(* Construct a matrix A used to solve for the IAC *)
		A = Flatten[Table[
			TwoRowsOfAForFindingTheIAC[H[ii]],
		{ii,1,Length[squares]}],1];
		(* Minimize norm(A.omega) using a SVD *)
		{a,b,c,d,e,f}=SingularValueDecomposition[A][[3,All,-1]];
		(* Construct the omega matrix *)
		omega = {{a,b/2,d/2},{b/2,c,e/2},{d/2,e/2,f}};
		(* Apply a Cholesky decomposition to obtain K *)
		U = CholeskyDecomposition[omega];
		K = Inverse[U]/Inverse[U][[3,3]]
	];
CameraCalibrationFromImagedSquaresAssertingZeroSkew[squares_] :=
	Module[ {H,cp,A,a,c,d,e,f,omega,K,U},
		(* Find homographies between the "unit-square" and the given quadrangles *)
		cp = {{0, 0, 1}, {0, 1, 1}, {1, 1, 1}, {1, 0, 1}};
		H[i_] := Homography2D[cp,Hgc/@squares[[i]]];
		(* Construct a matrix A used to solve for the IAC *)
		A = Flatten[Table[
			TwoRowsOfAForFindingTheIACAssertingZeroSkew[H[ii]],
		{ii,1,Length[squares]}],1];
		(* Minimize norm(A.omega) using a SVD *)
		{a,c,d,e,f}=SingularValueDecomposition[A][[3,All,-1]];
		(* Construct the omega matrix *)
		omega = {{a,0,d/2},{0,c,e/2},{d/2,e/2,f}};
		(* Apply a Cholesky decomposition to obtain K *)
		U = CholeskyDecomposition[omega];
		K = Inverse[U]/Inverse[U][[3,3]]
	];

(*	This helper-function returns rows of A for finding the image of the absolute conic.
	Argument: a homography that transforms a square in the z=0 plane to an imaged square *)
TwoRowsOfAForFindingTheIAC[h_] :=
	Module[ {h1,h2,omega,a,b,c,d,e,f,r1,r2},
		h1 = h[[All,1]]; (* first column *)
		h2 = h[[All,2]]; (* second column *)
		omega = {{a,b/2,d/2},{b/2,c,e/2},{d/2,e/2,f}};
		r1 = Coefficient[h1.omega.h2,{a,b,c,d,e,f}];
		r2 = Coefficient[h1.omega.h1-h2.omega.h2,{a,b,c,d,e,f}];
		{r1,r2}
	];
TwoRowsOfAForFindingTheIACAssertingZeroSkew[h_] :=
	Module[ {h1,h2,omega,a,c,d,e,f,r1,r2},
		h1 = h[[All,1]]; (* first column *)
		h2 = h[[All,2]]; (* second column *)
		omega = {{a,0,d/2},{0,c,e/2},{d/2,e/2,f}};
		r1 = Coefficient[h1.omega.h2,{a,c,d,e,f}];
		r2 = Coefficient[h1.omega.h1-h2.omega.h2,{a,c,d,e,f}];
		{r1,r2}
	];

End[] (* End Private Context *)

EndPackage[]