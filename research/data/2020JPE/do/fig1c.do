use clean, clear

#delimit cr
gen mandate=0
replace mandate=1 if inlist(statefip, 5, 15, 17, 24, 25, 44, 30, 36, 39, 54, 6, 9, 48)

#delimit ;
keep if
(year==1960 & inrange(birthyr,1900,1909)) |
(year==1960 & inrange(birthyr,1910,1919)) |
(year==1970 & inrange(birthyr,1920,1929)) |
(year==1980 & inrange(birthyr,1930,1939)) |
(year==2010 & inrange(birthyr,1940,1949)) |
(year==2010 & inrange(birthyr,1950,1959)) |
(year==2010 & inrange(birthyr,1960,1969)) |
(year==2015 & inrange(birthyr,1970,1974));

replace incwage=log(incwage);
replace incwage_sp=log(incwage_sp);

#delimit cr
gen cohort=.
foreach i of numlist 1900 1910 1920 1930 1940 1950 1960 1970 {
	replace cohort=`i' if inrange(birthyr,`i',`=`i'+9')
}

gen afmbinsp=.
replace afmbinsp=1 if inrange(afm_sp,16,22)
replace afmbinsp=2 if inrange(afm_sp,23,29)
replace afmbinsp=3 if inrange(afm_sp,30,39)

#delimit ;
collapse
(mean) meanincwage=incwage
(sem) seincwage=incwage

(mean) meanincwagesp=incwage_sp
(sem) seincwagesp=incwage_sp
,
by (cohort sex afmbinsp mandate);

#delimit cr

replace meanincwage = meanincwage
replace seincwage = seincwage
gen ubincwage = meanincwage + 1.96*seincwage
gen lbincwage = meanincwage - 1.96*seincwage

replace meanincwagesp = meanincwagesp
replace seincwagesp = seincwagesp
gen ubincwagesp = meanincwagesp + 1.96*seincwagesp
gen lbincwagesp = meanincwagesp - 1.96*seincwagesp

label variable afm "age at marriage"
label variable meanincwage "Average log midlife labor income"
label variable meanincwagesp "Average log spousal labor income"
label variable cohort "birth cohort"

#delimit cr
save afmbinsp_logincwage_mandate.dta, replace emptyok

**/

/**/
use clean.dta, clear

#delimit ;
keep if
(year==1960 & inrange(birthyr,1900,1909)) |
(year==1960 & inrange(birthyr,1910,1919)) |
(year==1970 & inrange(birthyr,1920,1929)) |
(year==1980 & inrange(birthyr,1930,1939)) |
(year==2010 & inrange(birthyr,1940,1949)) |
(year==2010 & inrange(birthyr,1950,1959)) |
(year==2010 & inrange(birthyr,1960,1969)) |
(year==2015 & inrange(birthyr,1970,1974));

replace incwage=log(incwage);
replace incwage_sp=log(incwage_sp);

#delimit cr
gen cohort=.
foreach i of numlist 1900 1910 1920 1930 1940 1950 1960 1970 {
	replace cohort=`i' if inrange(birthyr,`i',`=`i'+9')
}


gen afmbinsp=.
replace afmbinsp=1 if inrange(afm_sp,16,22)
replace afmbinsp=2 if inrange(afm_sp,23,29)
replace afmbinsp=3 if inrange(afm_sp,30,39)

#delimit ;
collapse
(mean) meanincwage=incwage
(sem) seincwage=incwage
(mean) meanincwagesp=incwage_sp
(sem) seincwagesp=incwage_sp
,
by (cohort sex afmbinsp);

#delimit cr

replace meanincwage = meanincwage
replace seincwage = seincwage
gen ubincwage = meanincwage + 1.96*seincwage
gen lbincwage = meanincwage - 1.96*seincwage

replace meanincwagesp = meanincwagesp
replace seincwagesp = seincwagesp
gen ubincwagesp = meanincwagesp + 1.96*seincwagesp
gen lbincwagesp = meanincwagesp - 1.96*seincwagesp

label variable afm "age at marriage"
label variable meanincwage "Average log labor income"
label variable meanincwagesp "Average log spousal labor income"
label variable cohort "birth cohort"

#delimit cr
save afmbinsp_logincwage.dta, replace emptyok

**/

/**/
use afmbinsp_logincwage_mandate.dta, clear
drop if mandate==.
append using afmbinsp_logincwage.dta

#delimit ;
label define cohortvalm
1900 "1900s"
1910 "1910s"
1920 "1920s"
1930 "1930s"
1940 "1940s"
1950 "1950s"
1960 "1960s"
1970 "1970s";
label values cohort cohortvalm;

drop if sex==2;
drop if afmbinsp==.;
keep sex mandate cohort afmbinsp ubincwage lbincwage meanincwage afmbinsp;
#delimit ;
tw
(rcap ubincwage lbincwage afmbinsp if sex==1 & mandate==., lcolor(black) color(black) msize(vtiny) lw(0.6))
(connected meanincwage afmbinsp if sex==1 & mandate==., lcolor(black) mcolor(black) msymbol(square) msize(large) lw(0.6))
(rcap ubincwage lbincwage afmbinsp if sex==1 & mandate==1, lcolor(black) color(black) msize(vtiny) lw(0.6) lpattern(dash))
(connected meanincwage afmbinsp if sex==1 & mandate==1, lcolor(black) mcolor(black) msymbol(O) msize(large) lw(0.6) lpattern(dash))
(rcap ubincwage lbincwage afmbinsp if sex==1 & mandate==0, lcolor(black) color(black) msize(vtiny) lw(0.6) lpattern(dot))
(connected meanincwage afmbinsp if sex==1 & mandate==0, lcolor(black) mcolor(black) msymbol(triangle) msize(large) lw(0.6) lpattern(dot)),
by(
cohort, ixaxes compact  cols(8)
graphregion(style(none) margin(l=0 b=0 r=0 t=0))
plotregion(style(none) margin(l=0 b=0 r=0 t=0)) bgcolor(white)
note("",size(vtiny)) imargin(small)
title(,size(huge))
scale(1)
)
legend(order(2 "all states" 4 "mandated states" 6 "nonmandated states") rows(1) region(lcolor(white)) size(vlarge))
subtitle(, fcolor(white%0) size(huge) margin(zero) lcolor(white))
ytitle("Average log spousal labor income", size(vlarge))
xtitle("Age at marriage, women", size(vlarge))
xlabel(1 "       16-22" 2 "23-29" 3 "30-39      ", labsize(large))
ylabel(, angle(h) nogrid labsize(huge))
ysize(2) xsize(6)
xline(1, lcolor(black))
graphregion(style(none) margin(l=0 b=0 r=0 t=0))
plotregion(style(none) margin(l=0 b=0 r=2 t=0)) bgcolor(white)
name(afmbinw_logincwagem_combine, replace);

graph export ${figdir}/fig1c.pdf, replace as(pdf);
graph export ${figdir}/fig1c.eps, replace as(eps);
