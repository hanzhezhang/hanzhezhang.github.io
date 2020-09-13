use clean, clear

keep if inrange(age,35,39)
collapse college incwage, by (sex year)
replace incwage=incwage/1000

global color white

twoway ///
connected college year if sex==1, color(black) lcolor(black) msym(S) mcolor(black) || ///
connected college year if sex==2, color(gray) lcolor(gray) mcolor(gray) lp(dash) ///
xlabel(1960 1970 1980 1990 2000 2010, labsize(huge)) ///
ylabel(0(0.1)0.4, labsize(huge)) ///
xtitle("Census year", size(huge)) ///
ytitle("Percent with college degrees" "ages 35-39", size(huge)) ///
plotregion(margin(b = 0)) ///
graphregion(fcolor($color) lcolor($color) color($color) ) ///
plotregion(fcolor($color) lcolor($color) icolor($color) margin(r+2)) ///
bgcolor($color) ///
ylabel(,nogrid) ylabel(, axis(1) angle(0)) ///
legend(order(1 "men" 2 "women") rows(1) ring(0) pos(4) size(huge) region(color(white))) ///
name(year_college, replace) ///
xsize(3) ysize(2) ///
title("Reversed college gender gap", color(black) size(huge)) nodraw

twoway ///
connected incwage year if sex==1, color(black) lcolor(black) msym(S) mcolor(black) || ///
connected incwage year if sex==2, color(gray) lcolor(gray) mcolor(gray) lp(dash) ///
xlabel(1960 1970 1980 1990 2000 2010, labsize(huge)) ///
ylabel(0(10)40, labsize(huge)) ///
xtitle("Census year", size(huge)) ///
ytitle("Average labor income (000s)" "ages 35-39", size(huge)) ///
plotregion(margin(b = 0)) ///
graphregion(fcolor($color) lcolor($color) color($color) ) ///
plotregion(fcolor($color) lcolor($color) icolor($color) margin(r+2)) ///
bgcolor($color) ///
ylabel(,nogrid) ylabel(, axis(1) angle(0)) ///
legend(order(1 "men" 2 "women") rows(1) ring(0) pos(4) size(huge) region(color(white))) ///
name(year_income, replace) ///
xsize(3) ysize(2) ///
title("Persistent income gender gap", color(black) size(huge)) nodraw

gr combine year_college year_income, xsize(6) ysize(2) graphregion(fcolor($color) lcolor($color) color($color) )

graph export ${figdir}/fig1a.pdf, replace as(pdf)
graph export ${figdir}/fig1a.eps, replace as(eps)
