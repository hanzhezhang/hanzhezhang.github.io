use clean, clear

/**/
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

#delimit cr

drop if afm<=15

#delimit ;
collapse

(mean) meanincwage=incwage
(sem) seincwage=incwage

(mean) meanincwagesp=incwage_sp
(sem) seincwagesp=incwage_sp

,
by (cohort sex afm);

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
label variable meanincwage "Average log total income"
label variable meanincwagesp "Average log spousal total income"

label variable cohort "birth cohort"

#delimit cr
save afm_logincwage.dta, replace emptyok

**/

/**/
use afm_logincwage.dta, clear

keep if inrange(afm,16,39)

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

#delimit cr
egen min=min(lbincwage) if sex==2
replace min=floor(min*10)/10
sum min
local min=r(min)
drop min
egen max=max(ubincwage) if sex==1
replace max=ceil(max*10)/10
sum max
local max=r(max)
drop max

#delimit ;
tw
(rcap ubincwage lbincwage afm if sex==1 & afm<=40, lcolor(black) color(black) msize(vtiny) lw(0.6))
(connected meanincwage afm if sex==1 & afm<=40, lcolor(black) mcolor(black) msymbol(none) msize(small) lw(0.6) )
(rcap ubincwage lbincwage afm if sex==2 & afm<=40, lcolor(gray) color(gray) msize(vtiny) lw(0.6))
(connected meanincwage afm if sex==2 & afm<=40, lcolor(gray) mcolor(gray) lp(dash) msymbol(none) msize(small) lw(0.6) )
,
by(
cohort, ixaxes compact  cols(8)
graphregion(style(none) margin(l=0 b=0 r=0 t=0))
plotregion(style(none) margin(l=0 b=0 r=0 t=0)) bgcolor(white)
note("",size(vsmall)) imargin(small)
scale(1.15)
)
legend(region(lcolor(white)) order(2 "men" 4 "women") size(vlarge))
subtitle(, fcolor(white%0) size(vlarge) margin(zero) lcolor(white))
ytitle("Average log labor income", size(vlarge))
xtitle("Age at marriage", size(vlarge))
xlabel(20 30 40, labsize(vlarge))
ylabel(`min'(0.4)`max', angle(h) nogrid labsize(vlarge))
ysize(2) xsize(6)
xline(16, lcolor(black))
graphregion(style(none) margin(l=0 b=0 r=0 t=0))
plotregion(style(none) margin(l=0 b=0 r=2 t=0)) bgcolor(white)
bgcolor(white)
name(afm_logincwage_combine, replace);
graph export ${figdir}/fig1b.pdf, replace as(pdf);
graph export ${figdir}/fig1b.eps, replace as(eps);
