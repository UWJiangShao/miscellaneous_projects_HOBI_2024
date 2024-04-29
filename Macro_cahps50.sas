%let Version     = 5.0 ;
*--------------------------------------------------------------------------*
| Department of Health Care Policy - Harvard Medical School - Boston, MA   |
|--------------------------------------------------------------------------|
| File Name      = Macro_cahps50.sas                                       |
| Path or URL    = /data/cahps/                                            |
| Version        = 5.0                                                     |
| Creation Date  = 05 Aug 2008                                             |
| Modified Date  = 3 April 2018                                             |
| Author         = Matthew J. Cioffi, Alan M. Zaslavsky and Kayo Walsh     |
| Affiliation    = HCP                                                     |
| Category       = CAHPS Macro                                             |
| Keys           =                                                         |
|--------------------------------------------------------------------------|
| Brief Description: (1-2 sentences)                                       |
|--------------------------------------------------------------------------|
|   This macro is designed to accompany the CAHPS Survey and Reporting Kit.|
|The macro tests for significant differences between plan means and also   |
|provide case-mix adjustments and weighting of the means.                  |
*--------------------------------------------------------------------------*;

*--------------------------------------------------------------------------*
| Update Information: Repeat below fields for each update                  |
|--------------------------------------------------------------------------|
| Modified Date  = 18 Jul 2006                                             |
| By Whom        = Matthew J. Cioffi                                       |
| Reason:                                                                  |
|  Modified formula for case where SE may be missing to set T=0 in that    |
|case. Also VO can now have a zero denominator, in the case where there is |
|only one unit being analyized, modified code to catch that error.         |
*--------------------------------------------------------------------------*
| Modified Date  = 04 Jun 2007                                             |
| By Whom        = Matthew J. Cioffi                                       |
| Reason:                                                                  |
|  When using wgtdata=2 for strat combininations get an error that _WGTDATA|
|not found. Make change in code to carry variable when using strata. Change|
|made in data wstemp ( keep = plan... line                                 |
*--------------------------------------------------------------------------*
| Modified Date  = 04 Feb 2009                                             |
| By Whom        = Kayo Walsh                                              |
| Reason:                                                                  |
| Due to a lack of sample size and respondents for some plans, a new       |
| adjusted plan mean vp, smoothing variance was created.                   |
| A new parameter is added to the macro call for smoothing variances.      |                                                                        |
|   smoothing:       is the value to use either a single item or           |
|                    composites items. The default is 0.                   |
*--------------------------------------------------------------------------*
| Modified Date  = 21 Apr 2009                                             |
| By Whom        = Kayo Walsh                                              |
| Reason:                                                                  |
| The calculation of weights for the composite items was modified(in usable|
| macro). The sum of weights based on the number of responses from each    |
| item is used as the weights of the composite case.                       |
*--------------------------------------------------------------------------*
| Modified Date  = 26 May 2009                                             |
| By Whom        = Kayo Walsh                                              |
| Reason:                                                                  |
| One part of creating plandtal data set was modified (in usable macro).   |
| It affects for suset = 3 case.                                           |
*--------------------------------------------------------------------------*
| Modified Date  = 25 Jun 2009                                             |
| By Whom        = Kayo Walsh                                              |
| Reason:                                                                  |
| 'WARNING' note was added for case when a plan does not have any value in |
| one (or more) of composite items.  It appears on the output text file.   |
*--------------------------------------------------------------------------*
| Modified Date  = 13 Jan 2010                                             |
| By Whom        = Kayo Walsh                                              |
| Reason:                                                                  |
| T statistic was modified (in star macro). A weighting factor was not     |
| placed correctly for computing variance of the difference of two plan    |
| means.                                                                   |
*--------------------------------------------------------------------------*
| Modified Date  = 06 Apl 2011                                             |
| By Whom        = Kayo Walsh                                              |
| Reason:                                                                  |
| Proc standard was replaced with proc stdize. Proc stdize can handle the  |
| case correctly when values of a case mix adjuster are all the same within|
| a plan.                                                                  |
*--------------------------------------------------------------------------*
| Modified Date  = 22 Jun 2011                                             |
| By Whom        = Kayo Walsh                                              |
| Reason:                                                                  |
| A macro option for handling composites when even_wgt = 1 was modified.   |
| This will provide a way of downweighting on some items with few or zero  |
| responses appear in the composites.                                      |
|                                                                          |
*--------------------------------------------------------------------------*
| Modified Date  = 28 Mar 2012                                             |
| By Whom        = Kayo Walsh                                              |
| Reason:                                                                  |
| A mean score of composite case for even_wgt = 1 was modified. This will  |
| provide composite weights for only usable plans. As a result, the final  |
| mean score will have correct weights. %item_wgt, %usable, %preptest,     |
| %pct_resp and %std_data were modified.                                   |
*--------------------------------------------------------------------------*
| Modified Date  = 21 Novermber 2016                                       |
| By Whom        = Kayo Walsh                                              |
| Reason:                                                                  |
| Computing weighted residuals was modified. This affects the calculating a|  
| %std_data and %preptest were modified.                                   |
*--------------------------------------------------------------------------*
| Modified Date  = 10 February 2017                                        |
| By Whom        = Kayo Walsh                                              |
| Reason:                                                                  |
| PROC SURVEYREG option was added in %casemix. A new parameter, &proc_type |
| was implemeted to distinguish to select eith PROC REG or PROC SURVEYREG. |
*--------------------------------------------------------------------------*
| Modified Date  = 2 March 2017                                            |
| By Whom        = Kayo Walsh                                              |
| Reason:                                                                  |
| A new weight option (WT_TYPE) for calculating of casemix regression      | 
| coefficients was implemented in %casemix.                                |
|                                                                          | 
| A type of weights for calculating the overall mean was implemented       |
|(OVERALL_WT).                                                             |
|                                                                          | 
| The default value of suppressing results of regression models            |  
|(OUTREGRE) was modified to be 1 instead of 0.                             |
|                                                                          |
| A VARDEF option was added to PROC MEANS. This calculates the weighted    | 
| standard deviation correctly.                                            |
|                                                                          |
| The output of the casemix regression coefficients file(C_&OUTNAME) was   |
| updated. The new output contains the standard errors and the p-values    |
| along with the casemix estimates.                                        | 
|                                                                          |
*--------------------------------------------------------------------------*
| Modified Date  = 2 February 2018                                         |
| By Whom        = Kayo Walsh                                              |
| Reason:                                                                  |
| A composite calculation was modified.  Each overall mean of the items    |
| gets computed first before combining the composite mean. This is done in | 
| the star macro program.                                                  |
*--------------------------------------------------------------------------*
| Modified Date  = 25 May 2018                                             |
| By Whom        = Kayo Walsh                                              |
| Reason:                                                                  |
| A composite calculation without casemix addjusted was modified. Also,    |  
| codes for subset options for composite cases are modified.               |
*--------------------------------------------------------------------------*;

*--------------------------------------------------------------------------*
| Full Description:                                                        |
|--------------------------------------------------------------------------|
   This macro is designed to accompany the CAHPS Survey and Reporting Kit.
The macro tests for significant differences between plan means on
individual questionnaire items and also for composites of more than one
questionnaire items either with or without case-mix adjustments.

   The starting point for the code of this macro is from the version 3.6
of the CAHPS macro, created 15 Feb 2004 and last modified 25 May 2018.

CHANGES MADE IN CREATING VERSION 5.0

This update to the CAHPS macro corrects an error in the previous version, which 
failed to take differential weighting at the individual level into account in 
variance estimation. The modification impacted on calculation of vp.  

New weights for calculating of casemix regression coefficients were implemented.  
One option (&wt_type = 1) is used when primary objective is comparison among units of 
equal importance.  The other option (&wt_type = 2) is used when population-weighted 
regression coefficients are of interst. The default is &wt_type = 0, which is used 
when responding sample size for units vary greatly.     

Overall mean weight option was implemented to the macro program.  
By selecting &overall_wt = 1, the overall mean is calculated with equal weight by unit. 
&overall_wt = 2 uses the sum of population weights and &overall_wt = 0 uses the number of 
respondents as the overall mean weight.
  
The default value of suppressing results from regression models (&outregre option) is updated. 
The default is now 1 instead of 0.

VARDEF option is added to PROC MEANS to compute the weighted standard deviation for 
the overall means correctly. 

PROC SURVEYREG was implemented to the regression section.  There are two options to run 
the regression: PROC REG and PROC SURVEYREG. The SURVEYREG procedure can handle survey 
sample data including with stratification, clustering and unequal weighting and the procedure 
will provide appropriate standard error of the coefficients.  Proc_type = 1 indicates  
PROC SURVEYREG and Proc_type = 0 indicates PROC REG to run the model.  

An output dataset for coefficients (c_&outname) now contains standard errors and p-values 
besides the estimates. 

A composite calculation was modified.  Each overall mean of the items gets computed first 
before combining the composite mean. This code was done in the star macro program. 

A macro option, smoothing variable needs to be updated. This is still in progress.

CHANGES MADE IN CREATING VERSION 4.0 and 4.1

This version contians a new plan mean variance called a smoothing variance. 
Users can assign an optimal wieght on the varaiance in the smoothing 
parameter.  A new warning note was added in the macro output. If a plan contains
a zero response in one or more of the composite items, the warning note will be 
on the output.  

There are several modifications in this version. A plandtal work dataset (in 
usable macro) was modified due to the output issue when subset = 3.  The original
 subcode ID was kept in plandtal work dataset so that each subset can provide its 
result correctly. 

Computing of weights for composite items was corrected. Only a weight of the first item 
was used before.  The part was modified so that all weights of all items are added.

A way of handling even weights for composites was modified. Users can assign the least 
responses in each item, called K.  The weights can be assigned differently in each item
depending on the value k.  

In star macro, calculation of the variance of the difference between a plan mean 
and the oveall mean was modified.  The weighting factor part was not coded correctly 
before. 

proc standard was replaced with proc stdize due to the incorrect computation of adjuster mean
by plan. This occured when an adjuster contains the same values in a plan.

   CHANGES MADE IN CREATING VERSION 3.6
This new version corrects an error in some previous versions affecting
calculation of the variances for the comparison of a plan mean to the
mean of all other plan means, when the plans were weighted.  This error
only affects analyses with parameter wgtplan=1 using CAHPS macro versions
3.4b and 3.5.  By default, the macro sets wgtplan=0 so the error does not
affect unweighted plan analysis.  The affected macro versions 3.4b was
released on 05 May 2003 and 3.5 was released on 17 Feb 2004. The error
caused significance tests to be calculated incorrectly when determining
whether a plans mean was significantly above or below the average.  This
could cause some plans to be declared 1- or 3-star plans when they were
respectively below or above average, but not by a statistically
significant amount.

Modified formula for special case of using only one plan unit and a
division by zero error may occur.  This case used to work in prior
versions. Modified code for checking if SE may be missing to set T=0
in that case. Also VO can now have a zero denominator, in the case
where there is only one unit being analyzed, modified code to catch
that error.


*--------------------------------------------------------------------------*
| DISCLAIMER:                                                              |
|--------------------------------------------------------------------------|
   The information contained within this file, the CAHPS SAS macro, is
provided "AS IS " by the Department of Health Care Policy (HCP), Harvard
Medical School, under the multi-year CAHPS grant sponserd by the Agency for
Healthcare Research and Quality (AHRQ) and the Centers for Medicare and
Medicaid Services (CMS) which are part of the U.S. Department of Health and
Human Services (HHS)as a service to CAHPS-Survey Users Network to provide a
common analysis program that can be used to analyze and case-mix adjust
data from CAHPS surveys. There are no warranties, expressed or implied, as
to the merchantability or fitness for a particular purpose regarding the
accuracy of the materials or programming code contained herein. This macro
may be distributed freely as long as all comments, headers and related
files are included.

   Copyright (C) 2018 by The Department of Health Care Policy, Harvard
Medical School, Boston, MA, USA. All rights reserved.
*--------------------------------------------------------------------------*;

*--------------------------------------------------------------------------*
| Insructions:                                                             |
|--------------------------------------------------------------------------|
/*
USAGE:
------
   Not all the parameters need to be listed in the macro call if the
default values will be used.  See input parameter list below.

       
%macro cahps(var          =  ,
             vartype      =  ,
             recode       =  ,
             min_resp     =  ,
             max_resp     =  ,
             name         =  ,
             adjuster     =  ,
             adj_bars     =  ,
             bar_stat     =  ,
             impute       =  ,
             even_wgt     =  ,
	         k            =  ,
             kp_resid     =  ,
             adultkid     =  ,
             visits       =  ,
             pvalue       =  ,
             change       =  ,
             meandiff     =  ,
             wgtdata      =  ,
             wgtresp      =  ,
             wgtmean      =  ,
             wgtplan      =  ,
             id_resp      =  ,
             subset       =  ,
             splitflg     =  , 
             smoothing    =  , /*This is in progress. (4/3/2018)*/
             dataset      =  ,
             outregre     =  ,
             outname      =  ,
             proc_type    =  ,
	         overall_wt   =  ,
	         wt_type      =   ) ;



 */
/*

INPUT PARAMETERS:
-----------------
   var           = list of variable names included in the composite or
                   single item measure,

   vartype       = select 1, 2, 3, 4 or 5

                   1 - Dichotomous (yes/no scale 0-1 response options)
                   2 - Rating Scale (0-10 response options)
                   3 - How Often (1-4 response options)
                   4 - Trichotomous (problem scale 1-3 response options),
                   5 - Other Scale (min_resp and max_resp must be assigned value)

   recode       =  select 0, 1, 2, or 3 (not needed in CAHPS macro call if = 0)
                   Default Value = 0

                   0 - For the statistical tests, use the original response
                       categories of the variables in the &var parameter.

                       For the "Percent of each response" table and report
                       split the "Rating" scale into three categories with the
                       following break points, 0-6|7-8|9-10 or 1-2|3|4 for the
                       "How Often" scale.

                   1 - For the statistical tests recode the Rating scale (0-10),
                       if &vartype = 2 or the "How Often" scale (1-4) if
                       &vartype = 3 as follows:

                        Rating Scale             How Often
                           0 - 6 = 1             1 - 2 = 1
                           7 - 8 = 2                 3 = 2
                           9 -10 = 3                 4 = 3

                       If &vartype is not equal to 2 or 3, then no recoding
                       occurs for the statistical tests

                       For the "Percent of each response" table and report
                       split the "Rating" scale into three categories with the
                       following break points, 0-6|7-8|9-10 or 1-2|3|4 for the
                       "How Often" scale.

                   2 - For the statistical tests, use the original response
                       categories of the variables in the &var parameter.

                       For the "Percent of each response" table and report
                       split the "Rating" scale into three categories with the
                       following break points, 0-7|8-9|10 or 1-2|3|4 for the
                       "How Often" scale.

                   3 - For the statistical tests recode the Rating scale (0-10),
                       if &vartype = 2 or the "How Often" scale (1-4) if
                       &vartype = 3 as follows:

                        Rating Scale             How Often
                           0 - 7 = 1             1 - 2 = 1
                           8 - 9 = 2                 3 = 2
                              10 = 3                 4 = 3

                       If &vartype is not equal to 2 or 3, then no recoding
                       occurs for the statistical tests

                       For the "Percent of each response" table and report
                       split the "Rating" scale into three categories with the
                       following break points, 0-7|8-9|10 or 1-2|3|4 for the
                       "How Often" scale.
                 
   min_resp     =  the minimum response value for the variables.  For the vartypes
                   1, 2, 3, and 4, the min_resp = 0, 0, 1, and 1 respectively.
                   If vartype = 1-4 then there is no need to enter a value for
                   the min_resp parameter, (i.e. may be left out of CAHPS
                   macro call). A vartype = 5 allows the min_resp values
                   to be any value.

   max_resp     =  the maximum response value for the variables.  For the vartypes
                   1, 2, 3, and 4, the max_resp = 1, 10, 4, and 3 respectively.
                   If vartype = 1-4 then there is no need to enter a value for
                   the max_resp parameter, (i.e. may be left out of CAHPS
                   macro call).  A vartype = 5 allows the max_resp values
                   to be any value.

   name         =  detailed name of composite, summary scale
                   or yes/no scale of var argument above,

   adjuster     =  name(s) of adjuster variable(s),

   adj_bars     =  select 0 or 1
                   Default Value = 0

                   0 - do not case mix adjust the triple stacked bars,
                   1 - case mix the triple stacked bars and store the adjusted
                       frequencies along with the unadjusted frequencies.

   bar_stat     =  select 0 or 1
                   Default Value = 0

                   0 - do not case save the statistical results in a data set for
                       the case-mix adjusted triple stacked frequency bars.
                   1 - save the case-mix adjusted statistical results in a permanent
                       data set for  the triple stacked frequency bars.

   impute       =  select 0 or 1
                   Default Value = 0

                   0 - do not impute mean values by plan for EACH of the adjuster variables
                   1 - impute mean value by plan for EACH of the adjuster variables, 

   even_wgt     =  select 0, 1 or 2.
                   Default Value = 1

                   0 - Weight by overall number of respondents for each item 
                   1 - Use even weighting for composites (1 / # of Items)
                   2 - Sum of the weight by the respondents for each item

   k            =  The number >= 0 assign a target minimum response size for equal weighting 
                   for composites (even_wgt = 1) - the default value is 1. 

   kp_resid     =  select 0 or 1.
                   Default Value = 0

                   0 - Do NOT save the residual response values
                   1 - Save the residual response values

                   This flag is used to make the residual values permanent
                   from the SAS work data set RES_4_ID in the STD_DATA module.

   adultkid     =  select  0, 1, 2 or 3

                   0 - no child interactions
                   1 - combine children and adults
                   2 - children only
                   3 - adults only,

   visits       =  select 1, 2 or 3
                   Default Value = 1

                   1 - combine low and high users
                   2 - low users only (< 3 visits per 12 mos)
                   3 - high users only (>= 3 visits per 12 mos),

   pvalue       =  selected p-value for contrast (recommend 0.05)
                   Default Value = 0.05,

   change       =  substantively meaningful difference (# >= 0)
                   Default Value = 0,

   meandiff     =  absolute difference (adjusted mean-overall mean) (# >= 0)
                   Default Value = 0,

   wgtdata      =  select 1 or 2
                   Default Value = 1

                   1 - Keep data stratafied - no weighting performed
                   2 - Weight strata - weighting performed,

   wgtresp      =  Either leave blank if no response level weighting is desired or
                   set it to the variable name in the dataset.  This will be used
                   in the regression when doing casemix adjustments.

   wgtmean      =  Leave blank if no mean or plan level weighting is desired.
                   If weighting of the mean or plan mean comparisons is desired,
                   set to the variable name in the dataset that contains the
                   weights to be used for weighting the unadjusted plan mean
                   scores and plan mean comparisons.  If a variable exists for
                   this parameter then the weight, at the individual record level,
                   will be used to compute the weighted, unadjusted plan means.
                   In addition, if the parameter wgtplan = 1, then the sum of the
                   individual weights to the plan level will be used in weighting
                   the plan mean comparisons.

   wgtplan      =  select 0 or 1
                   Default Value = 0

                   0 - Do not use the plan weights when computing the overall
                       mean for the comparison of plan means.  Equal weighting
                       will be used as in previous versions of the macro.
                   1 - Use the summof the weights to the plan level of the
                       variable specified in the parameter wgtmean. This weight
                       is used for weighting the overall and grand means used in
                       the statistical comparisons of the plan means.

   id_resp      =  If there is unique variable in the data set that identifies each
                   individual respondent, then enter the variable name in this
                   parameter.  The macro will carry it through the individual data
                   sets and attach it to the residual data set if kp_resid = 1.  If
                   no id variable is entered her, then the id_resp variable will be
                   'Z'.  The variable will be character and have a maximum of 50
                   characters

   subset       =  select 1, 2 or 3
                   Default Value = 1

                   1 - No subsetting, global case mix model and centering
                   2 - Global case mix model with centered means for subsets
                   3 - Subset case mix model

                   The subset code will be a part of the plan ascii data file
                   that will include the original plan name, the new plan name
                   for the stratification weighting, the stratification weight
                   and the subsetting code.

                   A filename PLAN_DAT needs to refer to the ascii data file
                   that is used by wgtdata and subset.

   splitflg     =  Select either 0 or 1.
                   Default value = 0.
                   If this flag is set to 0 then the macro will run the dataset
                   as usual with every plan getting centered to the same mean and
                   the case mix being run once.  If the flag is set to 1 then the
                   data set must contain the variable  SPLIT and the values of this
                   variable in the data set must be 0 for one set, (i.e. Managed Care)
                   and 1 for the other, (i.e. Fee for Service).  If there are any
                   missing values for this variable, then these records will be dropped
                   from the analysis.
  
  /************************************************************************************/

  /*****This parameter is in progress(5/16/2017)***************************************/
   smoothing    =  Assign weight for pooled variance estimate in smoothing variances - 
                   the default value is 0.  
  /************************************************************************************/               

   dataset      =  SAS data set name (in file),

   outregre     =  Select either 0 or 1.
                   Default value = 1 (replaced with 0 (3/3/2017)).

                   If set to 0, then the SAS printed output from the regressions in
                   the case mix procedure will not be printed out into the output
                   file.  If set to 1, then the regression output will appear.

   outname      =  Part of SAS data set name (where the maximum length is
                   5 characters). This option creates datasets of the output
                   tables (which aid in the generation of an excel spreadsheet)
                   The user must specify a libname statement in their program
                   where libref = out

   proc_type    =  Select 0 or 1. Assign the procedure type for the casemix regression. 

                   0 - PROC REG is assined to run the casemix regression
                   1 - PROC SURVEYREG is assigned to run the casemix regression

                   Defaulat value = 0, which PROC REG is used. Is set to 1, the resggion 
                   is run under PROC SUREYREG.

   wt_type      =  Weight options for calculating of casemix regression coefficients,
                   Default value is 0.

                   0 - Number of respondents
                   1 - Equal by unit
                   2 - Population: sum of case weights

   overall_wt   =  Weight options for calculating of overall mean,
                   Default value is 2.

                   0 - Number of respondents
                   1 - Equal by unit
                   2 - Population: sum of case weights



GLOBAL VARIABLES:
-----------------
   _numadj  = number of adjuster variables
   _numitem = number of items in the parameter &var
   _numnpln = number of health plans (strata collapsed)
   _numopln = number of health plans (stratified)
   _num_sub = number of subsets in plan detail file
   _numstra = maximum number of stratification levels
   _num_val = number of unique response values in an item
   _now     = current system date and time, used in reports


OUTPUT CREATED:
---------------
   REPORTS CREATED (Not Data Sets):
      Percent Items Missing by Plan
      Percent of each Response
      Regression Coefficients
      Overall Statistics by Plan
      Star Ratings by Plan

   SAS DATA SETS:
   &outname in the following data set names should be replaced with the
   value given to outname in the macro call.

      DP&outname - List of plans dropped by macro due to only 0 or 1 record.
      P_&outname - Percent Items Missing by plan
      PW&outname - % item missing for unstratifed data (wgtdata = 2)
      N_&outname - Percent of each response
                   (Overall Rating Scale Aggregated to 0-6|7-8|9-10 or
                    0-7|8-9|10 depending on RECODE parameter setting,
                    default is 0-6|7-8|9-10.
                    How Often Scale Aggregated to 1-2, 3, 4)
      NW&outname - % each response for unstratified data (wgtdata = 2)
      C_&outname - Regression Coefficients for items by adjuster
      R2&outname - R-squared values for the dependent variables
      Y_&outname - The response value residuals (kp_resid = 1)
      OA&outname - Overall statistics for all plans all responses
      SA&outname - Star rating details for all plans all responses
      OW&outname - Overall statistics for unstratified data (wgtdata = 2)
      SW&outname - Star Rating details for unstratified data (wgtdata = 2)

      F1&outname - Overall statistics for all plans for first bar/frequency
      B1&outname - Star rating details for all plans for first bar/frequency
      F2&outname - Overall statistics for all plans for second bar/frequency
      B2&outname - Star rating details for all plans for second bar/frequency
      F3&outname - Overall statistics for all plans for third bar/frequency
      B3&outname - Star rating details for all plans for third bar/frequency
      FA&outname - Overall statistics for unstratified data (wgtdata = 2)
                   for first bar/frequency
      BA&outname - Star rating details for unstratified data (wgtdata = 2)
                   for first bar/frequency
      FB&outname - Overall statistics for unstratified data (wgtdata = 2)
                   for second bar/frequency
      BB&outname - Star rating details for unstratified data (wgtdata = 2)
                   for second bar/frequency
      FC&outname - Overall statistics for unstratified data (wgtdata = 2)
                   for third bar/frequency
      BC&outname - Star rating details for unstratified data (wgtdata = 2)
                   for third bar/frequency
*/

%*-------------------------------------------------------------------------*
| ************************************************************************ |
|  ****   Begin the listing of Subroutines used by the CAHPS macro.  ****  |
| ************************************************************************ |
*--------------------------------------------------------------------------* ;

/*
SubName   :  chkparam
Created   :  28-May-2003
Author    :  Matthew J. Cioffi
Purpose   :
   Check the list of parameters to make sure critical values exist or make
   sense.  If something is wrong eithier stop macro or take other
   appropriate action.

---------------------------------------------------------------------------
Updated   :  dd-mmm-yyyy
by Whom   :
Reason    :

---------------------------------------------------------------------------
*/

%macro chkparam () ;

   %put  -------------------------------  ;
   %put    Entering CHKPARAM Macro  ;
   %put  -------------------------------  ;
   %put  ---------------------------------------------------------------  ;
   %put    Checking values from the Parameter List. ;
   %put  ---------------------------------------------------------------  ;

   %global _okparam ;
   %local
   ;
   %let _okparam = 1 ;

%*-------------------------------------------------------------------------*
|  Check to see if the DATASET parameter is set, and if it is set, see if  |
|  the data set physically exists.                                         |
*--------------------------------------------------------------------------* ;
   %let _dsid   = %sysfunc ( open ( &dataset, i )) ;
   %let _rc     = %sysfunc ( close ( &_dsid )) ;

   %if &dataset = %then %do ;
         %put  ;
         %put  ;
         %put  CAHPS-MACRO-ERROR: ;
         %put  -----------------------------------------------------------------  ;
         %put  *****************************************************************  ;
         %put  *****************************************************************  ;
         %put  *****************************************************************  ;
         %put  ;
         %put    DATASET Parameter is Empty, Please check Macro Call parameter    ;
         %put    settings.  There may be a syntax error, such as a missing comma, ;
         %put    or the DATASET parameter may be missing.                         ;
         %put  ;
         %put    EXITING CAHPS MACRO ;
         %put  *****************************************************************  ;
         %put  *****************************************************************  ;
         %put  *****************************************************************  ;
         %put  -----------------------------------------------------------------  ;
         %put  ;
         %put  ;

         %let _okparam = 0 ;
      %end ;
   %else %if &_dsid = 0 %then %do ;
         %put  ;
         %put  ;
         %put  CAHPS-MACRO-ERROR: ;
         %put  -----------------------------------------------------------------  ;
         %put  *****************************************************************  ;
         %put  *****************************************************************  ;
         %put  *****************************************************************  ;
         %put  ;
         %put    &dataset DATASET, refered to in the DATASET Parameter            ;
         %put    DOES NOT EXIST.  Please make sure data set referenced in         ;
         %put    the DATASET parameter physically exists.                         ;
         %put  ;
         %put    EXITING CAHPS MACRO ;
         %put  *****************************************************************  ;
         %put  *****************************************************************  ;
         %put  *****************************************************************  ;
         %put  -----------------------------------------------------------------  ;
         %put  ;
         %put  ;

         %let _okparam = 0 ;
   %end ;

%mend chkparam ;


*--------------------------------------------------------------------------*;
%let Sb01Name    = make_fmt ;
%let Sb01Crea    = 23-July-1998 ;

***********
* Purpose *
   Create a data set and a format that has sequential values begining at
   1 up to the maximum unique number of labels for the format label passed
   in.  This subroutine is used by the plandtal.sas macro subroutine.

Usage      :  Syntax for use and/or examples
Input      :  Input parameters

   fmt_name = The name of the format and the name of the data set used
              to create the format.

   fmtlabel = The 'meaningful value' that will be the label for the
              sequential value.

   dataset  = The name of the data set that contains the variable that
              needs a sequential value.

   max_name = The name for the global variable that stores the maximum
              number for the labels being coded.

Output     :  Output returned from module

   1 - A data set with the name given by the parameter fmt_name.
   2 - A format with the name given by the parameter fmt_name.
   3 - A gloabl variable with the name given by the parameter max_num.

Limits     :  Note any known limitations

*--------------------------------------------------------------------------*;
%let Sb01Upd = dd-mmm-yyyy ;
%let Sb01By  = ;
**********
* Reason *

*--------------------------------------------------------------------------*;

%macro make_fmt ( fmt_name = ,
                  fmtlabel = ,
                  dataset  = ,
                  max_name =   ) ;

   %put  -------------------------------  ;
   %put    Entering MAKE_FMT Macro  ;
   %put  -------------------------------  ;

   %global &max_name ;

%*-------------------------------------------------------------------------*
|  Sort the data set by the variable that needs a sequential value.        |
|  Keep one of each unique value of the variable.                          |
*--------------------------------------------------------------------------* ;

   proc sort data = &dataset
             nodupkey
             out = ztemp
             ;
      by &fmtlabel ;
   run ;

%*-------------------------------------------------------------------------*
|  Create the data set to be used as the control input for the format.     |
*--------------------------------------------------------------------------* ;

   data &fmt_name  ( keep   = start
                              fmtname
                              label   ) ;

      attrib  start    format = comma10.0  label = 'ID'
              label    length = $40        label = 'Value Label'
              fmtname  length = $8         label = 'Format Name'
      ;
      set ztemp  ( keep   = &fmtlabel )
                 end = last ;

      start    = _n_ ;
      label    = &fmtlabel ;
      fmtname  = "&fmt_name" ;

      if last then
         call symput ( "&max_name", trim ( left ( put ( _n_, 5.0)))) ;
   run ;

%*-------------------------------------------------------------------------*
|  Sort the data set and create the format for the sequential values.      |
*--------------------------------------------------------------------------* ;

   proc sort data = &fmt_name ;
      by label ;
   run ;

   proc format cntlin = &fmt_name ;
   run ;

%*-------------------------------------------------------------------------*
|  Clean up work space.  Delete temporary data sets.                       |
*--------------------------------------------------------------------------* ;

   proc datasets nolist ;
      delete ztemp ;

   quit ;
   run ;

%mend make_fmt ;


*--------------------------------------------------------------------------*;
%let Sb02Name    = plandtal ;
%let Sb02Crea    = 22-July-1998 ;

***********
* Purpose *
   Create data sets for plan details.  One for original plan names, one for
   new plan names.  Create a sequential plan number for each of the plans.
   Create formats for each of the plans.  Create a data set that holds the
   matrix multipliers (proportions) to be used when combining strata.  The
   dimensions of the data set are the number of new plans (rows) and the
   maximum number of strata within a new plan (columns = strata + 1 column
   for plan id).

Usage      :  Syntax for use and/or examples
Input      :  Input parameters
   plandtal - This is an ascii data set that contains four columns
                 1 - Strata or original plan name or code
                 2 - New plan name or code to collapse strata
                 3 - strata weight
                 4 - subsetting name or code

Output     :  Output returned from module
   1.  The number of strata in the plan detail file stored in the global
       variable &_numstra.
Limits     :  Note any known limitations

*--------------------------------------------------------------------------*;
%let Sb02Upd1 = 22-January-2001 ;
%let Sb02By1  = Matthew J. Cioffi ;
**********
* Reason *
   Want to make the use of the plan detail file optional, so code must be
   added to check for the existence of the file.  If it does exist, then
   it may have some columns missing, where dummy values need to be entered.
*--------------------------------------------------------------------------*;
*--------------------------------------------------------------------------*;
%let Sb02Upd = 09-January-2003 ;
%let Sb02By  = Matthew J. Cioffi ;
**********
* Reason *
   If the original plan is blank, then delete that record.
*--------------------------------------------------------------------------*;

%macro plandtal ( plandtal = ) ;

   %put  -------------------------------  ;
   %put    Entering PLANDTAL Macro  ;
   %put  -------------------------------  ;

   %global
      _numstra
      _numopln
   ;

%*-------------------------------------------------------------------------*
|   Delete any previous plandtal data sets.                                |
*--------------------------------------------------------------------------* ;

   proc datasets nolist ;
      delete
         plandtal
         plandt_z
      ;
   quit ;

%*-------------------------------------------------------------------------*
|   Check for the existence of the pladtal file reference and if the file  |
|   reference exists, check for the existence of the external file.        |
|   If the file exists, then process the file. Otherwise write a note to   |
|   the log file.                                                          |
*--------------------------------------------------------------------------* ;

   %if %sysfunc( fileref ( &plandtal )) =  0 %then %do ;
      %put =============================================================== ;
      %put File reference &plandtal EXISTS. ;
      %put =============================================================== ;

%*-------------------------------------------------------------------------*
|   Reads in the ASCII dataset -  If missing data, then supply default     |
|   values for those missing fields.                                       |
*--------------------------------------------------------------------------* ;

   data plandtal ;
      infile &plandtal missover ;

      attrib  origplan  length = $40        label = 'Original Plan Name'
              newplan   length = $40        label = 'New Plan Name'
              stratwgt  format = comma14.8  label = 'Strata Weight'
              subcode   length = $40        label = 'Subset Value for Plan'
      ;

      input origplan $
            newplan  $
            stratwgt
            subcode  $
      ;

      if origplan = ' ' then delete ;
      else do ;
         origplan   = trim ( left ( origplan )) ;
         if newplan  = ' ' then newplan  = origplan ;
         if stratwgt = .   then stratwgt = 1 ;
         if subcode  = ' ' then subcode  = "1" ;
         if &subset  = 1   then subcode  = "1" ;
      end ;
   run;
   %end ;

   %else %do ;
      %if %sysfunc( fileref ( &plandtal )) >  0 %then %do ;
         %put =============================================================== ;
         %put File reference &plandtal IS NOT ASSIGNED. ;
         %put CAHPS Macro will use the plan codes in the PLAN variable   ;
         %put from the data set &dataset. ;
         %put =============================================================== ;
      %end ;
      %else %if %sysfunc( fileref ( &plandtal )) <  0 %then %do ;
         %put =============================================================== ;
         %put Physical file referred to by &plandtal DOES NOT EXIST. ;
         %put CAHPS Macro will use the plan codes in the PLAN variable ;
         %put from the data set &dataset. ;
         %put =============================================================== ;
      %end ;

%*-------------------------------------------------------------------------*
|   Determine whether the plan variable is character or numeric.           |
*--------------------------------------------------------------------------* ;
      proc sort data = &dataset
                ( keep = plan )
                out  = dsplan
                nodupkey ;
         by plan ;
      run ;

      %let _dsid    = %sysfunc ( open ( dsplan, i )) ;
      %let _planid  = %sysfunc ( varnum ( &_dsid, plan )) ;
      %let _plantyp = %sysfunc ( vartype ( &_dsid,&_planid )) ;
      %if &_dsid > 0 %then
         %let _dsc = %sysfunc ( close ( &_dsid )) ;

      data plandtal ( drop = plan ) ;
         set dsplan ;
         attrib  origplan  length = $40        label = 'Original Plan Name'
                 newplan   length = $40        label = 'New Plan Name'
                 stratwgt  format = comma14.8  label = 'Strata Weight'
                 subcode   length = $40        label = 'Subset Value for Plan'
         ;

         %if &_plantyp = C %then %do ;
            origplan = trim ( left ( plan )) ;
            if plan = ' ' then delete ;
         %end ;
         %else %do ;
            origplan = trim ( left ( put ( plan, 32.0 ))) ;
            if plan = . then delete ;
         %end ;
         newplan  = origplan ;
         stratwgt = 1 ;
         subcode  = "1" ;
      run;
   %end ;

%*-------------------------------------------------------------------------*
|   Get the total number of plans in the current plan detail file.  After  |
|   the usable records are determined, some plans may get dropped out due  |
|   to having zero or one record only, so the total plans will be          |
|   recomputed at that time.                                               |
*--------------------------------------------------------------------------* ;

   proc sort data = plandtal
             ( keep = origplan )
             out  = getnplan nodupkey ;
      by origplan ;
   run ;

   data _null_ ;
      set getnplan
      ( obs = 1 )
      nobs = numrec ;
      call symput ( '_numopln', numrec ) ;
   run ;

%*-------------------------------------------------------------------------*
|   Create the formats and sequential numbers for the subsets in the plan  |
|   detail file and save the total number of subsets for looping purposes. |
|   These sequential numbers will be added to the plan detail file and it  |
|   assumes that if a plan is dropped, then the subset will have other     |
|   plans in it to analyze.  If all plans in a subset are dropped, then    |
|   The sequential numbering for the subsets must be recomputed.           |
*--------------------------------------------------------------------------* ;

   %make_fmt ( fmt_name = sub_fmt  ,
               fmtlabel = subcode  ,
               dataset  = plandtal ,
               max_name = _num_sub    ) ;


   proc sort data = plandtal ;
      by subcode ;
   run ;

   data plandtal ;
      merge sub_fmt  ( keep   = label
                                start
                       rename = ( label = subcode
                                  start = sub_id   ))
            plandtal
      ;
      attrib  sub_id    label = 'Subsetting ID' ;
      by subcode ;
   run ;

%*-------------------------------------------------------------------------*
|   Using the ID codes for the subsetting code, loop through the data set  |
|   to create a format for each subset based on the original plan names.   |
*--------------------------------------------------------------------------* ;

   proc datasets nolist ;
      delete splan_id ;
   quit ;

   %do i = 1 %to &_num_sub ;
      data plan_sub ;
         set plandtal ;
         where sub_id = &i ;
      run ;

      %make_fmt ( fmt_name = s&i.fmt  ,
                  fmtlabel = origplan ,
                  dataset  = plan_sub ,
                  max_name = _&i.set    ) ;

      proc append base = splan_id
                  data = s&i.fmt ;
   %end ;

%*-------------------------------------------------------------------------*
|   Merge the subsetting original plan id into the plan detail data set.   |
*--------------------------------------------------------------------------* ;

   proc sort data = splan_id ;
      by label ;
   run ;

   proc sort data = plandtal ;
      by origplan ;
   run ;

   data plandtal ;
      merge splan_id ( keep   = label
                                start
                       rename = ( label = origplan
                                  start = splan_id ))
            plandtal
      ;
      attrib  splan_id  label = 'Subset Original Plan ID' ;
      by origplan ;
   run ;

%*-------------------------------------------------------------------------*
|   Copy origional plan detail file to be used as a reference data set.    |
*--------------------------------------------------------------------------* ;

   data plandt_z ;
      set plandtal ;
   run ;

%*-------------------------------------------------------------------------*
|   Delete unneeded data sets                                              |
*--------------------------------------------------------------------------* ;

   proc datasets nolist ;
      delete
         dsplan
         plan_sub
         splan_id
      ;
   quit ;
   run ;

%mend plandtal ;

/*
SubName   :  _now
Created   :  28-May-1998
Author    :  Matthew J. Cioffi
Purpose   :
   Assign the global variable &_now the current system date and time

---------------------------------------------------------------------------
Updated   :  dd-mmm-yyyy
by Whom   :
Reason    :

---------------------------------------------------------------------------
*/

%macro _now ;

   %put  ---------------------------------------------------------------  ;
   %put    Setting Current Date and Time in macro variable _now  ;
   %put  ---------------------------------------------------------------  ;

   %global _now  ;
   %local  date_a
           time_a
   ;

   %let date_a = %trim ( %left ( %sysfunc (date(), worddatx32. ))) ;
   %let time_a = %trim ( %left ( %sysfunc (time(), time9. ))) ;
   %let _now = &date_a at &time_a ;

%mend _now;

/*
SubName    :  item_cnt
Created    :  20-May-1998
Author     :  Matthew J. Cioffi
Type       :  Macro Function
Purpose    :
     Count the number of items in the list passed to this macro.

Usage      :  (list     = ,
               delim    = ,
               glbl_var =   )

Input      :  list      - The string contating a list of items separated
                          by a delimiter.
              delim     - The delimiter used to separate list items.
                          The default delimiter is a blank.  In order to
                          have a comma as a delimiter, you must enter the
                          comma as %str(',').  A blank is represented as
                          the default delimiter by using %str(' ').
              glbl_var  - The name of the variable to store the item count
                          in.

Output     :  &glbl_var - The parameter used to pass back the results of
                          the macro, the total count of items in list.
                          This variable is defined as global within the
                          macro.

Limits     :  If the list uses commas or other special characters
              for separaters, enclose the list in the macro
              function %quote().

---------------------------------------------------------------------------
Updated    :  dd-mmm-yyyy
by Whom    :
Reason     :

---------------------------------------------------------------------------
*/

%macro item_cnt (list     = ,
                 delim    = %str(' ') ,
                 glbl_var =  ) ;

   %put  -------------------------------  ;
   %put    Entering ITEM_CNT Macro  ;
   %put  -------------------------------  ;

   %global &glbl_var ;
   %local  cnt ;
   %local  itemword ;

%*-------------------------------------------------------------------------*
|  The if condition "&list ne" test to see if the variable &list has       |
|  some characters in it.  If it does then we begin counting the items     |
|  in the &list variable.                                                  |
*--------------------------------------------------------------------------*;

   %let cnt = 0 ;

   %if &list ne  %then
   %do ;
      %let itemword = %scan (&list, 1, &delim) ;
      %do %while (&itemword ne) ;
         %let cnt      = %eval(&cnt + 1) ;
         %let itemword = %scan(&list, &cnt + 1, &delim) ;
      %end;
   %end;

%*-------------------------------------------------------------------------*
|  Output returned from macro function item_cnt.                           |
*--------------------------------------------------------------------------*;

   %let &glbl_var = &cnt ;

%mend item_cnt;

/*
SubName    :  presetup
Created    :  24-September-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Create additional formats and varibles needed by the CAHPS macro

Usage      :  %presetup
Input      :  No parameters needed
Output     :  None
Limits     :

---------------------------------------------------------------------------
Updated    :  dd-mmm-yyyy
by Whom    :
Reason     :

---------------------------------------------------------------------------
*/

%macro presetup () ;

   %put  -------------------------------  ;
   %put    Entering PRESETUP Macro  ;
   %put  -------------------------------  ;

   %local  ac_adj
   ;

%*-------------------------------------------------------------------------*
|  Create the following formats:                                           |
|     Convert the rating (meaning) scores into stars.                      |
|     Convert a dichotomous response 0-1 to 2-1 respectively.              |
|     Collapse the 0-10 scale down to 1-3.                                 |
|     Collapse the 1-4  scale down to 1-3.                                 |
*--------------------------------------------------------------------------*;

   proc format ;
      value starfmt
                1 = "*"
                2 = "**"
                3 = "***"
            other = "?"
      ;

      value dichfmt
                1 = 1
                0 = 2
            other = .
      ;

      %if &recode = 0 or
          &recode = 1 %then %do ;
         value ratefmt
               9 - 10 = 3
               7 -  8 = 2
               0 -  6 = 1
               other  = .
         ;
      %end ;

      %if &recode = 2 or
          &recode = 3 %then %do ;
         value ratefmt
                   10 = 3
               8 -  9 = 2
               0 -  7 = 1
               other  = .
         ;
      %end ;

      value freqfmt
                4 = 3
                3 = 2
            1 - 2 = 1
            other = .
      ;

      value trichfmt
                1 = 1
                2 = 2
                3 = 3
            other = .
      ;

   run ;

%*-------------------------------------------------------------------------*
|  Set up the format to use in later data sets and reports.                |
*--------------------------------------------------------------------------*;

   %if       &vartype = 1 %then %do ;
      %let usefmt   = dichfmt. ;
   %end ;

   %else %if &vartype = 2 %then %do ;
      %let usefmt   = ratefmt. ;
   %end ;

   %else %if &vartype = 3 %then  %do ;
      %let usefmt   = freqfmt. ;
   %end ;

   %else %if &vartype = 4 %then  %do ;
      %let usefmt   = trichfmt. ;
   %end ;

   %else %do ;
      %let usefmt   = 8.0;
   %end ;

%*-------------------------------------------------------------------------*
|  Create dummy variables for the Adult & Child (ac) adjuster variables.   |
|  If no adjusters or only adult or only child, then set the new           |
|  variables to the original adjuster and number of adjuster values.       |
*--------------------------------------------------------------------------*;

   %if &_numadj >= 1 and
       &adultkid = 1 %then %do ;

      %let ac_adj = ;

%*-------------------------------------------------------------------------*
|  Create dummy variables for the Adult & Child (ac) adjuster variables.   |
*--------------------------------------------------------------------------*;

      %do i = 1 %to &_numadj ;
         %let ac_adj = &ac_adj ac&i ;
      %end ;

      %let adj_new  = &adjuster &ac_adj child ;
      %let numadj_2 = %eval ( &_numadj * 2 + 1 ) ;
      %put adj_new  = &adj_new -/- adultkid = 1 -/- numadj_2 = &numadj_2  ;
   %end ;

   %else %do ;
      %let adj_new  = &adjuster ;
      %let numadj_2 = %eval ( &_numadj ) ;
   %end ;

%*-------------------------------------------------------------------------*
|  Set the minimum and maximum responses for the type of variable being    |
|  used in the macro.                                                      |
*--------------------------------------------------------------------------*;

   %if &vartype = 1 %then %do ;
      %let min_resp =  0 ;
      %let max_resp =  1 ;
   %end ;

   %else %if &vartype = 2 %then %do ;
      %let min_resp =  0 ;
      %let max_resp = 10 ;
   %end ;

   %else %if &vartype = 3 %then %do ;
      %let min_resp =  1 ;
      %let max_resp =  4 ;
   %end ;

   %else %if &vartype = 4 %then %do ;
      %let min_resp =  1 ;
      %let max_resp =  3 ;
   %end ;

   %else %if &vartype ne 5 %then %do ;
      %let min_resp =  . ;
      %let max_resp =  . ;
   %end ;

%*-------------------------------------------------------------------------*
|  Set the original variable type to missing.                              |
*--------------------------------------------------------------------------*;

   %let orivtype = ;

%*-------------------------------------------------------------------------*
|  Set the date and time to be used in the reports as the current system   |
|  date and time. Creates a global variable &_now.                         |
*--------------------------------------------------------------------------*;

   %_now ;

%*-------------------------------------------------------------------------*
|  If there is no variable for the weight mean parameter, then set the     |
|  wgtplan parameter to zero.                                              |
*--------------------------------------------------------------------------*;

   %if &wgtmean =  %then %do ;
      %if &wgtplan ne 0 %then %do ;
         %put =============================================================== ;
         %put   The WGTMEAN parameter is not assigned a weight variable  ;
         %put   and the WGTPLAN parameter is set to &wgtplan.  These  ;
         %put   settings are not compatible, so WGTPLAN is being set to 0  ;
         %put =============================================================== ;
         %let wgtplan = 0 ;
      %end ;
   %end ;

%mend presetup ;

/*
SubName    :  settitle
Created    :  24-September-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Set up the common titles and footnotes to be used when generating
     a report.

Usage      :  %settitle
Input      :  No parameteres needed
Output     :  None
Limits     :

---------------------------------------------------------------------------
Updated    :  dd-mmm-yyyy
by Whom    :
Reason     :

---------------------------------------------------------------------------
*/

%macro settitle () ;

   %put  -------------------------------  ;
   %put    Entering SETTITLE Macro  ;
   %put  -------------------------------  ;

%*-------------------------------------------------------------------------*
|  Attaches appropriate macro variable values into the titles              |
*--------------------------------------------------------------------------*;

   %let a0 = NO CHILD INTERACTIONS ;
   %let a1 = COMBINE CHILDREN AND ADULTS ;
   %let a2 = CHILDREN ONLY ;
   %let a3 = ADULTS ONLY ;

   %let v1 = COMBINE LOW AND HIGH USERS ;
   %let v2 = LOW USERS ONLY ;
   %let v3 = HIGH USERS ONLY ;

%*-------------------------------------------------------------------------*
|  Prepare the appropriate titles and footnotes.                           |
*--------------------------------------------------------------------------*;

   %if &vartype = 1 %then %do ;
      %let t1begin = Dichotomous Variable (0 - 1) ;
   %end ;

   %else %if &vartype = 2 %then %do ;
      %if &recode = 1 %then
         %let t1begin = RECODED Rating Scale 0-6=1 7-8=2 9-10=3 ;
      %else %if &recode = 3 %then
         %let t1begin = RECODED Rating Scale 0-7=1 8-9=2 10=3 ;
      %else
         %let t1begin = Rating Scale (0 - 10) ;
   %end ;

   %else %if &vartype = 3 %then %do ;
      %if &recode = 1 or
          &recode = 3 %then
         %let t1begin = RECODED How Often Scale 1-2=1 3=2 4=3 ;
      %else
         %let t1begin = How Often (1 - 4) ;
   %end ;

   %else %if &vartype = 4 %then %do ;
      %let t1begin = Trichotomous Variable (1 - 3) ;
   %end ;

   %else %if &vartype = 5 %then %do ;
      %let t1begin = Responses &min_resp - &max_resp ;
   %end ;

   %else %do ;
      %let t1begin = Unkown Variable Type ;
   %end ;

   title1 "&t1begin.: &NAME" ;
   title2 "Analysis = &&a&adultkid  -  Visits = &&v&visits" ;

   footnote1 "Report run on &_now" ;
   footnote2 "CAHPS SAS Analysis Program Version &version " ;

%mend settitle ;

/*
SubName    :  allcases
Created    :  25-September-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Read in the data, merge the IDs, clean the variables, subset the data
     based on parameters in the CAHPS macro call and sum the number of cases
     by plan.

Usage      :  %allcases
Input      :  No parameteres needed
Output     :  Data Sets ALLCASES
                        ALLN
Limits     :

---------------------------------------------------------------------------
Updated    :  15-Apr-2002
by Whom    :  Matthew J. Cioffi
Reason     :
   When the ALLCASES data set has zero records, stop macro and print note
   in the log file.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  29-Jan-2003
by Whom    :  Matthew J. Cioffi
Reason     :
  Need to keep all variables in dsplan so CHILD variable can be checked.
  Added condition for adultkid=2.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  09-Oct-2003
by Whom    :  Matthew J. Cioffi
Reason     :
   Remove records where the weight variable is zero or missing.
---------------------------------------------------------------------------
*/

%macro allcases () ;

   %put  -------------------------------  ;
   %put    Entering ALLCASES Macro  ;
   %put  -------------------------------  ;

%*-------------------------------------------------------------------------*
|  Make the zeroall variable global so it can be used in the main CAHPS    |
|  calling macro.  This variable will be used to determine if the ALLCASES |
|  data set has any records or not.                                        |
*--------------------------------------------------------------------------*;
   %global
      _zeroall
   ;

%*-------------------------------------------------------------------------*
|  Keep only the plans that exist in the PLANDTAL data set.                |
|                                                                          |
|  Attach the sequential ids to ALLCASES to allow for easy looping         |
|  and array indexes.                                                      |
|                                                                          |
|  Insures &var values are with in the valid range of values.              |
*--------------------------------------------------------------------------* ;

%*-------------------------------------------------------------------------*
|   Determine the whether the plan variable is character or numeric.       |
|   Also determine if the CHILD variable exists in the data set.           |
|   Determine if the respondent ID variable is character or numeric.       |
*** Updated 29 January 2003 ***
|   Removed keep=plan statement to allow to look for child variable        |
*--------------------------------------------------------------------------* ;
   proc sort data = &dataset
             out  = dsplan
             nodupkey ;
      by plan ;
   run ;

   %let _dsid    = %sysfunc ( open ( dsplan, i )) ;
   %let _planid  = %sysfunc ( varnum ( &_dsid, plan )) ;
   %let _plantyp = %sysfunc ( vartype ( &_dsid, &_planid )) ;
   %let _childid = %sysfunc ( varnum ( &_dsid, child )) ;
   %if &_planid = 0 %then %do ;
      %put =============================================================== ;
      %put   The variable PLAN DOES NOT EXIST in &dataset ;
   %end ;
   %else %do ;
      %put =============================================================== ;
      %put   The variable PLAN EXISTS in &dataset ;
   %end ;

   %if &_childid = 0 %then %do ;
      %put   The variable CHILD DOES NOT EXIST in &dataset ;
      %put   The variable CHILD will be created by the MACRO ;
      %put =============================================================== ;
   %end ;
   %else %do ;
      %put   The variable CHILD EXISTS in &dataset ;
      %put =============================================================== ;
   %end ;

   %if &_dsid > 0 %then
      %let _dsc = %sysfunc ( close ( &_dsid )) ;

   %if &_inadjb = 0 and &id_resp ne    %then %do ;
      proc sort data = &dataset
                ( keep = &id_resp )
                out  = dsidresp
                nodupkey ;
         by &id_resp ;
      run ;
      %let _dsidr   = %sysfunc ( open ( dsidresp, i )) ;
      %let _respid  = %sysfunc ( varnum ( &_dsidr, &id_resp )) ;
      %let _resptyp = %sysfunc ( vartype ( &_dsidr, &_respid )) ;
      %if &_dsidr > 0 %then
         %let _dsc = %sysfunc ( close ( &_dsidr )) ;
   %end ;

   data planonly ;
      set dsplan
          ( keep = plan ) ;
      attrib
         origplan  length = $40        label = 'Original Plan Name'
      ;
      %if &_plantyp = C %then %do ;
         origplan   = trim ( left ( plan )) ;
      %end ;
      %else %do ;
         origplan = trim ( left ( put ( plan, 32.0 ))) ;
      %end ;
   run;

   proc sort data = &dataset ;
      by plan ;
   run ;

   proc sort data = planonly ;
      by plan ;
   run ;

   data origdata ;
      merge
         planonly
         &dataset
      ;
      by plan ;

%*-------------------------------------------------------------------------*
|  If there is no split flag indicated by the user, create one and set     |
|  the value of the variable to 0 for all records.                         |
*--------------------------------------------------------------------------*;

      %if &splitflg = 0 %then %do ;
          split = 0 ;
      %end ;

%*-------------------------------------------------------------------------*
|  If the CHILD variable does not exist, then create it here, otherwise    |
|  use the child variable as coded in the original data set.               |
*** Updated 29 January 2003 ***
|  Added condition for adultkid=2                                          |
*--------------------------------------------------------------------------*;

      %if &_childid = 0 %then %do ;
         %if &adultkid = 2 %then %do ;
            child = 1 ;
         %end ;
         %else %do ;
            child = 0 ;
         %end ;
      %end ;

%*-------------------------------------------------------------------------*
|  If the respondent weight parameter is missing, then create a respondent |
|  weight variable set to 1, equal weights, otherwise use the variable     |
|  found in the parameter &wgtresp.                                        |
*** Updated 09 October 2003 ***
|   Remove records where the weight = 0 or missing.                        |
*--------------------------------------------------------------------------*;

      %if &wgtresp =  %then %do ;
         _wgtresp = 1 ;
      %end ;
      %else %do ;
         _wgtresp = &wgtresp ;
      %end ;
      if _wgtresp = . or _wgtresp = 0 then delete ;

%*-------------------------------------------------------------------------*
|  If the mean weight parameter is missing, then create a mean weight      |
|  variable set to 1, equal weights, otherwise use the variable            |
|  found in the parameter &wgtmean.                                        |
*** Updated 09 October 2003 ***
|   Remove records where the weight = 0 or missing.                        |
*--------------------------------------------------------------------------*;

      %if &wgtmean =  %then %do ;
         _wgtmean = 1 ;
      %end ;
      %else %do ;
         _wgtmean = &wgtmean ;
      %end ;
      if _wgtmean = . or _wgtmean = 0 then delete ;

%*-------------------------------------------------------------------------*
|  If the respondent id parameter is missing, then create a 'Z'            |
|  respondent ID that is 50 characters long.  If there is an ID parameter  |
|  value, check to see if it is numeric or character, then create the ID   |
|  for the respondent as a character variable.                             |
*--------------------------------------------------------------------------*;

      attrib
         _id_resp  length = $50        label = 'Original Respondent ID'
      ;
      %if &id_resp =  %then %do ;
         _id_resp = 'Z' ;
      %end ;
      %else %if &_inadjb = 0 %then %do ;
         %if &_resptyp = C %then %do ;
            _id_resp = &id_resp ;
         %end ;
         %else %do ;
            _id_resp = put ( &id_resp, BEST. ) ;
         %end ;
      %end ;
   run ;

   proc sort data = origdata ;
      by origplan ;
   run ;

   proc sort data = plandt_z ;
      by origplan ;
   run ;

   data allcases ( drop = i ) ;
      merge
         plandt_z ( in     = p
                    keep   = origplan
                             sub_id
                             splan_id
                     %if &subset = 3 %then %do ;
                        where = ( sub_id = &sub )
                     %end ;
                   )
         origdata ( in     = d
                    keep   = origplan
                             &var
                             &adjuster
                             child
                             _wgtresp
                             _wgtmean
                             _id_resp
                             split
                             %if &visits ne 1 %then %do ;
                                visits
                             %end ;
                    );
      by origplan ;

%*-------------------------------------------------------------------------*
|  Keep only records if they match one of the plan codes in the PLANDTAL   |
|  data set.                                                               |
*--------------------------------------------------------------------------*;

      if p and d ;

%*-------------------------------------------------------------------------*
|  If adultkid = 2 (Children Only) then only keep the child records.       |
|  If adultkid = 3 (Adult Only) then only keep the adult records.          |
*--------------------------------------------------------------------------*;

      %if &adultkid = 2 %then %do ;
         if child = 1 ;
      %end;

      %else %if &adultkid = 3 %then %do ;
         if child ne 1 ;
      %end ;

%*-------------------------------------------------------------------------*
|  If visits = 2 then keep only the 'low' utilizers.                       |
|  If visits = 3 then keep only the 'high' utilizers.                      |
*--------------------------------------------------------------------------*;

      %if &visits = 2 %then %do ;
         if visits < 3 ;
      %end ;

      %else %if &visits = 3 %then %do ;
         if visits >= 3 ;
      %end ;

%*-------------------------------------------------------------------------*
|  Create a unique ID number for each record.                              |
|  Clean the variables based on the type of variable indicated in the      |
|     CAHPS macro call.                                                    |
*--------------------------------------------------------------------------*;

      _id + 1 ;

      array oneitem &var ;

      do i = 1 to dim ( oneitem ) ;

         if &vartype = 1 and
            oneitem [i] not in (0, 1)
         then oneitem [i] = . ;

         else if &vartype = 2 and
                 oneitem [i] not in (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
         then oneitem [i] = . ;

         else if &vartype = 3 and
                 oneitem [i] not in (1, 2, 3, 4)
         then oneitem [i] = . ;

         else if &vartype = 4 and
                 oneitem [i] not in (1, 2, 3)
         then oneitem [i] = . ;

         else if &vartype = 5 and
              not ( &min_resp <= oneitem [i] <= &max_resp )
         then oneitem [i] = . ;

      end ;

%*-------------------------------------------------------------------------*
|  Recode the rating or how often scale if required.                       |
*--------------------------------------------------------------------------* ;

      %if (&recode  = 1 or &recode  = 3) and
          (&vartype = 2 or &vartype = 3) %then %do ;

         format &var 8.0 ;
         %let usefmt   = 8.0 ;

         do i = 1 to dim ( oneitem ) ;
            if &vartype = 2 then do ;
               oneitem [i] = put ( oneitem [i], ratefmt. ) ;
            end ;
            else if &vartype = 3 then do ;
               oneitem [i] = put ( oneitem [i], freqfmt. ) ;
            end ;
         end ;

         call symput ("orivtype", put ( &vartype., 1.0 )) ;
         call symput ("vartype", put ( 4, 1.0 )) ;

      %end ;

   run ;

%*-------------------------------------------------------------------------*
|  Check the number of records merged in the ALLCASES data set.  If there  |
|  are none, then print note to log and exit macro/SAS. Also print to the  |
|  output file the PLAN codes that were used in the MERGE to show unique   |
|  values for trouble shooting the problem.                                |
*--------------------------------------------------------------------------* ;

   %let _dsid   = %sysfunc ( open ( allcases )) ;
   %let _dsnobs = %sysfunc ( attrn ( &_dsid, NOBS )) ;
   %let _rc     = %sysfunc ( close ( &_dsid )) ;

      %if &_dsnobs = 0 %then %do ;
         %put  ;
         %put  ;
         %put  CAHPS-MACRO-ERROR: ;
         %put  -----------------------------------------------------------------  ;
         %put  *****************************************************************  ;
         %put  *****************************************************************  ;
         %put  *****************************************************************  ;
         %put  ;
         %put         MERGE OF ANALYSIS DATA SET WITH PLAN DETAIL  ;
         %put            FILE RESULTED IN NO RECORDS MATCHING.  ;
         %put    Please check to make sure the PLAN variable values in both  ;
         %put    files have the exact same spelling, capitalization, etc  ;
         %put   The plan code values have been printed to the output file.  ;
         %put  ;
         %put     EXITING CAHPS MACRO Due to ZERO records in ALLCASES Data Set   ;
         %put  *****************************************************************  ;
         %put  *****************************************************************  ;
         %put  *****************************************************************  ;
         %put  -----------------------------------------------------------------  ;
         %put  ;
         %put  ;

         %let _zeroall = 1 ;

         title "PLAN Codes from the Plan Detail data set" ;
         proc freq data = plandt_z ;
            table origplan / nocum ;
         run ;

         title "PLAN Codes from the original Analysis data set" ;
         proc freq data = origdata ;
            table origplan / nocum ;
         run ;
      %end ;
      %else %do ;
         %let _zeroall = 0 ;
      %end ;
   %if &_zeroall = 1 %then %goto errout ;

%*-------------------------------------------------------------------------*
|  Get the number of respondents by plan.                                  |
*--------------------------------------------------------------------------* ;

   proc means data = allcases
              noprint
              nway ;
      class origplan ;
      var _id ;
      output out = alln
                   (drop = _type_
                           _freq_ )
             n = alln
             ;
   run ;

%*-------------------------------------------------------------------------*
|  Delete large datasets no longer needed in macro                         |
*--------------------------------------------------------------------------*;

   proc datasets library = work
                 nolist
               ;
      delete
         origdata
      ;
      modify alln ;
         label  alln = "Total # of Respondents"
         ;
         format alln comma12.0
         ;
   run ;
   quit ;

%*-------------------------------------------------------------------------*
|  Use this label to jump out of macro if no records in ALLCASES.          |
*--------------------------------------------------------------------------* ;
%errout:

%mend allcases ;

/*
SubName    :  item_wgt
Created    :  18-Nov-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Create the weights for the items in the variable list, VAR.

Usage      :  %item_wgt
Input      :  No parameteres needed
Output     :  Data Sets NONMISS
                        MER_WGT
Limits     :

---------------------------------------------------------------------------
Updated    :  06-Mar-2002
by Whom    :  Matthew J. Cioffi
Reason     :
     Use the respondent weights if the even_wgt parameter = 2, so the
     unequal weighting of composite items will get weighted instead of
     only summing up the total observations.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  06-Mar-2003
by Whom    :  Matthew J. Cioffi
Reason     :
     The plan weights had to be moved out of this step and added in another
     location in the submacro usable.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  25-Jun-2011
by Whom    :  Kayo Walsh
Reason     :
     A parameter k is added when even_wgt = 1 is selected. A usable dataset 
is created here when adjusters are used.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  24-Feb-2012
by Whom    :  Kayo Walsh
Reason     :
     ORIGPLAN is used to compute n in PROC MEANS instead of SPLAN_ID.       
This is due to merging with another data set by ORIGPLAN.                   
This applies when even_wgt = 1. 
---------------------------------------------------------------------------
*/

%macro item_wgt () ;

   %put  -------------------------------  ;
   %put    Entering ITEM_WGT Macro  ;
   %put  -------------------------------  ;

%*-------------------------------------------------------------------------*
|  Create the weights for the items in the variable list.  If only one     |
|  item then the data set will have only one record with weight = 1.  If   |
|  composite variable, then the data set will have one row for each        |
|  variable and a weight percent determined either by all non-missing      |
|  values or an even weight based on the number of variables.              |
*--------------------------------------------------------------------------*;

%*-------------------------------------------------------------------------*
|  *** Update 25-June-2011 ***                                             |
|  Create a usable dataset when adjusters are used.                        |
*--------------------------------------------------------------------------*;

   data usable_itemwgt ;
      %if &_numadj ^= 0 and
          &impute = 1 %then %do ;
         set allimput ;
      %end ;
      %else %do ;
         set allcases ( keep = &var
                               &adjuster
                               origplan
                               child
                               split
                               _wgtresp
                               _wgtmean
                               _id_resp
                               _id ) ;
      %end ;

      %if &_numadj ^= 0 %then %do ;
         if &adultkid = 1 then do ;
            if n (of &adjuster child) = &_numadj + 1 and
               nmiss (of &var) ne &_numitem ;
         end ;

         else do ;
            if n (of &adjuster) = &_numadj and
               nmiss (of &var) ne &_numitem ;
         end ;
      %end ;

      %else %do ;
         if nmiss (of &var) ne &_numitem ;
      %end ;
   run ;

   %if &_numadj ^= 0 %then %do;
      %if &_numitem > 1 %then %do ;

         proc means data = usable_itemwgt
                   nway
                   noprint ;
            var &var ;

            %if &even_wgt = 2 %then %do ;
               weight _wgtresp ;
               output out = nonmiss  ( keep = &var )
                     sumwgt =
               ;
            %end ;
            %else %do ;
               output out = nonmiss  ( keep = &var )
                     n =
               ;
            %end ;
         run ;

%*-------------------------------------------------------------------------*
| *** Update 25-June-2011 ***                                              |
|  Use a parameter k responses to find the minimum size for even_wgt = 1.  |
*--------------------------------------------------------------------------*;

         %if &even_wgt = 1 %then %do ;
   
            proc sort data = usable_itemwgt;
               by origplan;
            run;

            proc means data = usable_itemwgt
                      nway
                      noprint ;
               var &var ;
               class origplan ;
         
                  output out = nonmiss_evenwt ( keep = &var origplan )
                           n =
                  ;
            run ;

            data k_evenwt ( drop = i ) ;
               set nonmiss_evenwt ;

               array kcheck &var ;
               do i = 1 to dim ( kcheck ) ;

                  if min( kcheck [i], &k) = &k then kcheck [i] = &k;

               end ;
            run;

          %end ;


%*-------------------------------------------------------------------------*
| *** Update 25-June-2011 ***                                              |
|  Create the weights for the items in the variable list.  If only one     |
|  item then the data set will have only one record with weight = 1.  If   |
|  composite variable, then the data set will have one row for each        |
|  variable and a weight percent determined either by all non-missing      |
|  values or an even weight based on the number of variables.              |
*--------------------------------------------------------------------------*;

         data mer_wgt ;

            %if &even_wgt = 1 %then %do ;
               set k_evenwt ;
            %end ;
            %else %do ;
               set nonmiss ;
            %end;

            attrib itemwgt  format = 10.4
                            label  = "Item Weight"
                   itemno   format = 10.0
                            label  = "Item Number"
                   ;
            denom = sum (of &var) ;

            array allvar &var ;
            do itemno = 1 to dim (allvar) ;

               itemwgt = allvar [ itemno ] / denom ;

            output ;
            end ;
         run ;
   %end ;
   %else %do ;

      data mer_wgt ;
         attrib itemwgt format = 10.4
                        label  = "Item Weight"
                itemno  format = 10.0
                        label  = "Item Number"
                ;
         itemwgt   = 1 ;
         itemno    = 1 ;
      run ;
   %end ;
%end;

%*-------------------------------------------------------------------------*
|  Use allocates to create item weights when adjusters are not assigned.    |
*--------------------------------------------------------------------------*;

%if &_numadj = 0 %then %do;

   %if &_numitem > 1 %then %do ;

      proc means data = allcases
                 nway
                 noprint ;
         var &var ;

         %if &even_wgt = 2 %then %do ;
            weight _wgtresp ;
            output out = nonmiss  ( keep = &var )
                   sumwgt =
            ;
         %end ;
         %else %do ;
            output out = nonmiss  ( keep = &var )
                   n =
            ;
         %end ;
      run ;

      %if &even_wgt = 1 %then %do ;

%*-------------------------------------------------------------------------*
| *** Update 24-February-2012 ***                                          |
|  ORIGPLAN is used to compute n in PROC MEANS instead of SPLAN_ID.        |
|  This is due to merging with another data set by ORIGPLAN.               |
|  This applies when even_wgt = 1.                                         |
*--------------------------------------------------------------------------*;

         proc sort data = allcases;
            by origplan;
         run;   

         proc means data = allcases
              nway
              noprint ;
            var &var ;
            class origplan ;
         
            output out = nonmiss_evenwt ( keep = &var origplan )
                     n =
            ;         
         run ;
      
         data k_evenwt ( drop = i ) ;
            set nonmiss_evenwt;

            array kcheck &var ;
            do i = 1 to dim ( kcheck ) ;

               if min( kcheck [i], &k) = &k then kcheck [i] = &k;

            end ;
         run;

      %end ;

      data mer_wgt ;

         %if &even_wgt = 1 %then %do ;
            set k_evenwt ;
         %end ;
         %else %do ;
            set nonmiss ;
         %end;

         attrib itemwgt  format = 10.4
                         label  = "Item Weight"
                itemno   format = 10.0
                         label  = "Item Number"
                ;
         denom = sum (of &var) ;

         array allvar &var ;
         do itemno = 1 to dim (allvar) ;

            itemwgt = allvar [ itemno ] / denom ;

            output ;

         end ;
      run ;

   %end ;
   %else %do ;

      data mer_wgt ;
         attrib itemwgt format = 10.4
                        label  = "Item Weight"
                itemno  format = 10.0
                        label  = "Item Number"
                ;
         itemwgt   = 1 ;
         itemno    = 1 ;
      run ;

   %end ;

%end;

%mend item_wgt ;

/*
SubName    :  adjuster
Created    :  25-September-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Impute the mean value of the adjuster variables to all adjuster
     variables that have a missing value.

Usage      :  %adjuster
Input      :  No parameteres needed
Output     :  Data Sets ADJUSTER
                        ALLIMPUT
Limits     :

---------------------------------------------------------------------------
Updated    :  dd-mmm-yyyy
by Whom    :
Reason     :

---------------------------------------------------------------------------
*/

%macro adjuster () ;

   %put  -------------------------------  ;
   %put    Entering ADJUSTER Macro  ;
   %put  -------------------------------  ;

%*-------------------------------------------------------------------------*
|  Calculates the mean value for each adjuster - to later impute           |
|  mean value BY HEALTH PLAN                                               |
*--------------------------------------------------------------------------*;

   proc means data = allcases
              noprint
              nway ;
      class origplan ;
      var &adjuster ;
      output out = adjuster
                   (drop = _type_
                           _freq_ )
             mean =
          ;
   run ;

%*-------------------------------------------------------------------------*
|  Rename the adjuster variable names to be a sequential column name.      |
|  This needs to be done since these values get merged with allcases       |
|  which also have the same names for the adjuster variables.              |
*--------------------------------------------------------------------------*;

   data adjuster ( drop = &adjuster );
      set adjuster ;
      %do i = 1 %to &_numadj ;
         col&i = %scan (&adjuster, &i) ;
      %end ;
   run ;

%*-------------------------------------------------------------------------*
|  Impute the mean value of the adjuster for missing values if requested   |
|  by the CAHPS macro parameter IMPUTE = 1                                 |
*--------------------------------------------------------------------------*;

   %if &impute = 1 %then %do ;

      proc sort data = allcases ;
         by origplan ;
      run ;

      proc sort data = adjuster ;
         by origplan ;
      run ;

      data allimput ( keep= &var
                            &adjuster
                            origplan
                            child
                            split
                            _wgtresp
                            _wgtmean
                            _id_resp
                            _id ) ;
         merge
            allcases
            adjuster
         ;
         by origplan ;
         array adj_c col1 - col&_numadj. ;
         array adj_a &adjuster ;

         do i = 1 to dim (adj_c) ;
            if adj_a [i] = . then adj_a [i] = adj_c [i] ;
         end ;

      run ;

   %end ;

%mend adjuster ;

/*
SubName    :  usable
Created    :  25-Sep-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Determine which records should be kept for analysis.  Transpose the
     usable records so each variable has an item number.  This will be done
     on variables that have a missing value.

Usage      :  %usable
Input      :  No parameteres needed
Output     :  Data Sets USABLE
                        USEN
                        USESTACK
                        UNADJ_M
                        UNADJ_MW
                        UAM_PLAN

Limits     :

---------------------------------------------------------------------------
Updated    :  03-April-2001
by Whom    :  Matthew J. Cioffi
Reason     :
   Remove any plans with only zero or one record from the usable records
   for analysis.  Then recreate the sequential numbering for the plans and
   add that back into the usable data set.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  29-January-2003
by Whom    :  Matthew J. Cioffi
Reason     :
   The iteration of the macro when subset=3 did not work beyond the first
   cycle.  Corrected logic and also corrected the assignment of the formats
   created in this sub macro.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  06-Mar-2003
by Whom    :  Matthew J. Cioffi
Reason     :
   The plan weights had to added into the plan means data here instead
   of in the item weight submacro.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  21-Apl-2009
by Whom    :  Kayo Walsh
Reason     :
   The plan weights for composite items were modified. Each weight of each 
composite item is summed and it is used as the composite weight for the plan. 
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  26-May-2009
by Whom    :  Kayo Walsh
Reason     :
   One part of the code that creats for plandtal work data set was modified. 
This creates sub_id = 1 up to the number of subsets. By doing so, it creates 
a correct output. 
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  25-Jun-2009
by Whom    :  Kayo Walsh
Reason     :
   Work datasets, itemn and itemnstack were added in usable macro. Itemn  
contains a number of respondents (alln) for each item. Itemstack contains 
the same data as itemn but listed vertically.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  25-Jun-2011
by Whom    :  Kayo Walsh
Reason     :
   In unadj_mv dataset, a value of unadjusted and unweighted means are modified
when even_wgt = 1 is selected.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  24-Feb-2012
by Whom    :  Kayo Walsh
Reason     :
   ORIGPLAN and ITEMNO used for merging when even_wgt = 1.
---------------------------------------------------------------------------
*/

%macro usable () ;

   %put  -------------------------------  ;
   %put    Entering USABLE Macro  ;
   %put  -------------------------------  ;

   %global
      _allpln
   ;
%*-------------------------------------------------------------------------*
|  Only keeps respondents if at least one item in the variable list is     |
|  complete and adjusters (if not imputed) are complete.                   |
*--------------------------------------------------------------------------*;

   data usable ;
      %if &_numadj ^= 0 and
          &impute = 1 %then %do ;
         set allimput ;
      %end ;
      %else %do ;
         set allcases ( keep = &var
                               &adjuster
                               origplan
                               child
                               split
                               _wgtresp
                               _wgtmean
                               _id_resp
                               _id ) ;
      %end ;

      %if &_numadj ^= 0 %then %do ;
         if &adultkid = 1 then do ;
            if n (of &adjuster child) = &_numadj + 1 and
               nmiss (of &var) ne &_numitem ;
         end ;

         else do ;
            if n (of &adjuster) = &_numadj and
               nmiss (of &var) ne &_numitem ;
         end ;
      %end ;

      %else %do ;
         if nmiss (of &var) ne &_numitem ;
      %end ;

   run ;

%*-------------------------------------------------------------------------*
| *** Update 24-June-2009 ***                                              |
| Work datasets, itemn and itemnstack were added in usable macro. Itemn    |
| contains a number of respondents (alln) for each item. Itemstack contains|
| the same data as itemn but listed vertically.                            |
*--------------------------------------------------------------------------* ;

%*-------------------------------------------------------------------------*
|  Get the number of each item by plan.                                    |
*--------------------------------------------------------------------------* ;

   proc means data = allcases
             n
             noprint
             nway ;
     class origplan ; 
     var  &var ;
     output out = itemn
                  (drop = _type_
                          _freq_ )
            n(&var) = 
            ;
   run;

   data itemnstack(keep = origplan itemno item_n);
      set itemn ;
      array item &var;
      do itemno = 1 to dim(item);
         item_n = item[itemno];
      output;
      end;
   run;

%*-------------------------------------------------------------------------*
|  Get the number of useable respondents by plan.                          |
*--------------------------------------------------------------------------* ;

   proc means data = usable
              n
              noprint
              nway ;
      class origplan ;
      var _id ;
      output out = usen
                   (drop = _type_
                           _freq_ )
             n = usen
             ;
   run ;

   proc datasets library = work
                 nolist
               ;
      modify usen ;
         label  usen = "Number of Respondents Analyzed"
         ;
         format usen comma12.0
         ;
   run ;
   quit ;

%*-------------------------------------------------------------------------*
| *** Update 03-April-2001 ***                                             |
|  Remove any plans that have only zero or one record from the usable,     |
|  plandtal, allcases, alln, adjuster datasets and then compute the        |
|  sequential numbers for the remaining plans.                             |
|                                                                          |
|  Store the dropped plans in a permanent data set for later reference.    |
|                                                                          |
| *** Update 14-October-2003 ***  STILL NEED TO IMPLEMENT                  |
|  Also need to check that the subset codes used all have at least one     |
|  plan in them, otherwise the numbering sequence for looping through the  |
|  subsets needs to be recomputed.                                         |
|                                                                          |
|  Store the dropped subsets along with the dropped plans, include warning |
|  in the log file.                                                        |
*--------------------------------------------------------------------------* ;

   proc sort data = usable ;
      by origplan ;
   run ;

   proc sort data = plandt_z (
                    %if &subset = 3 %then %do ;
                       where = ( sub_id = &sub )
                    %end ;
                    )
             out  = plandtal ;
      by origplan ;
   run ;

   proc sort data = allcases ;
      by origplan ;
   run ;

   proc sort data = alln   ;
      by origplan ;
   run ;

   %if &_numadj ^= 0 %then %do ;
      proc sort data = adjuster   ;
         by origplan ;
      run ;
   %end ;

   proc sort data = usen
             ( where = ( usen > 1 )) ;
      by origplan ;
   run ;

   data del_plan ;
      merge
         usen ( in = u
                keep = origplan usen )
         alln ( in = a
                keep = origplan alln )
      ;
      label
         origplan = 'Drop Plan from Analysis'
         usen     = 'Number of Usable Records for Plan'
      ;
      by origplan ;
      if not u ;
   run ;

   data alln ;
      merge
         usen   ( in     = u )
         alln   ( in     = a )
      ;
      by origplan ;
      if u and a ;
   run ;

   data plandtal ;
      merge
         usen     ( in     = u )
         plandtal ( in     = a )
      ;
      by origplan ;
      if u and a ;
   run ;

   %if &_numadj ^= 0 %then %do ;
      data adjuster ;
         merge
            usen     ( in     = u )
            adjuster ( in     = a )
         ;
         by origplan ;
         if u and a ;
      run ;
   %end ;

   data usable ;
      merge
         usen   ( in     = k )
         usable ( in     = u )
      ;
      by origplan ;
      if k and u ;
   run ;

   data allcases ;
      merge
         usen     ( in     = k )
         allcases ( in     = a )
      ;
      by origplan ;
      if k and a ;
   run ;

%*-------------------------------------------------------------------------*
|   Create formats for the sequential numbers of the original plan names   |
|   and the new plan names.  For each, save the maximum sequential number  |
|   to be used in loops by other parts of a program.                       |
|   Add the ID fields to the plan detail file.                             |
*--------------------------------------------------------------------------* ;

   %make_fmt ( fmt_name = oplanfmt ,
               fmtlabel = origplan ,
               dataset  = plandtal ,
               max_name = _numopln   ) ;

   %let _allpln = &_numopln ;

   %put ********************** ;
   %put _numopln = &_numopln ;
   %put ********************** ;

   %make_fmt ( fmt_name = nplanfmt ,
               fmtlabel = newplan  ,
               dataset  = plandtal ,
               max_name = _numnpln   ) ;

   %put ********************** ;
   %put _numnpln = &_numnpln ;
   %put ********************** ;


   proc sort data = plandtal ;
      by origplan ;
   run ;

   data plandtal ;
      merge oplanfmt ( keep   = label
                                start
                       rename = ( label = origplan
                                  start = oplan_id ))
            plandtal
      ;
      attrib
         oplan_id  label = 'Original Plan ID'
         plan      label = 'Health Plan ID'
      ;
      by origplan ;
      plan  = oplan_id ;
   run ;

   proc sort data = plandtal ;
      by newplan ;
   run ;

   data plandtal ;
      merge nplanfmt ( keep   = label
                                start
                       rename = ( label = newplan
                                  start = nplan_id ))
            plandtal
      ;
      attrib  nplan_id  label = 'New Plan ID' ;
      by newplan ;
   run ;

%*-------------------------------------------------------------------------*
|   Create the formats and sequential numbers for the subsets in the plan  |
|   detail file and save the total number of subsets for looping purposes. |
|   These sequential numbers will be added to the plan detail file.        |
|                                                                          |
| *** Update 26-May-2009 ***                                               |
|  The code that creats plandtal below (merged by sub_fmt and plandtal)    |
|  was modified. A variable, SUB_ID from plandtal should be kept instead   |
|  of being deleted, and a variable, START from sub_fmt should be dropped. |
|  The previous code only works for subset = 1 since START only creates a  |
|  value 1.                                                                |
*--------------------------------------------------------------------------* ;

   %make_fmt ( fmt_name = sub_fmt  ,
               fmtlabel = subcode  ,
               dataset  = plandtal ,
               max_name = _num_sub  ) ;

   %put ********************** ;
   %put _num_sub = &_num_sub ;
   %put ********************** ;

   proc sort data = plandtal ;
      by subcode ;
   run ;

   data plandtal ;
      merge sub_fmt  ( keep   = label
                       rename = ( label = subcode ))
            plandtal 
      ;
      attrib  sub_id    label = 'Subsetting ID' ;
      by subcode ;
   run ;


%*-------------------------------------------------------------------------*
|   Using the ID codes for the subsetting code, loop through the data set  |
|   to create a format for each subset based on the original plan names.   |
| *** Update 29-Jan-2003 ***                                               |
|   When using parameter subset = 3, need to have sub_id = the current     |
|   iteration number.                                                      |
*--------------------------------------------------------------------------* ;
   proc datasets nolist ;
      delete splan_id ;
   quit ;

   %do i = 1 %to &_num_sub ;
      data plan_sub ;
         set plandtal ;
         %if &subset = 3 %then %do ;
            where sub_id = &sub ;
         %end ;
         %else %do ;
            where sub_id = &i ;
         %end ;
      run ;

      %if &subset = 3 %then %do ;
         %make_fmt ( fmt_name = s&sub.fmt  ,
                     fmtlabel = origplan ,
                     dataset  = plan_sub ,
                     max_name = _&sub.set    ) ;
      %put ********************** ;
      %put _&sub.set = &&&_&sub.set ;
      %put ********************** ;

         proc append base = splan_id
                     data = s&sub.fmt ;
      %end ;
      %else %do ;
         %make_fmt ( fmt_name = s&i.fmt  ,
                     fmtlabel = origplan ,
                     dataset  = plan_sub ,
                     max_name = _&i.set    ) ;
      %put ********************** ;
      %put _&i.set = &&&_&i.set ;
      %put ********************** ;

         proc append base = splan_id
                     data = s&i.fmt ;
      %end ;
   %end ;


%*-------------------------------------------------------------------------*
|   Merge the subsetting original plan id into the plan detail data set.   |
*--------------------------------------------------------------------------* ;

   proc sort data = splan_id ;
      by label ;
   run ;

   proc sort data = plandtal ;
      by origplan ;
   run ;

   data plandtal ;
      merge splan_id ( keep   = label
                                start
                       rename = ( label = origplan
                                  start = splan_id ))
            plandtal ( drop = splan_id )
      ;
      attrib  splan_id  label = 'Subset Original Plan ID' ;
      by origplan ;
   run ;

%*-------------------------------------------------------------------------*
|   This section creates the strata weights for use in the CAHPS macro.    |
|                                                                          |
|   The first step sums the original strata weights for the original plans |
|   by the new plan ids.                                                   |
*--------------------------------------------------------------------------* ;

   proc means data = plandtal
              sum
              nway
              noprint
      ;
      class nplan_id ;
      var stratwgt ;
      output out = sum_wgts ( drop   = _type_
                              rename = ( _freq_ = strata ))
             sum = plan_tot ;
   run ;

%*-------------------------------------------------------------------------*
|   Calculate the percent for each weight for each original plan within    |
|   the new plan breakouts.                                                |
*--------------------------------------------------------------------------* ;

   proc sort data = sum_wgts ;
      by nplan_id ;
   run ;

   proc sort data = plandtal ;
      by nplan_id ;
   run ;

   data stratwgt  ( drop = plan_tot  maxstrat strata) ;
      attrib  stratwgt  format = 10.8 ;
      merge plandtal  ( keep = oplan_id nplan_id stratwgt)
            sum_wgts
            end = lastplan ;
      by nplan_id ;

      retain maxstrat 0 ;

      if stratwgt in (., 0) or
         plan_tot in (., 0) then stratwgt = 0 ;
      else stratwgt = stratwgt / plan_tot ;

      if first.nplan_id and
         strata > maxstrat then
         maxstrat = strata ;

      if lastplan then
         call symput ("_numstra", trim ( left ( put ( maxstrat, 10.0 )))) ;
   run ;

   %put ========================== ;
   %put global variables created ;
   %put _numstra = &_numstra ;
   %put ========================== ;

%*-------------------------------------------------------------------------*
|   Next we have to get all these ID fields into the following data sets.  |
|   allcases, alln, usen, adjuster and usable.                             |
*--------------------------------------------------------------------------* ;

   proc sort data = plandtal ;
      by origplan ;
   run ;

   proc sort data = usable ;
      by origplan ;
   run ;

   data usable ;
      merge
         plandtal ( in   = p )
         usable   ( in   = o )
      ;
      by origplan ;
      if p and o ;
   run ;

   proc sort data = usen ;
      by origplan ;
   run ;

   data usen ;
      merge
         plandtal ( in   = p )
         usen     ( in   = o )
      ;
      by origplan ;
      if p and o ;
   run ;

   proc sort data = alln ;
      by origplan ;
   run ;

   data alln ;
      merge
         plandtal ( in   = p )
         alln     ( in   = o )
      ;
      by origplan ;
      if p and o ;
   run ;

   %if &_numadj ^= 0 %then %do ;
      proc sort data = adjuster ;
         by origplan ;
      run ;

      data adjuster ;
         merge
            plandtal ( in   = p )
            adjuster ( in   = o )
         ;
         by origplan ;
         if p and o ;
      run ;
   %end ;

   proc sort data = allcases ;
      by origplan ;
   run ;

   data allcases ;
      merge
         plandtal ( in   = p )
         allcases ( in   = o )
      ;
      by origplan ;
      if p and o ;
   run ;

%*-------------------------------------------------------------------------*
|  Stack the &var items and create an item number field.                   |
*--------------------------------------------------------------------------*;

   data usestack ( drop = &var );
      set usable  ;
      array item &var ;
      do itemno = 1 to dim (item) ;
         y      = item [ itemno ] ;
         output ;
      end ;
   run ;

%*-------------------------------------------------------------------------*
|  Unadjusted Means by plan and by item                                    |
|  If there is a weight for weighting the unadjusted means, it is applied  |
|  at this point, to get weighted unadjusted means to be used as the base  |
|  for the adjusted means.                                                 |
|                                                                          |
|  *** Updated 01 May 2003 ***                                             |
|  Save the summed weights at the plan level to be used in comparison of   |
|  the plan mean to the overall weighted mean.  This summed weight will be |
|  be used if the parameter wgtplan = 1.  If wgtplan = 0, then the         |
|  _wgtplan variable must be set back to 1.                                |
|                                                                          |
|  Get both weighted and unweighted means for display in final data        |
|                                                                          |
|  *** Update 21 April 2009 ***                                            |
|  Sum of weights of composite items is assigned for the weights for       |
|  the composite measure.                                                  |
|                                                                          |
|  *** Update 25 June 2011 ***                                             |
|  A way of calculating unadjusted and unweighted means are modified for   |
|  even_wgt = 1.                                                           |
|                                                                          |
|  *** Update 24 February 2012 ***                                         |
|  ORIGPLAN was added in unadj_m and unwgt_m data sets so that they can    |
|  merged with mer_wgt by ORIGPLAN and itemno when even_wgt = 1            |
*--------------------------------------------------------------------------*;

   proc means data =  usestack
              nway
              noprint ;
      class plan origplan itemno ;
      var y ;
      weight _wgtmean ;
      output out  = unadj_m ( drop = _type_  _freq_
                              sortedby = plan origplan itemno )
             mean =
             sumwgt = _wgtplan
      ;
   run ;

   proc means data =  usestack
              nway
              noprint ;
      class plan origplan itemno ;
      var y ;
      output out  = unwgt_m ( drop = _type_  _freq_
                              sortedby = plan origplan itemno )
             mean = unwgt_y
      ;
   run ;

%*-------------------------------------------------------------------------*
|  *** Update 25 June 2011 ***                                             |
|  Create overall mean from unadj_m and unwgt_m cases.                     |
*--------------------------------------------------------------------------*;

   proc means data =  unadj_m
              nway
              noprint ;
      class itemno ;
      var y ;
      output out  = unadj_item ( drop = _type_  _freq_
                              sortedby = itemno )
             mean = item_y_unadj
      ;
   run ;

   proc means data =  unadj_item
              nway
              noprint ;
      var item_y_unadj ;
      output out  = unadj_ov ( drop = _type_  _freq_
                                )
             mean = ov_y_unadj
      ;
   run ;

   data unadj_ov;
        set unadj_ov;
        comp_ov = 1;
   run;

   proc means data =  unwgt_m
              nway
              noprint ;
      class itemno ;
      var unwgt_y ;
      output out  = unwgt_item ( drop = _type_  _freq_
                              sortedby = itemno )
             mean = item_y_unwgt
      ;
   run ;

   proc means data =  unwgt_item
              nway
              noprint ;
      var item_y_unwgt ;
      output out  = unwgt_ov ( drop = _type_  _freq_
                                )
             mean = ov_y_unwgt
      ;
   run ;

   data unwgt_ov;
      set unwgt_ov;
      comp_ov = 1;
   run;

   data unadj_m ;
      merge
         unadj_m
         unwgt_m
      ;
      by plan origplan itemno ;
   run ;

%*-------------------------------------------------------------------------*
|  *** Update 25 June 2011 ***                                             |
|  creates a dataset that contains item level means for unadj and unwgt    |
|  cases.                                                                  |         
|                                                                          |
|  A dataset, unadj_m is renamed as unadj_m_item.                          |
*--------------------------------------------------------------------------*;

   proc sort data = unadj_m;
      by itemno;
   run;

   data unadj_m_item ;
      merge
         unadj_m
         unadj_item
         unwgt_item 
      ;
      by itemno ;
   run ;

   %if &wgtplan = 0 %then %do ;
      data unadj_m_item ;
         set unadj_m_item ;
         _wgtplan = 1 ;
      run ;
   %end ;

   proc sort data = unadj_m_item;
      by plan;
   run; 

   proc means data = unadj_m_item noprint nway;
      var _wgtplan;
      class plan;
      output out = planwgts ( keep = plan _wgtplan )
      sum( _wgtplan ) =  ; 
   run; 

%*-------------------------------------------------------------------------*
|  In the unadjusted plan mean data set, combine the means in each row by  |
|  the item weights to get a composite mean.                               |
|                                                                          |
|  *** Update 25 June 2011 ***                                             |
|  A calculation of y and unwgt_y when even_wgt = 1 is updated.            |
|                                                                          |
|  *** Update 24 February 2012 ***                                         |
|  ORIGPLAN and ITEMNO used for merging when even_wgt = 1.                 |
*--------------------------------------------------------------------------*;

   %if &_numitem > 1 %then %do ;

      proc sort data = unadj_m_item ;

         %if &even_wgt = 1 %then %do;
            by origplan  itemno ;
         %end;
         %else %do;
            by itemno;
         %end;

      run ;

      proc sort data = mer_wgt ;

         %if &even_wgt = 1 %then %do;
            by origplan itemno ;
         %end;    
         %else %do;
            by itemno;
         %end;

      run ;

      data unadj_mw ;
         merge mer_wgt (in = a)
               unadj_m_item (in = b);
         %if &even_wgt = 1 %then %do;
            by origplan itemno ;
         %end;
         %else %do;
            by itemno;
         %end;

         if a and b;

%*-------------------------------------------------------------------------*
|  *** Update 12 Feb 2018 ***                                              |
|  Original unadjusted mean Y and unweighted mean UNWGT_Y are saved as     |
|  ORG_YSCORE and ORG_UNWGTT_Y to be used for calculating the mean by      |
|  each item.                                                              |
*--------------------------------------------------------------------------*;
      
         org_yscore = y;
         org_unwgt_y = unwgt_y;

         %if &even_wgt = 1 %then %do ;
            y        = ( y - item_y_unadj )*itemwgt;
            unwgt_y  = ( unwgt_y - item_y_unwgt)*itemwgt;
         %end; 
         %else %do ;
            y        =       y * itemwgt ;
            unwgt_y  = unwgt_y * itemwgt ;
         %end;
      
         comp_ov = 1;
      run ;
   %end;
   %else %do;
   
      proc sort data = unadj_m_item ;
         by itemno;
      run ;

      proc sort data = mer_wgt ;
         by itemno;
      run ;

      data unadj_mw ;
         merge mer_wgt (in = a)
               unadj_m_item (in = b);
    
         by itemno;
         if a and b;

%*-------------------------------------------------------------------------*
|  *** Update 12 Feb 2018 ***                                              |
|  Original unadjusted mean Y and unweighted mean UNWGT_Y are saved as     |
|  ORG_YSCORE and ORG_UNWGTT_Y to be used for calculating the mean by      |
|  each item.                                                              |
*--------------------------------------------------------------------------*;

         org_yscore = y;
         org_unwgt_y = unwgt_y;

         y        =       y * itemwgt ;
         unwgt_y  = unwgt_y * itemwgt ;
      
         comp_ov = 1;

      run ;
   %end;

   data unadj_mw;
       merge unadj_mw
             unadj_ov
             unwgt_ov;
       by comp_ov;
   run;

%*-------------------------------------------------------------------------*
|  Delete large datasets no longer needed in macro                         |
*--------------------------------------------------------------------------*;

   proc datasets library = work
                 nolist
               ;
      delete
         allimput
      ;
   quit ;
   run ;

%mend usable ;

/*
SubName    :  low_numb
Created    :  19-November-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Saves the plans that have less than 100 usable records for use in a
     report.

Usage      :  %low_numb
Input      :  No parameteres needed
Output     :  Data Set LOW_NUMB
Limits     :

---------------------------------------------------------------------------
Updated    :  24-Jun-2009
by Whom    :  Kayo Walsh
Reason     : Add another work dataset that saves the plans that have 0 record
in one (or more) of the composites items. Low_numb2 is created. 
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  dd-mmm-yyyy
by Whom    :
Reason     :

---------------------------------------------------------------------------
*/

%macro low_numb () ;

   %put  -------------------------------  ;
   %put    Entering LOW_NUMB Macro  ;
   %put  -------------------------------  ;

   proc sort data = plan_n ;
      by plan ;
   run ;

%*-------------------------------------------------------------------------*
|  If a plan has less than 100 usable respondents, save record and add the |
|  plan name and convert usen to character.                                |
*--------------------------------------------------------------------------*;

   data low_numb ;
      set plan_n ;

      if usen < 100 ;

      plantxt = "Plan ID " ||
                compress ( put ( plan, 8.0 )) ||
                " - " ||
                put ( plan, oplanfmt. ) ;

      usentxt = compress ( put ( usen, 6.0 )) ;

   run;
 
%*-------------------------------------------------------------------------*
|  If a plan has no record, save record and add the plan name and convert  |
|  itemn to character.                                                     |
*--------------------------------------------------------------------------*;
 
   data zero_item ;
      set itemnstack ;

      if  item_n = 0 ;
      
   run;

   proc sort data = plan_n;
       by origplan;
   run;

   proc sort data = zero_item;
       by origplan;
   run;

   data zero_item2;
       merge zero_item(in = a) plan_n(in = b);
       by origplan;
   run;

   data low_numb2;
       set zero_item2;
 
       if item_n = 0;

       label
       itemno   = "Item number with missing data";     
     
       plantxt = "Plan ID " ||
                compress ( put ( plan, 8.0 )) ||
                " - " ||
                put ( plan, oplanfmt. ) ;

       itemntxt = compress ( put (itemno, 6.0 )) ;

   run;

%mend low_numb ;

/*
SubName    :  pct_miss
Created    :  25-September-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Saves the data on the percent of each variable and adjuster that
     has missing values.  Will be used in a report later

Usage      :  %pct_miss
Input      :  No parameteres needed
Output     :  Data Sets PCT_MISS
                        P_MISS
                        W_P_MISS
                        PW_MISS
Limits     :

---------------------------------------------------------------------------
Updated    :  dd-mmm-yyyy
by Whom    :
Reason     :

---------------------------------------------------------------------------
*/

%macro pct_miss () ;

   %put  -------------------------------  ;
   %put    Entering PCT_MISS Macro  ;
   %put  -------------------------------  ;

   %global use_flds ;

%*-------------------------------------------------------------------------*
|  Calculate the percent items missing by health plan for each variable    |
|  and adjuster.                                                           |
*--------------------------------------------------------------------------*;

   %if &adultkid = 1 %then
      %let use_flds = &var &adjuster child ;
   %else
      %let use_flds = &var &adjuster ;

   proc means data = allcases
              nway
              noprint ;
      class plan ;
      var &use_flds ;
      output out = pct_miss  ( keep = plan &use_flds )
             nmiss =
      ;
   run ;

%*-------------------------------------------------------------------------*
|  Create a temporary data of the percent missing data.                    |
*--------------------------------------------------------------------------*;

   proc sort data = pct_miss ;
      by plan ;
   run ;

   proc sort data = plan_n ;
      by plan ;
   run ;

   data p_miss ( keep = plan
                        planname
                        subcode
                        alln
                        &use_flds) ;
      merge pct_miss
            plan_n ;
      by plan ;

      format &use_flds   percent9.2 ;

      attrib  planname label  = "Health Plan"
                       length = $40
      ;
      planname = put (plan, oplanfmt.) ;

      array allvar &use_flds ;
      do i = 1 to dim (allvar) ;
            allvar [i] = allvar [i] / alln ;
      end ;

   run ;

%*-------------------------------------------------------------------------*
|  If data is stratified and combining strata is desired then create the   |
|  compressed data set using the stratification weights.                   |
*--------------------------------------------------------------------------*;

   %if &wgtdata = 2 %then %do ;

      proc sort data = stratwgt ;
         by oplan_id ;
      run ;

      proc sort data = p_miss ;
         by plan ;
      run ;

      data w_p_miss ( keep = planname subcode alln &use_flds) ;
         merge p_miss  ( rename = (plan = oplan_id))
               stratwgt ( rename = (nplan_id = plan)) ;
         by oplan_id ;

         attrib  planname label  = "Health Plan"
                          length = $40
         ;
         planname = put (plan, nplanfmt.) ;

         array allvar &use_flds ;
         do i = 1 to dim (allvar) ;
               allvar [i] = allvar [i] * stratwgt ;
         end ;

      run ;

      proc means data = w_p_miss
                 nway
                 noprint ;
         class planname subcode ;
         var alln &use_flds ;
         output out = pw_miss ( drop = _type_  _freq_ )
                sum =
         ;
      run ;
   %end ;

%mend pct_miss ;

/*
SubName    :  pct_resp
Created    :  25-September-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Prints a report showing the percent of each response category, some
     variable types collapse the scale down to three values.

Usage      :  %pct_resp
Input      :  No parameteres needed
Output     :  Data Sets BAR_RATE
                        BAR_Y
                        NUM_VAL
                        W_COMP
                        W_COMP1
                        NON
                        W_NON
                        WNON
Limits     :

---------------------------------------------------------------------------
Updated    :  06 March 2003
by Whom    :  Matthew J. Cioffi
Reason     :
   Need to fix how the plan weights are carried through the data sets or
   use later.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  28 March 2012
by Whom    :  Kayo Walsh
Reason     :
   Compute response rate properly when even_wgt = 1 is selected. This option
   requaires ORIGPLAN and ITEMNO for merging to get W_COMP data set.
---------------------------------------------------------------------------

*/

%macro pct_resp () ;

   %put  -------------------------------  ;
   %put    Entering PCT_RESP Macro  ;
   %put  -------------------------------  ;

%*-------------------------------------------------------------------------*
|  Calculate the percent of each response for each plan.  If it is a       |
|  composite, then the individual items will be weighted to create the     |
|  percent of each response.                                               |
*--------------------------------------------------------------------------*;

   data bar4mat ;
      set usestack ;
      y = input ( put ( y, &usefmt. ), 8.0 ) ;
   run ;

   proc sort data = bar4mat ( where = ( y ne . )) ;
      by plan itemno  ;
   run ;

   proc freq data  = bar4mat ;
      by plan itemno ;
      tables y / noprint
                 out = bar0rate ;
   run ;

   proc sort data = bar0rate ( keep = plan itemno )
             out  = planitem
             nodupkey ;
      by plan itemno ;
   run ;

   data dum_bar ;
      set planitem ;
      by plan itemno ;

      %if &vartype = 1 %then %do ;
         do y = 1 to 2 ;
      %end ;
      %else %if &vartype = 5 %then %do ;
         do y = &min_resp to &max_resp ;
      %end ;
      %else %do ;
         do y = 1 to 3 ;
      %end ;
         output ;
      end ;
   run ;

   proc sort data = dum_bar ;
      by plan itemno y ;
   run ;

   proc sort data = bar0rate ;
      by plan itemno y ;
   run ;

   data bar_rate ;
      merge dum_bar
            bar0rate ;
      by plan itemno y ;
      if count = . then count = 0 ;
   run ;

   proc transpose data   = bar_rate ( where = ( y ne . ))
                  prefix = res
                  out    = bar_set
                         ( drop   = _name_  _label_
                           sortedby = plan itemno ) ;
      by plan itemno ;
      var count ;
   run ;

%*-------------------------------------------------------------------------*
|  *** Updated 06 March 2003 ***                                           |
|  Add in the plan weights, _wgtplan, to the bar_set data set.             |
*--------------------------------------------------------------------------*;

   data bar_set ;
      merge
         bar_set   ( in = b )
         planwgts  ( in = w )
      ;
      by plan ;
      if b ;
   run ;

%*-------------------------------------------------------------------------*
|  Get all unique values for the variable y and store the total number in  |
|  the global variable _num_val.                                           |
*--------------------------------------------------------------------------*;

   proc sort data = bar_rate
             out = num_val ( rename = ( y = resp_val ))
             nodupkey
          ;
      by y ;
   run ;

   data _null_ ;
      set num_val  nobs = _num_val ;
      if _n_ = 1 then
         call symput ( "_num_val", put ( _num_val, 8.0 )) ;

      length row $ 3 ;
      row = trim ( left ( put ( _n_, 3.0 ))) ;
      rvlabel = 'Response Value ' || trim ( left ( put ( resp_val, 10.0 ))) ;
      call symput ('rv'||row, rvlabel) ;
   run ;

%*-------------------------------------------------------------------------*
|  Merge the item weights to the plan item variable value counts.          |
*--------------------------------------------------------------------------*;
%*-------------------------------------------------------------------------*
|  *** Updated 28 March 2012 ***                                           |
|  Add ORIGPLAN to be used for merging when even_wgt = 1 is selected.      |
*--------------------------------------------------------------------------*;

   %if &_numitem > 1 and &even_wgt = 1 %then %do ;

      proc sort data = bar_set ;
         by plan itemno ;
      run ;

      data allcases_pct(keep = origplan plan);
         set allcases;
      run; 

      proc sort data = allcases_pct nodupkey;
         by plan;
      run;

      data bar_set2;
         merge bar_set(in = a) allcases_pct(in = b);
         by plan ;
      run;

      proc sort data = mer_wgt ;
         by origplan itemno ;
      run ;

      proc sort data = bar_set2 ;
         by origplan itemno ;
      run ;

      data w_comp ( drop = i ) ;
         merge mer_wgt (in = a)
            bar_set2 (in = b);
      
         by origplan itemno ;
      
         if a and b;      

         array ptres [ &_num_val ] ;
         array res res: ;
         format ptres: percent9.2 ;

         sum_res = 0 ;

         do i = 1 to dim ( res ) ;
            sum_res = sum ( sum_res, res [i] ) ;
         end ;

         n_ratio = 1 / (_wgtplan * sum_res) ;

         do i = 1 to dim ( res ) ;
            if sum_res = 0 or
               res [i] = . then ptres [i] = . ;
            else ptres [i] = res [i] / sum_res * itemwgt ;
         end ;
      run ;

   %end;
   %else %do;

      proc sort data = mer_wgt ;
         by itemno ;
      run ;

      proc sort data = bar_set ;
         by itemno ;
      run ;

      data w_comp ( drop = i ) ;
         merge mer_wgt
               bar_set ;
         by itemno ;

         array ptres [ &_num_val ] ;
         array res res: ;
         format ptres: percent9.2 ;

         sum_res = 0 ;

         do i = 1 to dim ( res ) ;
            sum_res = sum ( sum_res, res [i] ) ;
         end ;

         n_ratio = 1 / (_wgtplan * sum_res) ;

         do i = 1 to dim ( res ) ;
            if sum_res = 0 or
               res [i] = . then ptres [i] = . ;
            else ptres [i] = res [i] / sum_res * itemwgt ;
         end ;
      run ;

   %end;

%*-------------------------------------------------------------------------*
|  Sum the percents to the plan level.  These can be for the bar charts.   |
*--------------------------------------------------------------------------*;

   proc means data = w_comp
              nway
              noprint ;
      class plan ;
      var ptres: ;
      output out = w_comp1 ( drop = _type_  _freq_ )
             sum =
      ;
   run ;

   proc sort data = plan_n ;
      by plan ;
   run ;

   proc sort data = w_comp1 ;
      by plan ;
   run ;

   data non ( keep = planname
                     oplan_id
                     subcode
                     alln
                     usen
                     ptres: ) ;
      merge
         plan_n ( drop = sub_id )
         w_comp1
      ;
      by plan ;


      length planname $ 40 ;
      planname = put (plan, oplanfmt.) ;

      label planname = "Health Plan"
            plan     = "Health Plan ID"
      ;

      %if &vartype = 1 %then %do ;
         label  ptres1 = "% Yes"
                ptres2 = "% No"
         ;
      %end ;
      %else %if &vartype  = 2 or
                &orivtype = 2 %then %do ;
         %if &recode = 0 or
             &recode = 1 %then %do ;
            label  ptres1 = "% Rating 0 - 6"
                   ptres2 = "% Rating 7 - 8"
                   ptres3 = "% Rating 9 -10"
            ;
         %end ;
         %else %if &recode = 2 or
                   &recode = 3 %then %do ;
            label  ptres1 = "% Rating 0 - 7"
                   ptres2 = "% Rating 8 - 9"
                   ptres3 = "% Rating    10"
            ;
         %end ;
      %end ;
      %else %if &vartype  = 3 or
                &orivtype = 3 %then %do ;
         label  ptres1 = "% Sometimes or Never 1-2"
                ptres2 = "% Usually 3"
                ptres3 = "% Always 4"
         ;
      %end ;
      %else %if &vartype = 4 %then %do ;
         label  ptres1 = "% Big Problem 1"
                ptres2 = "% Small Problem 2"
                ptres3 = "% Not a Problem 3"
         ;
      %end ;
      %else %if &vartype = 5 %then %do ;
         %do i = 1 %to &_num_val ;
            label ptres&i = "&&rv&i" ;
         %end ;
      %end ;

   run ;

%*-------------------------------------------------------------------------*
|  If data is stratified and combining strata is desired then create the   |
|  compressed data set using the stratification weights.                   |
*--------------------------------------------------------------------------*;

   %if &wgtdata = 2 %then %do ;
      proc sort data = stratwgt ;
         by oplan_id ;
      run ;

      proc sort data = non ;
         by oplan_id ;
      run ;

      data w_non ( keep = planname
                          subcode
                          alln
                          usen
                          ptres: ) ;
         merge
            non
            stratwgt ( rename = (nplan_id = plan))
         ;
         by oplan_id ;

         array allvar  ptres: ;
         do i = 1 to dim (allvar) ;
            allvar [i] = allvar [i] * stratwgt ;
         end ;

         length planname $ 40 ;
         planname = put (plan, nplanfmt.) ;
      run ;

      proc means data = w_non
                 nway
                 noprint ;
         class planname subcode ;
         var alln  usen  ptres: ;
         output out = wnon ( drop = _type_  _freq_ )
                sum =
         ;
      run ;

   %end ;

%*-------------------------------------------------------------------------*
|  Delete large datasets no longer needed in macro                         |
*--------------------------------------------------------------------------*;

   proc datasets library = work
                 nolist
               ;
      delete
         usestack
         bar4mat
      ;
   quit ;
   run ;

%mend pct_resp ;

/*
SubName  :  ctr_mean
Created    :  23-April-2001
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Get the centering means for the purpose of using in the standardize
     procedure and computation of the plan mean adjustments.

Usage      :  %ctr_mean
Input      :  No parameteres needed
Output     :  Data Sets CTR_MEAN
                        PLN_MEAN
Limits     :

---------------------------------------------------------------------------
Updated    :  dd-mmm-yyyy
by Whom    :
Reason     :

---------------------------------------------------------------------------
*/

%macro ctr_mean () ;

   %put  -------------------------------  ;
   %put    Entering CTR_MEAN Macro  ;
   %put  -------------------------------  ;

   %local
   ;
   run ;
%*-------------------------------------------------------------------------*
|  Calculate the plan means for the adjuster and outcome variables.        |
*--------------------------------------------------------------------------*;
   proc means data = ctr_data
              noprint
              nway ;
      class plan split sub_id ;
      var &adj_new &cur_item ;
      output out = pln_mean
                   (drop = _type_  _freq_
                    sortedby = plan split sub_id )
             mean =
          ;
   run ;

   data pln_mean ;
      merge
         pln_mean ( in = a )
         planwgts ( in = w )
      ;
      by plan ;
   run ;

%*-------------------------------------------------------------------------*
|  Calculate the mean of the plan means for the adjuster and outcome       |
|  variables, then add additional fields so the records in the data set    |
|  of all respondents to be standardized to a mean of zero.                |
*--------------------------------------------------------------------------*;

   %if &splitflg = 0 %then %do ;
      proc means data = pln_mean
                 noprint
                 nway ;
         class sub_id ;
         var &adj_new &cur_item ;
         weight _wgtplan ;
         output out = ctr2mean
                      (drop = _type_
                              _freq_ )
                mean =
             ;
      run ;
   %end ;
   %else %do ;
      proc means data = pln_mean
                 noprint
                 nway ;
         class split sub_id ;
         var &adj_new &cur_item ;
         weight _wgtplan ;
         output out = split_st
                      (drop = _type_
                              _freq_ )
                mean =
             ;
      run ;

      proc means data = split_st
                 noprint
                 nway ;
         class sub_id ;
         var &adj_new &cur_item ;
         output out = ctr2mean
                      (drop = _type_
                              _freq_ )
                mean =
             ;
      run ;
   %end ;

   data ctr_mean ;
      set ctr2mean ;
      attrib
         _id_resp  length = $50        label = 'Original Respondent ID'
      ;
      if sub_id = . then sub_id = 1 ;
      _id       = . ;
      _id_resp  = ' ' ;
      col_type  = 1 ;
      &cur_item = . ;
      _wgtresp  = 0 ;
      _wgtmean  = 0 ;
      _wgtplan  = 0 ;
      _wgtstan  = 0 ;
   run ;


   %put  -------------------------------  ;
   %put    Leaving CTR_MEAN Macro  ;
   %put  -------------------------------  ;

%mend ctr_mean ;

/*
SubName    :  std_data
Created    :  28-September-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Standardize the means to center and calculate the regression coefficients,
     predictions and residuals for each variable item. Apply the item weights
     to the adjusters and the residuals.  If no adjusters, then the case mix
     section is skipped.  Calculates the sum of the squared residuals, where
     if there is no adjuster, the residual = the standardize means for each
     item.

Usage      :  %std_data
Input      :  No parameteres needed
Output     :  Data Sets ADJ_COPY
                        ADJ_NEW
                        ADJ_STD
                        A_R
                        ADJ_RWN
                        RES_4_ID
                        RES4PLAN
                        C_&outname
                        ADJ_PW
Limits     :

---------------------------------------------------------------------------
Updated    :  04-April-2001
by Whom    :  Matthew J. Cioffi
Reason     :
   Added the respondent level weight variable to be carried through the
   data sets needed for casemix.

---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  29-January-2003
by Whom    :  Matthew J. Cioffi
Reason     :
   When subset=3, the formats for the coefficients and the r-squared values
   after iteration 1 were not being assigned correctly.  Adjusted the logic
   to account for this problem.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  06-August-2008
by Whom    :  Kayo Walsh
Reason     :
   Since we need to create a new vp for composite and individual items,
   itemno was used to find the max number of dependent variables(new variable
   = itemno_max). This variable was added into RES4PLAN.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  07-April-2011
by Whom    :  Kayo Walsh
Reason     :
    Proc standard was replaced with proc stdize. Proc stdize can handle the 
    case correctly when values of a case mix adjuster are all the same within
    a plan.  
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  28-March-2012
by Whom    :  Kayo Walsh
Reason     :
    Adjusted composite item means when even_wgt = 1 were not computed properly
    since the data set was not merged by ORIGPLAN and ITEMNO.  
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  21-October-2016
by Whom    :  Kayo Walsh
Reason     :
    The code of computing weighted residuals is modified since weights were
not added properly.  
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  03-October-2018
by Whom    :  Kayo Walsh
Reason     :
    The code of combining coefficients for composites was modified for SPLIT case.  
---------------------------------------------------------------------------*/

%macro std_data () ;

   %put  -------------------------------  ;
   %put    Entering STD_DATA Macro  ;
   %put  -------------------------------  ;

   %local cur_item
          item
   ;

%*-------------------------------------------------------------------------*
|  Loop over each item - BEGIN                                             |
*--------------------------------------------------------------------------*;

   %do item = 1 %to &_numitem ;
      %let cur_item = %scan ( &var, &item ) ;
      %put Processing for item number &item from &var., &cur_item ;

      %if &item = 1 %then %do ;
         proc datasets nolist ;
            delete adj_plan
                   adj_pred
                   adj_resi
                   coeff
                 
                   ;
         quit ;
      %end ;


%*-------------------------------------------------------------------------*
|  Create a data set of the plan id, items,and adjusters.  If there are    |
|  adult and child interactions, then calculate the interaction between    |
|  the child variable (0 or 1) and the adjuster variables.                 |
*--------------------------------------------------------------------------*;

      data adj_copy
         %if &_numadj >= 1 %then %do ;
           ( drop = i )
         %end ;
      ;
         set usable ( keep = _id
                             plan
                             &cur_item
                             &adjuster
                             child
                             _wgtresp
                             _wgtmean
                             _id_resp
                             split
                             sub_id
                     ) ;

         _wgtstan = 1 ;
         %if &_numadj >= 1 %then %do ;
            %if &adultkid = 1 %then %do ;
               array adj_list &adjuster ;
               array ac [&_numadj] ;
               do i = 1 to dim (adj_list) ;
                  ac [i] = adj_list [i] * child ;
               end ;
            %end ;

            array new_list &adj_new ;

            do i = 1 to dim (new_list) ;
               if &cur_item = . then new_list [i] = . ;
            end ;
         %end ;
      run ;

%*-------------------------------------------------------------------------*
|  *** 23 April 2001 ***                                                   |
|  Copy the adj_copy data set to a temporary centering data set to be      |
|  passed to the centering macro.                                          |
*--------------------------------------------------------------------------*;
      data ctr_data ;
         set adj_copy ;
         col_type = 0 ;
      run ;

      %ctr_mean ;

%*-------------------------------------------------------------------------*
|  *** 23 April 2001 ***                                                   |
|  Append the centering mean to each of the plans in the whole data set.   |
*--------------------------------------------------------------------------*;
      proc sort data = pln_mean
                ( keep = plan sub_id split )
                out  = plan_one ;
         by sub_id plan ;
      run ;

      proc sort data = ctr_mean ;
         by sub_id ;
      run ;

      proc sql ;
         create table ctr_plan as
         select a.plan, a.split, b.*
         from plan_one as a, ctr_mean as b
         where a.sub_id = b.sub_id ;
      quit ;

      data ctr_all ;
         set
            ctr_plan
            ctr_data
         ;
      run ;

%*-------------------------------------------------------------------------*
|  If adjusters available then do casemix adjustments.  Calculate the      |
|  regression coeffcients, predictions and residuals for each item.        |
|  Apply the item weights to the adjustments.                              |
*--------------------------------------------------------------------------*;

      %if &_numadj >= 1 %then %do ;
         %if &splitflg = 1 %then %do ;
%*-------------------------------------------------------------------------*
|  *** 26 April 2001 ***                                                   |
|  For each split we must standardize the data set to a mean = 0 and then  |
|  run the data through the casemix module.  The extra record for each plan|
|  that has the outcome variable missing will have the adjuster variables  |
|  equal to all the plans casemix mean.                                    |
*--------------------------------------------------------------------------*;

%*-------------------------------------------------------------------------*
|  *** update 07 April 2011 ***                                            |
|  proc standard was replaced with proc stdize.                            |
*--------------------------------------------------------------------------*;

%*-------------------------------------------------------------------------*
|  Run case mix where split = 0.                                           |
*--------------------------------------------------------------------------*;
            proc sort data = ctr_all ;
               by plan ;
            run ;

            proc stdize data = ctr_all
                          ( where = ( split = 0 ))
                          out  = ctr_adj
                          method = mean
                         ;
               by plan ;
               var &adj_new &cur_item ;
               weight _wgtstan ;
            run ;

            data adj_reg ;
               set ctr_adj ;
               if &cur_item = . then col_type = 0 ;
               else                  col_type = 1 ;
            run ;

            data adj_std ;
               set ctr_adj ;

*               if &cur_item ne . ;
*               col_type = 0 ;
                if col_type = 0 ;

            run ;

            %casemix ;

%*-------------------------------------------------------------------------*
|  *** update 8 Feb 2017 ***                                               |
|  Copy resulting data sets to temporary data sets to be combined later.   |
*--------------------------------------------------------------------------*;
%*-------------------------------------------------------------------------*
|  *** update 3 Oct 2018 ***                                               |
|  A data set, output_p under SET was replace with coe_pvalue for SPLIT.   |
*--------------------------------------------------------------------------*;
            data output_p0;
               set coe_pvalue; 
            run;

%*-------------------------------------------------------------------------*
|  Copy resulting data sets to temporary data sets to be combined later.   |
*--------------------------------------------------------------------------*;

            data resid0 ;
               set resid ;
            run ;

%*-------------------------------------------------------------------------*
|  Save the coefficients in a single data set.                             |
*--------------------------------------------------------------------------*;

%*-------------------------------------------------------------------------*
|  *** update Jan 31 2017 ***                                              |
|  &proc_type option was added. Each type (0=PROC REG and                  |
|  1 =PROC SURVEYREG) outputs resuls in a different format.                |
*--------------------------------------------------------------------------*;

            %if &proc_type = 0 %then %do;     

               data para_est ( drop = &cur_item ) ;
                  set para_est ;

                  itemno = &item ;
                  length y $ 30 ;
                  y      = &cur_item ;
                  split  = 0 ;
               run ;

               proc append base = coeff
                  data = para_est force ;
               run ;

            %end;
            %else %if &proc_type = 1 %then %do;
        
               data rsqu_survey (keep = _rsq_ _depvar_ split);
	              set fitstatistics ;
             
                  where Label1 = "R-Square" ;
 
                  _rsq_    = nValue1;
                  _depvar_ = "&cur_item";
                  split    = 0;	  

               run;

               data adjrsqu_survey (keep = _adjrsq_ _depvar_);
	              set fitstatistics ;
          
	              where Label1 = "Adjusted R-Square" ;
 
                  _adjrsq_ = nValue1;
                  _depvar_ = "&cur_item";
	  
               run;

               data rsqu_survey ;
	              merge rsqu_survey(in = a) adjrsqu_survey(in = b);
	              by _depvar_;

                  label
                  _adjrsq_  = "Adjusted R-Square" 
                  _rsq_     = "R-Square"
                  _depvar_  = "Dependent variable"
                  ;

                  attrib subcode length = $40
                  label  = 'Subset Name'
                  ;

                  %if &subset = 3 %then %do ;
                     if &endsub = 1 then subcode = 'GLOBAL' ;
                     else subcode = put ( 1, sub_fmt. ) ;
                  %end ;
                  %else %do ;
                     if &endsub = 1 then subcode = 'GLOBAL' ;
                     else subcode = put ( &sub, sub_fmt. ) ;
                  %end ;

               run;

               proc append base = rsqu_surveyreg
                  data = rsqu_survey force ;
               run ;

            %end;

%*-------------------------------------------------------------------------*
|  Predictions for the plan mean observations (where the col_type is 1)    |
|  are the adjustments for the  plans.  Save these in ADJ_PLAN, appending  |
|  the results for each item.                                              |
*--------------------------------------------------------------------------*;

            data a_p1 ( drop = &cur_item col_type) ;
               set predict (where = ( col_type = 1 )) ;
               itemno = &item ;
               y      = &cur_item ;
               split  = 0 ;
            run ;

            proc append base = adj_plan
                        data = a_p1 force ;
            run ;

            data a_p2 ( drop = &cur_item col_type) ;
               set predict (where = ( col_type ^= 1 )) ;
               itemno = &item ;
               y      = &cur_item ;
               split  = 0 ;
            run ;

            proc append base = adj_pred
                        data = a_p2 force ;
            run ;

%*-------------------------------------------------------------------------*
|  Run case mix where split = 1.                                           |
*--------------------------------------------------------------------------*;

            proc sort data = ctr_all ;
               by plan ;
            run ;

            proc stdize data = ctr_all
                          ( where = ( split = 1 ))
                          out  = ctr_adj
                          method = mean
                         ;
               by plan ;
               var &adj_new &cur_item ;
               weight _wgtstan ;
            run ;

            data adj_reg ;
               set ctr_adj ;
               if &cur_item = . then col_type = 0 ;
               else                  col_type = 1 ;
            run ;

            data adj_std ;
               set ctr_adj ;
*               if &cur_item ne . ;
*               col_type = 0 ;
                if col_type = 0 ;
            run ;

            %casemix ;

%*-------------------------------------------------------------------------*
|  *** update 8 Feb 2017 ***                                               |
|  Copy resulting data sets to temporary data sets to be combined later.   |
*--------------------------------------------------------------------------*;
%*-------------------------------------------------------------------------*
|  *** update 3 Oct 2018 ***                                               |
|  A data set, output_p under SET was replace with coe_pvalue for SPLIT.   |
*--------------------------------------------------------------------------*;

            data output_p1;
               set coe_pvalue;  
            run;

%*-------------------------------------------------------------------------*
|  Copy resulting data sets to temporary data sets to be combined later.   |
*--------------------------------------------------------------------------*;

            data resid1 ;
               set resid ;
            run ;

%*-------------------------------------------------------------------------*
|  Save the coefficients in a single data set.                             |
*--------------------------------------------------------------------------*;
        
%*-------------------------------------------------------------------------*
|  *** update 31  2017 ***                                                 |
|  &proc_type option was added. Each type (0=PROC REG and                  |
|  1 =PROC SURVEYREG) outputs resuls in a different format.                |
*--------------------------------------------------------------------------*;

            %if &proc_type = 0 %then %do;     

               data para_est ( drop = &cur_item ) ;
                  set para_est ;

                  itemno = &item ;
                  length y $ 30 ;
                  y      = &cur_item ;
                  split  = 1 ;
               run ;

               proc append base = coeff
                  data = para_est force ;
               run ;

            %end;
            %else %if &proc_type = 1 %then %do;
        
               data rsqu_survey (keep = _rsq_ _depvar_ split);
	              set fitstatistics ;
             
                  where Label1 = "R-Square" ;
 
                  _rsq_    = nValue1;
                  _depvar_ = "&cur_item";
                  split    = 1;	  

               run;

               data adjrsqu_survey (keep = _adjrsq_ _depvar_);
	              set fitstatistics ;
          
	              where Label1 = "Adjusted R-Square" ;
 
                  _adjrsq_ = nValue1;
                  _depvar_ = "&cur_item";
	  
               run;

               data rsqu_survey ;
	              merge rsqu_survey(in = a) adjrsqu_survey(in = b);
	              by _depvar_;

                  label
                  _adjrsq_  = "Adjusted R-Square" 
                  _rsq_     = "R-Square"
                  _depvar_  = "Dependent variable"
                  ;

                  attrib subcode length = $40
                  label  = 'Subset Name'
                  ;

                  %if &subset = 3 %then %do ;
                     if &endsub = 1 then subcode = 'GLOBAL' ;
                     else subcode = put ( 1, sub_fmt. ) ;
                  %end ;
                  %else %do ;
                     if &endsub = 1 then subcode = 'GLOBAL' ;
                     else subcode = put ( &sub, sub_fmt. ) ;
                  %end ;

               run;

               proc append base = rsqu_surveyreg
                  data = rsqu_survey force ;
               run ;

            %end;

%*-------------------------------------------------------------------------*
|  Predictions for the plan mean observations (where the col_type is 1)    |
|  are the adjustments for the  plans.  Save these in ADJ_PLAN, appending  |
|  the results for each item.                                              |
*--------------------------------------------------------------------------*;

            data a_p1 ( drop = &cur_item col_type) ;
               set predict (where = ( col_type = 1 )) ;
               itemno = &item ;
               y      = &cur_item ;
               split  = 1 ;
            run ;

            proc append base = adj_plan
                        data = a_p1 force ;
            run ;

            data a_p2 ( drop = &cur_item col_type) ;
               set predict (where = ( col_type ^= 1 )) ;
               itemno = &item ;
               y      = &cur_item ;
               split  = 1 ;
            run ;

            proc append base = adj_pred
                        data = a_p2 force ;
            run ;

%*-------------------------------------------------------------------------*
|  Combine the two sets of data from the casemix into one, adding the      |
|  split variable back in.                                                 |
*--------------------------------------------------------------------------*;
            data resid ;
               set
                  resid0 ( in = d0 )
                  resid1 ( in = d1 )
               ;
               if d0 then split = 0 ;
               else       split = 1 ;
            run ;

%*-------------------------------------------------------------------------*
|  *** update 3 Oct 2018 ***                                               |
|  A data set, output_p  was replace with output_p_split so that the       | 
|  coefficient otuput can be merged correctly.                             |
*--------------------------------------------------------------------------*;

            data output_p_split ; 
               set
                  output_p0 ( in = d0 )
                  output_p1 ( in = d1 )
               ;
               if d0 then split = 0 ;
               else       split = 1 ;
            run ;


            %if &item = 1 %then %do ;

               data output_p_split_all;
                  set output_p_split;
               run;

               proc sort data = output_p_split_all;
		          by split variable;
		       run;

            %end;
            %else %do;
		   
	           proc sort data = output_p_split;
                  by split variable;
		       run;

               data output_p_split_all;
                  merge output_p_split_all output_p_split;
                  by split variable;
               run;

            %end;

         %end ; 
         %else %do ;
%*-------------------------------------------------------------------------*
|  *** 23 April 2001 ***                                                   |
|  Standardize the data set to a mean = 0.  The extra record for each plan |
|  that has the outcome variable missing will have the adjuster variables  |
|  equal to all the plans casemix mean.                                    |
*--------------------------------------------------------------------------*;
            proc sort data = ctr_all ;
               by plan ;
            run ;

            proc stdize data = ctr_all
                          out  = ctr_adj
                          method = mean
                         ;
               by plan ;
               var &adj_new &cur_item ;
               weight _wgtstan ;
            run ;

            data adj_reg ;
               set ctr_adj ;
               if &cur_item = . then col_type = 0 ;
               else                  col_type = 1 ;
            run ;

            data adj_std ;
               set ctr_adj ;
*               if &cur_item ne . ;
*               col_type = 0 ;
                if col_type = 0 ;
            run ;

            %casemix ;

            data resid ;
               set resid ;
               split = 0 ;
            run ;

%*-------------------------------------------------------------------------*
|  Save the coefficients in a single data set.                             |
*--------------------------------------------------------------------------*;
%*-------------------------------------------------------------------------*
|  *** update 31 Jan 2017 ***                                              |
|  &proc_type option was added. Each type (0=PROC REG and                  |
|  1 =PROC SURVEYREG) outputs resuls in a different format.                |
*--------------------------------------------------------------------------*;

            %if &proc_type = 0 %then %do;     

               data para_est ( drop = &cur_item ) ;
                  set para_est ;

                  itemno = &item ;
                  length y $ 30 ;
                  y      = &cur_item ;
                  split  = 0 ;
               run ;

               proc append base = coeff
                  data = para_est force ;
               run ;

            %end;
            %else %if &proc_type = 1 %then %do;
        
               data rsqu_survey (keep = _rsq_ _depvar_ split );
	              set fitstatistics ;
             
                  where Label1 = "R-Square" ;
 
                  _rsq_    = nValue1;
                  _depvar_ = "&cur_item";	  
                  split    = 0;

               run;

               data adjrsqu_survey (keep = _adjrsq_ _depvar_ split);
	              set fitstatistics ;
          
	              where Label1 = "Adjusted R-Square" ;
        
                  _adjrsq_ = nValue1;
                  _depvar_ = "&cur_item";
                  split    = 0;
	  
               run;

               data rsqu_survey ;
	              merge rsqu_survey(in = a) adjrsqu_survey(in = b);
	              by _depvar_;

                  label
                  _adjrsq_  = "Adjusted R-Square" 
                  _rsq_     = "R-Square"
                  _depvar_  = "Dependent variable"
                  ;

                  attrib subcode length = $40
                  label  = 'Subset Name'
                  ;

                  %if &subset = 3 %then %do ;
                     if &endsub = 1 then subcode = 'GLOBAL' ;
                     else subcode = put ( 1, sub_fmt. ) ;
                  %end ;
                  %else %do ;
                     if &endsub = 1 then subcode = 'GLOBAL' ;
                     else subcode = put ( &sub, sub_fmt. ) ;
                  %end ;

               run;

               proc append base = rsqu_surveyreg
                  data = rsqu_survey force ;
               run ;

            %end;
   
%*-------------------------------------------------------------------------*
|  Predictions for the plan mean observations (where the col_type is 1)    |
|  are the adjustments for the  plans.  Save these in ADJ_PLAN, appending  |
|  the results for each item.                                              |
*--------------------------------------------------------------------------*;

            data a_p1 ( drop = &cur_item col_type) ;
               set predict
                  ( where = ( col_type = 1 )
                   ) ;
               itemno = &item ;
               y      = &cur_item ;
               split  = 0 ;
            run ;

            proc append base = adj_plan
                        data = a_p1 force ;
            run ;

            data a_p2 ( drop = &cur_item col_type) ;
               set predict (where = ( col_type ^= 1 )) ;
               itemno = &item ;
               y      = &cur_item ;
               split  = 0 ;
            run ;

            proc append base = adj_pred
                        data = a_p2 force ;
            run ;

         %end ;

      %end ;

%*-------------------------------------------------------------------------*
|  If there are no adjusters then we only need to create the standardized  |
|  means data set, means = 0.                                              |
*--------------------------------------------------------------------------*;
      %else %do ; 
         proc sort data = ctr_all ;
            by plan ;
         run ;

         proc stdize data = ctr_all
                       out  = ctr_adj
                       method = mean
                      ;
            by plan ;
            var &adj_new &cur_item ;
            weight _wgtstan ;
         run ;

         data adj_std ;
            set ctr_adj ;
            if &cur_item ne . ;
            col_type = 0 ;
         run ;
      %end ;

%*-------------------------------------------------------------------------*
|  Append the residuals for each item into a single data set.              |
|  The residuals will be used to calculate the variance.                   |
*--------------------------------------------------------------------------*;

      data a_r1 ( drop = &cur_item ) ;
         %if &_numadj >= 1 %then %do ;
            set resid ;
         %end ;
         %else %do ;
            set adj_std ;
            yresid = &cur_item ;
         %end ;
         itemno = &item ;
         y      = &cur_item ;

         length item $ 8 ;
         item = "&cur_item" ;
      run ;

      proc append base = adj_resi
                  data = a_r1 force ;
      run ;

   %end ;

%*-------------------------------------------------------------------------*
|  END of Loopover each item                                               |
*--------------------------------------------------------------------------*;

%*-------------------------------------------------------------------------*
|  Using the number of valid responses for each item within plan           |
|  and the item weights, go through the residuals and combine              |
|  for each item.                                                          |
*--------------------------------------------------------------------------*;

   proc sort data = adj_resi ;
      by plan itemno ;
   run ;

   proc sort data = w_comp ;
      by plan itemno ;
   run ;

   data adj_rwn ;
      merge w_comp   ( keep = plan itemno n_ratio itemwgt _wgtplan )
            adj_resi ( keep = plan itemno item yresid  _id  _id_resp split ) ;
      by plan itemno ;
      if yresid = . then yresid = . ;
      else yresid = yresid * itemwgt * _wgtplan * n_ratio ;
   run ;

%*-------------------------------------------------------------------------*
|  *** 21 October 2016 ***                                                 |
|  The code of computing weighted residuals has been modified.             |
*--------------------------------------------------------------------------*;

   data adj_rwn_yresid ;
      merge w_comp   ( keep = plan itemno n_ratio itemwgt _wgtplan )
            adj_resi ( keep = plan itemno item yresid  _id  _wgtresp _id_resp split ) ;
      by plan itemno ;
	 
      if yresid = . then response = 0; 
	  else response = 1;
      
	  if response = 0 then delete;
        
	  w_yresid = _wgtresp*yresid;

   run ;

   %if &_numitem = 1 %then %do;

      proc means data = adj_rwn_yresid
            noprint
            nway ;
        class plan itemno ;
        var w_yresid  _wgtresp;
        output out = sum_yresid
                 (drop = _type_
                         _freq_ )
        sum = sum_w_yresid  sum_wgtresp
          ;
      run ;

      proc sort data = sum_yresid;
         by plan itemno;
      run;

      proc sort data = adj_rwn_yresid;
         by plan itemno;
      run;

      data std_yresid;
         merge adj_rwn_yresid ( in = a ) sum_yresid ( in = b );
         by plan itemno;
      
         w_yresid_bar = sum_w_yresid/sum_wgtresp;
       
	     std_yresid = yresid - w_yresid_bar ;
      run;

      data std_yresid_2;
    
         set std_yresid;

         sq_std_yresid = std_yresid**2;

 	     sq_wgtresp = sum_wgtresp**2;

	     wt_sumsqu = (sq_std_yresid/sq_wgtresp)*_wgtresp**2;
      run; 

      proc means data = std_yresid_2
              noprint
              nway ;
         class plan itemno;
         var wt_sumsqu;
         output out = wt_sumsqu    
                 (drop = _type_
                       _freq_ )
         sum = wt_sumsqu_byitem 
         ;
      run ;

      proc sort data = wt_sumsqu;
         by plan itemno;
      run;

      proc sort data = std_yresid_2;
         by plan itemno;
      run;

      data std_yresid_3 (keep = plan vp_wt);
         merge std_yresid_2(in = a) wt_sumsqu (in = b);
         by plan itemno;

         vp_wt = wt_sumsqu_byitem;
      run;  

      proc sort data = std_yresid_3 out = vp_ind nodupkey;
         by plan ;
      run; 
 
      proc datasets library = work
                nolist
                ;
         delete  std_yresid_2 
                 std_yresid_3
                 wt_sumsqu
                 adj_rwn_yresid
                 sum_yresid
                 ;
      run;

   %end;

   %else %if &_numitem > 1 %then %do;
   
      proc means data = adj_rwn_yresid
                 noprint
                 nway ;
         class plan itemno ;
         var w_yresid  _wgtresp;
         output out = sum_yresid
                      (drop = _type_
                              _freq_ )
         sum = sum_w_yresid  sum_wgtresp
               ;
      run;

      proc sort data = sum_yresid;
         by plan itemno;
      run;

      proc sort data = adj_rwn_yresid;
         by plan itemno;
      run;

      data std_yresid_comp ;
         merge adj_rwn_yresid ( in = a ) sum_yresid ( in = b );
	     by plan itemno;
      
	     w_yresid_bar = sum_w_yresid/sum_wgtresp;/*z bar*/
         std_yresid  = (yresid - w_yresid_bar) ;

         resid_term = itemwgt*response*std_yresid/sum_wgtresp;
      run;

      proc sort data = std_yresid_comp out = comp_id (keep = plan _wgtresp _id)  nodupkey;
         by plan _id _wgtresp;
      run;

      proc means data = std_yresid_comp
                 noprint
                 nway ;
         class plan _id _wgtresp;
         var resid_term;
         output out = resid_by_id    
                      (drop = _type_
                              _freq_ )
         sum = resid_term_by_id 
            ;
      run ;

      proc sort data = resid_by_id;
         by plan _id _wgtresp;
      run;

      data sum_resid_term;
         merge resid_by_id (in = a) comp_id (in = b);
	     by plan _id _wgtresp;

         vp_wt = _wgtresp**2*resid_term_by_id**2;

      run;

      proc means data = sum_resid_term
                 noprint
                 nway ;
         class plan ;
         var vp_wt;
         output out = std_yresid_3  
                     (drop = _type_
                             _freq_ )
         sum =  
            ;
      run ;

      data vp_ind (keep = plan vp_wt);
         set std_yresid_3    ; 
      run;
   
      proc datasets library = work
                    nolist
                  ;
         delete  std_yresid_3 
                 sum_resid_term 
                 resid_by_id
	             std_yresid
                 sum_resid_term
                 adj_rwn_yresid
                 sum_yresid
                 std_yresid_comp
                 comp_id
                 ;
      run;

   %end;

   proc means data = adj_rwn
              noprint
              nway ;
      class plan _id  _id_resp ;
      var yresid ;
      output out = res_4_id
                   (drop = _type_
                           _freq_ )
             sum =
          ;
   run ;

   proc sort data = res_4_id ;
      by plan ;
   run ;

%*-------------------------------------------------------------------------*
| *** 06 April 2008 ***                                                    |
|itemno_max is created below.                                              |
*--------------------------------------------------------------------------*;

   proc means data = adj_rwn noprint nway;
      var itemno;
      class plan;
      output out = adj_rwn2(drop = _type_ _freq_) max(itemno) = itemno_max;
      label
      itemno = "Max of item numbers";
   run;

   data res_4_id_2;
      merge
      res_4_id
      adj_rwn2;
      by plan;
   run;

   data res_4_id;
      set res_4_id_2;
   run;

   data res4plan ( keep = plan sumsqu itemno_max ) ;
      set res_4_id ( drop = _id  _id_resp ) ;
      by plan ;
      retain sumsqu 0 ;

      ysqu = yresid ** 2 ;

      if first.plan then sumsqu = ysqu ;
      else sumsqu = sumsqu + ysqu ;

      if last.plan then do ;
         output ;
      end ;
   run ;

   %if &_numadj >= 1 %then %do ;

%*-------------------------------------------------------------------------*
|  Create a temporary data set for the coeffcients and add the subset code |
*--------------------------------------------------------------------------*;
%*-------------------------------------------------------------------------*
|  *** Update 1-Feb-2017 ***                                               | 
|  &proc_type (1 = PROC SURVEYREG, 0 = PROC REG) is added to the code      |
|  below since these lines only work for PROC REG.                         |
|                                                                          |
|  The code of creating c_&outcome from a work dataset, coeff, is no longer|
|  used since a new work dataset, ouput_p, contains the coefficients, se,  |
|  and pvalue.  (2/1/2017)                                                 |
*--------------------------------------------------------------------------*;

      %if &proc_type = 0 %then %do; 

/* No longer used (1/23/2018)
         proc sort data = coeff ;
            by split ;
         run ;
 
         proc transpose data = coeff
                     out  = c_&outname ;
            by split ;
            var &adj_new ;
            id _depvar_ ;
         run ;

         data c_&outname ;
            set c_&outname ;
            attrib subcode length = $40
                        label  = 'Subset Name'
            ;
         %if &subset = 3 %then %do ;
            if &endsub = 1 then subcode = 'GLOBAL' ;
            else subcode = put ( 1, sub_fmt. ) ;
         %end ;
         %else %do ;
            if &endsub = 1 then subcode = 'GLOBAL' ;
            else subcode = put ( &sub, sub_fmt. ) ;
         %end ;
         run ;

*/
%*-------------------------------------------------------------------------*
|  Create a temporary data set for the R-squared values and add subset cd. |
*--------------------------------------------------------------------------*;

         data rsqu ;
            set coeff ( keep = _depvar_
                               _rsq_
                               _adjrsq_
                               split
                       ) ;
            attrib subcode length = $40
                           label  = 'Subset Name'
            ;

            %if &subset = 3 %then %do ;
               if &endsub = 1 then subcode = 'GLOBAL' ;
               else subcode = put ( 1, sub_fmt. ) ;
            %end ;
            %else %do ;
               if &endsub = 1 then subcode = 'GLOBAL' ;
               else subcode = put ( &sub, sub_fmt. ) ;
            %end ;
         run ;

      %end; /*end &proc_type = 0*/

%*-------------------------------------------------------------------------*
|  *** Update 24-April-2001 ***                                            |
|  In the adjustments data set, combine the adjustments for each item      |
|  using item weights to get composite adjustments.                        |
*--------------------------------------------------------------------------*;
%*-------------------------------------------------------------------------*
|  *** Update 28-March-2012 ***                                            |
|  Adjusted means when even_wgt = 1 are updated. In the case, ADJ_PW data  |
|  set needs to merged by ORIGPLAN and ITEMNO.                             |
*--------------------------------------------------------------------------*;

      %if &_numitem > 1 and &even_wgt = 1 %then %do ;

         proc sort data = adj_pred ;
            by plan itemno ;
         run ;

         data allcases_plan(keep = origplan plan);
            set allcases;
         run; 

         proc sort data = allcases_plan nodupkey;
             by plan;
         run;

         data adj_pred2;
              merge adj_pred(in = a) allcases_plan(in = b);
              by plan;
         run;

         proc sort data = adj_pred2;
              by origplan itemno;
         run;

         proc sort data = mer_wgt ;
              by origplan itemno ;
         run ;

         data adj_pw ;
             merge mer_wgt
                   adj_pred2 ;
             by origplan itemno ;
%*-------------------------------------------------------------------------*
|  *** Update 21-Februrary-2018 ***                                        |
|  The original YHAT is saved as ORG_YHAT in ADJ_PW.                       |
*--------------------------------------------------------------------------*;
             org_yhat = yhat;

             yhat = yhat * itemwgt ;
         run ;

      %end;
      %else %do;

%*-------------------------------------------------------------------------*
|  *** Update 14-February-2018 ***                                         |
|  ORIGPLAN was added to ADJ_PW when &even_wgt parameteres are in (0,2)    |
*--------------------------------------------------------------------------*;
      
         proc sort data = adj_pred ;
            by plan ;
         run ;

         data allcases_plan(keep = origplan plan);
            set allcases;
         run; 

         proc sort data = allcases_plan nodupkey;
             by plan;
         run;

         data adj_pred2;
              merge adj_pred(in = a) allcases_plan(in = b);
              by plan;
         run;

         proc sort data = adj_pred2 ;
            by itemno ;
         run ;

         proc sort data = mer_wgt ;
            by itemno ;
         run ;

         data adj_pw ;
            merge mer_wgt
                  adj_pred2 ;
            by itemno ;

%*-------------------------------------------------------------------------*
|  *** Update 21-Februrary-2018 ***                                        |
|  The original YHAT is saved as ORG_YHAT in ADJ_PW.                       |
*--------------------------------------------------------------------------* ;          
            org_yhat = yhat;

            yhat = yhat * itemwgt ;
         run ;
      %end;

      proc means data = adj_pw
                 noprint
                 nway ;
         class plan split ;
         var yhat ;
         output out = adj4plan
                      (drop = _type_
                              _freq_ )
                sum =
                ;
      run ;

   %end ;

%mend std_data ;

/*
SubName    :  casemix
Created    :  28-Sep-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Calculate the regression coefficients, predictions and residuals for
     each variable item. Apply the item weights to the adjusters and the
     residuals and calculate the sum of the squared residuals.

Usage      :  %casemix
Input      :  No parameteres needed
Output     :  None
Limits     :

---------------------------------------------------------------------------
Updated    :  04-April-2001
by Whom    :  Matthew J. Cioffi
Reason     :
   Add in the weight variable option to the regression procedures.

---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  24-April-2001
by Whom    :  Matthew J. Cioffi
Reason     :
   Have only the two regression procedures in the casmix module.  Move the
   combining of the data sets outside this module into the calling module
   std_data.

---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  22-Nov-2016
by Whom    :  Kayo Walsh
Reason     :
   Add a PROC SURVEYREG option to the regression procesures. Use PROC_TYPE
option. (PROC_TYPE = 1 - use PROC REG, PROC_TYPE = 0 - use PROC SURVEYREG)
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  7-Mar-2017
by Whom    :  Kayo Walsh
Reason     :
   A new weight option for casemix regression coefficients are implemented.
---------------------------------------------------------------------------

*/

%macro casemix ;

   %put  -------------------------------  ;
   %put    Entering CASEMIX Macro  ;
   %put  -------------------------------  ;

   run ;

%*-------------------------------------------------------------------------*
|  Set title and footnotes above row 2.                                    |
*--------------------------------------------------------------------------*;

      title3 "REGRESSION for Subset &sub" ;
      footnote3 ;

%*-------------------------------------------------------------------------*
|  Create a data set of the predicted values, parameter estimates          |
|  (coefficients) and the sums of squares.                                 |
*--------------------------------------------------------------------------*;

%*-------------------------------------------------------------------------*
|  *** Update 14-Feb-2017 ***                                              |
|  Additional weigths of coefficients are created.                         |
*--------------------------------------------------------------------------*;

   proc means data = adj_reg noprint sum ;
      var _wgtresp;
	  class plan;
	  output out = adj_reg_sumwt(drop =  _type_) sum(_wgtresp) = sumwt ;
	  where _id not in ( . ) and col_type = 1;
   run;

   data adj_reg_sumwt;
      set adj_reg_sumwt;
	  where plan not in (.);
   run;
   
   data adj_reg_wtadd ;
      merge adj_reg (in = a) adj_reg_sumwt (in = b);
	  by plan;
	 
	  if a = b;

	  equal_wt        =  _wgtresp/sumwt;
	  samplesize_wt   =  (_wgtresp/sumwt)*_freq_;

   run;

   data adj_std_wtadd ;
      merge adj_std (in = a) adj_reg_sumwt (in = b);
	  by plan;
	 
	  if a = b ;

      equal_wt        =  _wgtresp/sumwt;
	  samplesize_wt   =  (_wgtresp/sumwt)*_freq_;

   run;

%*-------------------------------------------------------------------------*
|  *** Update 22-November 2016 ***                                         |
|  Use PROC SURVEYREG when proc_type = 1. The defalt is PROC REG when      |
|  proc_type = 0.                                                          |
*--------------------------------------------------------------------------*;

   %if &proc_type = 1 %then %do;

      ods listing close;
      ods output ParameterEstimates = coe_pvalue(keep = parameter StdErr probt estimate)
                 fitstatistics = fitstatistics  
                  ;

         proc surveyreg data    = adj_reg_wtadd ;         
	     cluster plan ;  
            model &cur_item = &adj_new /adjrsq solution ;

%*-------------------------------------------------------------------------*
|  *** Update 14-Feb-2017 ***                                              |
|  Additional weigths of coefficients are created.                         |
|                                                                          |
|  0 - Precision: by number of respondents                                 |
|  1 - Equal by unit                                                       |
|  2 - Population: sum of case weights                                     |
*--------------------------------------------------------------------------*;
            
            %if &wt_type = 1 %then %do;

               weight equal_wt ;
 
            %end;
            %else %if &wt_type = 2 %then %do;

               weight _wgtresp ;

            %end;
			%else %do;

               weight samplesize_wt ;
                
            %end; 
            
            output out = predict
            predicted  = yhat
            ;
         run ;
         quit ;
         title3 ;

      ods output close;
      ods listing;

      data coe_pvalue;

         set coe_pvalue;

         rename
         probt     = p_&cur_item
         estimate  = coe_&cur_item
         StdErr    = se_&cur_item
         parameter = variable
         ;
      
         label
         probt     = "p-value: &cur_item"
         estimate  = "Coe: &cur_item"
         StdErr    = "SE: &cur_item"
         parameter = "Variable Name"
         ;
        
      run;

	  proc sort data = coe_pvalue;        
         by variable;
      run;

      %if &item = 1 %then %do ;

         data output_p;
            set coe_pvalue;
         run;

      %end;
      %else %do;
		   
	     proc sort data = output_p;
            by variable;
		 run;

         data output_p;
            merge output_p coe_pvalue;
            by variable;
         run;

      %end;
	

      quit ;
      title3 ;

%*-------------------------------------------------------------------------*
|  Calculate the residuals for the remaining observations. (observed -     |
|  expected).                                                              |
*--------------------------------------------------------------------------*;
      %if &outregre = 0 %then %do;
         
         ods listing close;
         ods output ParameterEstimates = suppress  
                  ;
      %end;

      proc surveyreg data = adj_std_wtadd ;
         cluster plan ;  
         model &cur_item = &adj_new /solution ;

%*-------------------------------------------------------------------------*
|  *** Update 14-Feb-2017 ***                                              |
|  Additional weigths of coefficients are created.                         |
|                                                                          |
|  0 - Precision: by number of respondents                                 |
|  1 - Equal by unit                                                       |
|  2 - Population: sum of case weights                                     |
*--------------------------------------------------------------------------*;
        
         %if &wt_type = 1 %then %do;

            weight equal_wt ;
 
         %end;
         %else %if &wt_type = 2 %then %do;

            weight _wgtresp ;

         %end;
		 %else %do;

            weight samplesize_wt ;
                
         %end; 

         output out      = resid
                residual = yresid
               ;         
      run ;
      quit ;
    
      %if &outregre = 0 %then %do;
      
         ods output close;
         ods listing;
      
      %end;

   %end;
   %else %do;

      ods listing close;
      ods output "Parameter Estimates" = coe_pvalue(keep = variable StdErr probt estimate);

         proc reg data    = adj_reg_wtadd
                  outest  = para_est
                  rsquare
                  adjrsq  
                  ; 
                                  
            model &cur_item = &adj_new / stb ;

%*-------------------------------------------------------------------------*
|  *** Update 14-Feb-2017 ***                                              |
|  Additional weigths of coefficients are created.                         |
|                                                                          |
|  0 - Precision: by number of respondents                                 |
|  1 - Equal by unit                                                       |
|  2 - Population: sum of case weights                                     |
*--------------------------------------------------------------------------*;

    	    %if &wt_type = 1 %then %do;

               weight equal_wt ;
 
            %end;
            %else %if &wt_type = 2 %then %do;

               weight _wgtresp ;

            %end;
			%else %do;

               weight samplesize_wt ;
                
            %end; 

            output out = predict
            predicted  = yhat
            ;

         run ;
         quit ;
         title3 ;

      ods output close;
      ods listing;

         data coe_pvalue;

            set coe_pvalue;

               rename
               probt    = p_&cur_item
               estimate = coe_&cur_item
               StdErr   = se_&cur_item;

               label
               probt    = "p-value: &cur_item"
               estimate = "Coe: &cur_item"
               StdErr   = "SE: &cur_item"
               variable = "Variable Name"
               ;

         run;


         proc sort data = coe_pvalue;
		    by variable;
         run;

         %if &item = 1 %then %do ;

            data output_p;
               set coe_pvalue;
            run;
         %end;
         %else %do;
		   
	        proc sort data = output_p;
		       by variable;
		    run;

            data output_p;
               merge output_p coe_pvalue;
               by variable;	
            run;

         %end;
	
%*-------------------------------------------------------------------------*
|  Calculate the residuals for the remaining observations. (observed -     |
|  expected).                                                              |
*--------------------------------------------------------------------------*;

         proc reg data = adj_std_wtadd

            %if &outregre = 0 %then %do;  

               noprint

            %end;
               ;
            model &cur_item = &adj_new ;
%*-------------------------------------------------------------------------*
|  *** Update 14-Feb-2017 ***                                              |
|  Additional weigths of coefficients are created.                         |
|                                                                          |
|  0 - Precision: by number of respondents                                 |
|  1 - Equal by unit                                                       |
|  2 - Population: sum of case weights                                     |
*--------------------------------------------------------------------------*;
         
            %if &wt_type = 1 %then %do;

               weight equal_wt ;
 
            %end;
            %else %if &wt_type = 2 %then %do;

               weight _wgtresp ;

            %end;
			%else %do;

               weight samplesize_wt ;
                
            %end; 

            output out = resid
            residual   = yresid
               ;
         run  ;
         quit ;

   %end;

   %put  -------------------------------  ;
   %put    Leaving CASEMIX Macro  ;
   %put  -------------------------------  ;
%mend casemix ;


/*
SubName    :  preptest
Created    :  29-Sep-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
   Prepare the plan means for the statistical tests.  Center the
   adjustments so the mean is zero and subtract each adjustment from the
   unadjuated plan mean to get an adjusted mean.  Calculate the sum of
   the squared residuals to get the variance by plan.  Call the STAR macro
   to perform the t-test.  Create permanent data sets.

Usage      :  %preptest
Input      :  No parameteres needed
Output     :  None
Limits     :

---------------------------------------------------------------------------
Updated    :  06-Apr-2008
by Whom    :  Kayo Walsh
Reason     :
   a new computaton of vp is included. Let the original vp as vp_old and keep 
   both in the output when smoothed variance is requested. 
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  11-Feb-2009
by Whom    :  Kayo Walsh
Reason     :
  A macro paramter, smoothing was added into the vp code described above. 
  If smoothing is assigned, then the value turned into the value A in the 
  formula of vp below. The default is 0. 
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  14-Apr-2011
by Whom    :  Kayo Walsh 
Reason     :  
   vp_old in not included in the final output since having two types of vp
   might confuse users.
   
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  25-Jun-2011
by Whom    :  Kayo Walsh 
Reason     :  
   A calculation of y and adj_mean are updated for even_wgt = 1.   
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  24-Feb-2012
by Whom    :  Kayo Walsh 
Reason     :  
   A nested macro for &_numitem > 1 and &even_wgt = 1 are added for computing
adjuted mean.   
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  21-October-2016
by Whom    :  Kayo Walsh 
Reason     :  
   The code of computing a VP is modified. Previously, computing weighted residuals was not
not done properly.
---------------------------------------------------------------------------
*/

%macro preptest () ;

   %put  -------------------------------  ;
   %put    Entering PREPTEST Macro  ;
   %put  -------------------------------  ;

   %local inwgt ;
   %let inwgt = 0 ;

%*-------------------------------------------------------------------------*
|  *** Update 24-April-2001 ***                                            |
|  Copy the centering adjustments to a common named data set.              |
*--------------------------------------------------------------------------*;

    %if &_numadj >= 1 %then %do ;
       data adj_cntr ;
          set adj4plan ;
       run ;
    %end ;

%*-------------------------------------------------------------------------*
|  If there are no adjusters, then create a dummy data set with the        |
|  adjustments set to zero.                                                |
*--------------------------------------------------------------------------*;

   %else %do ;
      data adj_cntr ;
         do i = 1 to &_numopln ;
            plan = i ;
            yhat = 0 ;
            output ;
         end ;
      run ;
   %end ;

%*-------------------------------------------------------------------------*
|  Get a data set with the unadjusted means for each plan.                 |
|  If only one item, then total records will be the same, if more than one |
|  item, then they will be summed to get a single composite mean for each  |
|  plan.                                                                   |
|                                                                          |
|  *** Update 25-June-2011 ***                                             |
|  ov_y_unadj and ov_y_unwgt were added under class statement below.       |
*--------------------------------------------------------------------------*;

   proc means data = unadj_mw
              noprint
              nway ;
      class plan ov_y_unadj ov_y_unwgt;
      var y unwgt_y ;
      output out = uam_plan
                   (drop = _type_
                           _freq_ )
             sum =
          ;
   run ;

%*-------------------------------------------------------------------------*
|  Subtract adjustments from plan means to obtain adjusted plan means.     |
|                                                                          |
|  *** Update 25-June-2011 ***                                             |
|  A calculation of adjust mean for even_wgt = 1 is updated.               |
|                                                                          |
|  *** Update 24-February-2012 ***                                         |
|  A nested macro  &_numitem > 1 and &even_wgt = 1 are added.              |
*--------------------------------------------------------------------------*;

   proc sort data = adj_cntr ;
      by plan ;
   run ;

   proc sort data = uam_plan ;
      by plan ;
   run ;

   data am_plan ( keep = plan
                         adj_mean
                         y
                         unwgt_y
                  rename = ( y       = una_mean
                             unwgt_y = uwt_mean )
                 ) ;
      merge adj_cntr
            uam_plan ;
      by plan ;
      %if &_numitem > 1 %then %do ;
         %if &even_wgt = 1 %then %do ;
            y           = y + ov_y_unadj;
            adj_mean    = y + yhat;
            unwgt_y     = unwgt_y + ov_y_unwgt;
         %end;
         %else %do;
            adj_mean    = y + yhat ;
         %end; 
      %end;
      %else %do;
            adj_mean    = y + yhat ;
      %end;

   run ;


%*-------------------------------------------------------------------------*
|  Calculate sum of squared residuals by plan and multiply the number of   |
|  usable records and divide by the number of usable records - 1.          |
|  This will get the variance by plan.                                     |
*--------------------------------------------------------------------------*;
   proc sort data = plan_n ;
      by plan ;
   run ;

   proc sort data = res4plan ;
      by plan ;
   run ;

   proc sort data = vp_ind;
      by plan ;
   run;

   data var_plan ( keep = plan vp itemno_max usen alln top bottom ) ;
      merge plan_n
            res4plan 
            vp_ind;
      by plan ;
      if usen <= 1 then do ;

         vp = 0 ;
		 
		 vp_oldversion = 0;

         put "CAHPS NOTE:  Number of Usable Records is 0 or 1 for a plan" ;
         put "CAHPS NOTE:  variable vp set to zero" ;
      end ;

      else do;

         vp_oldversion = sumsqu * usen / ( usen - 1 ) ;

         vp = vp_wt;

      end;

  /*smoothing variance - need to be updated(03/06/2017) */

      top        = (usen-1)*vp; /*before (usen-1)*usen*vp;*/
      bottom     = usen - 1;

   run;

   proc datasets library = work
                 nolist
                 ;
       delete  vp_ind
                ;
   run;

   proc means data = var_plan noprint;
      var top bottom;
      output out = var_plan2(drop = _freq_ _type_)
      sum(top bottom) = sum_top2 sum_bottom2;
   run;

   data var_plan3;
      set var_plan2 var_plan;
   run;

   data var_plan4;
      set var_plan3;

      if sum_top2    = . then sum_top2    = 0;
      if sum_bottom2 = . then sum_bottom2 = 0;

      retain sum_top sum_bottom;

         sum_top    = max(sum_top , sum_top2);
         sum_bottom = max(sum_bottom, sum_bottom2);

      if top = . then delete;

      sbar = sum_top/sum_bottom;

      vp_old  = vp;

%*-----------------------------------------------------------------------------------*
|    *** Update in progress 30-October-2017 ***                                      |                       
|  Smoothing variance needs to be updated. The default setting is A = 0, which is    |
|  the same as the original VP.                                                      |
*------------------------------------------------------------------------------------*;

      %if &smoothing > 0 %then %do ;

           A   = &smoothing;
           /*old vp  = (A*sbar/usen + ( usen - 1 )*vp_old)/(A + ( usen - 1 ));*/
		        vp  = (A*sbar + ( usen - 1 )*vp_old)/(A + ( usen - 1 )); /*test*/

      %end ;
      %else %do ;

           A   = 0;
           /*old  vp  = (A*sbar/usen + ( usen - 1 )*vp_old)/(A + ( usen - 1 ));*/
            vp  = (A*sbar + ( usen - 1 )*vp_old)/(A + ( usen - 1 )); /*test*/

      %end ;

      label
         vp      = "Variance of the mean" ;

   run;

   data var_plan;
      set var_plan4;
   run;

%*-------------------------------------------------------------------------*
|  Combine the centered adjustments, adjusted means, plan weights and the  |
|  variance of each plan into one data set that can be used to calculate   |
|  the hypothesis test and subset the plans.                               |
*--------------------------------------------------------------------------*;

   proc sort data = adj_cntr ;
      by plan ;
   run ;

   proc sort data = am_plan ;
      by plan ;
   run ;

   proc sort data = var_plan ;
      by plan ;
   run ;

   proc sort data = plandtal ;
      by oplan_id ;
   run ;

   proc sort data = planwgts ;
      by plan ;
   run ;

   %if &smoothing > 0 %then %do;

      data stemp ( keep = plan
                       planname
                       _wgtplan
                       yhat
                       uwt_mean
                       una_mean
                       adj_mean
                       usen
                       alln
                       vp
                       subcode
                       sub_id
                       splan_id
                 ) ;
         merge adj_cntr
              am_plan
              var_plan
              planwgts
              plandtal ( keep   = oplan_id
                                subcode
                                sub_id
                                splan_id
                        rename = ( oplan_id = plan )
                        %if &subset = 3 %then %do ;
                           where = ( sub_id = &sub )
                        %end ;
                       )
              end = eodata
              ;
         by plan ;

         length planname $ 40 ;
         planname = put ( plan, oplanfmt. ) ;

         %if &subset = 3 %then %do ;
            plan = splan_id ;
         %end ;

      run ;
   %end;
   %else %do;

      data stemp ( keep = plan
                       planname
                       _wgtplan
                       yhat
                       uwt_mean
                       una_mean
                       adj_mean
                       usen
                       alln
                       vp
                       subcode
                       sub_id
                       splan_id
                 ) ;
         merge adj_cntr
               am_plan
               var_plan
               planwgts
               plandtal ( keep   = oplan_id
                                   subcode
                                   sub_id
                                   splan_id
                          rename = ( oplan_id = plan )

                          %if &subset = 3 %then %do ;
                             where = ( sub_id = &sub )
                          %end ;
                         )
         end = eodata
            ;
         by plan ;

         length planname $ 40 ;
         planname = put ( plan, oplanfmt. ) ;

         %if &subset = 3 %then %do ;
            plan = splan_id ;
         %end ;
      run ;
   %end;

%*-------------------------------------------------------------------------*
|  Do the t-tests, determine significance of the difference between means. |
*--------------------------------------------------------------------------*;

   %star ( stemp, over_all, star_all, &_numopln,  0 ) ;

%*-------------------------------------------------------------------------*
|  If the means need to be centered with each subset then                  |
|  loop through each subset to calculate the statistics for each.          |
|  Keep the over_all data set from above to have the global f-statistic    |
|  but delete star_all because we want the test results by subset only.    |
*--------------------------------------------------------------------------*;

   %if &subset = 2 %then %do ;
      proc datasets library = work
                    nolist
                  ;
         delete
            star_all
         ;
      run ;
      quit ;


      %do i = 1 %to &_num_sub ;
         data stemp2 ;
            set stemp ;
            where sub_id = &i ;
            plan = splan_id ;
         run ;

         %let _ns     = _&i.set ;
         %star ( stemp2, over_i, star_i, &&&_ns,  1 ) ;

%*-------------------------------------------------------------------------*
|  Concatenate the overall and plan level summary files to create one      |
|  overall data set and one plan level data set.                           |
*--------------------------------------------------------------------------*;

         proc append base = over_all
                     data = over_i ;
         run ;

         proc append base = star_all
                     data = star_i ;
         run ;

      %end ;
   %end ;

%*-------------------------------------------------------------------------*
|  If data is stratified and combining strata is desired then create the   |
|  compressed data set using the stratification weights.                   |
*--------------------------------------------------------------------------*;

   %if &smoothing > 0 and &wgtdata = 2 %then %do ;
      %let inwgt = 1 ;

      proc sort data = stratwgt ;
         by oplan_id ;
      run ;

      proc sort data = stemp ;
         by plan ;
      run ;

      data w_stemp ;
         merge stemp    ( rename = (plan = oplan_id))
               stratwgt ( rename = (nplan_id = plan)) ;
         by oplan_id ;

         array allvar  adj_mean  una_mean uwt_mean  vp ; 
         do i = 1 to dim (allvar) ;
            allvar [i] = allvar [i] * stratwgt ;
         end ;
         vp     = vp * stratwgt ; 
         
         length planname $ 40 ;
         planname = put (plan, nplanfmt.) ;
      run ;

      proc means data = w_stemp
                 nway
                 noprint ;
         class plan planname ;
         var alln  usen  adj_mean  una_mean uwt_mean vp _wgtplan ; 
         output out = wstemp ( drop = _type_  _freq_ )
                sum =
         ;
      run ;

      proc sort data = wstemp ;
         by plan ;
      run ;

      proc sort data = plandtal ( keep   = nplan_id
                                           subcode
                                           sub_id
                                           splan_id )
                out = pd_temp
                nodupkey
                        ;
         by nplan_id ;
      run ;

      data wstemp ( keep = plan
                           planname
                           _wgtplan
                           uwt_mean
                           una_mean
                           adj_mean
                           usen
                           alln
                           vp
                           sub_id
                           splan_id
                           subcode
                    ) ;
         merge wstemp ( in = ws )
               pd_temp ( rename = ( nplan_id = plan )
                          %if &subset = 3 %then %do ;
                             where = ( sub_id = &sub )
                          %end ;
                         ) ;

         by plan ;
         if ws ;
      run ;

%*-------------------------------------------------------------------------*
|  Use the STAR macro to calculate the hypothesis test and print the       |
|  reports using the strata weights.                                       |
*--------------------------------------------------------------------------*;
         %star ( wstemp, overwall, starwall, &_numnpln,  2 ) ;

   %end ;

   %else %if &smoothing = 0 and &wgtdata = 2 %then %do ;
      %let inwgt = 1 ;

      proc sort data = stratwgt ;
         by oplan_id ;
      run ;

      proc sort data = stemp ;
         by plan ;
      run ;

      data w_stemp ;
         merge stemp    ( rename = (plan = oplan_id))
               stratwgt ( rename = (nplan_id = plan)) ;
         by oplan_id ;

         array allvar  adj_mean  una_mean uwt_mean  vp ; 
         do i = 1 to dim (allvar) ;
            allvar [i] = allvar [i] * stratwgt ;
         end ;
         vp     = vp * stratwgt ; 
         
         length planname $ 40 ;
         planname = put (plan, nplanfmt.) ;
      run ;

      proc means data = w_stemp
                 nway
                 noprint ;
         class plan planname ;
         var alln  usen  adj_mean  una_mean uwt_mean vp _wgtplan ; 
         output out = wstemp ( drop = _type_  _freq_ )
                sum =
         ;
      run ;

      proc sort data = wstemp ;
         by plan ;
      run ;

      proc sort data = plandtal ( keep   = nplan_id
                                           subcode
                                           sub_id
                                           splan_id )
                out = pd_temp
                nodupkey
                        ;
         by nplan_id ;
      run ;

      data wstemp ( keep = plan
                           planname
                           _wgtplan
                           uwt_mean
                           una_mean
                           adj_mean
                           usen
                           alln
                           vp
                           sub_id
                           splan_id
                           subcode
                           
                    ) ;
         merge wstemp ( in = ws )
               pd_temp ( rename = ( nplan_id = plan )
                          %if &subset = 3 %then %do ;
                             where = ( sub_id = &sub )
                          %end ;
                         ) ;

         by plan ;
         if ws ;
      run ;

%*-------------------------------------------------------------------------*
|  Use the STAR macro to calculate the hypothesis test and print the       |
|  reports using the strata weights.                                       |
*--------------------------------------------------------------------------*;
         %star ( wstemp, overwall, starwall, &_numnpln,  2 ) ;

   %end ;

%mend preptest ;

/*
SubName    :  star
Created    :  30-July-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
   Used by the CAHPS macro to perform hypothesis tests on the data and
   to produce reports and data sets of the overall results and results
   by plan.

Usage      : %star (indata  ,
                    overdsn ,
                    stardsn ,
                    max_plan ,
                    subsetwt )

Input      :
   indata   = The input data set
   over_dsn = data set name to hold the overall statistical information
   stardsn  = data set name to hold the "star" information used in the
              reports.
   max_plan = Maximum number of plans in the data set.
   subsetwt = This identifies the type of indata set. It provides different type 
              of subset based on the &subset parameter.
              

Output     :  Output returned from module
Limits     :  Note any known limitations

---------------------------------------------------------------------------
Updated    :  23-April-2003
by Whom    :  Matthew J. Cioffi
Reason     :
   Add in the plan level weights to get a weighted overall mean and apply
   these to the statistical tests.

   Add the unweighted and unadjusted means to the sa* data set and text
   output.

---------------------------------------------------------------------------
Updated    :  6-March-2017
by Whom    :  Kayo Walsh
Reason     :
   Add a parameter to assign three different weight options when computing 
the overall mean. 

---------------------------------------------------------------------------
Updated    :  6-Feb-2018
by Whom    :  Kayo Walsh
Reason     :
   A way of calculating a composite mean is updated. Each overall item mean           
gets calculated first. Then the composite mean is calculated with the item weight. 
The updated results will be replaced with the old ones.   
---------------------------------------------------------------------------
Updated    :  17-May-2018
by Whom    :  Kayo Walsh
Reason     :
   Update outputs for composite unadjusted means. Also, unadjusted and unweighted
unadjusted composite means need to be readjusted when missing or small sample
size in the composite items.   
---------------------------------------------------------------------------
Updated    :  22-May-2018
by Whom    :  Kayo Walsh
Reason     :
   Update composite scores in indata1 dataset for each subset parameter.  
---------------------------------------------------------------------------

*/

%macro star (indata  ,
             overdsn ,
             stardsn ,
             max_plan ,
             subsetwt ) ;

   %put  -------------------------------  ;
   %put    Entering STAR Macro  ;
   %put  -------------------------------  ;

   %global dfe
           dfr
           overallf
           overallp
           ov_mean
   ;

%*-------------------------------------------------------------------------*
|  Calculate the overall unadjusted and adjusted means of the plan means.  |
*--------------------------------------------------------------------------*;

%*-------------------------------------------------------------------------*                                                                          |
|  *** Update 10-Feb-2017 ***                                              |
|  VARFDEF option is added to PROC MEANS so that weighted standard         |
|  deviation gets computed correctly.                                      |            
*--------------------------------------------------------------------------*;
%*-------------------------------------------------------------------------*                                                                          |
|  *** Update 6-Mar-2017 ***                                               |
|  &overall_wt is implemented. There are three wt options: 0-wt by number  |
|  of respondents, 1-wt equally by unit, and 2-wt by sum of case weights.  | 
*--------------------------------------------------------------------------*;

   proc sort data = &indata
             out  = planstar ;
      by plan ;
   run ;

%*-------------------------------------------------------------------------*                                                                          |
|  *** Update 6-Feb-2018 ***                                               |
|  OV_WT_EQUAL = 1 is added to PLANSTAR dataset.  This equal weight is used| 
|  for the overall mean calaculation.                                      |
*--------------------------------------------------------------------------*;

   data planstar;
      set planstar;
      ov_wt_equal = 1;
   run;
   
   proc means data = planstar noprint nway
      vardef = wgt 
      ;
      var una_mean
          adj_mean
          uwt_mean
      ;

      %if &overall_wt = 0 %then %do;

	     weight usen ;

      %end;
      %if &overall_wt = 1 %then %do;
 
         weight ov_wt_equal ;

      %end; 
      %else %if &overall_wt = 2 %then %do;
 
         weight _wgtplan ;

      %end; 
      
      output out = ov_mean(drop = _type_
                           _freq_ )
         mean = ov_unadj
                ov_adj
                ov_unwgt
                ;
   run ;
   
%*-------------------------------------------------------------------------*
|  Calculate the difference between the two means then readjust the        |
|  centered adjusted means by the difference before doing the tests.       |
*--------------------------------------------------------------------------*;

   data ov_mean ;
      set ov_mean ;
      ov_diff  = ov_unadj - ov_adj ;
      call symput ("constant", trim ( left ( put ( ov_diff, 14.8 )))) ;
   run ;

   data indata1 ( drop   = ov_adj
                           ov_diff
      rename = ( ov_unadj = ov_mean )) ;

%*-------------------------------------------------------------------------*
|  Create a copy of the overall mean record for each plan.                 |
*--------------------------------------------------------------------------*;

      if _n_ = 1 then set ov_mean ;

      set planstar ;
      adj_mean = adj_mean + ov_diff ;
   run ;

%*------------------------------------------------------------------------------*                                                                          |
|  *** Update 6-Feb-2018 ***                                                    |
|  A way of calculating a composite mean is updated. Each overall item mean     |        
|  gets calculated first. Then the composite mean is calculated with the item   |
|  weight. The updated results will be replaced with the old ones.              |                                                              | 
*-------------------------------------------------------------------------------*;
%*------------------------------------------------------------------------------*                                                                          |
|  *** Update 17-May-2018 ***                                                   |
|  A way of calculating a composite mean for unadjusted case is updated.        |        
*-------------------------------------------------------------------------------*;

   %if &_numitem > 1 %then %do;
      %if  &_numadj = 0 %then %do;
     
         proc sort data = itemnstack out = itemstack_temp(keep = origplan itemno item_n) ;
	        by origplan itemno;
	     run;

	     proc sort data = unadj_mw out = unadj_mw(keep = origplan itemwgt itemno org_unwgt_y 
                                            org_yscore _wgtplan plan);
	        by origplan itemno;
         run;

         data ov_comp; 
            merge itemnstack(in = a) 
                  unadj_mw(in = b);
            by origplan itemno;
            if a = b;

            rename item_n = usen_item;

		    adj_mean_item_pre = org_yscore; /*y score only*/

            ov_wt_equal = 1;
            
         run;

%*------------------------------------------------------------------------------*                                                                          |
|  *** Update 24-May-2018 ***                                                   |
|  Add Sub ID code information used for a SUBSET parameter.                     |        
*-------------------------------------------------------------------------------*;

         proc sort data = ov_comp;
            by origplan;
         run;

         proc sort data = plandtal out = plandtal2(keep = origplan newplan sub_id subcode);
            by origplan;
         run;

         data ov_comp;
            merge ov_comp (in = a)
                  plandtal2 (in = b);
	        by origplan;
        
		    planname = origplan;
         run;

  
         %if &wgtdata = 2 and &subsetwt = 1 %then %do;
           
	        proc sort data = indata1;
		       by sub_id planname;
            run;

	        proc sort data = ov_comp;
		       by sub_id planname;
		    run;

		    data ov_comp;
		       merge ov_comp (in = a)
			         indata1 (in = b);
               by sub_id planname;
			   if a = b;
		    run;

         %end;

      %end;
      %else %if &_numadj >=1 %then %do ;

         data adj_pw_comp(keep = plan origplan itemno org_yhat yhat usen_item);
            set adj_pw;
            usen_item = _freq_;
            where yhat not in (.);
         run;

         proc sort data = adj_pw_comp;
            by origplan itemno;
         run;

         proc sort data = unadj_mw out = unadj_mw_comp;
            by origplan itemno;
         run;

         data ov_comp; 
            merge adj_pw_comp(in = a) 
                  unadj_mw_comp(in = b);
            by origplan itemno;
            if a = b;

            adj_mean_item_pre = org_yscore + org_yhat;

            ov_wt_equal = 1; 
         run;

%*------------------------------------------------------------------------------*                                                                          |
|  *** Update 24-May-2018 ***                                                   |
|  Add Sub ID code information used for a SUBSET parameter.                     |        
*-------------------------------------------------------------------------------*;

         proc sort data = ov_comp;
            by origplan;
         run;

         proc sort data = plandtal out = plandtal2(keep = origplan newplan sub_id subcode);
            by origplan;
         run;

         data ov_comp;
            merge ov_comp (in = a)
                  plandtal2 (in = b);
	        by origplan;
        
		    planname = origplan;
         run;

         %if &wgtdata = 2 and &subsetwt = 1 %then %do;
           
	        proc sort data = indata1;
		       by sub_id planname;
            run;

	        proc sort data = ov_comp;
		       by sub_id planname;
		    run;

		    data ov_comp;
		       merge ov_comp (in = a)
			         indata1 (in = b);
               by sub_id planname;
			   if a = b;
		    run;
 
         %end;

      %end;  	 

%*------------------------------------------------------------------------------*                                                                          |
| Calculate mean by item first.                                                 |                                                           | 
*-------------------------------------------------------------------------------*;

      proc means data = ov_comp noprint nway vardef = wgt;

         class itemno;
        
         var adj_mean_item_pre org_yscore  ;

         %if &overall_wt = 1 %then %do;
 
            weight ov_wt_equal;

         %end; 
         %else %if &overall_wt = 2 %then %do;
 
            weight _wgtplan;

         %end; 
         %else %do;
 
            weight usen_item;

         %end;
         
         output out = ov_comp_item mean = ov_adj_mean_item 
                                             ov_una_mean_item ;
      run;

%*------------------------------------------------------------------------------*                                                                          |
| Calculate unweighted unadjusted mean                                          |                                                           | 
*-------------------------------------------------------------------------------*;

      proc means data = ov_comp noprint nway vardef = wgt;

         class itemno;
         
         var org_unwgt_y ;
         
         output out = ov_comp_item_unwgt mean = ov_unwgt_mean_item;

      run;
    
      proc sort data = ov_comp_item_unwgt;

         by itemno;

      run;

      proc sort data = ov_comp_item;

         by itemno;

      run;

      proc sort data = ov_comp;

         by itemno;

      run;

      data ov_comp_item_compute (drop = _type_ _freq_);

         merge ov_comp_item(in = a)
               ov_comp(in = b)
               ov_comp_item_unwgt(in = c) ;
	     by itemno;
         
         diff_item  = ov_una_mean_item - ov_adj_mean_item;
         
	     /*Readjust adjusted mean by item*/
         adj_mean_item_new = adj_mean_item_pre + diff_item;  

         /*Ajustment for units in which cotain missing item*/
	     diff_mean = adj_mean_item_new - ov_una_mean_item;
		 
		 /*Unwgt for units in which cotain missing item*/
         diff_mean_unwgt = org_unwgt_y - ov_unwgt_mean_item;
 
         /*Unajustment for units in which cotain missing item*/
	     diff_mean_una = org_yscore - ov_una_mean_item;
        
      run;

      %if &even_wgt = 1 %then %do;

         proc sort data = ov_comp_item_compute 

            out = ov_comp_itemwt
            (keep = itemno ov_una_mean_item ov_unwgt_mean_item ov_wt_equal sub_id subcode) 
            nodupkey;

            by itemno ov_una_mean_item;

         run;

      %end;
      %else %do;

         proc sort data = ov_comp_item_compute 

            out = ov_comp_itemwt
            (keep = itemno itemwgt ov_una_mean_item ov_unwgt_mean_item sub_id subcode) 
            nodupkey;

            by itemno itemwgt ov_una_mean_item;

         run;

      %end;

%*------------------------------------------------------------------------------*                                                                          |
| Calculate overall composite mean                                              |                                                           | 
*-------------------------------------------------------------------------------*;

      proc means data = ov_comp_itemwt noprint nway vardef = wgt;

	     var ov_una_mean_item ov_unwgt_mean_item ; 
	     
	     %if &even_wgt = 1 %then %do;

            weight ov_wt_equal;

         %end;
         %else %do;

	        weight itemwgt;

	     %end;

         output out = ov_comp_itemwgt_final  
         mean = ov_mean_comp ov_mean_comp_unwgt;
      run;
  
      /*Calculate comp adjusted mean*/
      proc means data = ov_comp_item_compute noprint nway ;
         class planname;
         weight itemwgt;

         var adj_mean_item_new 
             org_yscore 
             org_unwgt_y 
             diff_mean
			 diff_mean_una
			 diff_mean_unwgt
             ;

         output out = mean_comp(drop = _type_)  
                mean = adj_mean_comp 
                       una_mean_comp 
                       uwt_mean_comp 
                       diff_mean_comp
					   diff_mean_comp_una
					   diff_mean_comp_unwgt
               ;
      run; 

	  proc means data = ov_comp_item_compute noprint nway ;
         class planname;
         var usen_item
             ;
         output out = min_usen_comp(drop = _type_)  
             min =  min_usen_item
             ;
      run;

      data mean_comp;
         merge mean_comp(in = a)
               min_usen_comp(in = b);
         by planname;
	  run;
 
      data mean_comp;
         set mean_comp;
         comp_merge = 1;

         %if &even_wgt = 1 %then %do;

            even_wt_min_n = &k;

         %end;
         %else %do;

		    even_wt_min_n = 1;

		 %end;

      run;

      data ov_comp_itemwgt_final(drop = _freq_);
	     set ov_comp_itemwgt_final;

         comp_merge = 1;

	  run;
     
      data comp_mean_info;
         merge mean_comp 
               ov_comp_itemwgt_final;

         by comp_merge;

		 old_adj_mean = adj_mean_comp;

         num_item = &_numitem;

		 if _freq_ < num_item or min_usen_item < even_wt_min_n then do; 
         
		     adj_mean_comp = diff_mean_comp + ov_mean_comp;

             una_mean_comp = diff_mean_comp_una + ov_mean_comp;

             uwt_mean_comp = diff_mean_comp_unwgt + ov_mean_comp_unwgt;

		 end;
		 
      run;

	  proc sort data = comp_mean_info;
         by planname;
      run;
     
      proc sort data = indata1;
         by planname;
      run;

      proc sort data = stratwgt ;
         by oplan_id ;
      run    ;
      proc sort data = plandtal 
         out = plandtal2 (keep = origplan nplan_id splan_id oplan_id
                                         subcode newplan sub_id);
         by oplan_id ;
      run   ;

      data planinfo;
         merge stratwgt (in = a)
               plandtal2 (in = b);
         by oplan_id;

         rename 
         origplan = planname;

      run;
      proc sort data = planinfo;
         by planname;
      run;
      proc sort data = comp_mean_info ;
         by planname ;
      run ;

      %if &wgtdata = 2 %then %do; 
         %if &subsetwt = 2 %then %do;

            data comp_mean_info2(drop = i) ;
               merge comp_mean_info  
                     planinfo   ;
               by planname ;

               array allvar  adj_mean_comp  una_mean_comp uwt_mean_comp ;                
               do i = 1 to dim (allvar) ;
                  allvar [i] = allvar [i] * stratwgt ;
               end ;

            run ;

            proc means data = comp_mean_info2
               nway noprint ;
               class newplan ;
               var adj_mean_comp  una_mean_comp uwt_mean_comp  ;
               output out = comp_mean_info3 ( drop = _type_  _freq_ )
               sum =
               ;
            run ;
   
            /*overall mean*/
            proc sort data = comp_mean_info2 
                    out = ov_mean_info (keep = newplan ov_mean_comp) nodupkey;
            by newplan ;
            run ;

            data ov_mean_info;
               set ov_mean_info;
               rename
                  newplan = planname;
            run;

            data comp_mean_info3;
               set comp_mean_info3;
               rename
               newplan = planname;
            run;

            data indata1;
               merge indata1 (in = a)
                  comp_mean_info3 (in = b)
                  ov_mean_info (in = c);
               by planname;
               if a = b = c;

               old_adj_mean = adj_mean;
               old_ov_mean  = ov_mean;
               adj_mean     = adj_mean_comp;
               una_mean     = una_mean_comp;
               uwt_mean     = uwt_mean_comp;
               ov_mean      = ov_mean_comp;

            run;

         %end;
         %else; %if &subsetwt = 1 %then %do;

            data comp_mean_info4;
               merge comp_mean_info  
                     planinfo   ;
               by planname ;
            run ;

            data indata1(drop = _freq_ _type_);
               merge indata1 (in = a)
                  comp_mean_info4 (in = b);
               by planname sub_id;
               if a = b;

               old_adj_mean = adj_mean;
               old_ov_mean  = ov_mean;
               adj_mean     = adj_mean_comp;
               una_mean     = una_mean_comp;
               uwt_mean     = uwt_mean_comp;
               ov_mean      = ov_mean_comp;

            run;
      	  
         %end;
         %else %if &subsetwt = 0 %then %do;

            data indata1(drop = _freq_ _type_);
               merge indata1 (in = a)
                     comp_mean_info (in = b);
               by planname;
               if a = b;

               old_adj_mean = adj_mean;
               old_ov_mean  = ov_mean;
               adj_mean     = adj_mean_comp;
               una_mean     = una_mean_comp;
               uwt_mean     = uwt_mean_comp;
               ov_mean      = ov_mean_comp;

            run;

         %end;

      %end;
	  %else %if &wgtdata = 1 %then %do;

      data indata1(drop = _freq_ _type_);
            merge indata1 (in = a)
                  comp_mean_info (in = b);
            by planname;
            if a = b;

            old_adj_mean = adj_mean;
            old_ov_mean  = ov_mean;
            adj_mean     = adj_mean_comp;
            una_mean     = una_mean_comp;
            uwt_mean     = uwt_mean_comp;
            ov_mean      = ov_mean_comp;

      run;
	  %end;
	  
   %end;

%*-------------------------------------------------------------------------*
|  Calculate the grand mean, gm,  for use in the F-tests.                  |
*--------------------------------------------------------------------------*;

   data gm ( keep = gm
                    ov_mean
                    rows
                    ntot ) ;
      set indata1  end = eodata ;

      retain ntot sum1 sum2 0 ;

%*-------------------------------------------------------------------------*
|  Sum up the total analyzed patients from each plan, store in ntot.       |
*--------------------------------------------------------------------------*;

      ntot = ntot + usen ;

%*-------------------------------------------------------------------------*
|  Sum up the adjusted means divided by the variance of the plan and       |
|  sum up the inverse of the variance of the plan.                         |
*--------------------------------------------------------------------------*;

      if vp = 0 then do ;
         sum1 = sum1 ;
         sum2 = sum2 ;
      end ;
      else do ;
         sum1 = sum1 + adj_mean * _wgtplan / vp ;
         sum2 = sum2 + _wgtplan / vp ;
      end ;

%*-------------------------------------------------------------------------*
|  After all the data is summed up, calculate the grand mean.              |
|  Creates a data set with one record.                                     |
*--------------------------------------------------------------------------*;

      if eodata then do ;
         rows = _n_ ;
         if sum2 = 0 then gm = . ;
         else             gm = sum1 / sum2 ;
         call symput ("gm", trim ( left ( put ( gm, 14.8 )))) ;
         output ;
      end ;
   run ;

%*-------------------------------------------------------------------------*
|  Calculate F statistic and Degrees of Freedom (DF) for overall tests.    |
*--------------------------------------------------------------------------*;

   data &overdsn ( keep = dfr
                          dfe
                          gm
                          overallf
                          overallp
                          ov_mean
                          ntot
                          subcode
                   ) ;

%*-------------------------------------------------------------------------*
|  Create a copy of the grand mean record for each plan.                   |
*--------------------------------------------------------------------------*;

      if _n_ = 1 then set gm ;

      set indata1  end = eodata ;

      attrib   dfr       format = comma8.0    label = 'DFR'
               dfe       format = comma10.0   label = 'DFE'
               overallf  format = 8.4         label = 'F-Statistic'
               overallp  format = 8.4         label = 'P-Value'
               gm        format = 8.4         label = 'Grand Mean'
               ov_mean   format = 8.4         label = 'Overall Mean'
               ntot      format = comma10.0
                         label  = '# of Respondents Analyzed'
               subcode   label  = 'Subset Name'
      ;

%*-------------------------------------------------------------------------*
|  Sum up the f for each plan, where f = the (adjusted mean - grand mean)  |
|  squared divided by the variance of the plan.                            |
*--------------------------------------------------------------------------*;
      retain f 0 ;
      if vp ne 0 then
         f = f + ( adj_mean - gm ) ** 2 / vp ;

%*-------------------------------------------------------------------------*
|  After all the data is summed up, calculate the various overall          |
|  statistics and create a data set with one record.  If the overall p-    |
|  value is less than 0.0001 than make the p-value = 0.0001.               |
|  **** UPDATED 15-Apr-2002 UPDATED ****                                   |
|    If the DFE (denominator degrees of freedom) is computed to be less    |
|    than zero, then force it to be 1 so the computation will work.        |
*--------------------------------------------------------------------------*;

      if eodata then do ;

%*-------------------------------------------------------------------------*
|  Compute numerator degrees of freedom                                    |
*--------------------------------------------------------------------------*;
         dfr = rows - 1 ;
%*-------------------------------------------------------------------------*
|  Compute denominator degrees of freedom                                  |
*--------------------------------------------------------------------------*;

         if &adultkid = 1 then dfe = ntot - rows - &numadj_2 ;
         else                  dfe = ntot - rows - &_numadj ;
         if dfe <= 0 then dfe = 1 ;

         if dfr ne 0 then overallf = f / dfr ;
         else             overallf = . ;

         overallp = 1 - probf (overallf, dfr, dfe) ;
         if . < overallp < 0.0001 then overallp = 0.0001 ;

         if &max_plan = &_allpln and
            &subset ne 3 then do ;
            subcode = 'GLOBAL' ;
         end ;
         else if &inwgt = 1 and
              &max_plan = &_numnpln then do ;
            subcode = 'GLOBAL' ;
         end ;
         output ;

         call symput ("dfe", compress ( put (dfe, 10.))) ;
         call symput ("dfr", compress ( put (dfr, 10.))) ;
         call symput ("overallf", compress ( put (overallf, 10.4))) ;
         call symput ("overallp", put (overallp, 6.4)) ;
         call symput ("ov_mean", put (ov_mean, 8.4)) ;
         call symput ("subcode", put (subcode, $40.)) ;
      end ;

   run ;

%*-------------------------------------------------------------------------*
|  Print a copy of the overall statistics to the log file.                 |
*--------------------------------------------------------------------------*;

   %put dfe      = &dfe ;
   %put dfr      = &dfr ;
   %put overallf = &overallf ;
   %put overallp = &overallp ;
   %put ov_mean  = &ov_mean ;
   %put subcode  = &subcode ;

%*-------------------------------------------------------------------------*
|  Perform T-test separately for each plan and check for statistically     |
|  significant and meaningful difference.                                  |
|  **** UPDATED 13-Jan-2010 UPDATED ****                                   |
|  A variance of the differnce of a plan mean and the overall mean is      |
|  modified.                                                               |
*--------------------------------------------------------------------------*;

   %put  max plan = &max_plan ;

   data ttest ( keep = plan
                       delta
                       se
                       cl95
                       meaning
                       ov_mean
                       vi
                       vo
                       plan_wgt
                       t
               ) ;
%*-------------------------------------------------------------------------*
|  Create a copy of the overall mean record for each plan.                 |
|  Sum up the total number of plans and the plan weights.                  |
*--------------------------------------------------------------------------*;

      if _n_ = 1 then set ov_mean ;

      set indata1   end = eodata ;

      retain all_vp nrows sum_pwgt 0 ;

      nrows = nrows + 1 ;
      sum_pwgt = sum_pwgt + _wgtplan ;

%*-------------------------------------------------------------------------*
|  Store the variance for each plan.                                       |
|  Sum up the total of all plan variances.                                 |
*--------------------------------------------------------------------------*;

      array vis     [ &max_plan ] _temporary_ ;
      all_vp      = all_vp + vp * _wgtplan**2 ;
      vis [ _n_ ] = vp ;

%*-------------------------------------------------------------------------*
|  Store the difference of the plan mean from the overall mean for each    |
|  plan.                                                                   |
*--------------------------------------------------------------------------*;

      array deltas  [ &max_plan ] _temporary_ ;
      deltas [ _n_ ]  = adj_mean - ov_mean ;

%*-------------------------------------------------------------------------*
|  Store the weights for each plan.                                        |
*--------------------------------------------------------------------------*;

      array wgts    [ &max_plan ] _temporary_ ;
      wgts   [ _n_ ]  = _wgtplan ;

%*-------------------------------------------------------------------------*
|  Store the plan adjusted mean for each plan.                             |
*--------------------------------------------------------------------------*;

      array centers [ &max_plan ] _temporary_ ;
      centers [ _n_ ] = adj_mean ;

%*-------------------------------------------------------------------------*
|  Determine the minimum distance of the overall mean to the minimum and   |
|  maximum possible responses.                                             |
*--------------------------------------------------------------------------*;

      array mindis [ &max_plan ] _temporary_ ;
      mindis [ _n_ ] = min ( ov_mean - &min_resp, &max_resp - ov_mean ) ;

%*-------------------------------------------------------------------------*
|  After all the data is summed up, calculate the various statistics       |
|  for each plan.                                                          |
*--------------------------------------------------------------------------*;

      if eodata then do ;
         do plan = 1 to &max_plan ;
        
            plan_wgt = wgts [ plan ] ;
 
            vi       = vis [ plan ]*(1 - (2*wgts [ plan ])/sum_pwgt) ;

            vo       = all_vp/sum_pwgt**2 ;
 
            se       = sqrt ( vi + vo ) ;

            cl95    = 1.96 * se ;
            delta   = deltas [ plan ] ;

            if se = 0 then      t = 0 ;
            else if se = . then t = 0 ;
            else                t = delta / se ;

            abst    = abs ( t ) ;
            cont_p  = ( 1 - probt ( abst, &dfe )) * 2 ;
            mindist = mindis [ plan ] ;
            pdis    = mindist * &change ;
            planabs = abs ( delta ) ;

%*-------------------------------------------------------------------------*
|  Substantively meaningful difference based on min distance * &change     |
*--------------------------------------------------------------------------*;
            if centers [ plan ] < ov_mean and
               planabs >= pdis then meaning = -1 ;
            else if centers [ plan ] >= ov_mean and
                    planabs >= pdis then meaning = 1 ;
            else meaning = 0 ;

%*-------------------------------------------------------------------------*
|  Difference between the adjusted mean and overall mean                   |
*--------------------------------------------------------------------------*;

            if centers [ plan ] < ov_mean and
               planabs >= &meandiff then meandiff = -1 ;
            else if centers [ plan ] >= ov_mean and
                    planabs >= &meandiff then meandiff = 1 ;
            else meandiff = 0 ;

%*-------------------------------------------------------------------------*
|  Creates 1, 2 and 3 stars based on results of p-values and the results   |
|  of the substantive mean difference and absolute mean difference         |
*--------------------------------------------------------------------------*;

            if cont_p < &pvalue and
               meaning  = -1    and
               meandiff = -1    then meaning = 1 ;
            else if cont_p < &pvalue and
                    meaning  = 1     and
                    meandiff = 1     then meaning = 3 ;
            else meaning = 2 ;

            output ;
         end ;
      end ;
   run;

   proc sort data = indata1 ;
      by plan ;
   run ;

   %if &smoothing > 0 %then %do;

      data &stardsn ( drop = plan ) ;
         merge ttest   ( keep = plan
                                delta
                                se
                                cl95
                                meaning
                                plan_wgt
                        )
               indata1 ( keep = plan
                                planname
                                subcode
                                alln
                                usen
                                uwt_mean
                                una_mean
                                adj_mean
                                vp
                        ) ;
         by plan ;

         attrib planname                      label = "Plan Name"
                subcode                       label = "Subset Name"
                alln      format = comma10.0  label = "Total # of Respondents"
                usen      format = comma10.0  label = "# of Respondents Analyzed"
                plan_wgt  format = comma12.2  label = "Plan Weight"

             %if &vartype = 1 %then %do ;
                uwt_mean  format = 8.4
                          label  = "Unweighted Unadjusted Plan Yes"
                una_mean  format = 8.4
                          label  = "Weighted Unadjusted Plan Fraction Yes"
                adj_mean  format = 8.4
                          label = "Adjusted Plan Fraction Yes"
             %end ;

             %else %do ;
                uwt_mean  format = 8.4
                          label  = "Unweighted Unadjusted Plan Mean"
                una_mean  format = 8.4
                          label = "Weighted Unadjusted Plan Mean"
                adj_mean  format = 8.4
                          label = "Adjusted Plan Mean"
             %end ;

                delta     format = 8.4
                          label  = "Plan Diff. From Overall Mean"
                se        format = 8.4
                          label  = "Std Error of Difference"
                cl95      format = 8.4
                          label  = "+/- 95% Conf. Limit of Diff."
                meaning   format = 4.0
                          label  = "Rating"
                vp        format = 8.4
                          label  = "Variance of the Mean"
               ;

      run ;

   %end;
   %else %do;

      data &stardsn ( drop = plan ) ;
         merge ttest   ( keep = plan
                                delta
                                se
                                cl95
                                meaning
                                plan_wgt
                       )
               indata1 ( keep = plan
                                planname
                                subcode
                                alln
                                usen
                                uwt_mean
                                una_mean
                                adj_mean
                                vp

                       ) ;
         by plan ;

         attrib planname                      label = "Plan Name"
                subcode                       label = "Subset Name"
                alln      format = comma10.0  label = "Total # of Respondents"
                usen      format = comma10.0  label = "# of Respondents Analyzed"
                plan_wgt  format = comma12.2  label = "Plan Weight"

            %if &vartype = 1 %then %do ;
               uwt_mean  format = 8.4
                         label  = "Unweighted Unadjusted Plan Yes"
               una_mean  format = 8.4
                         label  = "Weighted Unadjusted Plan Fraction Yes"
               adj_mean  format = 8.4
                         label = "Adjusted Plan Fraction Yes"
            %end ;

            %else %do ;
               uwt_mean  format = 8.4
                         label  = "Unweighted Unadjusted Plan Mean"
               una_mean  format = 8.4
                         label = "Weighted Unadjusted Plan Mean"
               adj_mean  format = 8.4
                         label = "Adjusted Plan Mean"
            %end ;

               delta     format = 8.4
                         label  = "Plan Diff. From Overall Mean"
               se        format = 8.4
                         label  = "Std Error of Difference"
               cl95      format = 8.4
                         label  = "+/- 95% Conf. Limit of Diff."
               meaning   format = 4.0
                         label  = "Rating"
               vp        format = 8.4
                         label  = "Variance of the Mean"
               ;
      run ;
      
   %end;

   %put  -------------------------------  ;
   %put    Leaving STAR Macro  ;
   %put  -------------------------------  ;

%mend star ;

/*
SubName    :  adj_bar
Created    :  12-July-2001
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Create a data set that will have dummy variables for each response
     category represented in the triple stacked bars.  Only run this
     procedure if case mixed frequencies are requested.  Merge the case
     mixed frequencies into the n_* data set.

Usage      :  %adj_bar
Input      :  No parameteres needed
Output     :  None
Limits     :  Note limits here

---------------------------------------------------------------------------
Updated    :  dd-mmm-yyyy
by Whom    :
Reason     :

---------------------------------------------------------------------------
*/

%macro adj_bar () ;

   %put  -------------------------------  ;
   %put    Entering ADJ_BAR Macro  ;
   %put  -------------------------------  ;

   %let _inadjb = 1 ;

   data tbarset
      ( drop = i ) ;
      set allcases
          ( keep   = origplan
                     &var
                     &adjuster
                     child
                     _wgtresp
                     _wgtmean
                     _id_resp
                     split
                     %if &visits ne 1 %then %do ;
                        visits
                     %end ;
            rename = ( origplan = plan )
             );
      array origvar [&_numitem] &var ;
      array _b1v [&_numitem] ;
      array _b2v [&_numitem] ;
      array _b3v [&_numitem] ;

      %if &wgtresp =  %then %do ;
      %end ;
      %else %do ;
         &wgtresp = _wgtresp ;
      %end ;

      %if &wgtmean =  %then %do ;
      %end ;
      %else %do ;
         &wgtmean = _wgtmean ;
      %end ;

      do i = 1 to &_numitem ;
         if &vartype = 1 then do ;
            if origvar [i] not in (0,1) then do ;
               _b1v [i] = . ;
               _b2v [i] = . ;
               _b3v [i] = . ;
            end ;
            else do ;
               _b1v [i] = 0 ;
               _b2v [i] = 0 ;
            end ;

            if      origvar [i] in (0)   then _b1v [i] = 1 ;
            else if origvar [i] in (1)   then _b2v [i] = 1 ;
         end ;

         if &vartype = 2 then do ;
            if origvar [i] not in (0,1,2,3,4,5,6,7,8,9,10) then do ;
               _b1v [i] = . ;
               _b2v [i] = . ;
               _b3v [i] = . ;
            end ;
            else do ;
               _b1v [i] = 0 ;
               _b2v [i] = 0 ;
               _b3v [i] = 0 ;
            end ;

            if &recode in (0,1) then do ;
               if      origvar [i] in (0,1,2,3,4,5,6) then _b1v [i] = 1 ;
               else if origvar [i] in (7,8)           then _b2v [i] = 1 ;
               else if origvar [i] in (9,10)          then _b3v [i] = 1 ;
            end ;
            else if &recode in (2,3) then do ;
               if      origvar [i] in (0,1,2,3,4,5,6,7) then _b1v [i] = 1 ;
               else if origvar [i] in (8,9)             then _b2v [i] = 1 ;
               else if origvar [i] in (10)              then _b3v [i] = 1 ;
            end ;
         end ;

         if &vartype = 3 then do ;
            if origvar [i] not in (1,2,3,4) then do ;
               _b1v [i] = . ;
               _b2v [i] = . ;
               _b3v [i] = . ;
            end ;
            else do ;
               _b1v [i] = 0 ;
               _b2v [i] = 0 ;
               _b3v [i] = 0 ;
            end ;

            if      origvar [i] in (1,2) then _b1v [i] = 1 ;
            else if origvar [i] in (3)   then _b2v [i] = 1 ;
            else if origvar [i] in (4)   then _b3v [i] = 1 ;
         end ;

         if &vartype = 4 then do ;
            if origvar [i] not in (1,2,3) then do ;
               _b1v [i] = . ;
               _b2v [i] = . ;
               _b3v [i] = . ;
            end ;
            else do ;
               _b1v [i] = 0 ;
               _b2v [i] = 0 ;
               _b3v [i] = 0 ;
            end ;

            if      origvar [i] in (1)   then _b1v [i] = 1 ;
            else if origvar [i] in (2)   then _b2v [i] = 1 ;
            else if origvar [i] in (3)   then _b3v [i] = 1 ;
         end ;
       end ;
   run ;

   %macro newvar (_bname) ;
      %do i = 1 %to &_numitem ;
         &_bname&i
      %end ;
   %mend newvar ;

   %let origds  = &dataset ;
   %let origvar = &var ;
   %let origvt  = &vartype ;

   %let var     = %newvar (_b1v) ;
   %let _barnum = 1 ;
   %let _barchr = A ;
   %let vartype = 1 ;
   %let dataset = tbarset ;

   %allcases ;
   %if &_numadj ^= 0 %then %do ;
      %adjuster ;
   %end ;
   %item_wgt ;
   %usable ;
   %pct_resp ;
   %std_data ;
   %preptest ;
   %perm_ds ;

%*-------------------------------------------------------------------------*
|  Now add in the case mix adjusted frequencies for the first bar to the   |
|  permanent frequency data set, n_&outname, and nw&outname if wgtdata=2.  |
|  Also add in the weighted frequencies.                                   |
*--------------------------------------------------------------------------*;

   proc sort data = out.n_&outname ;
      by planname ;
   run ;

   proc sort data = star_all ;
      by planname ;
   run ;

   data out.n_&outname ;
      merge
         out.n_&outname  ( in = f )
         star_all        ( in = n
            keep = planname adj_mean una_mean
            rename = ( adj_mean = adj_1
                       una_mean = wgt_1 )) ;
      by planname ;
   run ;

   %if &wgtdata = 2 %then %do ;
      proc sort data = out.nw&outname ;
         by planname ;
      run ;

      proc sort data = starwall ;
         by planname ;
      run ;

      data out.nw&outname ;
         merge
            out.nw&outname  ( in = f )
            starwall        ( in = n
               keep = planname adj_mean una_mean
               rename = ( adj_mean = adj_1
                          una_mean = wgt_1 )) ;
         by planname ;
      run ;
   %end ;

   %if &origvt ne 1 %then %do ;
      %let var     = %newvar (_b2v) ;
      %let _barnum = 2 ;
      %let _barchr = B ;
      %allcases ;
      %if &_numadj ^= 0 %then %do ;
         %adjuster ;
      %end ;
      %item_wgt ;
      %usable ;
      %pct_resp ;
      %std_data ;
      %preptest ;
      %perm_ds ;

%*-------------------------------------------------------------------------*
|  Now add in the case mix adjusted frequencies for the second bar to the  |
|  permanent frequency data set, n_&outname, and nw&outname if wgtdata=2.  |
*--------------------------------------------------------------------------*;
      proc sort data = out.n_&outname ;
         by planname ;
      run ;

      proc sort data = star_all ;
         by planname ;
      run ;

      data out.n_&outname ;
         merge
            out.n_&outname  ( in = f )
            star_all        ( in = n
               keep = planname adj_mean una_mean
               rename = ( adj_mean = adj_2
                          una_mean = wgt_2 )) ;
         by planname ;
      run ;

      %if &wgtdata = 2 %then %do ;
         proc sort data = out.nw&outname ;
            by planname ;
         run ;

         proc sort data = starwall ;
            by planname ;
         run ;

         data out.nw&outname ;
            merge
               out.nw&outname  ( in = f )
               starwall        ( in = n
                  keep = planname adj_mean una_mean
                  rename = ( adj_mean = adj_2
                             una_mean = wgt_2 )) ;
            by planname ;
         run ;
      %end ;
   %end ;

   data out.n_&outname ;
      set out.n_&outname ;
      label
         adj_1 = 'Adjusted Bar 1'
         adj_2 = 'Adjusted Bar 2'
         wgt_1 = 'Weighted Unadjusted Bar 1'
         wgt_2 = 'Weighted Unadjusted Bar 2'
      ;
      %if &origvt ne 1 %then %do ;
         wgt_3 = 1 - sum ( wgt_1, wgt_2 ) ;
         adj_3 = 1 - sum ( adj_1, adj_2 ) ;
         label
            wgt_3 = 'Weighted Unadjusted Bar 3'
            adj_3 = 'Adjusted Bar 3'
         ;
      %end ;
      %else %do ;
         adj_2 = adj_1 ;
         adj_1 = 1 - adj_2 ;
         wgt_2 = wgt_1 ;
         wgt_1 = 1 - wgt_2 ;
      %end ;
      format adj_: wgt_:  percent9.2 ;
   run ;

   %if &wgtdata = 2 %then %do ;
      data out.nw&outname ;
         set out.nw&outname ;
         label
            adj_1 = 'Adjusted Bar 1'
            adj_2 = 'Adjusted Bar 2'
            wgt_1 = 'Weighted Unadjusted Bar 1'
            wgt_2 = 'Weighted Unadjusted Bar 2'
         ;
         %if &origvt ne 1 %then %do ;
            wgt_3 = 1 - sum ( wgt_1, wgt_2 ) ;
            adj_3 = 1 - sum ( adj_1, adj_2 ) ;
             label
               wgt_3 = 'Weighted Unadjusted Bar 3'
               adj_3 = 'Adjusted Bar 3'
            ;
         %end ;
         %else %do ;
            adj_2 = adj_1 ;
            adj_1 = 1 - adj_2 ;
            wgt_2 = wgt_1 ;
            wgt_1 = 1 - wgt_2 ;
         %end ;
         format adj_: wgt_:  percent9.2 ;
      run ;
   %end ;

%*-------------------------------------------------------------------------*
|  Run the 2nd bar for dichotomous variables and the 3rd bar for others    |
|  so a permanent data set can be made for the statistical results.        |
*--------------------------------------------------------------------------*;

   %if &bar_stat eq 1 %then %do ;
      %if &origvt eq 1 %then %do ;
         %let var     = %newvar (_b2v) ;
         %let _barnum = 2 ;
         %let _barchr = B ;
         %allcases ;
         %if &_numadj ^= 0 %then %do ;
            %adjuster ;
         %end ;
         %item_wgt ;
         %usable ;
         %pct_resp ;
         %std_data ;
         %preptest ;
         %perm_ds ;
      %end ;
      %else %do ;
         %let var     = %newvar (_b3v) ;
         %let _barnum = 3 ;
         %let _barchr = C ;
         %allcases ;
         %if &_numadj ^= 0 %then %do ;
            %adjuster ;
         %end ;
         %item_wgt ;
         %usable ;
         %pct_resp ;
         %std_data ;
         %preptest ;
         %perm_ds ;
      %end ;
   %end ;

   %let _inadjb = 0 ;
   %let dataset = &origds ;
   %let var     = &origvar ;
   %let vartype = &origvt ;

%mend adj_bar ;

/*
SubName    :  perm_ds
Created    :  18-November-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Create the permanent data sets for all the components and reports.

Usage      :  %perm_ds
Input      :  No parameteres needed
Output     :  None
Limits     :  Note limits here
---------------------------------------------------------------------------
Updated    :  30-JUN-2009
by Whom    :  Kayo Walsh
Reason     :  Low_numb3 work dataset was added. This dataset contains a plan 
with zero record in item. This dataset is used for 'WARNING' note in the text
output.  This only applies for composite items.

---------------------------------------------------------------------------
---------------------------------------------------------------------------
Updated    :  07-Mar-2017
by Whom    :  Kayo Walsh
Reason     :  A work dataset, output_p creates c_&outname which contains 
coeffecients, se, and pvalues.                                                         
---------------------------------------------------------------------------
*/

%macro perm_ds () ;

   %put  -------------------------------  ;
   %put    Entering PERM_DS Macro  ;
   %put  _inadjb =   &_inadjb ;
   %put  -------------------------------  ;

%*-------------------------------------------------------------------------*
|  If this is the first time in the main CAHPS loop, then the permanent    |
|  data sets need to be deleted if they exist.                             |
*--------------------------------------------------------------------------*;

   %if &sub = 1 and &_inadjb = 0 %then %do ;
      proc datasets library = out
                    nolist ;
         delete
            dp&outname
            lr&outname
            p_&outname
            pw&outname
            n_&outname
            nw&outname
            c_&outname
            r2&outname
            y_&outname
            oa&outname
            sa&outname
            ow&outname
            sw&outname
         ;
      run ;
      quit ;
   %end ;
 
   %if &_inadjb = 1 %then %do ;
      proc datasets library = out
                    nolist ;
         delete
            f&_barnum.&outname
            b&_barnum.&outname
            f&_barchr.&outname
            b&_barchr.&outname
         ;
      run ;
      quit ;
   %end ; 

%*-------------------------------------------------------------------------*
|  Keep the data set that contains the plans that were excluded from the   |
|  analysis because they had only zero or one usable records.              |
*--------------------------------------------------------------------------*;

   %if &_inadjb = 0 %then %do ;
      proc append base = out.dp&outname
                  ( label = dp&outname Created by CAHPS Macro &version )
                  data = del_plan ;
      run ;

%*-------------------------------------------------------------------------*
|  Keep the number of low respondent plans in a permanent data set,        |
|  Need to append information for when subset = 3.                         |
*--------------------------------------------------------------------------*;

      proc append base = out.lr&outname
                  ( label = lr&outname Created by CAHPS Macro &version )
                  data = low_numb ;
      run ;

%*-------------------------------------------------------------------------*
|  Keep the number of 0 respondent plans in a work data set, need to append |
| information for when subset = 3.                                          |
|  **** UPDATED 22-Feb-2010 UPDATED ****                                    |
|  proc dataset code was added below so that low_numb3 dataset does not     |
|  include item_n  itemno itemtxt. This applies when subset = 3.            |
*--------------------------------------------------------------------------*;

      proc datasets library = work nolist;
         delete low_numb3;
      run;     

      proc append base = low_numb3
                  ( label = lr&outname Created by CAHPS Macro &version )
                  data = low_numb ;
      run ;

%*-------------------------------------------------------------------------*
|  Create permanent data set for the percent missing for each variable and |
|  adjuster data.                                                          |
*--------------------------------------------------------------------------*;

      proc append base = out.p_&outname
                  ( label = p_&outname Created by CAHPS Macro &version )
                  data =  p_miss ;
      run ;

%*-------------------------------------------------------------------------*
|  Create permanent data set for the percent missing for each variable and |
|  adjuster data for the unstratified data (wgtdata = 2)                   |
*--------------------------------------------------------------------------*;

      %if &wgtdata = 2 %then %do ;
         proc append base = out.pw&outname
                     ( label = pw&outname Created by CAHPS Macro &version )
                     data =  pw_miss ;
         run ;
      %end ;

%*-------------------------------------------------------------------------*
|  Create permanent data set for the percent response type for each        |
|  variable                                                                |
*--------------------------------------------------------------------------*;

      proc append base = out.n_&outname
                  ( label = n_&outname Created by CAHPS Macro &version )
                  data = non ;
      run ;

%*-------------------------------------------------------------------------*
|  Create permanent data set for the percent response type for each        |
|  variable for the unstratified data (wgtdata = 2)                        |
*--------------------------------------------------------------------------*;

      %if &wgtdata = 2 %then %do ;
         proc append base = out.nw&outname
                     ( label = nw&outname Created by CAHPS Macro &version )
                     data = wnon ;
         run ;
      %end ;

%*-------------------------------------------------------------------------*
|  Create permanent data set for the coeffcients                           |
|  and for the R-squared and adjusted R-squared values.                    |
*--------------------------------------------------------------------------*;

%*-------------------------------------------------------------------------*
|  **** UPDATED 02-Feb-2017 UPDATED ****                                   |
| A work dataset, output_p creates c_&outname which contains coeffecients, |
| se, and pvalues.                                                         |                                   |
*--------------------------------------------------------------------------*;

      %if &_numadj >= 1 %then %do ;


         data output_p;
		    set output_p;
            attrib subcode length = $40
                           label  = 'Subset Name'
            ;
            %if &subset = 3 %then %do ;
               if &endsub = 1 then subcode = 'GLOBAL' ;
               else subcode = put ( 1, sub_fmt. ) ;
            %end ;
            %else %do ;
               if &endsub = 1 then subcode = 'GLOBAL' ;
               else subcode = put ( &sub, sub_fmt. ) ;
            %end ;
         run;

%*-------------------------------------------------------------------------*
|  **** UPDATED 20-Nov-2018 UPDATED ****                                   |
| &splitflg = 1 uses a different output, output_p_split_all.               |                     
*--------------------------------------------------------------------------*;

		 %if &splitflg = 1 %then %do;

         proc append base = out.c_&outname
                     ( label = c_&outname Created by CAHPS Macro &version )
                     data = output_p_split_all ; 
         run ;

		 %end;
		 %else %do;

         proc append base = out.c_&outname
                     ( label = c_&outname Created by CAHPS Macro &version )
                     data = output_p ; 
         run ;

		 %end;
	 
%*-------------------------------------------------------------------------*
|  **** UPDATED 02-Feb-2016 UPDATED ****                                   |
| &proc_type is added to create r2&outname dataset.                        |                                   |
*--------------------------------------------------------------------------*;

         %if &proc_type = 0 %then %do; 

            proc append base = out.r2&outname
                        ( label = r2&outname Created by CAHPS Macro &version )
                        data = rsqu ;
         %end ;

         %if &proc_type = 1 %then %do; 

            proc append base = out.r2&outname
                     ( label = r2&outname Created by CAHPS Macro &version )
                     data = rsqu_surveyreg ;
         %end ;

         data out.r2&outname;
		     retain _depvar_ _rsq_ _adjrsq_ subcode;
			 set out.r2&outname;
         run; 

         %if &splitflg = 1 %then %do;

            proc sort data = out.r2&outname;
			by split;
			run;

		 %end;


      %end;

%*-------------------------------------------------------------------------*
|  Create permanent data set for the residuals by plan and id.             |
|  These may be used to create a covariance matrix of all the measures     |
|  that are run through the CAHPS macro.                                   |
*--------------------------------------------------------------------------*;

      %if &kp_resid = 1 %then %do ;
         proc append base = out.y_&outname
                     ( label = y_&outname Created by CAHPS Macro &version )
                     data = res_4_id ;
         run ;
      %end ;

%*-------------------------------------------------------------------------*
|  Create permanent data sets for the overall and star data for all the    |
|  plans.                                                                  |
*--------------------------------------------------------------------------*;

      proc append base = out.oa&outname
                  ( label = oa&outname Created by CAHPS Macro &version )
                  data = over_all ;
      run ;

      proc append base = out.sa&outname
                  ( label = sa&outname Created by CAHPS Macro &version )
                  data = star_all ;
      run ;

%*-------------------------------------------------------------------------*
|  Create permanent data sets for the overall and star data for all the    |
|  weighted starta (wgtdata = 2).                                          |
*--------------------------------------------------------------------------*;

      %if &wgtdata = 2 %then %do ;
         proc append base = out.ow&outname
                     ( label = ow&outname Created by CAHPS Macro &version )
                     data = overwall ;
         run ;

         proc append base = out.sw&outname
                     ( label = sw&outname Created by CAHPS Macro &version )
                     data = starwall ;
         run ;
      %end ;
   %end ;

%*-------------------------------------------------------------------------*
|  Create permanent data sets for the case-mix adjusted frequency bars.    |
*--------------------------------------------------------------------------*;

   %else %if &_inadjb = 1 and &bar_stat = 1 %then %do ;

%*-------------------------------------------------------------------------*
|  Create permanent data sets for the overall and star data for all the    |
|  plans.                                                                  |
*--------------------------------------------------------------------------*;
          
      proc append base = out.f&_barnum.&outname
                  ( label = f&_barnum.&outname Created by CAHPS Macro &version )
                  data = over_all ;
      run ;

      proc append base = out.b&_barnum.&outname
                  ( label = b&_barnum.&outname Created by CAHPS Macro &version )
                  data = star_all ;
      run ;

%*-------------------------------------------------------------------------*
|  Create permanent data sets for the overall and star data for all the    |
|  weighted starta (wgtdata = 2).                                          |
*--------------------------------------------------------------------------*;

      %if &wgtdata = 2 %then %do ;
         proc append base = out.f&_barchr.&outname
                     ( label = f&_barchr.&outname Created by CAHPS Macro &version )
                     data = overwall ;
         run ;

         proc append base = out.b&_barchr.&outname
                     ( label = b&_barchr.&outname Created by CAHPS Macro &version )
                     data = starwall ;
         run ;
      %end ;
   %end ;

%mend perm_ds ;

/*
SubName    :  mkreport.sas
Created    :  18-November-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Using the permanent data sets and other variable information, create
     the reports in an output file.

Usage      :  %mkreport
Input      :  No parameteres needed
Output     :  None
Limits     :  Note limits here

---------------------------------------------------------------------------
Updated    :  03-February-2003
by Whom    :  Matthew J. Cioffi
Reason     :
   Added some aditional text to indicate that child interactions with the
   adjuster variables have occured when the ADULTKID parameter = 1.
   Changed the macro variable for the adjusters and the number of adjusters
   to be the ones containing the child interactions.

---------------------------------------------------------------------------
Updated    :  24-June-2009
by Whom    :  Kayo Walsh
Reason     :  
   A warning note with plans with zero respondents was added. Low_numb3 work dataset 
   contains numbers for low nubmer and zero number.  
----------------------------------------------------------------------------

*/

%macro mkreport () ;

   %put  -------------------------------  ;
   %put    Entering MKREPORT Macro  ;
   %put  -------------------------------  ;


%*-------------------------------------------------------------------------*
|  Report plans with low number of respondents, plans with 0 respondents   |
|  and macro parameter information.                                        |
*--------------------------------------------------------------------------*;

   data _null_ ;
      file print ;

      if numrec = 0 then do ;
         %let empty = 1 ;
      end ;
      else do ;
         %let empty = 0 ;
         
         set low_numb3 
             nobs = numrec
             end  = eodata ;
      end ;

%*-------------------------------------------------------------------------*
|  Add to the report header the date, time and version of macro.           |
*--------------------------------------------------------------------------*;

      if _n_ = 1 or &empty = 1 then do ;
         put ;
         put "*---------------------------------------------*" ;
         put "  CAHPS SAS Analysis Program Version &version" ;
         put "  Report run on &_now" ;
         put "*---------------------------------------------*" ;
         put ;

%*-------------------------------------------------------------------------*
|  If a plan has less than 100 usable respondents, print out warning note. |
*--------------------------------------------------------------------------*;

         if numrec > 0  and usen > 0 then do ;
            put ;
            put "   **********   WARNING NOTE   **********   " ;
            put "      PLANS WITH FEWER THAN 100 CASES       " ;
            put "--------------------------------------------" ;
            put ;
         end ;
         else do ;
            put ;
            put "  *** ALL PLANS HAVE 100 OR MORE CASES ***  " ;
            put "--------------------------------------------" ;
         end ;
      end ;

      if numrec > 0 and usen > 0 and item_n = . then do ;
         put "  " plantxt " - " usentxt "Cases" ;
         put ;
      end;

%*-------------------------------------------------------------------------*
|  If one of items in composites has 0 respondents, print out warning note. |
*--------------------------------------------------------------------------*;

      if item_n = 0  then do ;
         put ;
         put "   **********   WARNING NOTE   **********   " ;
         put "      PLANS WITH ALL MISSING CASES          " ;
         put "--------------------------------------------" ;
         put ;
      end ;

      if item_n = 0  then do ;
         put "  " plantxt " - " "Item number" " " itemntxt ;
         put ;
      end ;
 
%*-------------------------------------------------------------------------*
|  After last record is read, print out other notes.                       |
*--------------------------------------------------------------------------*;

      if eodata or &empty = 1 then do ;
         if numrec > 0  then do ;
            put ;
            put "--------------------------------------------" ;
         end ;

         put ;
         put ;

         %let ptr = @32 ;

%*-------------------------------------------------------------------------*
|  If recoding is requested, print out appropriate note.                   |
*--------------------------------------------------------------------------*;

         %if &recode = 1 or
             &recode = 3 %then %do ;
            %if &recode   = 1 and
                &orivtype = 2 %then %do ;
               put "                 *** RECODING DONE ***                   " ;
               put " Rating variable responses (0-10 Scale) has been recoded:" ;
               put "    Values 0 -  6 coded as 1 " ;
               put "    Values 7 -  8 coded as 2 " ;
               put "    Value  9 - 10 coded as 3 " ;
            %end ;
            %else %if &recode   = 3 and
                      &orivtype = 2 %then %do ;
               put "                 *** RECODING DONE ***                   " ;
               put " Rating variable responses (0-10 Scale) has been recoded:" ;
               put "    Values 0 -  7 coded as 1 " ;
               put "    Values 8 -  9 coded as 2 " ;
               put "    Value      10 coded as 3 " ;
            %end ;
            %else %if &orivtype = 3 %then %do ;
               put "                 *** RECODING DONE ***                   " ;
               put " How Often variable responses (1-4 Scale) has been recoded:" ;
               put "    Values 1 - 2 coded as 1 " ;
               put "    Value      3 coded as 2 " ;
               put "    Value      4 coded as 3 " ;
            %end ;
            %else %do ;
               put " Variables with variable type = &vartype do not get recoded." ;
               put "          *** NO RECODING HAS BEEN DONE ***                 " ;
            %end ;
            put "The Variable Type has been changed from &orivtype to &vartype" ;
            put ;
            put ;
         %end ;

%*-------------------------------------------------------------------------*
|  Print out the variable item information.                                |
*--------------------------------------------------------------------------*;

         if &_numitem = 1 then
            put " The Variable Item "               &ptr "= &var " ;
         else if &_numitem > 1 then do ;
            numchar = put ( &_numitem, 2.0 ) ;
            put " The " numchar "Variable Items "   &ptr "= &var " ;
         end ;
         else
            put " There are no variable items " ;

         put " The Variable Type" &ptr "= &vartype " ;

%*-------------------------------------------------------------------------*
|  Print out the adjuster variable information.                            |
*--------------------------------------------------------------------------*;

         if &numadj_2 = 1 then
            put " The Adjuster Variable "             &ptr "= &adj_new " ;
         else if &numadj_2 > 1 then do ;
            numchar = put ( &numadj_2, 2.0 ) ;
            put " The " numchar "Adjuster Variables " &ptr "= &adj_new " ;
            if &adultkid = 1 then do ;
               put " The adjusters include Child Interactions with the original adjuster variables " ;
               put " ac1 is the interaction with the first adjuster in the list, ac2 the second... " ;
            end ;
         end ;
         else do ;
            put " There are no adjusters variables " ;
            put " No Case Mix Models Performed " ;
         end ;

         if &subset = 1 then do ;
            put ;
            put " Global Case Mix Model" ;
            put " Global Centering of Means" ;
            put ;
         end ;
         else if &subset = 2 then do ;
            put ;
            put " Global Case Mix Model" ;
            put " Means Centered and Tested within each Subset" ;
            put ;
         end ;
         if &subset = 3 then do ;
            put ;
            put " Subset Case Mix Model" ;
            put " Means Centered and Tested within each Subset" ;
            put ;
         end ;

%*-------------------------------------------------------------------------*
|  Print out the other macro parameteres                                   |
*--------------------------------------------------------------------------*;
         put ;
         put " The RECODE   parameter "     &ptr "= &recode " ;
         put " The MIN_RESP parameter "     &ptr "= &min_resp " ;
         put " The MAX_RESP parameter "     &ptr "= &max_resp " ;
         put " The NAME     parameter "     &ptr "= &name " ;
         put " The ADJ_BARS parameter "     &ptr "= &adj_bars " ;
         put " The BAR_STAT parameter "     &ptr "= &bar_stat " ;
         put " The IMPUTE   parameter "     &ptr "= &impute " ;
         put " The EVEN_WGT parameter "     &ptr "= &even_wgt " ;
	     put " The K        parameter "     &ptr "= &k " ;
         put " The KP_RESID parameter "     &ptr "= &kp_resid " ;
         put " The ADULTKID parameter "     &ptr "= &adultkid " ;
         put " The VISITS   parameter "     &ptr "= &visits " ;
         put " The PVALUE   parameter "     &ptr "= &pvalue " ;
         put " The CHANGE   parameter "     &ptr "= &change " ;
         put " The MEANDIFF parameter "     &ptr "= &meandiff " ;
         put " The WGTDATA  parameter "     &ptr "= &wgtdata " ;
         put " The WGTRESP  parameter "     &ptr "= &wgtresp " ;
         put " The WGTMEAN  parameter "     &ptr "= &wgtmean " ;
         put " The WGTPLAN  parameter "     &ptr "= &wgtplan " ;
         put " The ID_RESP  parameter "     &ptr "= &id_resp " ;
         put " The SUBSET   parameter "     &ptr "= &subset " ;
         put " The SPLITFLG parameter "     &ptr "= &splitflg " ;
         put " The data set used "          &ptr "= &dataset " ;
         put " The OUTREGRE parameter "     &ptr "= &outregre " ;
         put " The output data set suffix " &ptr "= &outname " ;
		 put " The PROC_TYPE parameter "    &ptr "= &proc_type " ;
	     put " The OVERALL_WT parameter "   &ptr "= &overall_wt " ; 
		 put " The WT_TYPE parameter "      &ptr "= &wt_type " ;
      end ;
   run ;

%*-------------------------------------------------------------------------*
|  Print the percent missing report.                                       |
*--------------------------------------------------------------------------*;

   proc print data = out.p_&outname
              noobs
              label
            ;
      var alln
          &use_flds
      ;
      %if &subset = 3 %then %do ;
         id subcode planname ;
      %end ;
      %else %do ;
         id planname ;
      %end ;
      title3 "PERCENT ITEMS MISSING BY HEALTH PLAN" ;
      footnote3 "Data Set out.p_&outname" ;
   run ;
   title3 ;
   footnote3 ;

%*-------------------------------------------------------------------------*
|  Print the percent missing report for unstratified data (wgtdatat = 2)   |
*--------------------------------------------------------------------------*;

   %if &wgtdata = 2 %then %do ;
      proc print data = out.pw&outname
                 noobs
                 label
               ;
         var alln
             &use_flds
         ;
         %if &subset = 3 %then %do ;
            id subcode planname ;
         %end ;
         %else %do ;
            id planname ;
         %end ;
         title3 "PERCENT ITEMS MISSING BY HEALTH PLAN" ;
         title4 "Weighted Strata" ;
         footnote3 "Data Set out.pw&outname" ;
      run ;
   %end ;
   title3 ;
   footnote3 ;

%*-------------------------------------------------------------------------*
|  Print the percent response type reports.                                |
*--------------------------------------------------------------------------*;

   proc print data = out.n_&outname
              noobs
              label
            ;
      var alln
          usen
          ptres:
      %if &adj_bars = 1 %then %do ;
          adj_:
          wgt_:
      %end ;
      ;

      %if &subset = 3 %then %do ;
         id subcode planname ;
      %end ;
      %else %do ;
         id planname ;
      %end ;
      title3 "PERCENT RESPONSE TYPE - NO IMPUTATIONS" ;
      footnote3 "Data Set out.n_&outname" ;

   run ;
   title3 ;
   footnote3 ;

%*-------------------------------------------------------------------------*
|  Print the percent response type report for unstratified data (wgtdata=2)|
*--------------------------------------------------------------------------*;

   %if &wgtdata = 2 %then %do ;
      proc print data = out.nw&outname
                 noobs
                 label
               ;
         var alln
             usen
             ptres:
         %if &adj_bars = 1 %then %do ;
             adj_:
             wgt_:
         %end ;
         ;
         %if &subset = 3 %then %do ;
            id subcode planname ;
         %end ;
         %else %do ;
            id planname ;
         %end ;
         title3 "PERCENT RESPONSE TYPE - NO IMPUTATIONS" ;
         title4 "Weighted Strata" ;
         footnote3 "Data Set out.nw&outname" ;
      run ;
   %end ;
   title3 ;
   footnote3 ;

%*-------------------------------------------------------------------------*
|  Print the coefficients report and the r-squared report                  |
*--------------------------------------------------------------------------*;

%*-------------------------------------------------------------------------*
|  **** UPDATED 02-Feb-2017 UPDATED ****                                   |
| New field names are used in PROC PRINT since the format of output dataset| 
| is updated.                                                              |                                   
*--------------------------------------------------------------------------*;

   %if &_numadj >= 1 %then %do ;

      proc print data = out.c_&outname
                 noobs
                 label            
                 ;
         id variable;
         title3 "REGRESSION COEFFICIENTS FOR ADJUSTER VARIABLES" ;
         footnote3 "Data Set out.c_&outname" ;
      run ;

      proc print data = out.r2&outname
                 noobs
                 label ;
         var /*split*/
             subcode
             _depvar_
             _rsq_
             _adjrsq_
         ;
         format _rsq_ _adjrsq_ 12.4 ;
         title3 "R-SQUARED VALUES for DEPENDENT VARIABLES" ;
         footnote3 "Data Set out.r2&outname" ;
      run ;


   %end ;
   title3 ;
   footnote3 ;

%*-------------------------------------------------------------------------*
|  Print the overall statistics and star reports for each plan             |
*--------------------------------------------------------------------------*;

   proc print data = out.oa&outname
              noobs
              label
              ;
      var ov_mean
          dfr
          dfe
          overallf
          overallp
      ;
      id subcode ;
      title3 "P-Value For Contrast = &pvalue - Change > &change - Meandiff > &meandiff" ;
      title4 "Overall Statistics from t-test" ;

      %if &vartype = 1 %then %do ;
         title5 "Ho:  Plan Fraction Yes All Equal" ;
      %end ;
      %else %do ;
         title5 "Ho:  Plan Means All Equal" ;
      %end ;

      footnote1 "Report run on &_now" ;
      footnote2 "CAHPS SAS Analysis Program Version &version" ;
      footnote3 "Data Set out.oa&outname" ;
   run ;
   title3 ;
   footnote3 ;

   %if &smoothing > 0 %then %do;
      proc print data = out.sa&outname
                 noobs
                 label
                 ;
         var alln
            usen
            uwt_mean
            una_mean
            adj_mean
            delta
            se
            cl95
            vp
            meaning
            plan_wgt
         ;

         %if &subset = 3 %then %do ;
            id subcode planname ;
         %end ;
         %else %do ;
            id planname ;
         %end ;

         format uwt_mean una_mean adj_mean delta se vp 8.4
             plan_wgt comma12.2
             meaning  starfmt.
         ;
         title3 "P-Value For Contrast = &pvalue - Change > &change - Meandiff > &meandiff" ;
         title4 "ALL PLANS" ;
         footnote1 "Report run on &_now" ;
         footnote2 "CAHPS SAS Analysis Program Version &version" ;
         footnote3 "Data Set out.sa&outname" ;

      run ;
      title3 ;
      footnote3 ;
   %end;
   %else %do;

      proc print data = out.sa&outname
              noobs
              label
              ;
         var alln
             usen
             uwt_mean
             una_mean
             adj_mean
             delta
             se
             cl95
             vp

             meaning
             plan_wgt
         ;
         %if &subset = 3 %then %do ;
            id subcode planname ;
         %end ;
         %else %do ;
            id planname ;
         %end ;

         format uwt_mean una_mean adj_mean delta se vp 8.4
               plan_wgt comma12.2
               meaning  starfmt.
         ;
         title3 "P-Value For Contrast = &pvalue - Change > &change - Meandiff > &meandiff" ;
         title4 "ALL PLANS" ;
         footnote1 "Report run on &_now" ;
         footnote2 "CAHPS SAS Analysis Program Version &version" ;
         footnote3 "Data Set out.sa&outname" ;
      run ;
      title3 ;
      footnote3 ;

   %end;

%*-------------------------------------------------------------------------*
|  Print the overall statistics and star reports for each unstratified     |
|  plan (wgtdata = 2).                                                     |
*--------------------------------------------------------------------------*;

   %if &wgtdata = 2 %then %do ;
      proc print data = out.ow&outname
                 noobs
                 label
                 ;
         var ov_mean
             dfr
             dfe
             overallf
             overallp
         ;
         id subcode ;
         title3 "P-Value For Contrast = &pvalue - Change > &change - Meandiff > &meandiff" ;
         title4 "Overall Statistics from t-test" ;

         %if &vartype = 1 %then %do ;
            title5 "Ho:  Plan Fraction Yes All Equal" ;
         %end ;
         %else %do ;
            title5 "Ho:  Plan Means All Equal" ;
         %end ;

         footnote1 "Report run on &_now" ;
         footnote2 "CAHPS SAS Analysis Program Version &version" ;
         footnote3 "Data Set out.ow&outname" ;
      run ;
      title3 ;
      footnote3 ;

      proc print data = out.sw&outname
                 noobs
                 label
                 ;
         var alln
             usen
             uwt_mean
             una_mean
             adj_mean
             delta
             se
             cl95
             vp
             meaning
         ;
         %if &subset = 3 %then %do ;
            id subcode planname ;
         %end ;
         %else %do ;
            id planname ;
         %end ;

         format uwt_mean una_mean adj_mean delta se  8.4
                meaning  starfmt.
         ;
         title3 "P-Value For Contrast = &pvalue - Change > &change - Meandiff > &meandiff" ;
         title4 "ALL PLANS - Weighted Strata" ;

         footnote1 "Report run on &_now" ;
         footnote2 "CAHPS SAS Analysis Program Version &version" ;
         footnote3 "Data Set out.sw&outname" ;
      run;
      title3 ;
      footnote3 ;

   %end;

%mend mkreport ;


/*
SubName    :  cleanup.sas
Created    :  29-Jul-1998
Author     :  Matthew J. Cioffi
Type       :  Macro
Purpose    :
     Clean up the work area of unneeded data sets, formats, ...
     Macros can be deleted after macro call if desired.  Currently
     this code is commented out.

Usage      :  %cleanup
Input      :  No parameteres needed
Output     :  None
Limits     :  To delete additional data sets, they must be manually added.

---------------------------------------------------------------------------
Updated    :  dd-mmm-yyyy
by Whom    :
Reason     :

---------------------------------------------------------------------------
*/

%macro cleanup () ;

   %put  -------------------------------  ;
   %put    Entering CLEANUP Macro  ;
   %put  -------------------------------  ;

%*-------------------------------------------------------------------------*
|  Clear the titles and footnotes.                                         |
*--------------------------------------------------------------------------*;
   title ;
   footnote ;

%*-------------------------------------------------------------------------*
|  Delete data sets in the work area created by the macro.                 |
*--------------------------------------------------------------------------*;

   proc datasets library = work
                 nolist
               ;
      delete  adj4plan
              adjuster
              adj_cntr
              adj_copy
              adj_new
              adj_plan
              adj_pred
              adj_pw
              adj_reg
              adj_res2
              adj_resi
              adj_rwn
              adj_std
              adj_reg_wtadd 
              adj_std_wtadd 
              allcases
              alln
              alln_sub
              am_plan
              a_p1
              a_p2
              a_r1
              bar0rate
              bar_rate
              bar_set
              bar_set2
              bar_y
              coeff
              coe_pvalue 
              ctr2mean
              ctr_adj
              ctr_all
              ctr_data
              ctr_mean
              ctr_plan
              c_new1
              c_&outname 
              del_plan
              dsplan
              dum_bar
              fitstatistics 
              getnplan
              gm
              indata1
              low_numb
              low_numb2
              low_numb3
              mer_wgt
              non
              nonmiss
              nplanfmt
              num_val
              oplanfmt
              otuput_p 
              overwall
              over_all
              over_i
              ov_mean
              para_est
              pct_miss
              pd_temp
              plandt_z
              plandtal
              planitem
              planonly
              planstar
              planwgts
              plan_one
              plan_n
              plan_sub
              pln_mean
              predict
              pw_miss
              p_miss
              res4plan
              resid
              resid0
              resid1
              res_4_id
              rsqu
			  rsqu_surveyreg
              splan_id
              split_st
              starwall
              star_all
              star_i
              stemp
              stemp2
              stratwgt
              sub_fmt
              sub_non1
              sub_non2
              suppress 
              sum_wgts
              s_non
              tbarset
              ttest
              uam_plan
              unadj_m
              unadj_mw
              unwgt_m
              usable
              usen
              var_plan
              wnon
              wstemp
              w_comp
              w_comp1
              w_non
              w_p_miss
              w_stemp
      %if &_num_sub > 0 %then
         %do i = 1 %to &_num_sub ;
              s&i.fmt
         %end ;
      ;
   quit ;
   run ;

%*-------------------------------------------------------------------------*
|  Delete formats in the work area formats catalog.                        |
*--------------------------------------------------------------------------*;

   proc catalog catalog   = formats
                entrytype = format
               ;
      delete dichfmt
             freqfmt
             nplanfmt
             oplanfmt
             ratefmt
             starfmt
             sub_fmt
      %if &_num_sub > 0 %then
         %do i = 1 %to &_num_sub ;
             s&i.fmt
         %end ;
      ;
   quit ;
   run ;

%mend cleanup ;

%*-------------------------------------------------------------------------*
| ************************************************************************ |
|  ****    End the listing of Submacros used by the CAHPS macro.     ****  |
| ************************************************************************ |
*--------------------------------------------------------------------------* ;

%*-------------------------------------------------------------------------*
| ************************************************************************ |
|  ****     START THE MAIN CAHPS MACRO - Calls submacors above.      ****  |
| ************************************************************************ |
*--------------------------------------------------------------------------* ;

%macro cahps(var          =  ,
             vartype      =  ,
             recode       = 0,
             min_resp     =  ,
             max_resp     =  ,
             name         =  ,
             adjuster     =  ,
             adj_bars     = 0,
             bar_stat     = 0,
             impute       = 0,
             even_wgt     = 1,
             k            = 1,
             kp_resid     = 0,
             adultkid     =  ,
             visits       = 1,
             pvalue       = 0.05,
             change       = 0,
             meandiff     = 0,
             wgtdata      = 1,
             wgtresp      =  ,
             wgtmean      =  ,
             wgtplan      = 1,
             id_resp      =  ,
             subset       = 1,
             splitflg     = 0, 
             smoothing    = 0,
             dataset      =  ,
             outregre     = 1,
             outname      =  ,
             proc_type    = 0,
             overall_wt   = 2, 
	         wt_type      = 0 ) ;


   %put  -------------------------------------------------  ;
   %put  *** Begining the CAHPS MACRO Version &version *** ;
   %put  -------------------------------------------------  ;

%*-------------------------------------------------------------------------*
|  Identify all variables that need to be local to the CAHPS macro and     |
|  available to all macros called within the CAHPS macro.                  |
*--------------------------------------------------------------------------*;

   %local  adj_new
           numadj_2
           orivtype
           usefmt
           _inadjb
   ;
   %let _inadjb = 0 ;

%*-------------------------------------------------------------------------*
|  Check the paremeters in the macro call for missing critical values or   |
|  in appropriate values.  Either correct or exit and display message in   |
|  log file.                                                               |
*--------------------------------------------------------------------------*;

   %chkparam ;
   %if &_okparam  = 0 %then %goto errmain ;

%*-------------------------------------------------------------------------*
|  Call the plan detail macro to create the formats for the original plans |
|  names, strata plan names, strata weights and subset codes.              |
*--------------------------------------------------------------------------*;

   %plandtal (plandtal = plan_dat) ;

%*-------------------------------------------------------------------------*
|  Calculate the number of items in the parameter VAR, store in _NUMITEM   |
|  and the number of items in the parameter ADJUSTER, store in _NUMADJ.    |
*--------------------------------------------------------------------------*;

   %item_cnt (list     = &var ,
              delim    = %str (' ') ,
              glbl_var = _numitem  ) ;

   %put The number of items in CAHPS macro call is &_numitem. ;


   %item_cnt (list     = &adjuster ,
              delim    = %str (' ') ,
              glbl_var = _numadj  ) ;

   %put The number of adjusters in CAHPS macro call is &_numadj. ;

%*-------------------------------------------------------------------------*
|  Call the pre-setup  macro to create additional formats and other        |
|  variables needed by the CAHPS macro.                                    |
*--------------------------------------------------------------------------*;

   %presetup ;

%*-------------------------------------------------------------------------*
|  Call the settitle macro to create common titles and footnotes for       |
|  reports.                                                                |
*--------------------------------------------------------------------------*;

   %settitle ;

%*-------------------------------------------------------------------------*
|  Begin loop to process data by the subgroups.  If subgroups exist, but   |
|  casemix is to be done for the entire data set, loop only once.          |
*--------------------------------------------------------------------------*;

   %if &subset = 3 %then %do ;
      %let endsub  = &_num_sub ;
   %end ;
   %else %do ;
      %let endsub = 1 ;
   %end ;

   %do sub = 1 %to &endsub ;

      %put  -------------------------------  ;
      %put    CAHPS macro Subset Loop        ;
      %put    Iteration &sub of &endsub      ;
      %put  -------------------------------  ;

      %if &subset = 3 %then %let _numopln = &&_&sub.set ;

%*-------------------------------------------------------------------------*
|  Read in the data for all the cases, merge in IDs and subset based on    |
|  parameter values in CAHPS macro.  Create the item weights for the       |
|  variables.  If only a single item then the weight will be 1.            |
*--------------------------------------------------------------------------*;

      %allcases ;
      %if &_zeroall = 1 %then %goto errmain ;

%*-------------------------------------------------------------------------*
|  If there are adjuster variables, get their means and if required        |
|  impute the means to missing adjuster variable values.                   |
*--------------------------------------------------------------------------*;

      %if &_numadj ^= 0 %then %do ;
         %adjuster ;
      %end ;

%*-------------------------------------------------------------------------*
|  Create the weights for the individual variables in the variable list    |
|  VAR.                                                                    |
*--------------------------------------------------------------------------*;

      %item_wgt ;

%*-------------------------------------------------------------------------*
|  Identify those records which should be kept for analysis.               |
*--------------------------------------------------------------------------*;

      %usable ;

%*-------------------------------------------------------------------------*
|  Merge the usable number of respondents within the plan with the number  |
|  of respondents within the plan                                          |
*--------------------------------------------------------------------------*;

      proc sort data = alln ;
         by plan ;
      run ;

      proc sort data = usen ;
         by plan ;
      run ;

      proc sort data = plandtal ;
         by oplan_id ;
      run ;

      data plan_n ;
         merge alln ( in = a )
               usen ( in = u )
               plandtal ( keep   = oplan_id
                                   subcode
                                   sub_id
                          rename = ( oplan_id = plan )
                          %if &subset = 3 %then %do ;
                             where = ( sub_id = &sub )
                          %end ;
                         )
         ;
         by plan ;
         if u ;
      run ;

%*-------------------------------------------------------------------------*
|  Identify those plans that have less than 100 analyzable records.        |
*--------------------------------------------------------------------------*;

      %low_numb ;

%*-------------------------------------------------------------------------*
|  Create reports for the percent of missing items for each variable and   |
|  adjuster.                                                               |
*--------------------------------------------------------------------------*;

      %pct_miss ;

%*-------------------------------------------------------------------------*
|  Prints a report showing the percent of each response category, some     |
|  variable types collapse the scale down to three values.                 |
*--------------------------------------------------------------------------*;

      %pct_resp ;

%*-------------------------------------------------------------------------*
|  Standardize the data to a mean of zero.  If adjusters are available     |
|  then perform the case mix using PROC REG regression. Calculate the      |
|  regression coeffcients, predictions and residuals for each item.        |
|  Apply the item weights to the adjustments and the residuals.            |
|  Calculate the sum of the squared residuals.                             |
*--------------------------------------------------------------------------*;

      %std_data ;

%*-------------------------------------------------------------------------*
|  Prepare the plan means for the statistical tests.  Center the           |
|  adjustments so the mean is zero and subtract each adjustment from the   |
|  unadjuated plan mean to get an adjusted mean.  Calculate the sum of     |
|  the squared residuals to get the variance by plan.                      |
*--------------------------------------------------------------------------*;

      %preptest ;
   
%*-------------------------------------------------------------------------*
|  Create permanent data sets by appending each data set from each         |
|  iteration of the do loop.                                               |
*--------------------------------------------------------------------------*;

      %perm_ds ;

	  %if &splitflg = 1 %then %do;

	     proc datasets library = work
                      nolist
                      ;
               delete  output_p_split_all ;
         run;

	  %end;
	  %else %do;

         proc datasets library = work
                      nolist
                      ;
               delete  output_p ;
         run;

	  %end;


%*-------------------------------------------------------------------------*
|  If the frequency bars need to be case mixed, then we need to create the |
|  dummy variables for the variables in the &var parameter.  Then the new  |
|  data set must be sent through the case mix procedures and the final     |
|  results merged into the frequency data set, n_*.                        |
*--------------------------------------------------------------------------*;

      %if &adj_bars = 1 and &vartype ne 5 %then %do ;

         %adj_bar ;

      %end ;

%*-------------------------------------------------------------------------*
|  End the DO loop.                                                        |
*--------------------------------------------------------------------------*;

   %end ;

%*-------------------------------------------------------------------------*
|  Create the reports from the permanent data sets.                        |
*--------------------------------------------------------------------------*;

   %mkreport ;

%*-------------------------------------------------------------------------*
|  Use this label to jump out of macro if error encountered                |
*--------------------------------------------------------------------------* ;
   
   %errmain:

%*-------------------------------------------------------------------------*
|  Clean up the work environment. Delete data sets, catalogs, titles and   |
|  footnotes.                                                              |
*--------------------------------------------------------------------------*;

   %cleanup ;

%mend cahps ;

