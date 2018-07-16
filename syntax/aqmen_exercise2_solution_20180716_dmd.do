// File: aqmen_exercise2_solution_20180716_dmd.do
// Creator: Dr Diarmuid McDonnell
// Created: 16/07/2018

******* England & Wales Charity Data *******

/* This DO file performs the following tasks:
	- imports raw data in csv format
	- cleans these datasets
	- links these datasets together to form a comprehensive Register of Charities
	- saves these datasets in Stata and CSV formats
   
	The Register of Charities (extract_main) is the base dataset that the rest are merged with.
   
   Datasets:
		- extract_charity
		- extract_main_charity
		- extract_trustees
		- extract_registration
		- extract_remove_ref
   
*/


/* Define paths */

// Create or reuse existing macros to define the project paths

** INSERT SYNTAX **

di "$path1"
di "$path2"
di "$path3"
di "$path4"
di "$path5"
di "$path6"
di "$path7"
di "$path8"


/* 1. Open the raw data in csv format */

/* Base dataset - extract_charity */

import delimited using $path2\extract_charity.csv, varnames(1) clear
count
desc, f
notes
codebook , compact
label data "One observation per registered/removed charity (including subsidiaries)"
**codebook *, problems

	keep regno subno orgtype

	/* Missing or duplicate values */
	
	duplicates report // Lots of duplicates
	duplicates list // Look to be data entry errors: every variable is blank except regno, which is a string (e.g. "AS AMENDED ON 27/11/2011&#x0D;").
	duplicates drop
	
	duplicates report regno
	duplicates list regno // Looks like a combination of data entry errors (strings again) and duplicate numbers. Delete strings first.
	
		list regno if missing(real(regno))
		replace regno = "" if missing(real(regno)) // Set nonnumeric instances of regno as missing
		destring regno, replace
		drop if regno==. // Drop instances where regno is missing.
		
		duplicates report regno
		duplicates list regno in 1/2000
		duplicates tag regno, gen(dupregno)
		
			duplicates report regno subno
			duplicates list regno subno
		
			list regno subno if regno==200027
			list regno subno if regno==201415
			list regno subno if dupregno!=0
			codebook subno
			codebook subno if dupregno!=0
			/*
				Ok, it looks as if the remaining instances of duplicate regno is accounted for by each subsidiary of a charity having its parent
				charity's regno.
				
				Create a variable that counts the number of subsidiaries per charity, and drop observations where subno > 0.
			*/
			
			destring subno, replace
			bysort regno: egen subsidiaries = max(subno)
			list regno subno subsidiaries in 1/1000
			
			keep if subno==0
			drop dupregno
			/*
				Think about keeping subsidiaries later on, as we can track their registration and removal dates.
			*/

	
	codebook orgtype
	tab orgtype // RM=deregistered, R=registered i.e. currently active
	encode orgtype, gen(charitystatus)
	tab charitystatus
	recode charitystatus 1=1 2=2 3/max=. // Recode anything above 2 (the highest valid value) as missing data.
	label define charitystatus_label 1 "Active" 2 "Removed"
	label values charitystatus charitystatus_label
	tab charitystatus
	drop orgtype
		
	
sav $path1\ew_charityregister_v1.dta, replace	

	
/* extract_main_charity dataset */

import delimited using $path2\extract_main_charity.csv, varnames(1) clear
count
desc, f
notes
codebook , compact
label data "One observation for every main registered charity (no subsidiaries)"

	
	/* Keep relevant variables */
	
	keep regno income incomedate

	/* Check for duplicates */
	
	duplicates report regno
	duplicates list regno
	
	
	codebook incomedate // Date latest income figure refers to - currently a string.
	rename incomedate str_incomedate
	replace str_incomedate = substr(str_incomedate, 1, 10) // Capture first 10 characters of string.
	replace str_incomedate = subinstr(str_incomedate, "-", "", .) // Remove 
	tab str_incomedate, sort
	
	gen incomedate = date(str_incomedate, "YMD")
	format incomedate %td
	codebook incomedate
	
	gen incomeyr = year(incomedate) // Identify the year the latest gross income refers to
	tab incomeyr
	drop str_incomedate

	
	codebook income
	inspect income
	sum income, detail
	
		// Create categorical measures of income
		
		capture drop inc_cat
		gen inc_cat = income
		egen inc_cat = cut(income), group(5)
		tab inc_cat
		
		capture drop alt_inc_cat
		gen alt_inc_cat = income
		recode alt_inc_cat min/99999=1 100000/999999=2 1000000/max=3
		label define alt_inc_cat_lab 1 "Small" 2 "Medium" 3 "Large"
		label values alt_inc_cat alt_inc_cat_lab
		tab alt_inc_cat
	
	
	sort regno // Sort the dataset by unique id
	
sav $path1\ew_maincharity_v1.dta, replace	
	
	
/* extract_registration dataset */	

import delimited using $path2\extract_registration.csv, varnames(1) clear
count
desc, f
notes
codebook *, compact

	/* Missing or duplicate values */
	
	capture ssc install mdesc
	mdesc
	missings dropvars, force
	
	duplicates report
	duplicates list
	duplicates drop
	
	duplicates report regno
	duplicates list regno
	duplicates tag regno, gen(dupregno)
		
		list regno subno if regno==1175809
		list regno subno if regno==1176305
		list regno subno if dupregno!=0
		codebook subno
		codebook subno if dupregno!=0
		/*
			Ok, it looks as if the remaining instances of duplicate regno is accounted for by each subsidiary of a charity having its parent
			charity's regno.
			
			Create a variable that counts the number of subsidiaries per charity, and drop observations where subno > 0.
		*/
			
		bysort regno: egen subsidiaries = max(subno)
		list regno subno subsidiaries in 1/1000
			
		keep if subno==0
		drop dupregno
		/*
			Think about keeping subsidiaries later on, as we can track their registration and removal dates.
		*/
	
	notes: use regno for linking with other datasets containing charity numbers

	
	codebook regdate remdate // Variables are currently strings, need to extract info in YYYYMMDD format.
	*tab1 regdate remdate
	foreach var of varlist regdate remdate {
		rename `var' str_`var'
		replace str_`var' = substr(str_`var', 1, 10) // Capture first 10 characters of string.
		replace str_`var' = subinstr(str_`var', "-", "", .) // Remove hyphen from date information.
		
		gen `var' = date(str_`var', "YMD")
		format `var' %td
		codebook `var'
		
		gen `var'yr = year(`var')
		drop str_`var'
	}
	
	rename regdateyr regy
	rename remdateyr remy
	codebook regy remy
	tab1 regy remy, sort
	
	
	codebook remcode
	tab remcode // Need to merge with extract_remove_ref to understand the codes.
	
	sort remcode
	
sav $path1\ew_rem_v1.dta, replace


/* extract_remove_ref dataset */	

import delimited using $path2\extract_remove_ref.csv, varnames(1) clear
count
desc, f
notes
codebook *, compact

	duplicates report
	duplicates list
	
	list , clean

	rename code remcode
	
	sort remcode
	
sav $path1\ew_rem_ref_may2018.dta, replace


/* extract_trustee dataset */

import delimited using $path2\extract_trustee.csv, varnames(1) clear
count
desc, f
notes
codebook *, compact

	/* Missing or duplicate values */
	
	capture ssc install mdesc
	mdesc
	missings dropvars, force
	tab v3
	drop v3
	
	duplicates report
	duplicates list
	duplicates drop
	
	codebook regno
	sort regno
	
	codebook trustee
	list trustee in 1/1000 // We don't need the names, just a count of trustees per charity.
	bysort regno: egen trustees = count(trustee)
	sum trustees
	
	drop trustee
	
	sort regno
	list in 1/500
	duplicates report regno
	duplicates drop regno, force

sav $path1\ew_trustees_may1018.dta, replace

	
	// Merge deregistration datasets
	
	use $path1\ew_rem_v1.dta, clear
	
	merge m:1 remcode using $path1\ew_rem_ref.dta, keep(match master using)
	tab _merge
	drop _merge
	
	rename text removed_reason
	codebook removed_reason
	tab removed_reason
	rename removed_reason oldvar
	
	encode oldvar, gen(removed_reason)
	tab removed_reason
	tab removed_reason, nolab
	drop oldvar
	notes: Only use two categories of removed_reason to measure demise/closure: CEASED TO EXIST (3) and DOES NOT OPERATE (4).
	
	sort regno
		
	duplicates report regno
	duplicates tag regno, gen(dupregno)
	list regno regy remy if dupregno!=0
	/*
		There may be something interesting going on here: charities with the same number have different registration dates, which in many cases
		seems to be because one observation has a registration and removal year, while the other just has a registration date.
		
		Look for one of these charities online. There could be duplicates due to charities changing legal form, which I think causes a new
		charity number of be issued on the Public Register but not in this dataset.
	*/
	
	drop if dupregno!=0 & remy!=.
	drop dupregno
	count
	
		list if regno==1161889
		
	duplicates report regno	
	duplicates drop regno, force
	/*
		Revisit this issue at a later date.
	*/
	
	sav $path1\ew_rem.dta, replace
	
	
	// Merge the supplementary datasets with the charity register
	
	use $path1\ew_charityregister_may2018_v1.dta, clear
	
	merge 1:1 regno using $path1\ew_rem_may2018.dta, keep(match master using) // Registration information
	tab _merge
	rename _merge rem_merge
	
	merge 1:1 regno using $path1\ew_trustees_may1018.dta, keep(match master using) // Trustees information
	tab _merge
	rename _merge trustee_merge
	drop if trustee_merge==2
	
	
/* Final data management */

	/* Charity age */
	
	capture drop charityage
	gen charityage = year - regy if charitystatus==1
	replace charityage = remy - regy if charitystatus==2
	list regno regy remy year charityage in 1/500
	list regno regy remy year charityage if charitystatus==1 & year!=.
	
	/* Create dependent variables */
	
	// Removed
	
	capture drop dereg
	gen dereg = charitystatus
	recode dereg 1=0 2=1
	tab dereg charitystatus
	label variable dereg "Organisation no longer registered as a charity"
	
	// Multinomial measure of removed reason
	/*
		Voluntary dissolution is not comparable (yet) between the three jurisidictions:
		- Canada includes mergers and amalgamations, the others do not.
	*/
	
	capture drop depvar
	gen depvar = .
	replace depvar = 0 if charitystatus==1
	replace depvar = 1 if removed_reason==3 | removed_reason==4
	replace depvar = 2 if removed_reason!=3 & removed_reason!=4 & removed_reason!=.
	tab depvar
	tab removed_reason depvar
	tab depvar charitystatus
	label define rem_label 0 "Registered" 1 "Vol Dissolution" 2 "Other Dereg"
	label values depvar rem_label
	label variable depvar "Indicates whether a charity has been de-registered and for what reason"


compress
		
sav $path4\ew_charityregister_20180522.dta, replace
