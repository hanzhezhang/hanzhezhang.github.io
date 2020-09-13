use raw, clear

gen afm=.
gen afm_sp=.
recode marrno (9=.)
replace marrno=0 if marst==6
recode marrno_sp (9=.)
replace marrno_sp = 0 if marst_sp==6
recode yrmarr (0=.)
recode yrmarr_sp (0=.)

/** marriage age **/
replace afm = . if marst == 6
replace agemarr=. if agemarr==0
replace agemarr_sp=. if agemarr_sp==0
/*in census 1960, 1970, 1980, age of first marriage is directly reported*/
replace afm = agemarr if inrange(year,1960,1980)
replace afm_sp = agemarr_sp if inrange(year,1960,1980)
/*in ACS 2008 onward, year of current marriage is reported*/
replace afm = age - (year - yrmarr) if marrno==1 & (marst==1 | marst==2) & year>=2008
replace afm_sp = age_sp-(year-yrmarr_sp) if marst==1 & marrno==1 & marrno_sp==1 & year>=2008

/** income **/
/** total personal income **/
replace inctot=. if inctot==9999999
replace inctot = inctot*cpi99
/** labor personal income **/
replace incwage=. if incwage==999999 | incwage==999998
replace incwage = incwage*cpi99
/** spousal total income **/
replace inctot_sp=. if inctot_sp==9999999
replace inctot_sp = inctot_sp*cpi99
/** spousal labor income **/
replace incwage_sp=. if incwage_sp==999999 | incwage_sp==999998
replace incwage_sp = incwage_sp*cpi99

/** college **/
gen college=.
replace college=1 if educd>=101
replace college=0 if educd<101
gen college_sp=.
replace college_sp=1 if educd_sp>=101
replace college_sp=0 if educd_sp<101

save clean.dta, replace emptyok
