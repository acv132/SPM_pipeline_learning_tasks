* Encoding: UTF-8.


* Ettinger et al. 2013
    To examine the task effect (i.e., the presence of PL), mean RTs to
    blocks of random and pattern trials were subjected to a repeated
    measures analysis of variance (ANOVA) with Trial Type (random,
    pattern) and Block (1–5) as within-subjects factors. The amount
    of PL was calculated as the difference between the mean RTs to
    random and pattern trials.[...] The alpha level of testing
    significance was kept at p = 0.05, unless stated otherwise.

/* test of normality for mean reaction times.
SUBTITLE "KS & Shapiro-Wilk".
EXAMINE VARIABLES=MRT_PATALL MRT_RANALL PL_MRT BY Substance_Group
    /PLOT BOXPLOT HISTOGRAM NPPLOT /* STEMLEAF
    /COMPARE GROUPS
    /STATISTICS DESCRIPTIVES
    /CINTERVAL 95
    /MISSING LISTWISE
    /NOTOTAL.

/* Covariance matrixes are assumed to be homogeneous as group sizes are roughly equal;
TITLE "General Linear Model for PL MRTs".
GLM MRT_RAN01 MRT_RAN02 MRT_RAN03 MRT_RAN04 MRT_RAN05 MRT_RAN06 MRT_RAN07 MRT_RAN08 MRT_RAN09
    MRT_RAN10 MRT_PAT01 MRT_PAT02 MRT_PAT03 MRT_PAT04 MRT_PAT05 MRT_PAT06 MRT_PAT07 MRT_PAT08 MRT_PAT09
    MRT_PAT10 BY Substance_Group
    /WSFACTOR=TrialType_MRT_RAN_PAT 2 Polynomial Block 10 Polynomial
    /MEASURE=PL_EFFECT_SUBSTANCE
    /METHOD=SSTYPE(3)
    /PLOT=PROFILE(
    Block
    TrialType_MRT_RAN_PAT
    Block*TrialType_MRT_RAN_PAT
    ) TYPE=LINE ERRORBAR=SE MEANREFERENCE=NO YAXIS=AUTO
    /PRINT= ETASQ HOMOGENEITY    
    /CRITERIA=ALPHA(.05)
    /WSDESIGN=TrialType_MRT_RAN_PAT Block TrialType_MRT_RAN_PAT*Block
    /DESIGN=Substance_Group /* what exactly does this do? Technically obsolete I think because of the GLM BY command but keeping it for now
    /EMMEANS=TABLES(OVERALL)
    /EMMEANS=TABLES(Substance_Group) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(TrialType_MRT_RAN_PAT) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(Block) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(Substance_Group*TrialType_MRT_RAN_PAT) COMPARE(Substance_Group) ADJ(BONFERRONI)
    /EMMEANS=TABLES(Substance_Group*Block) COMPARE(Substance_Group)  ADJ(BONFERRONI)
    /EMMEANS=TABLES(TrialType_MRT_RAN_PAT*Block) COMPARE(TrialType_MRT_RAN_PAT)  ADJ(BONFERRONI) /* same as matlab plot
    /EMMEANS=TABLES(Substance_Group*TrialType_MRT_RAN_PAT*Block) COMPARE(Substance_Group)  ADJ(BONFERRONI)

TITLE "General Linear Model for PL SDs".
GLM SD_RAN01 SD_RAN02 SD_RAN03 SD_RAN04 SD_RAN05 SD_RAN06 SD_RAN07 SD_RAN08 SD_RAN09
    SD_RAN10 SD_PAT01 SD_PAT02 SD_PAT03 SD_PAT04 SD_PAT05 SD_PAT06 SD_PAT07 SD_PAT08 SD_PAT09
    SD_PAT10 BY Substance_Group
    /WSFACTOR=TrialType_SD_RAN_PAT 2 Polynomial Block 10 Polynomial
    /MEASURE=PL_EFFECT_SUBSTANCE
    /METHOD=SSTYPE(3)
    /PLOT=PROFILE(
    Block
    ) TYPE=LINE ERRORBAR=SE MEANREFERENCE=NO YAXIS=AUTO
    /PRINT= ETASQ HOMOGENEITY
    /CRITERIA=ALPHA(.05)
    /WSDESIGN=TrialType_SD_RAN_PAT Block TrialType_SD_RAN_PAT*Block
    /DESIGN=Substance_Group
    /EMMEANS=TABLES(OVERALL)
    /EMMEANS=TABLES(Substance_Group) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(TrialType_SD_RAN_PAT) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(Block) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(Substance_Group*TrialType_SD_RAN_PAT) COMPARE(Substance_Group) ADJ(BONFERRONI)
    /EMMEANS=TABLES(Substance_Group*Block) COMPARE(Substance_Group)  ADJ(BONFERRONI)
    /EMMEANS=TABLES(TrialType_SD_RAN_PAT*Block) COMPARE(TrialType_SD_RAN_PAT)  ADJ(BONFERRONI)
    /EMMEANS=TABLES(Substance_Group*TrialType_SD_RAN_PAT*Block) COMPARE(Substance_Group)  ADJ(BONFERRONI)

TITLE "General Linear Model for PL coefficient of variation (CV)".
GLM CV_RAN01 CV_RAN02 CV_RAN03 CV_RAN04 CV_RAN05 CV_RAN06 CV_RAN07 CV_RAN08 CV_RAN09
    CV_RAN10 CV_PAT01 CV_PAT02 CV_PAT03 CV_PAT04 CV_PAT05 CV_PAT06 CV_PAT07 CV_PAT08 CV_PAT09
    CV_PAT10 BY Substance_Group
    /WSFACTOR=TrialType_CV_RAN_PAT 2 Polynomial Block 10 Polynomial
    /MEASURE=PL_EFFECT_SUBSTANCE
    /METHOD=SSTYPE(3)
    /PLOT=PROFILE(
    Block
    ) TYPE=LINE ERRORBAR=SE MEANREFERENCE=NO YAXIS=AUTO
    /PRINT= ETASQ HOMOGENEITY
    /CRITERIA=ALPHA(.05)
    /WSDESIGN=TrialType_CV_RAN_PAT Block TrialType_CV_RAN_PAT*Block
    /DESIGN=Substance_Group
    /EMMEANS=TABLES(OVERALL)
    /EMMEANS=TABLES(Substance_Group) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(TrialType_CV_RAN_PAT) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(Block) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(Substance_Group*TrialType_CV_RAN_PAT) COMPARE(Substance_Group) ADJ(BONFERRONI)
    /EMMEANS=TABLES(Substance_Group*Block) COMPARE(Substance_Group)  ADJ(BONFERRONI)
    /EMMEANS=TABLES(TrialType_CV_RAN_PAT*Block) COMPARE(TrialType_CV_RAN_PAT)  ADJ(BONFERRONI)
    /EMMEANS=TABLES(Substance_Group*TrialType_CV_RAN_PAT*Block) COMPARE(Substance_Group)  ADJ(BONFERRONI)

/* Ettinger et al. (2013): The possible association between the amount of PL and personality scores was examined with correlational analysis (Pearson’s r).
/* here instead sedation ratings.
CORRELATIONS
    /VARIABLES=PL_MRT PL_SD PL_ERR MRT_PATALL MRT_RANALL PL_EFFECT_OVERALL CV_PATALL CV_RANALL CV_DIFF MWT_Bscoremax37
    CS_SR_MENTALSEDATION CS_SR_PHYSICALSEDATION CS_SR_OTHERMOOD CS_SR_TRANQUILIZATION
    /PRINT=TWOTAIL NOSIG FULL
    /STATISTICS DESCRIPTIVES  /CI CILEVEL(95)
    /MISSING=PAIRWISE.
NONPAR CORR
    /VARIABLES=PL_MRT PL_SD PL_ERR MRT_PATALL MRT_RANALL PL_EFFECT_OVERALL CV_PATALL CV_RANALL CV_DIFF MWT_Bscoremax37
    CS_SR_MENTALSEDATION CS_SR_PHYSICALSEDATION CS_SR_OTHERMOOD CS_SR_TRANQUILIZATION
    /PRINT=SPEARMAN TWOTAIL NOSIG FULL
    /CI METHOD(FHP)  CILEVEL(95)
    /MISSING=PAIRWISE.

