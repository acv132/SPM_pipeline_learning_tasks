
INSERT FILE="..\..\utils\getDataSetROI.sps".

* ROI analysis for PL

DO REPEAT area =
anterior_cingulate_aal_roi
caudate_td_roi
cingulate_roi
IFG_td_roi
insula_td_roi
middleFG_td_roi
middleTG_td_roi
nacc_ibaspm71_roi
putamen_aal_roi .
   UNIANOVA area BY substance
     /METHOD=SSTYPE(3)
     /INTERCEPT=INCLUDE
     /POSTHOC=substance(LSD BONFERRONI) 
     /PLOT=PROFILE(substance)
     /PRINT=ETASQ DESCRIPTIVE
     /CRITERIA=ALPHA(.05)
     /DESIGN=substance.
END REPEAT.
EXECUTE.

* ROI analysis for OLA encoding


* ROI analysis for OLA retrieval

