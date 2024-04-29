/*Program name: FFS PPE */
/*Author:       jiang.shao@ufl.edu  */
/*Huge Thank to Siyu !!!!!!      */
/*Date:         June 15, 2023 */
/*read data - encounter visiting version 2021*/
libname inFFS "K:\TX-Data\Datasets\FFS";
libname outFFS "K:\TX-Data\PPE_calculations\SFY Hospital level PPE\SFY2023_midyear\Checking on TPI\FFS";

data ffs2023;
	set inFFS.ffs_enc_cy2023;
run;

proc contents data=ffs2023;
run;

/* 2128174 observations with duplicate key values were deleted */
proc sort data=ffs2023 out = ffs2023_dup nodupkey;
	by membno clmno;
run;

data ffs2023_dup_hopinp;
	set ffs2023_dup;
	if compress(membno,'0') eq ' ' or length(membno) ne 9 then
		delete;
	where transtype eq 'I' and typbill in: ('11','12','41');
run;

*output data;
data outFFS.ffs_2023_dedup;
	set ffs2023_dup_hopinp;
run;






*subset bnpi from active npi;
* crosswalk TPI to NPI using the HHSC crosswalk, use SFY2022 crosswalk;
options validvarname=V7;

**This allow sas to change the variables with space to standard SAS name convention;
proc import datafile="K:\TX-Data\PPE_calculations\Resources\TPI-NPI crosswalk\NPI_TPI Crosswalk_FY22_042023_v2.xlsx" 
	out=TPI(keep=active_npi) dbms=xlsx replace;
run;

options validvarname=ANY;

**This allow sas to change name convention to ANY;
data TPI2;
	set TPI;
	length bprovno $9 b_NPI $10 Organization_Name $150.;
	array t[*] Active_TPI Related_TPI_1 - Related_TPI_39;

	do i=1 to dim(t);
		if t[i] not in (' ' 'N/A' 'n/a' 'NA') then
			do;
				bprovno=t[i];
				Organization_Name=Provider_Name;
				b_NPI=Active_NPI;
				output;
			end;
	end;

	keep bprovno b_NPI Organization_Name;
run;

* For TPIs that cannot be found in the previous crosswalk, use the TMHP crosswalk;
proc import out=TPI_outp dbms=xls replace
	datafile="K:\TX-Data\PPE_calculations\Resources\TPI-NPI crosswalk\archive\Part 1 Providers Results.xls";
	sheet="Outpatient Providers";
run;

data TPI_outp(keep=bprovno Organization_Name b_npi);
	set TPI_outp;
	length Organization_Name $150. bprovno $9;
	Organization_Name=TMHP_NM;
	bprovno=TPI;
	rename TMHP_NPI=b_npi;
run;

* make a combined TPI-NPI crosswalk that contains both DSRIP and TMHP supplied information;
proc sort data=TPI2 nodupkey;
	by bprovno;
run;

proc sort data=TPI_outp nodupkey;
	by bprovno;
run;

data Master_TPI_NPI;
	update TPI_outp TPI2;
	by bprovno;
run;

* If a hospital does not have NPI, use its TPI as NPI;
data ppc_TMHP_TPI_NPI;
	set Master_TPI_NPI;

	if b_NPI eq ' ' then
		b_NPI=bprovno;
run;

* assign organization name to NPIs;
proc sort data=ppc_tmhp_tpi_npi(drop=bprovno) nodupkey out=NPI;
	by b_npi;
run;


proc sort data= ffs2023_dup_hopinp;
	by b_npi;
run;

data ffs2023_hopinp;
	merge ffs2023_dup_hopinp(in=in1) npi(in=in2);
	by b_npi;

	if in1 and in2;
run;

proc print data = ffs2023_hopinp (obs = 10);
run;


data outFFS.active_FFS_2023;
	set ffs2023_hopinp;
run;

/* work with TPI rate check*/
proc freq data=outFFS.active_FFS_2023;
	tables bprovno / nocol norow list ;
run;


data FFS_tpi;
	set outFFS.active_FFS_2023;
	if bprovno = '' or bprovno = '999999999' or bprovno = '000000000' then
		if_valid='n';
	else if_valid='y';
run;

proc freq data=FFS_tpi;
	tables if_valid;
run;
title 'TPI rate check';




