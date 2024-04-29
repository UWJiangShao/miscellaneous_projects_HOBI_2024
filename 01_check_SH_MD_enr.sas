OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT nofmterr ;

%let program = P01;

libname SH "K:\TX-Data\Datasets\STARHEALTH";
libname MDD "K:\TX-Data\Datasets\Medicaid";

data sh_enr_22;
	set SH.starhealth_enr_nodual_cy2022 (keep=membno);
run;

data mdd_enr_22;
	set MDD.md_dental_enr_cy2022 (keep=membno);
run;

proc sort data=sh_enr_22 out=sh_enr_22_dedup nodupkey;
	by membno;
run;

proc sort data=mdd_enr_22 out=mdd_enr_22_dedup nodupkey;
	by membno;
run;

proc contents data=sh_enr_22_dedup;
run;

proc contents data=mdd_enr_22_dedup;
run;

proc sql;
	select count (distinct sh_enr_22_dedup.membno) as STAR_Health_22
	from sh_enr_22_dedup;
quit;

proc sql;
	select count (distinct sh_enr_22_dedup.membno) as common_member
	from sh_enr_22_dedup
	inner join mdd_enr_22_dedup on sh_enr_22_dedup.membno = mdd_enr_22_dedup.membno;
quit;

/*-Double check using data step-*/

data merged;
	merge sh_enr_22_dedup(in=inSH) mdd_enr_22_dedup(in=inMD);
	by membno;
	if inSH and inMD;
run;

proc contents data=merged;
run;