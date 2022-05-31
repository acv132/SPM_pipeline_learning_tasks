* Encoding: UTF-8.

GET DATA  /TYPE=TXT
  /FILE="..\results\SPSS_taskvariables.csv"
  /ENCODING='UTF8'
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  LBID AUTO
  Drug AUTO
  Per_correctJudgement AUTO
  MRT_correctJudgement AUTO
  SD_correctJudgement AUTO
  Per_falseJudgement AUTO
  MRT_falseJudgement AUTO
  SD_falseJudgement AUTO
  Per_CORSCR AUTO
  MRT_CORSCR AUTO
  SD_CORSCR AUTO
  Per_FALSCR AUTO
  MRT_FALSCR AUTO
  SD_FALSCR AUTO
  Per_FORGSCR AUTO
  MRT_FORGSCR AUTO
  SD_FORGSCR AUTO
  Per_MISSCR AUTO
  Per_CORNEW AUTO
  MRT_CORNEW AUTO
  SD_CORNEW AUTO
  Per_FALNEW AUTO
  MRT_FALNEW AUTO
  SD_FALNEW AUTO
  Per_MISSNEW AUTO
  OLA_dprime AUTO
  OLA_responsebias_c AUTO
  OLA_responsebias_beta AUTO
  OLA_CHISQUARE AUTO
  OLA_P_CHISQUARE_P AUTO
  PL_MRT AUTO
  PL_SD AUTO
  PL_ERR AUTO
  ERR_RAN01 AUTO
  ERR_RAN02 AUTO
  ERR_RAN03 AUTO
  ERR_RAN04 AUTO
  ERR_RAN05 AUTO
  ERR_RAN06 AUTO
  ERR_RAN07 AUTO
  ERR_RAN08 AUTO
  ERR_RAN09 AUTO
  ERR_RAN10 AUTO
  MRT_RAN01 AUTO
  MRT_RAN02 AUTO
  MRT_RAN03 AUTO
  MRT_RAN04 AUTO
  MRT_RAN05 AUTO
  MRT_RAN06 AUTO
  MRT_RAN07 AUTO
  MRT_RAN08 AUTO
  MRT_RAN09 AUTO
  MRT_RAN10 AUTO
  SD_RAN01 AUTO
  SD_RAN02 AUTO
  SD_RAN03 AUTO
  SD_RAN04 AUTO
  SD_RAN05 AUTO
  SD_RAN06 AUTO
  SD_RAN07 AUTO
  SD_RAN08 AUTO
  SD_RAN09 AUTO
  SD_RAN10 AUTO
  MEDIAN_RAN01 AUTO
  MEDIAN_RAN02 AUTO
  MEDIAN_RAN03 AUTO
  MEDIAN_RAN04 AUTO
  MEDIAN_RAN05 AUTO
  MEDIAN_RAN06 AUTO
  MEDIAN_RAN07 AUTO
  MEDIAN_RAN08 AUTO
  MEDIAN_RAN09 AUTO
  MEDIAN_RAN10 AUTO
  ERR_PAT01 AUTO
  ERR_PAT02 AUTO
  ERR_PAT03 AUTO
  ERR_PAT04 AUTO
  ERR_PAT05 AUTO
  ERR_PAT06 AUTO
  ERR_PAT07 AUTO
  ERR_PAT08 AUTO
  ERR_PAT09 AUTO
  ERR_PAT10 AUTO
  MRT_PAT01 AUTO
  MRT_PAT02 AUTO
  MRT_PAT03 AUTO
  MRT_PAT04 AUTO
  MRT_PAT05 AUTO
  MRT_PAT06 AUTO
  MRT_PAT07 AUTO
  MRT_PAT08 AUTO
  MRT_PAT09 AUTO
  MRT_PAT10 AUTO
  SD_PAT01 AUTO
  SD_PAT02 AUTO
  SD_PAT03 AUTO
  SD_PAT04 AUTO
  SD_PAT05 AUTO
  SD_PAT06 AUTO
  SD_PAT07 AUTO
  SD_PAT08 AUTO
  SD_PAT09 AUTO
  SD_PAT10 AUTO
  MEDIAN_PAT01 AUTO
  MEDIAN_PAT02 AUTO
  MEDIAN_PAT03 AUTO
  MEDIAN_PAT04 AUTO
  MEDIAN_PAT05 AUTO
  MEDIAN_PAT06 AUTO
  MEDIAN_PAT07 AUTO
  MEDIAN_PAT08 AUTO
  MEDIAN_PAT09 AUTO
  MEDIAN_PAT10 AUTO
  MRT_SEQ_RAN01 AUTO
  MRT_SEQ_RAN02 AUTO
  MRT_SEQ_RAN03 AUTO
  MRT_SEQ_RAN04 AUTO
  MRT_SEQ_RAN05 AUTO
  MRT_SEQ_RAN06 AUTO
  MRT_SEQ_RAN07 AUTO
  MRT_SEQ_RAN08 AUTO
  MRT_SEQ_RAN09 AUTO
  MRT_SEQ_RAN10 AUTO
  MRT_SEQ_PAT01 AUTO
  MRT_SEQ_PAT02 AUTO
  MRT_SEQ_PAT03 AUTO
  MRT_SEQ_PAT04 AUTO
  MRT_SEQ_PAT05 AUTO
  MRT_SEQ_PAT06 AUTO
  MRT_SEQ_PAT07 AUTO
  MRT_SEQ_PAT08 AUTO
  MRT_SEQ_PAT09 AUTO
  MRT_SEQ_PAT10 AUTO
  PL_EFFECT_MRT_01 AUTO
  PL_EFFECT_MRT_02 AUTO
  PL_EFFECT_MRT_03 AUTO
  PL_EFFECT_MRT_04 AUTO
  PL_EFFECT_MRT_05 AUTO
  PL_EFFECT_MRT_06 AUTO
  PL_EFFECT_MRT_07 AUTO
  PL_EFFECT_MRT_08 AUTO
  PL_EFFECT_MRT_09 AUTO
  PL_EFFECT_MRT_10 AUTO
  PL_EFFECT_MEDIAN_01 AUTO
  PL_EFFECT_MEDIAN_02 AUTO
  PL_EFFECT_MEDIAN_03 AUTO
  PL_EFFECT_MEDIAN_04 AUTO
  PL_EFFECT_MEDIAN_05 AUTO
  PL_EFFECT_MEDIAN_06 AUTO
  PL_EFFECT_MEDIAN_07 AUTO
  PL_EFFECT_MEDIAN_08 AUTO
  PL_EFFECT_MEDIAN_09 AUTO
  PL_EFFECT_MEDIAN_10 AUTO
  SEQ_1 AUTO
  SEQ_2 AUTO
  SEQ_3 AUTO
  SEQ_4 AUTO
  SEQ_1_amount AUTO
  SEQ_2_amount AUTO
  SEQ_3_amount AUTO
  SEQ_4_amount AUTO
  /MAP.
RESTORE.
CACHE.
EXECUTE.

SAVE OUTFILE= "..\results\SPSS_NEUTRAL.sav".

GET FILE= "..\results\SPSS_NEUTRAL.sav".   