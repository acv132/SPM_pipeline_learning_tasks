* Encoding: UTF-8.

/* Bond & Lader (1974) sedation rating: items  4, 6, 8, 9, 10, 12, 14, and 16 are inverted

/* 4.
COMPUTE  PREMED_SR_clearheadedmuzzy=100 -  PREMED_SR_muzzyclearheaded.
COMPUTE  PRESCAN_SR_clearheadedmuzzy=100 -  PRESCAN_SR_muzzyclearheaded.

/* 6.
COMPUTE  PREMED_SR_energeticlethargic=100 -  PREMED_SR_lethargicenergetic.
COMPUTE  PRESCAN_SR_energeticlethargic=100 -  PRESCAN_SR_lethargicenergetic.

/* 8.
COMPUTE  PREMED_SR_tranquiltroubled=100 -  PREMED_SR_troubledtranquil.
COMPUTE  PRESCAN_SR_tranquiltroubled=100 -  PRESCAN_SR_troubledtranquil.

/* 9.
COMPUTE  PREMED_SR_quickwittedmentallyslow=100 -  PREMED_SR_mentallyslowquickwitted.
COMPUTE  PRESCAN_SR_quickwittedmentallyslow=100 -  PRESCAN_SR_mentallyslowquickwitted.


/* 10.
COMPUTE  PREMED_SR_relaxedtense = 100- PREMED_SR_tenserelaxed.
COMPUTE  PRESCAN_SR_relaxedtense  = 100- PRESCAN_SR_tenserelaxed.


/*12.
COMPUTE  PREMED_SR_competentincompetent=100 -  PREMED_SR_incompetentcompetent.
COMPUTE  PRESCAN_SR_competentincompetent=100 -  PRESCAN_SR_incompetentcompetent.

/* 14.
COMPUTE  PREMED_SR_amicableantagonistic=100 -  PREMED_SR_antagonisticamicable.
COMPUTE  PRESCAN_SR_amicableantagonistic=100 -  PRESCAN_SR_antagonisticamicable.

/*16.
COMPUTE  PREMED_SR_gregariouswithdrawn=100 -  PREMED_SR_withdrawngregarious.
COMPUTE  PRESCAN_SR_gregariouswithdrawn=100 -  PRESCAN_SR_withdrawngregarious.

/* skewness is corrected by a log-e tranformation of all items.
COMPUTE LV_PREMED_SR_alertdrowsy=LN(PREMED_SR_alertdrowsy).
COMPUTE LV_PREMED_SR_attentivedreamy=LN( PREMED_SR_attentivedreamy).
COMPUTE LV_PREMED_SR_energeticlethargic=LN( PREMED_SR_energeticlethargic).
COMPUTE LV_PREMED_SR_clearheadedmuzzy=LN( PREMED_SR_clearheadedmuzzy).
COMPUTE LV_PREMED_SR_coordinatedclumsy=LN( PREMED_SR_coordinatedclumsy).
COMPUTE LV_PREMED_SR_quickwittedmentallyslow=LN( PREMED_SR_quickwittedmentallyslow).
COMPUTE LV_PREMED_SR_strongfeeble=LN( PREMED_SR_strongfeeble).
COMPUTE LV_PREMED_SR_interestedbored=LN( PREMED_SR_interestedbored).
COMPUTE LV_PREMED_SR_competentincompetent=LN( PREMED_SR_competentincompetent).
COMPUTE LV_PREMED_SR_happysad=LN( PREMED_SR_happysad).
COMPUTE LV_PREMED_SR_amicableantagonistic=LN( PREMED_SR_amicableantagonistic).
COMPUTE LV_PREMED_SR_tranquiltroubled=LN( PREMED_SR_tranquiltroubled).
COMPUTE LV_PREMED_SR_contenteddiscontented=LN( PREMED_SR_contenteddiscontented).
COMPUTE LV_PREMED_SR_gregariouswithdrawn=LN( PREMED_SR_gregariouswithdrawn).
COMPUTE LV_PREMED_SR_calmexcited=LN( PREMED_SR_calmexcited).
COMPUTE LV_PREMED_SR_relaxedtense=LN( PREMED_SR_relaxedtense).
COMPUTE LV_PRESCAN_SR_alertdrowsy=LN( PRESCAN_SR_alertdrowsy).
COMPUTE LV_PRESCAN_SR_attentivedreamy=LN( PRESCAN_SR_attentivedreamy).
COMPUTE LV_PRESCAN_SR_energeticlethargic=LN( PRESCAN_SR_energeticlethargic).
COMPUTE LV_PRESCAN_SR_clearheadedmuzzy=LN( PRESCAN_SR_clearheadedmuzzy).
COMPUTE LV_PRESCAN_SR_coordinatedclumsy=LN( PRESCAN_SR_coordinatedclumsy).
COMPUTE LV_PRESCAN_SR_quickwittedmentallyslow=LN( PRESCAN_SR_quickwittedmentallyslow).
COMPUTE LV_PRESCAN_SR_strongfeeble=LN( PRESCAN_SR_strongfeeble).
COMPUTE LV_PRESCAN_SR_interestedbored=LN( PRESCAN_SR_interestedbored).
COMPUTE LV_PRESCAN_SR_competentincompetent=LN( PRESCAN_SR_competentincompetent).
COMPUTE LV_PRESCAN_SR_happysad=LN( PRESCAN_SR_happysad).
COMPUTE LV_PRESCAN_SR_amicableantagonistic=LN( PRESCAN_SR_amicableantagonistic).
COMPUTE LV_PRESCAN_SR_tranquiltroubled=LN( PRESCAN_SR_tranquiltroubled).
COMPUTE LV_PRESCAN_SR_contenteddiscontented=LN( PRESCAN_SR_contenteddiscontented).
COMPUTE LV_PRESCAN_SR_gregariouswithdrawn=LN( PRESCAN_SR_gregariouswithdrawn).
COMPUTE LV_PRESCAN_SR_calmexcited=LN( PRESCAN_SR_calmexcited).
COMPUTE LV_PRESCAN_SR_relaxedtense=LN( PRESCAN_SR_relaxedtense).

EXECUTE.

/* factors extracted by factor analysis as described in Bond & Lader (1974) are computed for pre-medication time point and pre-scan time point, respectively.
COMPUTE SR_F1ALERT_PREMED =MEAN(LV_PREMED_SR_alertdrowsy ,LV_PREMED_SR_attentivedreamy,
    LV_PREMED_SR_energeticlethargic,  LV_PREMED_SR_clearheadedmuzzy,  LV_PREMED_SR_coordinatedclumsy ,
    LV_PREMED_SR_quickwittedmentallyslow , LV_PREMED_SR_strongfeeble , LV_PREMED_SR_interestedbored ,LV_PREMED_SR_competentincompetent).
COMPUTE SR_F2CONTENTED_PREMED =MEAN(LV_PREMED_SR_happysad,LV_PREMED_SR_amicableantagonistic,  LV_PREMED_SR_tranquiltroubled, LV_PREMED_SR_contenteddiscontented, LV_PREMED_SR_gregariouswithdrawn).
COMPUTE SR_F3CALM_PREMED =MEAN (LV_PREMED_SR_calmexcited ,LV_PREMED_SR_relaxedtense).

COMPUTE SR_F1ALERT_PRESCAN =MEAN(LV_PRESCAN_SR_alertdrowsy ,LV_PRESCAN_SR_attentivedreamy,
    LV_PRESCAN_SR_energeticlethargic, LV_PRESCAN_SR_clearheadedmuzzy, LV_PRESCAN_SR_coordinatedclumsy ,
    LV_PRESCAN_SR_quickwittedmentallyslow , LV_PRESCAN_SR_strongfeeble , LV_PRESCAN_SR_interestedbored ,LV_PRESCAN_SR_competentincompetent).
COMPUTE SR_F2CONTENTED_PRESCAN =MEAN(LV_PRESCAN_SR_happysad,LV_PRESCAN_SR_amicableantagonistic,  LV_PRESCAN_SR_tranquiltroubled, LV_PRESCAN_SR_contenteddiscontented, LV_PRESCAN_SR_gregariouswithdrawn).
COMPUTE SR_F3CALM_PRESCAN =MEAN (LV_PRESCAN_SR_calmexcited ,LV_PRESCAN_SR_relaxedtense).
EXECUTE.

/* sedation rating scores are compared between the time points of measurement: pre-medication and pre-scan.
SUBTITLE "ALERT SED RAT".
GLM SR_F1ALERT_PREMED SR_F1ALERT_PRESCAN BY Substance_Group
    /WSFACTOR=T1_T2 2 Polynomial
    /MEASURE=ALERT_SEDRAT
    /METHOD=SSTYPE(3)
    /POSTHOC=Substance_Group(BONFERRONI)
    /PLOT=PROFILE(T1_T2*Substance_Group)
    /EMMEANS=TABLES(OVERALL)
    /EMMEANS=TABLES(Substance_Group) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(T1_T2) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(Substance_Group*T1_T2)
    /PRINT=DESCRIPTIVE ETASQ HOMOGENEITY
    /CRITERIA=ALPHA(.05)
    /WSDESIGN=T1_T2
    /DESIGN=Substance_Group.

SUBTITLE "CONTENTED SED RAT".
GLM SR_F2CONTENTED_PREMED SR_F2CONTENTED_PRESCAN BY Substance_Group
    /WSFACTOR=T1_T2 2 Polynomial
    /MEASURE=CONTENTED_SEDRAT
    /METHOD=SSTYPE(3)
    /POSTHOC=Substance_Group(BONFERRONI)
    /PLOT=PROFILE(T1_T2*Substance_Group)
    /EMMEANS=TABLES(OVERALL)
    /EMMEANS=TABLES(Substance_Group) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(T1_T2) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(Substance_Group*T1_T2)
    /PRINT=DESCRIPTIVE ETASQ HOMOGENEITY
    /CRITERIA=ALPHA(.05)
    /WSDESIGN=T1_T2
    /DESIGN=Substance_Group.

SUBTITLE "CALM SED RAT".
GLM SR_F3CALM_PREMED SR_F3CALM_PRESCAN BY Substance_Group
    /WSFACTOR=T1_T2 2 Polynomial
    /MEASURE=CALM_SEDRAT
    /METHOD=SSTYPE(3)
    /POSTHOC=Substance_Group(BONFERRONI)
    /PLOT=PROFILE(T1_T2*Substance_Group)
    /EMMEANS=TABLES(OVERALL)
    /EMMEANS=TABLES(Substance_Group) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(T1_T2) COMPARE ADJ(BONFERRONI)
    /EMMEANS=TABLES(Substance_Group*T1_T2)
    /PRINT=DESCRIPTIVE ETASQ HOMOGENEITY
    /CRITERIA=ALPHA(.05)
    /WSDESIGN=T1_T2
    /DESIGN=Substance_Group.
EXECUTE.

