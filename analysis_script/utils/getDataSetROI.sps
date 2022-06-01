
GET DATA  /TYPE=TXT
  /FILE="..\..\_DATA\results\timeCourses\timecourses_PL_ff.txt"
  /DELCASE=LINE
  /DELIMITERS=";"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  LBID A5
  substance A3
  anterior_cingulate_aal_roi A20
  caudate_td_roi A21
  cingulate_roi A21
  IFG_td_roi A21
  insula_td_roi A21
  middleFG_td_roi A21
  middleTG_td_roi A21
  nacc_ibaspm71_roi A21
  putamen_aal_roi A20.
CACHE.
EXECUTE.
DATASET NAME timecourses_PL_ff WINDOW=FRONT.

GET DATA  /TYPE=TXT
  /FILE="..\..\_DATA\results\timeCourses\timecourses_PL_ANOVA.txt"
  /DELCASE=LINE
  /DELIMITERS=";"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  LBID A5
  substance A3
  anterior_cingulate_aal_roi A20
  caudate_td_roi A21
  cingulate_roi A21
  IFG_td_roi A21
  insula_td_roi A21
  middleFG_td_roi A21
  middleTG_td_roi A21
  nacc_ibaspm71_roi A21
  putamen_aal_roi A20.
CACHE.
EXECUTE.
DATASET NAME timecourses_PL_ANOVA WINDOW=FRONT.


GET DATA  /TYPE=TXT
  /FILE="..\..\_DATA\results\timeCourses\timecourses_OLA_E_ff.txt"
  /DELCASE=LINE
  /DELIMITERS=";"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  LBID F5.0
  substance A3
  fusiform_aal_roi F18.15
  hippocampus_aal_roi A19
  insula_td_roi A19
  middleFG_td_roi A19
  parahippocampus_aal_roi A19.
CACHE.
EXECUTE.
DATASET NAME timecourses_OLA_E_ff WINDOW=FRONT.

GET DATA  /TYPE=TXT
  /FILE="..\..\_DATA\results\timeCourses\timecourses_OLA_E_ANOVA.txt"
  /DELCASE=LINE
  /DELIMITERS=";"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  LBID F5.0
  substance A3
  fusiform_aal_roi F18.15
  hippocampus_aal_roi A19
  insula_td_roi A19
  middleFG_td_roi A19
  parahippocampus_aal_roi A19.
CACHE.
EXECUTE.
DATASET NAME timecourses_OLA_E_ANOVA WINDOW=FRONT.


GET DATA  /TYPE=TXT
  /FILE="..\..\_DATA\results\timeCourses\timecourses_OLA_R_ff.txt"
  /DELCASE=LINE
  /DELIMITERS=";"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  LBID F5.0
  substance A3
  fusiform_aal_roi F18.15
  hippocampus_aal_roi A19
  insula_td_roi A19
  middleFG_td_roi A19
  parahippocampus_aal_roi A19.
CACHE.
EXECUTE.
DATASET NAME timecourses_OLA_R_ff WINDOW=FRONT.

GET DATA  /TYPE=TXT
  /FILE="..\..\_DATA\results\timeCourses\timecourses_OLA_R_ANOVA.txt"
  /DELCASE=LINE
  /DELIMITERS=";"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  LBID F5.0
  substance A3
  fusiform_aal_roi F18.15
  hippocampus_aal_roi A19
  insula_td_roi A19
  middleFG_td_roi A19
  parahippocampus_aal_roi A19.
CACHE.
EXECUTE.
DATASET NAME timecourses_OLA_R_ANOVA WINDOW=FRONT.

