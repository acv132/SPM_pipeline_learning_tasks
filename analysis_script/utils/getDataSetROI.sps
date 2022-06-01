
GET DATA  /TYPE=TXT
  /FILE="F:\UniBonnPraktikum2022\_DATA\results\timeCourses\timecourses_PL_ff.csv"
  /DELCASE=LINE
  /DELIMITERS=";"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  LBID A5.0
  substance A3
  anterior_cingulate_aal_roi F12.9
  caudate_td_roi F12.9
  cingulate_roi F12.9
  IFG_td_roi F12.9
  insula_td_roi F12.9
  middleFG_td_roi F12.9
  middleTG_td_roi F12.9
  nacc_ibaspm71_roi F12.9
  putamen_aal_roi F12.9.
CACHE.
DATASET NAME timecourses_PL_ff WINDOW=FRONT.
SAVE OUTFILE="F:\UniBonnPraktikum2022\_DATA\results\timeCourses\timecourses_PL_ff.sav".


GET DATA  /TYPE=TXT
  /FILE="F:\UniBonnPraktikum2022\_DATA\results\timeCourses\timecourses_PL_ANOVA.csv"
  /DELCASE=LINE
  /DELIMITERS=";"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  LBID A5.0
  substance A3
  anterior_cingulate_aal_roi F12.9
  caudate_td_roi F12.9
  cingulate_roi F12.9
  IFG_td_roi F12.9
  insula_td_roi F12.9
  middleFG_td_roi F12.9
  middleTG_td_roi F12.9
  nacc_ibaspm71_roi F12.9
  putamen_aal_roi F12.9.
CACHE.
DATASET NAME timecourses_PL_ANOVA WINDOW=FRONT.
SAVE OUTFILE="F:\UniBonnPraktikum2022\_DATA\results\timeCourses\timecourses_PL_ANOVA.sav".

GET DATA  /TYPE=TXT
  /FILE="F:\UniBonnPraktikum2022\_DATA\results\timeCourses\timecourses_OLA_E_ff.csv"
  /DELCASE=LINE
  /DELIMITERS=";"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  LBID F5.0
  substance A3
  fusiform_aal_roi F12.9
  hippocampus_aal_roi F12.9
  insula_td_roi F12.9
  middleFG_td_roi F12.9
  parahippocampus_aal_roi F12.9.
CACHE.
EXECUTE.
DATASET NAME timecourses_OLA_E_ff WINDOW=FRONT.
SAVE OUTFILE="F:\UniBonnPraktikum2022\_DATA\results\timeCourses\timecourses_OLA_E_ff.sav".

GET DATA  /TYPE=TXT
  /FILE="F:\UniBonnPraktikum2022\_DATA\results\timeCourses\timecourses_OLA_E_ANOVA.csv"
  /DELCASE=LINE
  /DELIMITERS=";"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  LBID F5.0
  substance A3
  fusiform_aal_roi F12.9
  hippocampus_aal_roi F12.9
  insula_td_roi F12.9
  middleFG_td_roi F12.9
  parahippocampus_aal_roi F12.9.
CACHE.
EXECUTE.
DATASET NAME timecourses_OLA_E_ANOVA WINDOW=FRONT.
SAVE OUTFILE="F:\UniBonnPraktikum2022\_DATA\results\timeCourses\timecourses_OLA_E_ANOVA.sav".


GET DATA  /TYPE=TXT
  /FILE="F:\UniBonnPraktikum2022\_DATA\results\timeCourses\timecourses_OLA_R_ff.csv"
  /DELCASE=LINE
  /DELIMITERS=";"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  LBID F5.0
  substance A3
  fusiform_aal_roi F12.9
  hippocampus_aal_roi F12.9
  insula_td_roi F12.9
  middleFG_td_roi F12.9
  parahippocampus_aal_roi F12.9.
CACHE.
EXECUTE.
DATASET NAME timecourses_OLA_R_ff WINDOW=FRONT.
SAVE OUTFILE="F:\UniBonnPraktikum2022\_DATA\results\timeCourses\timecourses_OLA_R_ff.sav".

GET DATA  /TYPE=TXT
  /FILE="F:\UniBonnPraktikum2022\_DATA\results\timeCourses\timecourses_OLA_R_ANOVA.csv"
  /DELCASE=LINE
  /DELIMITERS=";"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  LBID F5.0
  substance A3
  fusiform_aal_roi F12.9
  hippocampus_aal_roi F12.9
  insula_td_roi F12.9
  middleFG_td_roi F12.9
  parahippocampus_aal_roi F12.9.
CACHE.
EXECUTE.
DATASET NAME timecourses_OLA_R_ANOVA WINDOW=FRONT.
SAVE OUTFILE="F:\UniBonnPraktikum2022\_DATA\results\timeCourses\timecourses_OLA_R_ANOVA.sav".




