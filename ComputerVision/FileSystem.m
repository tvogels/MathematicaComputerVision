(* Mathematica Package *)

BeginPackage["ComputerVision`FileSystem`"]

LoadImagesInDirectory::usage = "LoadImagesInDirectory[dir] returns all images in a directory. ";

Begin["`Private`"] (* Begin Private Context *) 

LoadImagesInDirectory[dir_] :=
	Module[ {files},
		SetDirectory[dir];
		files=FileNames[{"*.jpg","*.png"}];
		Import/@files
	];

End[] (* End Private Context *)

EndPackage[]