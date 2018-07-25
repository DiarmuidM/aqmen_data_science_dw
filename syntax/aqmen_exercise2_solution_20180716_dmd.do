// File: aqmen_exercise2_solution_20180716_dmd.do
// Creator: Dr Diarmuid McDonnell
// Created: 16/07/2018

******* England & Wales Charity Data *******

/* This DO file performs the following tasks:
	- imports raw data in csv format
	- cleans these datasets
	- links these datasets together to form a comprehensive Register of Charities
	- saves these datasets in Stata and CSV formats
   
	The Register of Charities (extract_charity_sample) is the base dataset that the rest are merged with.
   
   Datasets:
		- extract_charity_sample
		- extract_main_charity
		- extract_trustees
		- extract_registration
		- extract_remove_ref
		
	You should consult the data dictionary throughout this exercise: include http://data.charitycommission.gov.uk/data-definition.aspx
   
*/


/* Define paths */

// Create or reuse existing macros to define the project paths

** INSERT SYNTAX **

include "H:\file_paths.doi"
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

import delimited using $path3\extract_charity_sample.csv, varnames(1) clear
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
		replace regno = "" if missing(real(regno)) // Set non-numeric instances of regno as missing
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
			*/
			
			destring subno, replace
			keep if subno==0 // Drop records relating to charity subsidiaries
			drop dupregno

	
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

import delimited using $path3\extract_main_charity.csv, varnames(1) clear
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
		
	/* Explore values of each variable */
	
	codebook incomedate // Date latest income figure refers to - currently a string.
	rename incomedate str_incomedate
	replace str_incomedate = substr(str_incomedate, 1, 10) // Capture first 10 characters of string.
	replace str_incomedate = subinstr(str_incomedate, "-", "", .) // Replace hyphens with a blank space.
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

import delimited using $path3\extract_registration.csv, varnames(1) clear
count
desc, f
notes
codebook *, compact
label data "One observation per main charity"

	/* Missing or duplicate values */
	
	capture ssc install mdesc
	mdesc
	missings dropvars, force
	
	duplicates report
	duplicates list
	duplicates drop
	
	duplicates report regno
	duplicates list regno
	keep if subno==0
	
	notes: use regno for linking with other datasets containing charity numbers

	
	codebook regdate remdate // Variables are currently strings, need to extract info in YYYYMMDD format.
	*tab1 regdate remdate
	foreach var of varlist regdate remdate {
		rename `var' str_`var'
		replace str_`var' = substr(str_`var', 1, 10) // Capture first 10 characters of string.
		replace str_`var' = subinstr(str_`var', "-", "", .) // Remove hyphen from date information.
		
		gen `var' = date(str_`var', "YMD") // Create a date variable in YYYYMMDD format.
		format `var' %td // Format date variable.
		codebook `var'
		
		gen `var'yr = year(`var') // Create a year variable from date variable.
		drop str_`var'
	}
	
	rename regdateyr regy
	rename remdateyr remy
	codebook regy remy
	tab1 regy remy, sort
	
	
	codebook remcode
	tab remcode // Need to merge with extract_remove_ref to understand the codes.
	
	sort remcode
	
	label variable regy "Year charity was registered"
	label variable remy "Year charity was de-registered"
	label variable remcode "Deregistration reason code"

	
sav $path1\ew_rem_v1.dta, replace


/* extract_remove_ref dataset */	

import delimited using $path3\extract_remove_ref.csv, varnames(1) clear
count
desc, f
notes
codebook *, compact

	duplicates report
	duplicates list
	
	list , clean

	rename code remcode
	
	sort remcode
	
sav $path1\ew_rem_ref_v1.dta, replace


/* extract_trustee dataset */

import delimited using $path3\extract_trustee.csv, varnames(1) clear
count
desc, f
notes
codebook *, compact

	/* Missing or duplicate values */
	
	capture ssc install mdesc
	ssc install missings
	mdesc
	missings dropvars, force // Drop variables with 100% missing values
	drop v3
	
	duplicates report
	duplicates list
	duplicates drop
	
	codebook regno
	sort regno
	
	codebook trustee
	list trustee in 1/1000 // We don't need the names, just a count of trustees per charity.
	bysort regno: egen trustees = count(trustee) // For each charity, count the number of trustees
	sum trustees
	
	drop trustee
	
	sort regno
	list in 1/500
	duplicates report regno
	duplicates drop regno, force // Only need one observation per charity

sav $path1\ew_trustees_v1.dta, replace

	
	// Merge deregistration datasets
	
	use $path1\ew_rem_v1.dta, clear
	
	merge m:1 remcode using $path1\ew_rem_ref_v1.dta, keep(match master using)
	tab _merge
	drop _merge
	
	rename text removed_reason
	codebook removed_reason
	tab removed_reason
	rename removed_reason oldvar
	
	encode oldvar, gen(removed_reason) // Create a number version of 'removed_reason'.
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
		charity number to be issued on the Public Register but not in this dataset.
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
	
	use $path1\ew_charityregister_v1.dta, clear
	
	merge 1:1 regno using $path1\ew_rem.dta, keep(match master using) // Registration information
	tab _merge
	rename _merge rem_merge
	
	merge 1:1 regno using $path1\ew_trustees_v1.dta, keep(match master using) // Trustees information
	tab _merge
	rename _merge trustee_merge
	drop if trustee_merge==2
	
	merge 1:1 regno using $path1\ew_maincharity_v1.dta, keep(match master using) // Income information
	tab _merge
	rename _merge inc_merge
	drop if inc_merge==2

	
/* Final data management */

	/* Charity age variable */
	
	capture drop charityage
	gen charityage = 2018 - regy if charitystatus==1
	replace charityage = 2018 - remy if charitystatus==2
	
	list regno regy remy charityage in 1/500
	list regno regy remy charityage if charitystatus==1
	
	/* Create dependent variables */
	
	// De-registered
	
	capture drop dereg
	gen dereg = charitystatus
	recode dereg 1=0 2=1
	tab dereg charitystatus
	label variable dereg "Organisation no longer registered as a charity"
	
	// Multinomial measure of removed reason

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

/* label the remaining variables */

// INSERT SYNTAX
		
sav $path4\ew_charityregister_analysis.dta, replace

***************************************************************************************************

***************************************************************************************************

/* Data Analysis */

use $path4\ew_charityregister_analysis.dta, clear
count
desc, f
codebook, compact
notes

	/* Descriptive statistics */
	
	tab1 charitystatus inc_cat alt_inc_cat dereg depvar // Categorical variables
	sum regy remy trustees income charityage, detail // Numeric variables
	
	estpost tab remy depvar if remy>=2007 // Distribution of dereg year and reason since 2007
	esttab using "$path7\table2.rtf", cell("b(f(0))" "rowpct(f(0))") ///
		nonumbers mtitles(" Reason")  ///  
		collabels(none) ///
		title(Table 1: Deregistration reason by year) addnotes(Notes: ew_charityregister_analysis.dta) ///
		noobs unstack replace
	/*
		What's going in 2009 with Other Dereg?
	*/	
	
		tab removed_reason if remy==2007
		tab removed_reason if remy==2008
		tab removed_reason if remy==2009 // Accounted for by the large spike in voluntary removals
	
	/* explore some other bivariate correlations in the data e.g. charityage and depvar */
	
	table depvar, c(mean charityage sd charityage min charityage max charityage)
	table depvar, c(mean income sd income min income max income) 
	tab charitystatus if income!=. // We only have income data for registered charities, but there are still some data errors
	tab charitystatus if income==.
	
	
	local fdate = "24jul2018" // Create a macro to capture today's date (useful for naming files)	
	tab remy depvar if remy>=2007
	local numobs:di %6.0fc r(N)
	
	tab depvar if depvar>0 & remy>=2007 // 70% is the average number of vol removals in a given year.
		
	graph bar if remy>=2007 & depvar!=0, over(depvar) over(remy) stack asyvar percent ///
		bar(1, color(dknavy )) bar(2, color(erose)) ///
		ylabel(, nogrid labsize(small)) ///
		ytitle("% of charities", size(medsmall)) ///
		yline(70, lpatt(dash) lcolor(gs8)) ///
		title("Charity Removal Reasons - UK")  ///
		subtitle("by deregistration year")  ///
		note("Source: Charity Commission for England & Wales (22/05/2018);  n=`numobs'. Produced: $S_DATE.", size(vsmall) span) ///
		scheme(s1color)

	graph export $path8\ew_removedreason_`fdate'.png, replace width(4096)
	
	
	
	/* Statistical modelling */
	
	// Let's use some of our variables to predict whether a charity is deregistered or not
	
	logit dereg, or
	ssc install fitstat // Useful package for assessing the results of a statistical model
	fitstat
	est store null // Store the results of the regression in an object called "null"
	/*
		The above is a logistic regression with no explanatory variables.
		It is used to predict the probability of an outcome occuring, in this instance deregistration.
		
		We have selected the 'or' option which gives us odds ratios; these tell us how much more likely an outcome is to occur
			for a given value or change in our explanatory variables.
			
		Ask John or Diarmuid for a more detailed explanation.
	*/
	
	logit dereg trustees charityage, or
	fitstat
	est store mod1
	/*
		We now include two potential explanatory variables: the number of trustees and the age of the charity.
		Essentially we are asking ourselves the following question: does our knowledge of the number of trustees and the age of the charity
			improve our prediction of whether a charity is deregistered or not.
	*/
	
	mlogit depvar trustees charityage, rrr
	**fitstat
	est store mod2
	/*
		Logit works well when we have a binary outcome i.e. de-registered or not. What about multi-category outcomes?
		We can use 'mlogit' (multinomial logit) to make predictions about different ou
	*/


	

