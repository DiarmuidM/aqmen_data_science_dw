STOP

/**


*******************************************************************************

AQMEN

Data Wrangling & Munging: Organising, Managing and Enabling Data for Analysis
(July 2018)

A two day hands-on workshop led by Professor John MacInnes and Dr Diarmuid McDonnell, 
University of Edinburgh.

		**********************************************
		* IT IS IMPORTANT THAT YOU READ THIS HANDOUT *
		* AND FOLLOW THE STATA.DO FILE LINE BY LINE! *
		**********************************************


Course Content:

This two-day workshop is an intermediate level course. 

It is aimed at analysts who already use some form of software for analysis of administrative (or similar) datasets. 

The workshop will introduce techniques for making your analyses more efficient 
and effective, and methods for improving your workflow.

The course will involve short professional demonstrations followed 
by participants practising in short sessions throughout the day.

The following topics will be covered (but not in this order):

		Better understanding the workflow

		Organising your .do files efficiently

		Managing survey and administrative data files

		Organising variables and measures

		Producing publication style outputs

		
It is intended for people who have no prior experience of Stata but want to quickly
gain proficiency in data wrangling and munging using this package.

Please adjust your expectations - this is a two day course.

The instructors have been working with Stata and undertaking statistical
analyses for many years and they are all still learning and improving their 
skills. 

It will NOT be possible to learn everthing in two days.

Please be patient. Computers often go wrong.

Please asks the instructors for help.

Feel free to work in pairs during the pratical sessions.

Not all of your questions will be answered but we will help as much as we can.

Good luck.

********************************************************************************

Latest Update

16th July 2018 Confirmed that football is not coming home.

26th June 2018 Diarmuid's sister and younger cousins heading InterRailing (Diarmuid not envious).


Previous Updates

25th June 2018 Proliferation of news articles hinting that Football is coming home.

1st October 2016 Stanstead Airport - Vernon going to see his Dad for his 80th Birthday

30th September 2016 Vernon going to bake a Battenberg Cake tonight 
for his Dad's 80th birthday

17th September 2016 Updated paths for use in Edinburgh Library.

24th August 2015 Usain Bolt wins World Championships 100m final victory 9.79 seconds
yesterday.

4th August 2015 Les Munro the last surviving Dambusters pilot dies.

3rd August 2015 The International Olympic Committee will act with 
'zero tolerance' should allegations of widespread doping in athletics be proven,
says president Thomas Bach.

1st August 2015 on this day in 1981 MTV begins broadcasting in the US.

27th July 2015 Chris Froome wins Tour de France yesterday.

3rd July 2015 Heather Watson loses to Serena Williams in Wimbledon thriller.


********************************************************************************

WARNING!

No research micro data will be distributed during this workshop.

The files required are provided on the memory stick or are available via 
the web.

Participants MAY NOT retain, make copies of these files or distribute them.

The files have been specifically created by AQMEN, Dr McDonnell and the ADRC-S for training 
and MUST not be used for social science or commercial research.

MOST OF THE DATA ARE NOT REAL! DO NOT USE THEM FOR REAL ANALYSES!

We advise that participants galvanise their training experience and
work with 'genuine' survey data files which they
can download legally from the UK Data Service (http://ukdataservice.ac.uk/ -
the old site is www.esds.ac.uk but you will be redirected).

At workshops where real survey datasets are used participants MUST sign 
a data access agreement.

********************************************************************************

© Vernon Gayle, University of Edinburgh.

This file has been produced for AQMEN and the ADRC-S by 
Professor Vernon Gayle with assistance from Dr Roxanne
Connelly and Dr Chris Playford. It was updated by Dr Diarmuid McDonnell
and Professor John MacInnes.

Any material in this file must not be reproduced, 
published or used for teaching without permission from Professor Vernon Gayle or Dr Diarmuid McDonnell. 

Many of the ideas and examples presented in this document draw heavily on
previous work (see especially www.longitudinal.stir.ac.uk). 
We are grateful for the comments and feedback from participants of 
earlier workshops. 

Over the last decade much of this material has been developed in close 
collaboration with Professor Paul Lambert, Stirling University. 
However, Professor Gayle and Dr McDonnell are responsible for any errors in this file.

Professor Vernon Gayle (vernon.gayle@ed.ac.uk) 
Dr Diarmuid McDonnell (diarmuid.mcdonnell@ed.ac.uk)


********************************************************************************

A few commands in this file write to your memory stick or computer.

For illustration this is called "F:\" you may need to change this location.

In your work environment you will probably use a network location
such as your "M:\" drive.

When using Stata at your own organisation you will have to change this to the 
correct location.

This file was initially prepared using Stata 13.1 for Windows and updated to
be compatible with Stata 15 for Windows.

Stata is continually being improved. This means that programs and do-files 
written for older versions might stop working.

It is possible to specify the version of Stata that you are using at the 
top of programs and do-files.

e.g.  version 10

Some of the commands that are used in this file may NOT
run on small versions of Stata. 

********************************************************************************

We suggest that you make a copy of this file.


		**********************************************
		* IT IS IMPORTANT THAT YOU READ THIS HANDOUT *
		* AND FOLLOW THE STATA.DO FILE LINE BY LINE! *
		**********************************************


The file is sequential. It MUST be run line by line. 
Many of the commands will NOT run if earlier lines of commands have not been 
executed.


Anotate your new copy of the file as you work through it with your own notes 
(use "*" to comment out your notes).

There are "Questions" for you to answer and "Tasks" for you to do.

There are "Exercises" at the end of the .do file.


********************************************************************************

**/



********************************************************************************
*
*                    Setting Up Stata and Your Directory Structure
*
********************************************************************************

* This section is about organising preliminary settings in Stata *

* clear the computer memory *

clear all

macro drop all


/** more causes Stata to display --more-- and pause until any key is pressed. 
    It is usually more convenient to have this function switched off **/

set more off

* keep clear log files containing your output *

* first close any log files that might already be running *

capture log close

/** 

we use the capture command because Stata will not report an error if there is
no log file to close

**/



/** 

Getting your directory structure in a consistent form is critical to efficient
working.

Most people wil already have established a directory structure on their own
machines or network areas.

We are not suggesting that you change your structure to any particular format.

However we ARE suggesting that you put some thought into your directory 
structure and consider how you could make it more CONSISTENT and how it might be
improved to assist your workflow.


In an example below we will organise your memory stick into a simple but 
effective directory sturture...

working
data_raw
data_clean
codebooks
logs
do_files
documents
figures
tables
trash
temp


Here is a version that is suggested by Scott Long...

Scott Long - Workflow Chapter 2 - designing a directory structure				
17/04/2008				
				
Project				
Directory	Level 1	Level 2	Level 3	Purpose
\AgeDisc				Project directory.
	\- To file			Files to examine and move to appropriate location.
	\Administration		Administration.
		\Budget		    Budget sheets.
		\Correspondence	Letters and e-mails.
		\Proposal		Grant proposal and related materials.
	\Documentation		Documentation for project.
		\Codebooks		Codebooks for source and constructed variables.
	\Hold then delete	Delete when project is complete.
		\2007-06-13     submited Do, data and text when paper was submitted.
		\2008-04-17     revised	 Do, data and text when revisions are sumbitted.
		\2008-01-02     accepted Do, data and text when paper is accepted.
	\Posted			    Completed files that cannot be changed.
		\- Datasets		Datasets.
			\Derived	Dataset constructed from original data files.
			\Source	    Original data without modifications.
		\- Text		    Completed drafts of paper.
		\DataClean		Data cleaning and variable construction.
		\DescStats		Descriptive statistics and sample selection.
		\Figures		Graphs of data.
		\PanelModels	Panel models for discrimination.
	\Readings			Articles related to project; bibliography.
	\Work			    Work directory.
		\- To do		Work that hasn't been started.
		\Text		    Active drafts of paper.


		
Spend some time thinking about a suitable directory structure for one of your
current or forthcoming projects.

Here are a few commands that will help you...

**/

* display the path of the current working directory *

pwd

* change the working directory *

cd /* select location where you want to store your project files */

pwd

* make a new directory *

mkdir "e:\new_directory"

* take a look on the drive to check that the directory has been created *

* now remove this directory *

rmdir "e:\new_directory"


/** 

you can run the following block of commands or decide on your own directory
structure...

**/

mkdir "e:\working"
mkdir "e:\data_raw"
mkdir "e:\data_clean"
mkdir "e:\codebooks"
mkdir "e:\logs"
mkdir "e:\do_files"
mkdir "e:\documents"
mkdir "e:\figures"
mkdir "e:\tables"
mkdir "e:\trash"
mkdir "e:\temp"


/**

Task: Write a paragraph to justifying the directory structure that you have 
chosen.

**/

********************************************************************************




********************************************************************************
*
*                    Locating Directories 
*
********************************************************************************


/** 

Locating files using macro commands is an extremely efficient practice. 

It tells Stata where to look for files on your machine or network.

**/

* make sure you run all of the following commands *

global path1 "e:\working\" 

/** 

the location of a working directory -  
where you can save newly created data files and output

**/


global path2 "e:\do_files\" 

* the location where your .do files will be saved *

global path3 "e:\data_raw\"

* the location where your raw (i.e. unprocessed) data is stored *

global path4 "e:\data_clean\"

* the location where your clean (i.e. processed) data is saved *

global path5 "e:\logs\"

* the location where your log files are saved *

global path6 "e:\codebooks\"

* the location where your codebooks are saved *

global path7 "e:\temp\"

* the location of a temporary folder where you can save intermediate files *

/**

often it is easier to define all of the path macros in a separate file, known as an "include" file: file_paths.doi.
then we can call this file from our do file as follows:

include "e:\file_paths.doi"
display $path1

very useful technique when there are multiple people working on the same data.

**/


********************************************************************************

* downloading data *

/**

Go to the course repository, download the data files and place them in the
"data_raw" folder you created.

**/

********************************************************************************
 
* using global macros and paths *

clear 

/**

Because you have already set path3 as "e:\data_raw\" you can use this macro 

to get the data file from the data_raw directory

**/


use $path3\adrc_s_training_data4.dta, clear 
summarize

/**

at this stage you might feel a sensation like fish scales falling from your 
eyes, or you might hear a sound like pennies falling from heaven...

defining paths as macros provides vital help for switching between machines, 
working in collaboration with colleagues and keeping track of where files came
from and where they end up!

**/

* now save an updated version of the file *

* consider how you might incorporate stuitable date, author and version info *

save $path4\adrc_s_training_data_20150923_student_v4.dta, replace


* take a look in the folder to see if the file has been saved *

* we don't really need this file so let us erase it *

erase $path4\adrc_s_training_data_20150923_student_v4.dta

* take a look in the folder to see if the file has been erased *



********************************************************************************
*
*                    Organising Variables and Measures
*
********************************************************************************


use $path3\adrc_s_training_data4.dta, clear 

* take a look at a summary of the variables *

summarize

* take a look at a description of the data *

describe
desc // Many commands can be abbreviated

* take a quick look at the data *
			
browse

* QUESTION: how many cases (rows) are in the dataset?

count

* take a look at the first three cases *

list in 1/3

* reorder the dataset with the varaibles id sex age marstat first *

order id sex age marstat 

list in 1/3

* save a codebook of the data *

capture log using $path6\codebook_20150923_student_v1.txt, replace text

codebook, compact

capture log close

/** 

take a look at the compact codebook that has been created as a txt file in
path6 "e:\codebooks\"

QUESTION: what is the "codebook" command doing?

**/

* here is an alternative format for your codebooks *

codebook, header
/**

you may have noticed that many commands have options that alter the results.
commands are specified by the use of a comma "," followed the option.

TASK: explore some of the options associated with the "codebook" command. HINT, use "help codebook" command to see what is available.

**/

/**

Right at the top of the output there is some additional information...

 Dataset:  f:\data_raw\adrc_s_training_data4.dta
            Last saved:   4 Aug 2015 08:54

                 Label:  [none]
   Number of variables:  49
Number of observations:  5,048
                  Size:  328,120 bytes ignoring labels, etc.


**/

* label the data *

label data "Training data for AQMEN course"

* add notes to the data *
/**

notes command attaches notes to the dataset in memory

these notes become a part of the dataset and are saved when the dataset 
is saved and retrieved when the dataset is used

**/

notes: contains synthetic (i.e. not real) observations.
notes: data are suitable for training purposes only.
notes

* start a log file *

capture log using $path5\day1_log_20180624_v1.txt, replace text 

* sort the data by id *

sort id

* list the id values for the first 10 cases *

list id in 1/10

* number labels *

tab sex

* remove the number labels from the dataset *

numlabel _all, remove

tab sex

* most of the time you will want the number labels - put them back *

numlabel _all, add


* generate a new indicator varaible for males (i.e. male=1)

gen males=.

tab males

replace males=1 if sex==1
replace males=0 if sex==2

tab males sex, missing

* add a label to the variable *

label variable males "gender"

tab males

* define a set of labels (called sexlabel) *

label define sexlabel 0 "female" 1 "male"

* attach the value labels (called sexlabel) to the new male variable *

label values male sexlabel

tab males

* you might also want the number labels *

numlabel sexlabel, add

tab males

* renaming a variable *

rename rgsc rgsoc_class

* cloning an existing a variable *

tab ethnic

clonevar ethnic2=ethnic

recode ethnic2 (1=0) (2/max=1) 

tab ethnic ethnic2, missing

/**

TASK:

1. Add a label to the variable ethnic2

2. Add some suitable value labels to the variable ethnic2

3. Check that you have the number and value labels for the variables

**/


* construct an indicator for girls under age 16 *

gen girlu16=.

replace girlu16=1 if male==0 & age<16

* remember 2 + 2 = 4 that is 2 plus 2 becomes 4 *
* in maths the single equal " = " sign means becomes *
* the double equals sign " == " means equivalent to *

tab girlu16, missing


* generate a variable for age squared *

generate agesq = age^2

scatter agesq age 

* take a look at some of the other maths functions that Stata can perform

help math functions

* drop the new variables that you have created *

drop males ethnic2 girlu16 agesq

* keep is the antonym of drop *

********************************************************************************

/**

END OF PRACTICAL ONE

...though feel free to continue a little bit further if you are feel you are on top
of things.

**/

********************************************************************************

* constructing dummy variables *

tab ethnic, missing

capture drop white
gen white=(ethnic==1)

/** 

Task: 

Check that there are the correct number of white people.

Where are the four missing cases?

**/

* there are several manual ways to create dummy variables here are two *

capture drop white
gen white=.
replace white=1 if ethnic==1
replace white=0 if ethnic>1 & ethnic<9
tab white ethnic, missing

capture drop white
gen white=.
replace white=1 if ethnic==1
replace white=0 if ethnic>1 
replace white=. if ethnic==.
tab white ethnic, missing

* a far better

capture drop white

tabulate ethnic, gen(eth)
tab1 eth*, missing

/**

TASK: 

Rename each of the new ethnicity variables.

**/


* now clear the memory *

clear

* now clear Stata's main window *

cls


* subsets of data *

use id sex ethnic age marstat using $path3\adrc_s_training_data4.dta, clear 

* take a look at a summary of the variables *

summarize

* take a look at a description of the data *

describe 

* take a quick look at the data *
			
browse

* keep only males *

keep if sex==1

tab sex

clear

* here is another way of getting a subset of the data *

use id sex ethnic age marstat if sex==1 using ///
	$path3\adrc_s_training_data4.dta, clear 
/**
QUESTION: what is the effect of "///" in the above command?
**/
	
tab sex


* making dataset of summary statistics *
/**

often we are interested in constructing summary, aggregate or population
statistics from micro-level data. Thankfully Stata makes this fairly simple
using the "collapse" command.

**/

use $path3\adrc_s_training_data4.dta, clear 

mean age, over(ethnic)
table ethnic, c(mean age sd age min age max age)

collapse age, by(ethnic)

browse
/**

TASK: write some documentation on the structure and contents of the new dataset.
		you can write comments in the do file or attach some notes to the dataset itself.
		e.g. "label data" or "notes: "
**/


use $path3\adrc_s_training_data4.dta, clear 

collapse (mean) mean_age=age (count) n=id, by(ethnic)
browse
/**

TASK: describe what each element of the above "collapse" command is doing (use "help collapse").

**/


* another example of collapsing data *

use $path3\adrc_s_training_data4.dta, clear 

count

tabulate sex, generate(sexdum)
collapse (count) n=id (sum) girls=sexdum1 boys=sexdum2, by(ethnic) 
browse
/**

TASK: describe what each element of the above "collapse" command is doing (use "help collapse").

**/


* making a dataset of frequencies or proportions *

use $path3\adrc_s_training_data4.dta, clear 

contract sex ethnic

browse


********************************************************************************

* expanding collapsed datasets *

clear
input ethnic gender n
1 1 2133
1 2 2186
2 1 52 
2 2 52
3 1 49
3 2 48
4 1 72
4 2 71
5 1 40
5 2 41
6 1 39
6 2 45
7 1 28
7 2 46
8 1 78
8 2 64
end

count

summarize 

expand n

browse

* you might want to drop the first 16 rows of the original data *

drop if _n<17

count

tab ethnic gender, missing


* preserving and restoring data *

/**

sometimes we would like to collapse/contract data (or perform some other transformation) without
altering the data in memory. we've done this by loading in the original data (i.e. "use $path3..."),
however there is another approach.

**/

use $path3\adrc_s_training_data4.dta, clear 

count

preserve
	tabulate sex, generate(sexdum)
	collapse (count) n=id (sum) girls=sexdum1 boys=sexdum2, by(ethnic)
	list
	count
	desc, f
restore

list
count
desc, f
browse

********************************************************************************



* convert string variables to numeric variables and vice versa *
 
 webuse destring1, clear 
 
 describe
 
 list

 
* generate numeric variables from the string variables

destring, generate(id2 num2 code2 total2 income2)

* describe the result
 
keep id2 num2 code2 total2 income2

describe


********************************************************************************

webuse destring2, clear
 
describe date
 
list date

/** 

remove the spaces in date and converts it to a numeric variable, 
replacing the original string variable
							
**/
 
destring date, ignore(" ") replace

* describe the result *

describe date

* list the result *

list

********************************************************************************

webuse tostring, clear

describe

list

/**
   
convert the numeric variables year and day to string variables, 
replacing the original string variables

**/

tostring year day, replace

* describe the result *
   
describe

* list the result *
 
list

browse

* check the colour of the variables *


********************************************************************************

* looking at the egen command *

use id sex ethnic age marstat using $path3\adrc_s_training_data4.dta, clear 

summarize age
histogram age, ///
	freq title("Distribution of age") ytitle("Frequency") xtitle("Age")
/**

let's create a categorical measure of age.

**/	

egen agecat_10 = cut(age), at(10,20,30,40,50,60,70,80,90,100)

tab agecat_10
table agecat_10, contents(min age max age)


/**

if you prefer, you can ask cut() to choose the cutoffs to form groups 
with approximately the same number per group

we request the creation of 4 (roughly) equally sized groups

**/

egen agecat_4 = cut(agecat), group(4) label

table age agecat_4

/**

"egen" is a very powerful and flexible command - see "help egen" for an idea of what other functions are available under this command. 

**/


********************************************************************************


* looking for variables *

cls

use $path3\adrc_s_training_data4.dta, clear 

/**

lookfor helps you find variables by searching for a string among all variable 
names and labels.

**/

lookfor ethnic

/**

the inspect command provides a quick summary of a numeric variable that differs 
from the summary provided by summarize or tabulate

it reports the number of negative, zero, and positive values

the number of integers and nonintegers; the number of unique values, and the 
number of missing and it produces a small histogram

its purpose is not analytical but is to allow you to quickly gain familiarity 
with unknown data

**/

inspect ethnic


/**

missing values are a perennial feature of data wrangling

often it is sufficient to identify observations with missing values for certain variables
and exlcude them from analyses

we can do this by dropping the observations from the dataset, or use an 'if statement' to
exclude them when executing a specific command

**/

** ssc install mdesc
/**
	The above command installs a user-written package that describes variables with missing values
**/
mdesc

codebook hoh_inc // numeric variable that measures household income
inspect hoh_inc
/**

	QUESTION: are negative and zero values valid for this variable?

**/
sum hoh_inc , detail // this command automatically excludes missing values

tab marstat if hoh_inc==.
tab marstat if hoh_inc!=.

drop if hoh_inc==. // '.' represents missing values for numeric variables


use $path3\adrc_s_training_data4.dta, clear // let's load in the dataset again, in case we made a mistake dropping observations

tab ethnic, missing

* change missing value (.) to a number (999)

mvencode ethnic, mv(999)
tab ethnic, missing 
/** 

	'999' is often used as a value to identify missing values in social science datasets
	
	this is advised as it distinguishes between different reasons for missing values
	e.g. a survey question wasn't relevant to a particular individual and thus should not
	have a value
	
**/	

codebook workhours
/**

	QUESTION: why are some many observations missing values for this variable?

**/

* change missing values (999) to missing (.)

mvdecode ethnic, mv(999)

tab ethnic, missing

* take a look at another variable with two missing value codes *

tab workmode, missing

mvdecode workmode, mv(-9, 7)

tab workmode, missing

/**

	there are other ways of dealing with missing values, one of the most common
	of which is imputing values e.g. replacing missing values with the mean or median value,
	or some other algorithmic approach
	
	this is an intermediate topic and readers are encouraged to consult the folllowing
	guidance: https://stats.idre.ucla.edu/stata/seminars/mi_in_stata_pt1_new/

**/


********************************************************************************

* dealing with long numbers (e.g. id numbers) *

clear
input id
123456788
123456789
123456791
123456792
123456793
123456794
123456799
123456100
end

list

* now use the format command *

format id %9.0f
list



********************************************************************************




********************************************************************************

/**

END OF PRACTICAL TWO

...though feel free to continue a little bit further if you are feel you are on top
of things.

**/

********************************************************************************



********************************************************************************

* appending files *
/**

most simple analyses can be conducted using one dataset, however there is substantial
added value in linking multiple data files.

appending is one such linkage method. it involves combining two or more datasets to 
increase the number of cases/rows.

**/

clear

input id wave age sex y x1
001 1 16 0 1 1
002 1 16 1 0 1
003 1 16 1 0 1
004 1 16 1 1 0
005 1 16 1 1 1
end

list

save $path7\wave1_temp.dta 

* the next wave of data *

clear
input id wave age sex y x1
001 2 17 0 0 0
002 2 17 1 0 1
003 2 17 1 0 1
004 2 17 1 1 0
005 2 17 1 1 1
end

save $path7\wave2_temp.dta 

* the final wave of data *

clear
input id wave age sex y x1
001 3 18 0 0 0
002 3 18 1 0 0
003 3 18 1 0 0
004 3 18 1 1 1
005 3 18 1 0 0
end

save $path7\wave3_temp.dta 

use $path7\wave1_temp.dta, clear 
append using $path7\wave2_temp.dta
append using $path7\wave3_temp.dta

list, sepby(id)

sort id wave

list, sepby(id)

/** 

this is classic panel data format: multiple observations on multiple cases e.g. individuals over time.

you will use append to join up waves of data e.g. multiple years of invoices, sales.

in practice appending is always easier with large scale data sources compared 
with reshaping data

**/

* reshaping datasets (wide and long files)

webuse reshape1, clear

list

* this is a wide dataset - reshape it into long (e.g. panel) format *

reshape long inc ue, i(id) j(year)

list

* seperate the data by id *

list, sepby(id)

* convert data back from long format to wide format *

reshape wide inc ue, i(id) j(year)

webuse reshape2, clear

list, sepby(id)
 
reshape long inc, i(id) j(year)

list, sepby(id)

reshape error

********************************************************************************

* merging files *


use "http://www.stata-press.com/data/r13/autosize.dta", clear

list

use "http://www.stata-press.com/data/r13/autoexpense.dta", clear

list

* now match the auto size data to the autoexpense data *

* performing a 1:1 match merge

use "http://www.stata-press.com/data/r13/autosize.dta", clear

* this is the master data set *

merge 1:1 make using http://www.stata-press.com/data/r13/autoexpense.dta

list

tab _merge

/**

Stata creates a flag called _merge

numeric    equivalent
code      word (results)     description
-------------------------------------------------------------------
1       master             observation appeared in master only
2       using              observation appeared in using only
3       match              observation appeared in both

this is especially helpful in complex merges where some observations 
are missing 

if you are undertaking multiple merges rename this variable and use it to help
keep track of the presence (or absence) of observations

**/

clear

* here is some individual data from wave 3 of a survey *
* hid is the household indentifier *

clear
input pid wave hid 
001 3 099
002 3 099
003 3 047
004 3 047
005 3 162
end

list

sort hid 

* merges only work when data are correctly sorted *

save $path7\wave4_ind_temp.dta, replace


* here is some household level data from wave 3 of a survey *
* hid is the household indentifier *

clear
input hid wave car garden tv
099 3 1 1 1
162 3 1 0 1
047 3 0 1 1
end

list

sort hid 

save $path7\wave4_household_temp.dta, replace


use $path7\wave4_ind_temp.dta, clear

list 

merge m:1 hid using $path7\wave4_household_temp.dta

list

tab _merge

********************************************************************************

* now take a look at matching individual level data to the household data *

use $path7\wave4_household_temp.dta, clear

list 

merge 1:m hid using $path7\wave4_ind_temp.dta

list

sort hid pid

list


********************************************************************************
*                    Stata Help
*
********************************************************************************

/**

Advice on finding help from Stata...

Let's say you are trying to find out how to do something.  
With over 2,000 help files and 11,000 pages of PDF documentation, 
Stata have probably explained how to do whatever you want.  

The documentation is filled with worked examples that you can run on supplied 
datasets.  Whatever your question, try the following first:

1. Select Help from the Stata menu and click on Search....

[We are Stata programmers so never use the menu!]


2. Type some keywords about the topic that interests you, 
e.g. "logistic regression".

3. Look through the resulting list of available resources, 
including help files, FAQs, Stata Journal articles, and other resources.

4. Select the resource whose description looks most helpful.  
Usually, this description will be a help file and will include 
"(help <xyz>)", or, as in our example, perhaps "(help logistic)".  
Click on the blue link "logistic".

5. Let's assume you have selected the "(help logistic)" entry.  
You are probably not interested in the syntax at the top of the file, 
but you would like to see some examples.  
Select Jump To from the Viewer menu 
in the top right corner of the help file now on your screen), 
and click on Examples.  You will be taken to example commands that you can run 
on example datasets. Simply cut and paste those commands into Stata 
to see the results.

6. If you are new to the logistic command and want both an overview and 
worked examples with discussion, from the Also See menu, click on [R] 
logistic with the PDF icon.
Or at the top of the help file, click on the blue title of the entry 
[R] logistic).  
Your PDF viewer will be opened to the full documentation of the logistic 
command.

7. There is a lot of great material in this documentation for both experts and 
novices. As with the help file, you will often want to begin first with the 
Remarks and examples section.  Simply click on the Remarks and examples link at
the top of the logistic entry.  A complete discussion of the logistic command 
can be found in the remarks along with worked examples that run on supplied 
datasets and are explained in detail.  That should get you ready to use the 
command on your own data.

If that does not help, try the many other Stata resources; 
see Resources for learning more about Stata.

**/


********************************************************************************

/**

PLEASE PLEASE PLEASE - spend some time refelecting on the new ideas and commands
that you have encountered

Remember - COMMENT COMMENT COMMENT

**/


********************************************************************************


/**

Well done. You have covered a lot of material.

The workshop is aimed at analysts who are novice/new Stata users but who want to quickly gain proficiency in this package.

Please adjust your expectations - this is a two day course.

The instructors have been working with Stata and undertaking statistical
analyses for many years and they are all still learning and improving their 
skills. 

It will NOT be possible to learn everthing in two days.

Please be patient. Computers often go wrong.

Please asks the tutors for help.

Not all of your questions will be answered but we will help as much as we can.

**/

********************************************************************************

/**

END OF PRACTICAL THREE

...though feel free to continue a little bit further if you are feel you are on top
of things.

**/

********************************************************************************



*******************************************************************************
*
*                   Producing Statistical Outputs
*
********************************************************************************


/**

Employment Status, Young People (age 16 -19) Great Britain 1974-81 
General Household Survey, Source Payne, Payne and Heath 1994 Table 3.1 

**/


* input the data *
clear
input year quals percent
1974 0 8
1974 1 5
1975 0 13
1975 1 7
1976 0 21
1976 1 8
1977 0 24
1977 1 8
1978 0 23
1978 1 9
1979 0 19
1979 1 8
1980 0 27
1980 1 12
1981 0 39
1981 1 16
end

* adding labels to the dataset *

label variable year "Year"
label variable quals "Qualifications"
label variable percent "Percentage Unemployed"
label define qual1 0 "None" 1 "Some"
label values quals  qual1
numlabel _all, add

* view the data *

summarize

* a simple table of percentage unemployed by year and qualifications *

tab year qual [fweight=percent]

* graphing the trend in youth unemployment *
* run these line together*

#delimit ;

graph twoway (scatter percent year if quals==1, msymbol(circle)) 
             (scatter percent year if quals==0, msymbol(diamond)) , 
			 title("Percentage Unemployed by Qualifications and Year", 
			 size(large) justification(center) )
             subtitle(
			 "Young people (age 16-19) Great Britain 1974-81 GHS", 
			 size(medsmall) justification(left) ) 
             note("Calculated from Payne, Payne and Heath 1994 Table 3.1" 
             "", 
             justification(left) ) 
             legend( order(1 2)   
            label(1 "Qualifications") label(2 "No Qualifications") ) 
			scheme(s1mono);

delimit cr


/** a thought about delimit

the #delimit command resets the character that marks the end of a command

in this case the semicolon ";"

delimit cr changes the back to the default i.e. carriage return

alternatively we could use the familiar line join /// but this has to be done at 
the end of each line

**/


/**

a picture paints a thousand words!
 
in Professor Gayle's experience, with the exception of weighting, 
graphing data is one of the most troublesome aspects of data analysis

we have a two-day graphing course if you are interested...

**/


********************************************************************************

********************************************************************************
*
*                    Publication Ready Outputs (Tables)
*
********************************************************************************

clear

sysuse auto.dta, clear
 
codebook, compact

* a table of summary statistics*

********************************************************************************
*
*                    Installing Packages
*
********************************************************************************

/**

Installing Packages in Stata

A benefit of Stata is that new commands and functions are developed which can 
be incorporated into your current version of Stata. It is possible to acquire 
and manage downloads from the internet using the command net. 
The findit command can be used to search the Stata site and other sites for 
information. For example imagine that you heard about a program to draw graphs 
using quasi-variance estimates, then using the syntax findit qvgraph would lead 
you to the module written by Aspen Chen of the University of Connecticut. 

Many new packages are deposited at the Statistical Software Components (SSC) 
archive which is sometime called the Boston College Archive and is administered 
by http://repec.org . 

The SSC archive has become the premier Stata download site for user-written 
software and also archives proceedings of Stata Users Group meetings and 
conferences. Programmes can be downloaded from the SSC archive using the syntax
ssc install followed by the new programme’s name. 

Readers who do not have administrative access to Stata 
(for example when working on their university network), may first require 
permission to download packages. 

An alternative approach may be to set up an area locally where you have write 
access (e.g. c:\temp ) and then use the following Stata syntax

	global path10 "c:\temp\"
	capture mkdir $path10\stata
	capture mkdir $path10\stata\ado
	adopath +  $path10\stata\ado
	net set ado $path10\stata\ado

You can test this by installing a package from SSC for example the estout 
package

ssc install estout

Help on this new package should then be available

		help estout


**/

ssc install estout

estpost summarize mpg trunk turn

esttab using "$path7\table1.rtf", cell("count(f(0)) mean(f(2)) sd(f(0))") ///
       title(Table 1: Summary Statisitics) addnotes(Notes: Auto.dta) ///
       nonumbers noobs replace

* the output is written to $path7\table1.rtf click on the text in the output *

* a two-way table *

use http://www.stata-press.com/data/r13/citytemp2, clear

tabulate region agecat

estpost tab region agecat

esttab using "$path7\table2.rtf", cell("b(f(0))") ///
 nonumbers mtitles(" Age Group")  ///  
 collabels(none) ///
   title(Table 1: Census Region by Age Group) addnotes(Notes: Citytemp2.dta) ///
   noobs unstack replace

* the output is written to path7\table2.rtf click on the text in the output *

/**

this is just a taste of the possibilities for producing publication ready 
outputs using Stata

**/

   
********************************************************************************


********************************************************************************
*
*                    Exporting Modelling Results
*
********************************************************************************


/**

exporting results - making regression tables from stored estimates

you might have to run "ssc install estout" on your own machine if it is
not already installed.

**/


webuse womenwk, clear

tab education, gen(ed)
rename ed1 no_ed
rename ed2 low_education
rename ed3 medium_education
rename ed4 high_education
label variable no_ed "no education"
label variable low_education "low education"
label variable medium_education "medium education"
label variable high_education"high education"

sum wage, detail
histogram wage, ///
	freq normal title("Distribution of hourly wage") ytitle("Frequency") xtitle("£") scheme(s1mono) 

regress wage low_education medium_education high_education age
estimates store reg1
/**

	regression is a statistical technique for estimating the association between an
	outcome and a suite of explanatory variables
	
	it is a powerful and flexible approach for predicting the values of an outcome
	
	in the above example we are estimating the value of an individual's wage using four
	explanatory variables, and saving the results in an object called "reg1"

**/

esttab reg1 using $path7\regress1.rtf,		///
	cells(b(star fmt(%9.3f)) se(par)) 					///
	stats(r2 r2_a N, fmt(%9.3f %9.3f) labels(R-Squared AdjR-Squared n)) /// 
	starlevels(* .10 ** .05 *** .01) stardetach 	///
	label mtitles("Regression Model") 		///
	nogaps replace
	
* the output is written to $path7\regress1.rtf click on the text in the output *


/**

	QUESTION: interpret the results of the linear regression analysis
	
	if it looks 'all greek' to you (statistics joke, sorry), then please ask one of the tutors
	to provide a thorough explanation

**/


/**

	TASK: load in the 'adrc_s_training_data4.dta' dataset and construct a regression analysis
	using any variables you like. start by selecting a numeric variable to act as an outcome
	and then choose 4+ variables that you think might explain variation in the values of the outcome

**/


********************************************************************************

/**

END OF PRACTICAL FOUR

...though feel free to continue a little bit further if you are feel you are on top
of things.

**/

********************************************************************************

********************************************************************************
*
*                    More on Macros
*
********************************************************************************

/**

A macro is used as shorthand  

you type a short macro name but are actually referring to some
numerical value or a string of characters

Here is an example of a simple local macro

**/

sysuse auto.dta, clear

codebook, compact

reg mpg weight length foreign

local varlist weight length foreign

regress mpg `varlist'


/**

The program reg1 will create a local macro called varlist.

The program reg1 will also use that macro.

**/

program define reg1
local varlist weight length foreign
regress mpg `varlist'
end

* running a the program reg1 *

reg1

* removing a program *

program drop reg1

/**

the program reg2 will create three local macros called varlist

the prgram reg2 will also use those macros.

**/

capture program drop reg2
program define reg2
local varlista weight 
local varlistb weight length 
local varlistc weight length foreign
regress mpg `varlista'
regress mpg `varlistb'
regress mpg `varlistc'
end

cls
reg2

********************************************************************************


********************************************************************************


********************************************************************************
*
*                    Loops
*
********************************************************************************

/**

loops offer a powerful and versatile tool for both constructing and 
analysing data

**/

clear

* here is a simple loop that counts *

forvalues x = 1/5 {
	display "`x' + 1 = " 
	display "result"
	display `x' + 1
	display " "
}

********************************************************************************
clear

sysuse auto, clear

codebook, compact

* here is a simple loop for performing a command on multiple variables *

foreach varname of varlist price mpg headroom trunk {

	ci `varname' 

}

*

********************************************************************************

* using a loop for manipulating variables *

* a simple example *

clear

input famid inc1-inc12 
1 3281 3413 3114 2500 2700 3500 3114 3319 3514 1282 2434 2818
2 4042 3084 3108 3150 3800 3100 1531 2914 3819 4124 4274 4471
3 6015 6123 6113 6100 6100 6200 6186 6132 3123 4231 6039 6215
end
 
list 


foreach var of varlist inc1-inc12 {
  generate tax`var' = `var' * .10
}

*

list


********************************************************************************

* here is an example of a more complex use of loop


* encode string into numeric and vice versa using a loop *

clear

* get an excel spreadsheet from the web *

insheet using "http://stats.idre.ucla.edu/stat/data/hdp.csv", comma
codebook
numlabel _all, add

browse

gen id=_n

keep id tumorsize familyhx smokinghx sex cancerstage school

order id tumorsize familyhx smokinghx sex cancerstage school

proportion familyhx smokinghx sex cancerstage school

* note the following error 'varlist:  familyhx:  string variable not allowed '*

* use a foreach loop to encode all the variables at once *

foreach var of varlist familyhx smokinghx sex cancerstage school {
encode `var', gen(`var'2)
drop `var'
rename `var'2 `var'
}

/**

	TASK: add comments to the end of each line in the loop detailing what is happening at each stage

**/


browse

proportion familyhx smokinghx sex cancerstage school

summarize


********************************************************************************


/**

using a loop to create data 

construct a fake dataset with 100 observations and 10 wave a variables

**/

clear

set obs 100

gen id=_n

forv i=1/10{
 gen waveavar`i'=runiform() 
}
/**

	creates a new variable and assigns it a random value between 0 and 1 for each observation

**/
summarize

* remove the wave a suffix *

rename wavea* *

summarize

/**

this is particularly useful when working with multiwave studies such as
household panel surveys (e.g. the British Household Panel Survey)

**/


********************************************************************************

********************************************************************************
*
*                    Call a.do File 
*
********************************************************************************

/** 

running another .do from within your current .do file is simple enough

in our experience data analysts (especially when tired) will tend to make errors

once again... commenting is critical

also using your file sharing record (spreadsheet) assiduously will be a great 
help


**/

do $path2\regress_hsb_v1


********************************************************************************

* close your log file *

capture log close


********************************************************************************

/**

Summary of topics covered:

Setting up Stata Directories
Locating Directories
Organising Variables and Measures
Stata Help
Publication Ready Outputs (Graphs)
Publication Ready Outputs (Tables)
Exporting Modelling Results
More of Macros
Loops
Calling a .do file

**/

*******************************************************************************

/**

END OF PRACTICAL FIVE

...if you finish ahead of time then please use this opportunity to revisit
troublesome topics/commands and ask the tutors plenty of questions

**/

*******************************************************************************


********************************************************************************
*
*                    Practical Activities (self directed)
*
********************************************************************************

/**

This phase is designed to help you consolidate your learning.

It can be completed during the workshop or at a later date.

Take your time.

Ask the tutors for help.

Discuss your work with other participants.


Good Luck!

**/


********************************************************************************
*
*                   EXERCISE 1 – Predicting Serious Incidents
*
********************************************************************************

/**

Dataset: 

the data for this exercise are a mix of open and confidential
raw datasets derived from the Scottish Charity Regulator (OSCR).
the data have been anonymised but still contain confidential information,
which should be respected and not divulged.

THE DATA WILL ONLY BE AVAILABLE FOR THE DURATION OF THESE EXERCISES AND MUST NOT BE RETAINED OR 
SHARED UNDER ANY CIRCUMSTANCES.


to save time we have constructed a version of the data in Stata format,
which is now available on the workshop Github repository: [INSERT LINK]


Scenario:

You have the rest of the workshop to replicate a simple piece of data analysis

You can work in pairs or small teams

You must attempt to construct an effective and efficient .do file (of files)

At the end of the exercise you should be able to show some summary statistics
and present the results of a statistical model.

You must get your .do file in a state that a collaborator (or supervisor) could
re-run the analyses and understand the steps you have taken and the choices that
you have made.

Remember anotate - Comment Comment Commment (and then add more comments) 

The .do file should be a pillar in the transparent research process!


Question(s):

1. What is the nature and extent of serious incident reporting?

2. Which factors best predict whether an organisation reports an incident?


Tasks:

1. Examine the codebook and the data files

2. Identify the outcome variable and a few explanatory variables

3. Start a .do file 
		
4. Undertake the necessary data construction 

5. Undertake some exploratory data analyses

6. Present some summary statistics

7. Estimate some more advanced data analysis (e.g. a statistical model)


some syntax has been provided to get you up-and-running: aqmen_exercise1_20180716_dmd.do
the full solution is documented in the following do file: aqmen_exercise1_solution_20180716_dmd.do


GOOD LUCK!


**/


********************************************************************************


********************************************************************************
*
*                   EXERCISE 2 – Modelling Demise
*
********************************************************************************

/**

Dataset: 

the data for this exercise are open datasets derived from the Charity Commission for England & Wales.

THE DATA WILL ONLY BE AVAILABLE FOR THE DURATION OF THESE EXERCISES. if you are interested in
using these data after the workshop then visit http://data.charitycommission.gov.uk/.

the data are provided in .csv format and must be converted to Stata format: [INSERT LINK]


Scenario:

You have the rest of the workshop to replicate a simple piece of data analysis

You can work in pairs or small teams

You must attempt to construct an effective and efficient .do file (of files)

At the end of the exercise you should be able to show some summary statistics
and present the results of a statistical model.

You must get your .do file in a state that a collaborator (or supervisor) could
re-run the analyses and understand the steps you have taken and the choices that
you have made.

Remember anotate - Comment Comment Commment (and then add more comments) 

The .do file should be a pillar in the transparent research process!


Question(s):

1. What is the rate of charity de-registration in England & Wales?

2. What factors are associated with de-registration and do they vary across different categories of the outcome?


Tasks:

1. Examine the codebook and the data files

2. Identify the outcome variable and a few explanatory variables

3. Start a .do file 
		
4. Undertake the necessary data construction 

5. Undertake some exploratory data analyses

6. Present some summary statistics

7. Estimate some more advanced data analysis (e.g. a statistical model)


some syntax has been provided to get you up-and-running: aqmen_exercise2_20180716_dmd.do
the full solution is documented in the following do file: aqmen_exercise2_solution_20180716_dmd.do


GOOD LUCK!


**/


********************************************************************************


/**

References

Baum, Christopher F. "An introduction to Stata programming." 
Stata Press books (2009).

Long, J. Scott. "The workflow of data analysis using Stata." 
Stata Press books (2009).

Long, J. Scott, and Jeremy Freese. "Regression models for categorical 
dependent variables using Stata." College Station. (2014).

Treiman, Donald J. "Quantitative data analysis: 
Doing social research to test ideas". John Wiley & Sons. (2014).


Friedrich Huebler's guide to integrating Stata and external text editors
http://huebler.blogspot.co.uk/2015/04/stata.html .

Our old website www.longitudinal.stir.ac.uk is no longer updated but has lots of
useful materials
 

**/


********************************************************************************

**							Additional topics

********************************************************************************

/**

the following tasks cover specialised or intermediate data management and analysis
tasks that you may be interested in. they are optional, and your time may be better spent
revising earlier material or tackling the exercises in depth.

**/


* standardizing a variable *

use "http://stats.idre.ucla.edu//stat/stata/notes/hsb2", clear

summarize math science socst

/** 

the mean of math is 52.645, and it's standard deviation is 9.368448 

based on this information, we can generate a standardized version of 
math called z1math

the code below does this with the generate command 
then uses summarize to confirm that the mean of z1math is very close to zero 
and the standard deviation is one(due to rounding error, the mean of a 
standardized variable will rarely be exactly 0)

**/

gen z1math = (math-52.645)/9.368448

summarize z1math

* we can change the format of the z1math variable *
* there will be more on the format command later *

format z1math %16.2fc

summarize z1math, format

/** 

below we do the same for science and socst, creating two new variables, 
z1science and z1socst, using their respective means and standard deviations 
taken from the table of summary statistics

**/

gen z1science = (science-51.85)/9.900891
gen z1socst = (socst-52.405)/10.73579

summarize z1science z1socst

/**

standardizing variables is not difficult, but to make this process easier, 
and less error prone, you can use the egen command to make standardized 
variables

**/

egen z2math = std(math)
egen z2science = std(science) 
egen z2socst = std(socst)

corr z1math z2math z1science z2science z1socst z2socst

* minor differences are due to rounding errors *


********************************************************************************

/**

WARNING!

No micro data will be distributed during this workshop.

The files required are provided via the course repository.

Participants MAY NOT make copies of these files or distribute them.

The files have been sepcially created by the AQMEN / ADRC-S for training and 
MUST not be used for social science or commercial research.

THE DATA ARE NOT REAL! DO NOT USE THEM FOR REAL ANALYSES!

We advise that participants galvanise their training experience and
work with 'genuine' survey data files which they
can dowload legally from the UK Data Service (http://ukdataservice.ac.uk/ -
the old site is www.esds.ac.uk but you will be redirected).

At workshops where real survey datasets are used participants MUST sign 
a data access agreement.

********************************************************************************

Congratulations!

You've gotten through a pile of work and are more than
capable of enabling raw data for analysis in a thorough, efficient
and accurate manner.

REMEMBER: the problems of big data are, essentially, the problems of small data,
and proficiency in the latter is an important precursor to the use of more
sophisticated/challenging datasets.

Hopefully this course has gone some way to convincing you of the value of adopting
social science approaches and tools for data science work; if not then let us know how we can improve;
if so then please engage with us on further topics and tools e.g. Introduction to R/Python,
Longitudinal Data Analysis, Reproducible Data Analytics.

Good luck with future data wrangling and analyses using Stata.



*******************************************************************************************************





© Vernon Gayle, Diarmuid McDonnell - University of Edinburgh.

This file has been produced for AQMeN and the ADRC-S by 
Professor Vernon Gayle with assistance from Dr Roxanne
Connelly and Dr Chris Playford, and updated by Dr Diarmuid McDonnell
and Professor John MacInnes

Any material in this file must not be reproduced, 
published or used for teaching without permission from Professor Vernon Gayle or Dr Diarmuid McDonnell. 

Many of the ideas and examples presented in this document draw heavily on
previous work (see especially www.longitudinal.stir.ac.uk). 
We are grateful for the comments and feedback from participants of 
earlier workshops. 

Over the last decade much of this material has been developed in close 
collaboration with Professor Paul Lambert, Stirling University. 
However, Professor Gayle and Dr McDonnell are responsible for any errors in this file.

Professor Vernon Gayle (vernon.gayle@ed.ac.uk) 
Dr Diarmuid McDonnell (diarmuid.mcdonnell@ed.ac.uk)


********************************************************************************

* End of file *


