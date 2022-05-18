* Encoding: UTF-8.

*Include TD and/or BMI as covariate?

TITLE "Difference in percentage of old and recognized items".
UNIANOVA Per_OLDrecognized BY  Substance_Group
    /RANDOM=Substance_Group
    /METHOD=SSTYPE(3)
    /INTERCEPT=INCLUDE
    /PLOT=PROFILE(Substance_Group)
    /EMMEANS=TABLES(OVERALL)
    /EMMEANS=TABLES(Substance_Group) COMPARE ADJ(BONFERRONI)
    /PRINT=ETASQ DESCRIPTIVE HOMOGENEITY
    /CRITERIA=ALPHA(.05)
    /DESIGN=Substance_Group.
EXECUTE.

