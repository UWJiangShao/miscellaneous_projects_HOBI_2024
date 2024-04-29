/*Program name: NPI and TPI derivation and rate calculation  */
/*Author:       jiang.shao@ufl.edu  */
/*Huge Thank to Siyu !!!!!!      */
/*Date:         June 14, 2023 */
/*read data - encounter visiting version 2021*/
libname in "K:\TX-Data\Datasets\temp\encv21";
libname out "K:\TX-Data\PPE_calculations\SFY Hospital level PPE\SFY2023_midyear\Checking on TPI";

data enc_2023;
	set in.all_finalimage_2021_2023;
	where "202301" <= month_id<="202312";
run;

proc freq data=enc_2023;
	tables month_id;
run;

proc contents data=enc_2023;
run;

/* Check if location at Texas, there are about 5% out-of-state*/
proc freq data = enc_2023;
	tables HP_SVCFAC_ST;
run;

data enc_2023;
	set enc_2023;
	where HP_SVCFAC_ST = "TX";
run;

proc sort data=enc_2023 out=enc_2023_dup nodupkey;
	by H_MBR_PRMRY_MBR_ID_NO hs_orig_icn;
run;

*clean member id;
*if compress(membno,'0') eq ' ' or length(membno) ne 9 or diagn1 eq ' ' then delete;
data enc_2023_dup_hopinp(rename=(HP_BLNG_PRV_NTNL_PRV_ID=b_npi));
	set enc_2023_dup;

	if compress(H_MBR_PRMRY_MBR_ID_NO,'0') eq ' ' or length(H_MBR_PRMRY_MBR_ID_NO) ne 9 then
		delete;
	where H_TXN_TYP eq 'I' and H_TYP_OF_BILL in: ('11','12','41');
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

proc sort data= enc_2023_dup_hopinp;
	by b_npi;
run;

data enc_2023_hopinp;
	merge enc_2023_dup_hopinp(in=in1) npi(in=in2);
	by b_npi;

	if in1 and in2;
run;



/* work with ZIPcode check*/
/* all of them follows 9 digits zipcode, no empty entry*/

proc freq data=enc_2023_hopinp;
	tables hp_svcfac_zip_cd / nocol norow list ;
run;

/* now we check how many of them have invalid last four area code*/
data zipcode;
	set enc_2023_hopinp;
	tail_four=substr(hp_svcfac_zip_cd,6,4);

	if tail_four='0000' or tail_four='9999' then
		if_valid='n';
	else if_valid='y';
run;

proc freq data=zipcode;
	tables if_valid;
run;
title 'Zipcode check';


*output data;
data out.full_hops_inp_2023;
	set enc_2023_dup_hopinp;
run;

data out.active_npi_2023;
	set enc_2023_hopinp;
run;

/* about 150000*/
proc contents data=out.full_hops_inp_2023;
run;
title '2023 Encounter in TX';

/* about 135000*/
proc contents data=out.active_npi_2023;
run;













/*proc sql;*/
/*select count(*) as num_rows*/
/*from work.enc_2023;*/
/*quit;*/
/*title 'number of data entry of the encounter 2023';*/
/*DATA WORK.encv21_new;*/
/*	SET 'K:\TX-Data\Datasets\temp\encv21\all_fullhistory_2021_2023.sas7bdat';*/
/*RUN;*/
/* Get the inpatient hospital data, and then*/
/* de-duplicate by patients' member id and claim id*/
/*PROC SORT data = work.enc_2023 out = in.encv23_nondup nodupkey;*/
/*	BY H_MBR_PRMRY_MBR_ID_NO claim_id;*/
/*RUN;*/
/* Subset the dataset to Year 2023 only */
/*DATA WORK.encv23;*/
/*	SET WORK.encv21_new_nondup;*/
/*	WHERE year = 2023;*/
/*RUN;*/
/* Subset the new datasets with billing NPI belongs to the active NPI */
/*DATA WORK.encv23;*/
/*	SET WORK.encv21_new_nondup;*/
/*	WHERE year = 2023;*/
/*RUN;*/
/* Check the zipcode, report cases with missing or invalid last four digits */
/*DATA WORK.zipcode_encv23;*/
/*	SET WORK.encv23;*/
/*	zipcode_last_four = SUBSTR(zipcode_in_dataset, 6, 4);*/
/**/
/*	if zipcode_last_four IN ('0000', '9999', 'xxxx', 'XXXX') then*/
/*		do;*/
/*			invalid_zipcode = 1;*/
/*		end;*/
/*	else*/
/*		do;*/
/*			invalid_zipcode = 0;*/
/*		end;*/
/*run;*/
/**/
/*proc freq data== work.zipcode_encv23;*/
/*	table year * invalid_zipcode;*/
/*		where invalid_zipcode = 1;*/
/*run;*/

