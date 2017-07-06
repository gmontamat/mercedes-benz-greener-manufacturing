# Mercedes-Benz Greener Manufacturing

Analysis and submissions code for the Kaggle competition. The idea is to predict the time it takes a car to pass testing given different permutations of Mercedes-Benz car features.

## Ideas

* Get rid of columns with no useful information (only one level, either all 0's or all 1's)
* Combine complementary columns (maybe even more than 2) into a single factor
	* Complemetary groups of 3:
		* "X111" "X112" "X113"
		* "X130" "X189" "X232"
		* "X136" "X162" "X310"
		* "X136" "X232" "X236"
		* "X186" "X187" "X54"
	* Complementary groups of 2:
		* "X120" "X52" 
		* "X128" "X130"
		* "X136" "X54" 
		* "X142" "X158"
		* "X156" "X157"
		* "X186" "X194"
		* "X204" "X205"
		* "X232" "X263"
* Remove outliers
* Try not using variables X0 through X8 as they might be features derived from the rest
* If X0 through X8 are used, group long tail features to avoid trouble when new levels are seen on test data
* Try some interactions between variables in linear models
* Use ID column as a feature

## Useful links

* https://www.kaggle.com/c/mercedes-benz-greener-manufacturing

## Timeline

* July 3, 2017 - Entry deadline. You must accept the competition rules before this date in order to compete.
* July 3, 2017 - Team Merger deadline. This is the last day participants may join or merge teams.
* July 10, 2017 - Final submission deadline.

All deadlines are at 11:59 PM UTC on the corresponding day unless otherwise noted. The competition organizers reserve the right to update the contest timeline if they deem it necessary.
