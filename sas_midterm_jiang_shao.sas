OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT nofmterr ;

%let program = P01;

libname ST "K:\TX-Data\Datasets\STAR";
* libname SP "K:\TX-Data\Datasets\STARPLUS";
* libname SK "K:\TX-Data\Datasets\STARKIDS";

data star_enroll_all_22;
	set ST.star_enr_nodual_cy2022 (keep=C2201--C2212 membno program months flag);
run;

proc contents data=star_enroll_all_22 varnum;
run;

/* Question 1: What is the number of rows in this dataset and the number of unique members? */
/* Answer: 4866019. Usually the enrollment dataset wont have duplicated members, 
but according to Ashley.S, sometimes form Querl --> SAS member level data could generate dup */

/* Write a proc sql to verify: */ 
proc sql;
	select count(*) as TotalRow,
	count(distinct membno) as Unique_Members_Star
	from star_enroll_all_22;
quit;



/* Question 2: How many members were enrolled for X months (where X ranges from 1 to 12) */
data count_for_member_month;
	set star_enroll_all_22;
	array plancodes(12) $ C2201-C2212;
	months_with_plan = 0;

	do i = 1 to 12;
		if plancodes(i) ne "" then months_with_plan + 1;
	end;
	keep C2201-C2212 months_with_plan;
run;

title "Question 2: How many members were enrolled for X months - Result";
proc freq data=count_for_member_month;
	tables months_with_plan;
run;
title;

/* corss check with original data month: */
title "Question 2: How many members were enrolled for X months - CrossCheck";
proc freq data= star_enroll_all_22;
	tables months;
run;
title;


/* Question 3: how many members experienced enrollment gap of more than 3 months? */
data enrollment_gap;
	set star_enroll_all_22;
	array plancodes(12) $ C2201-C2212;
	gap_times = 0;
	gap_is_more_than3 = 0;

	do i = 1 to 12;
		if plancodes(i) eq "" then do;
		gap_times + 1;
		if gap_times > 3 then gap_is_more_than3 = 1;
		end;
		else gap_times = 0;
	end;
	keep C2201-C2212 gap_is_more_than3;
run;


/* cross check with "flag" */
data enrollment_gap_crox_check;
	set star_enroll_all_22;
	array plancodes(12) $ C2201-C2212;
	gap_times = 0;
	gap_is_more_than3 = 0;

	do i = 1 to 12;
		if substr(flag, i, 1) eq '0' then do;
		gap_times + 1;
		if gap_times > 3 then gap_is_more_than3 = 1;
		end;
		else gap_times = 0;
	end;
	keep C2201-C2212 gap_is_more_than3 flag;
run;

title "Question 3: how many members experienced enrollment gap of more than 3 months? - Result";
proc freq data=enrollment_gap;
	tables gap_is_more_than3;
run;
title;

title "Question 3: how many members experienced enrollment gap of more than 3 months? - CrossCheck";
proc freq data=enrollment_gap_crox_check;
	tables gap_is_more_than3;
run;
title;


/* Question 4: how many members had continuous enrollment for 9 months or more? */

data enrollment_cont;
	set star_enroll_all_22;
	array plancodes(12) $ C2201-C2212;
	cont = 0;
	cont_is_9 = 0;

	do i = 1 to 12;
		if plancodes(i) ne "" then do;
		cont + 1;
		if cont >= 9 then cont_is_9 = 1;
		end;
		else cont = 0;
	end;
	keep C2201-C2212 cont cont_is_9;
run;


/* cross check with "flag" */
data enrollment_cont_crox_check;
	set star_enroll_all_22;
	array plancodes(12) $ C2201-C2212;
	cont = 0;
	cont_is_9 = 0;

	do i = 1 to 12;
		if substr(flag, i, 1) ne '0' then do;
		cont + 1;
		if cont >= 9 then cont_is_9 = 1;
		end;
		else cont = 0;
	end;
	keep C2201-C2212 flag cont cont_is_9;
run;

title "Question 4: how many members had continuous enrollment for 9 months or more? - Result";
proc freq data=enrollment_cont;
	tables cont_is_9;
run;
title;

title "Question 4: how many members had continuous enrollment for 9 months or more? - CrossCheck";
proc freq data=enrollment_cont_crox_check;
	tables cont_is_9;
run;
title;


/* Answer for question 4: there are 4351536 enrollee that have at least 9 months
of continuous enrollment, 89.43% */


* /* Question 5. How many members were enolled in more than one plan? */
* data enroll_change_plan;
* 	set star_enroll_all_22;
* 	array plancodes C2201-C2212;
* 	is_changed_plan = 0;

* 	do i = 1 to dim(plancodes) - 1;
* 		if not missing(plancodes[i]) 
* 			and not missing(plancodes[i+1]) 
* 			and plancodes[i] ne plancodes[i+1] then do;
* 		is_changed_plan = 1;
* 		leave;
* 	end;
* 	end;

* 	drop i months flag;
* run;

* title "Question 5. How many members were enolled in more than one plan? - Result";
* proc freq data=enroll_change_plan;
* 	tables is_changed_plan;
* run;
* title;

* /* Answer for question 5: there are 233017 members have more than one plan enrollment. 
* Takes 4.79% of the whole population. */


/* Question 5 Update Dec 18: detect members with changed plancode but with few empty month without any plancode, previous
code cannnot detect this kind of pattern */

*Question 5. How many members were enolled in more than one plan?;

data enroll_change_plan;
	set star_enroll_all_22;
	array plancodes C2201-C2212;
	is_changed_plan = 0;
	length last_plan_nonNA $4;

	/* Added a tracker here */
	last_plan_nonNA = "";

	do i = 1 to dim(plancodes);
		if not missing(plancodes[i]) then do;
			if last_plan_nonNA = "" then last_plan_nonNA = plancodes[i];
			else if plancodes[i] ne last_plan_nonNA then do;
				is_changed_plan = 1;
			leave;
		end;
		last_plan_nonNA = plancodes[i];
		end;
	end;

	drop i months flag;
run;

title "Question 5. How many members were enolled in more than one plan? - Result";
proc freq data=enroll_change_plan;
	tables is_changed_plan;
run;
title;

/* Updated: Answer for question 5: there are 236732 members have more than one plan enrollment. 
Takes 4.87% of the whole population. */



/* update Dec 20, redo by thinking about the data structure */
data star_enroll_all_trans;
	set star_enroll_all_22;
	keep membno C2201-C2212;
run; 

proc transpose data=star_enroll_all_trans out=star_enroll_all_trans;
	by membno;
	var c2201-C2212;
run;

proc sql;
	create table plan_counts as 
	select membno,
		count(distinct col1) as distinct_plans
	from star_enroll_all_trans
	group by membno;
quit;

proc sql;
	select count(*) as member_with_more_than_one_plan
	from plan_counts
	where distinct_plans > 1;
quit;

/* 236732 members*/

proc freq data=plan_counts;
tables distinct_plans;
run;

data changed_plan_member;
	set plan_counts;
	where distinct_plans > 1;
	keep membno;
run;
/* Question 6: For those member enrolled in more than one plan, 
how many month were they enrolled in each plan? */

/* filter those with enrolled in more than one plan */
/*data changed_plan_members;*/
/*	set enroll_change_plan; */
/*	where is_changed_plan = 1;*/
/*run;*/
/**/
/*data plan_counts;*/
/*	set changed_plan_members;*/
/*	array plancodes C2201-C2212;*/
/*	array plan_counts(9) plan_1 plan_2 plan_3 */
/*						 plan_4 plan_5 plan_6 */
/*						 plan_7 plan_8 plan_9;*/
/*	length current_plan $10;*/
/*	retain current_plan;*/
/*	retain plan_index;*/
/*	*/
/*	/* use call missing, for all variables in array, set them to have missing values */*/
/*	call missing(of plan_counts[*]);*/
/*	current_plan = "";*/
/*	plan_index = 1;*/
/**/
/**/
/*	do i = 1 to dim(plancodes);*/
/*		if not missing(plancodes[i]) then do;*/
/*			if current_plan ne plancodes[i] then do;*/
/*				if plan_index <= 9 and current_plan ne "" then plan_index + 1;*/
/*				current_plan = plancodes[i];*/
/*			end;*/
/*		*/
/*		if plan_index <= 9then plan_counts[plan_index] + 1;*/
/*	end;*/
/*	end;*/
/*run;*/


/* We can see that the answer I provided cannot handle the situation 
when members change plans frequently, however, I dont have a solution
to handle this at this moment. */

/*proc print data=plan_counts;*/
/*where plan_9 = 3;*/
/*run;*/;
proc sql;
	create table chaned_plan_members as
	select a.*
	from star_enroll_all_trans as a
	inner join changed_plan_member as b
	on a.membno = b.membno;
quit;

proc sql;
	create table plan_enrollment_counts as
	select membno, col1 as plan, count(*) as months_enrolled
	from chaned_plan_members
	where plan ne ""
	group by membno, col1;
quit;

/* double check */
proc sql;
	select count(*) as TotalRow,
	count(distinct membno) as Unique_Members_Star
	from plan_enrollment_counts;
quit;




/* Question 7. for members enrolled more than one plan, 
identify first and last plan of enrollment */;

data first_last_plan;
	set changed_plan_members;
	array plancodes C2201-C2212;
	length first_plan $4 last_plan $4;

	first_plan = "";
	last_plan = "";

	do i = 1 to dim(plancodes);
		if not missing(plancodes[i]) then do;
		first_plan = plancodes[i];
		leave;
	end;
	end;

		do i = dim(plancodes) to 1 by -1;
		if not missing(plancodes[i]) then do;
		last_plan = plancodes[i];
		leave;
	end;
	end;

	drop i program;

run;

proc print data=first_last_plan (obs = 10);
	run;

















