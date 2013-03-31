(* 	General implementation of the RANSAC algorithm
	Based on MATLAB code by the University of Western Austraila
	http://www.csse.uwa.edu.au/~pk/Research/MatlabFns/Robust/ransac.m
 *)

BeginPackage["ComputerVision`RANSAC`"]

RANSAC::usage = "RANSAC[x, fittingfn, distfn, degenfn, s, t, feedback, maxDataTrials, maxTrials] is a general RANSAC implementation. The last three arguments are optional.";

Begin["`Private`"] (* Begin Private Context *) 

 
RANSAC[x_, fittingfn_, distfn_, degenfn_, s_, t_] :=
	RANSAC[x, fittingfn, distfn, degenfn, s, t, 0, 100, 1000];
RANSAC[x_, fittingfn_, distfn_, degenfn_, s_, t_,feedback_] :=
	RANSAC[x, fittingfn, distfn, degenfn, s, t, feedback, 100, 1000];
RANSAC[x_, fittingfn_, distfn_, degenfn_, s_, t_,feedback_, maxDataTrials_] :=
	RANSAC[x, fittingfn, distfn, degenfn, s, t, feedback, maxDataTrials, 1000];
RANSAC[x_, fittingfn_, distfn_, degenfn_, s_, t_, feedback_, maxDataTrials_, maxTrials_] :=
	Module[ {rows, npts, p, bestM, trialcount, bestscore, Nn, degenerate, 
			count, ind, M, inliers, ninliers, bestinliers, pNoOutliers, fracinliers},
		
		{rows,npts}=Dimensions[x];
		
		p = 0.99; (* Desired probability of choosing at least one sample *)
	
		bestM = Null;
		trialcount = 0;
		bestscore = 0;
		Nn = 1; (* Dummy initialisation for number of trials. *)
		While[ Nn > trialcount,
			(* Select at random s datapoints to form a trial model, M. *)
     	   	(* In selecting these points we have to check that they are not in *)
        	(* a degenerate configuration. *)
        	degenerate = True;
        	count = 1;
        	While[degenerate,
				(* Generate s random indicies in the range 1..npts *)
				(* (If you do not have the statistics toolbox with randsample(), *)
				(* use the function RANDOMSAMPLE from my webpage) *)
				ind = RandomSample[Range[1,npts],s];
				
				(* Test that these points are not a degenerate configuration. *)
				degenerate = degenfn[x[[ind]]];
				
				If[ !degenerate, 
					(* Fit model to this random selection of data points. *)
					(* Note that M may represent a set of models that fit the data in *)
					(* this case M will be a cell array of models *)
					M = fittingfn[x[[ind]]];
					
					(* Depending on your problem it might be that the only way you *)
					(* can determine whether a data set is degenerate or not is to *)
					(* try to fit a model and see if it succeeds.  If it fails we *)
					(* reset degenerate to true. *)
					If[ M == Null,
						degenerate = True;
					];
				];
				
				(* Safeguard against being stuck in this loop forever *)
				count++;
				If [ count > maxDataTrials,
					Throw["RANSAC: Unable to select a nondegenerate data set"];
					Break[];
				];
        	];
        	
			(* Once we are out here we should have some kind of model... *)
			(* Evaluate distances between points and model returning the indices *)
			(* of elements in x that are inliers.  Additionally, if M is a cell *)
			(* array of possible models 'distfn' will return the model that has *)
			(* the most inliers.  After this call M will be a non-cell object *)
			(* representing only one model. *)
			{inliers, M} = distfn[M, x, t];
			
			(* Find the number of inliers to this model. *)
			ninliers = Length[inliers];
			
			If[ ninliers > bestscore, (* Largest set of inliers so far... *)
				bestscore = ninliers; (* Record data for this model *)
				bestinliers = inliers;
				bestM = M;
				
				(* Update estimate of N, the number of trials to ensure we pick, *)
				(* with probability p, a data set with no outliers. *)
				fracinliers = ninliers/npts;
				pNoOutliers = 1 - fracinliers^s;
				pNoOutliers = Max[2^{-52}, pNoOutliers]; (* Avoid division by infinity *)
				pNoOutliers = Min[1-2^{-52}, pNoOutliers];
				Nn = Log[1-p]/Log[pNoOutliers];
			];
			
			trialcount++;
			
			If[feedback,
				Print["Trial "<>ToString[trialcount]<>" of "<>ToString[Ceil[Nn]]<>" ..."];
			];
			
			(* Safeguard against being stuck in this loop forever *)
			If [ trialcount > maxTrials,
				Throw["RANSAC: the maximum number of "<>ToString[maxTrials]<>" trials was reached."];
			];
		];
		
		If[bestM != Null,
			(* We got a solution *)
			{bestM, bestinliers},
			Throw["RANSAC: unable to find a useful solution."];
			{Null, {}}
		];
	];

End[] (* End Private Context *)

EndPackage[]