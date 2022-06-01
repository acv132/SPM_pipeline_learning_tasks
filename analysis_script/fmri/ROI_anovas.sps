
CD "F:\UniBonnPraktikum2022\analysis_script\fmri\timecourseROI".

INSERT FILE="..\utils\getDataSetROI.sps".

/* ROI analysis for PL.

DATASET ACTIVATE timecourses_PL_ff.
EXECUTE.
OUTPUT NEW.

UNIANOVA 
anterior_cingulate_aal_roi
caudate_td_roi
cingulate_roi
IFG_td_roi
insula_td_roi
middleFG_td_roi
middleTG_td_roi
nacc_ibaspm71_roi
putamen_aal_roi  BY substance
     /METHOD=SSTYPE(3)
     /INTERCEPT=INCLUDE
     /POSTHOC=substance(LSD BONFERRONI) 
     /PLOT=PROFILE(substance)
     /PRINT=ETASQ DESCRIPTIVE
     /CRITERIA=ALPHA(.05)
     /DESIGN=substance.
EXECUTE.

OUTPUT SAVE OUTFILE  = "..\..\_DATA\results\timeCourses\timecourses_PL_ff.spv".

DATASET ACTIVATE timecourses_PL_ANOVA.
EXECUTE.
OUTPUT NEW.

UNIANOVA 
anterior_cingulate_aal_roi
caudate_td_roi
cingulate_roi
IFG_td_roi
insula_td_roi
middleFG_td_roi
middleTG_td_roi
nacc_ibaspm71_roi
putamen_aal_roi  BY substance
     /METHOD=SSTYPE(3)
     /INTERCEPT=INCLUDE
     /POSTHOC=substance(LSD BONFERRONI) 
     /PLOT=PROFILE(substance)
     /PRINT=ETASQ DESCRIPTIVE
     /CRITERIA=ALPHA(.05)
     /DESIGN=substance.
EXECUTE.

OUTPUT SAVE OUTFILE  = "..\..\_DATA\results\timeCourses\timecourses_PL_ANOVA.spv".

/* ROI analysis for OLA E.

DATASET ACTIVATE timecourses_OLA_E_ff.
EXECUTE.
OUTPUT NEW.

 UNIANOVA
fusiform_aal_roi
hippocampus_aal_roi
insula_td_roi
middleFG_td_roi
parahippocampus_aal_roi BY substance
     /METHOD=SSTYPE(3)
     /INTERCEPT=INCLUDE
     /POSTHOC=substance(LSD BONFERRONI) 
     /PLOT=PROFILE(substance)
     /PRINT=ETASQ DESCRIPTIVE
     /CRITERIA=ALPHA(.05)
     /DESIGN=substance.
EXECUTE.

OUTPUT SAVE OUTFILE  = "..\..\_DATA\results\timeCourses\timecourses_OLA_E_ff.spv".

DATASET ACTIVATE timecourses_OLA_E_ANOVA.
EXECUTE.
OUTPUT NEW.

UNIANOVA
fusiform_aal_roi
hippocampus_aal_roi
insula_td_roi
middleFG_td_roi
parahippocampus_aal_roi BY substance
     /METHOD=SSTYPE(3)
     /INTERCEPT=INCLUDE
     /POSTHOC=substance(LSD BONFERRONI) 
     /PLOT=PROFILE(substance)
     /PRINT=ETASQ DESCRIPTIVE
     /CRITERIA=ALPHA(.05)
     /DESIGN=substance.
EXECUTE.

OUTPUT SAVE OUTFILE  = "..\..\_DATA\results\timeCourses\timecourses_OLA_E_ANOVA.spv".

/* ROI analysis for OLA R.

DATASET ACTIVATE timecourses_OLA_R_ff. 
EXECUTE.
OUTPUT NEW.

UNIANOVA
fusiform_aal_roi
hippocampus_aal_roi
insula_td_roi
middleFG_td_roi
parahippocampus_aal_roi BY substance
     /METHOD=SSTYPE(3)
     /INTERCEPT=INCLUDE
     /POSTHOC=substance(LSD BONFERRONI) 
     /PLOT=PROFILE(substance)
     /PRINT=ETASQ DESCRIPTIVE
     /CRITERIA=ALPHA(.05)
     /DESIGN=substance.
EXECUTE.

OUTPUT SAVE OUTFILE  = "..\..\_DATA\results\timeCourses\timecourses_OLA_R_ff.spv".

DATASET ACTIVATE timecourses_OLA_R_ANOVA.
EXECUTE.
OUTPUT NEW.

UNIANOVA
fusiform_aal_roi
hippocampus_aal_roi
insula_td_roi
middleFG_td_roi
parahippocampus_aal_roi BY substance
     /METHOD=SSTYPE(3)
     /INTERCEPT=INCLUDE
     /POSTHOC=substance(LSD BONFERRONI) 
     /PLOT=PROFILE(substance)
     /PRINT=ETASQ DESCRIPTIVE
     /CRITERIA=ALPHA(.05)
     /DESIGN=substance.
EXECUTE.

OUTPUT SAVE OUTFILE  = "..\..\_DATA\results\timeCourses\timecourses_OLA_R_ANOVA.spv".

