* Encoding: UTF-8.

* Kukolja et al. 2009
    A random effects model was employed. Encoding and retrieval sessions were analysed separately. For the encoding session,
    the data were analysed by defining three event types at the first level of the random effects model,
    consisting of two effects of interest (CorSCE, FalSCE) and one effect of no interest
    (comprising items presented during encoding but which were classified as “new” during retrieval as well as missed responses
    in the encoding and retrieval sessions). For the retrieval session, three event types were defined: two effects of interest (CorSCR, FalSCR)
    and one effect of no interest (including items shown during encoding but which were falsely attributed to be “new”,
    new items correctly or incorrectly responded to, and missed responses). The six head movement parameters were included as confounds
    between-subject factor substance group and within-subject factor source judgement (correct, false);
    Additionally we applied a signal detection analysis to investigate ageingrelated differences in “old” versus “new” judgements. This
    analysis determines the sensitivity, d', and the response criterion, c, of classifying old items as “old”

* Encoding
    a repeated measures ANOVAon RTs for effect of substance, subsequent source judgement or interaction between them
* Retrieval
    difference in accuracy in recognizing items as “old”
    signal detection analysis for d' and response bias c (and beta)
    two-way repeated measures ANOVA on RTs with the innersubject factor spatial context judgement (CorSCR, FalSCR) and the inter-subject factor substance
    Per_OLDrecognized
    OLA_dprime OLA_responsebias_c OLA_responsebias_beta

*Include TD and/or BMI as covariate?
Per_Judgement or Per_CORSCR or MRTs?.

TITLE "Difference in percentage of correctly retrieved spatial context".
UNIANOVA Per_CORSCR BY  Substance_Group
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
TITLE "Difference in percentage of falsly retrieved spatial context".
UNIANOVA Per_FALSCR BY  Substance_Group
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

TITLE "Difference in lnMRT of correctly retrieved spatial context".
UNIANOVA lnMRT_CORSCR BY  Substance_Group
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
TITLE "Difference in lnMRT of falsly retrieved spatial context".
UNIANOVA lnMRT_FALSCR BY  Substance_Group
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

/* how to include bias c and beta?.
TITLE "Group difference in d'".
UNIANOVA OLA_dprime BY  Substance_Group  
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

 * TITLE "Group difference in d', bias c and beta".
 * GLM OLA_dprime BY Substance_Group WITH OLA_responsebias_c    
    /WSFACTOR=judgement 3 Polynomial
    /MEASURE=measure
    /METHOD=SSTYPE(3)
    /PLOT=PROFILE(Substance_Group Substance_Group*judgement) TYPE=LINE ERRORBAR=NO
    MEANREFERENCE=NO YAXIS=AUTO
    /EMMEANS=TABLES(OVERALL)
    /EMMEANS=TABLES(Substance_Group) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(judgement) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(Substance_Group*judgement) COMPARE(Substance_Group) ADJ(BONFERRONI)
    /EMMEANS=TABLES(Substance_Group*judgement) COMPARE(judgement) ADJ(BONFERRONI)
    /PRINT=DESCRIPTIVE ETASQ HOMOGENEITY
    /CRITERIA=ALPHA(.05)
    /WSDESIGN=judgement
    /DESIGN= Substance_Group OLA_R_TD BMI.

TITLE "Difference in correctly judged new items".
UNIANOVA Per_CORNEW BY  Substance_Group
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

/* tests of homogeneity of variances for (standardized) mean reaction times of the OLA task.
TITLE "KS & Shapiro-Wilk".
SUBTITLE "lnMRT_CORSCR KS & Shapiro-Wilk".
EXAMINE VARIABLES=lnMRT_CORSCR BY Substance_Group
    /PLOT BOXPLOT HISTOGRAM NPPLOT /* STEMLEAF
    /COMPARE GROUPS
    /STATISTICS DESCRIPTIVES
    /CINTERVAL 95
    /MISSING LISTWISE
    /NOTOTAL.

SUBTITLE "lnMRT_FALSCR KS & Shapiro-Wilk".
EXAMINE VARIABLES= lnMRT_FALSCR BY Substance_Group
    /PLOT BOXPLOT HISTOGRAM NPPLOT /* STEMLEAF
    /COMPARE GROUPS
    /STATISTICS DESCRIPTIVES
    /CINTERVAL 95
    /MISSING LISTWISE
    /NOTOTAL.

SUBTITLE "lnMRT_correctJudgement KS & Shapiro-Wilk".
EXAMINE VARIABLES=  lnMRT_correctJudgement BY Substance_Group
    /PLOT BOXPLOT HISTOGRAM NPPLOT /* STEMLEAF
    /COMPARE GROUPS
    /STATISTICS DESCRIPTIVES
    /CINTERVAL 95
    /MISSING LISTWISE
    /NOTOTAL.

SUBTITLE "lnMRT_falseJudgement KS & Shapiro-Wilk".
EXAMINE VARIABLES=lnMRT_falseJudgement BY Substance_Group
    /PLOT BOXPLOT HISTOGRAM NPPLOT /* STEMLEAF
    /COMPARE GROUPS
    /STATISTICS DESCRIPTIVES
    /CINTERVAL 95
    /MISSING LISTWISE
    /NOTOTAL.

