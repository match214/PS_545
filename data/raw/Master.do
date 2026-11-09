////Replication Do File for Trounstine APSR

cd "E:\Box Sync\Research\Zoning\APSR"

*Table 1
use "LandUse_Wharton.dta", clear
tobit WRLURIdiff2 NHW_70diff if totcities>1, cluster(msastate) ll(0)
tobit WRLURIdiff2 NHW_70diff WLTH2_70diff OWN_70diff zoneall2 center1970 citylandarea2000 citypop2000 popchange if totcities>1, cluster(msastate) ll(0)

*Figure 1
xtile  NHW_70diff_quintile=NHW_70diff if e(sample), nq(5)
tobit WRLURIdiff2 i.NHW_70diff_quintile  , cluster(msastate) ll(0)
margins i.NHW_70diff_quintile
marginsplot, xtitle("Mean Value Relative Whiteness Quintile, 1970", margin(medium) size(large)) plotopts(color(black)) xlabel (1 "-0.08" 2 "0.01" 3 "0.05" 4 "0.11" 5 "0.18") recast(line) ciopts(color(gs14)) ytitle("Predicted Relative Land Use Stringency", size(small) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white)) title("")

*Figure 2
tsset msastate geo_id2
xtreg pctnhwht_city2011 WRLURI pctnhwht_city1970 pctrenter_city1970 pctwlth2_city1970 , fe
quietly margins, at(WRLURI=(-2 (.1) 4))
marginsplot, xlabel(-2(1)4) xtitle("Land Use Regulation Stringency", margin(medium) size(large)) plotopts(color(black)) recast(line) ciopts(color(gs14)) recastci(rarea) title("") ytitle(" Metro Area Adjusted White Population Share, 2011", size(medsmall) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white))

*Table 2
use "FairHousing.dta", clear
xtreg pctnhwht_cityi fairhousingimp_v1 i.year if year>1968 & minyear<2011, fe

sum pctnhwht_cityi if e(sample) & year==1970 & fairhousingcase==0
sum pctnhwht_cityi if e(sample) & year==1970 & fairhousingcase==1
margins, at((mean) _all fairhousingimp_v1=(0 1) year=2011)

xtreg pctnhwht_cityi fairhousingimp_v1 pctrenter_cityi pctwlth_city2i logpop homevali pct_vacanti i.year if year>1968 & minyear<2011, fe


*Table 3
use "CA_Initiatives.dta", clear

xtreg pctrestrict_tr pctwhite_tr pctrenter_tract11 pctwlth_tract211 , fe
xtreg pctrestrict_tr pctwhite_tr if e(sample), fe

*Table A4
xtreg pctrestrict_tr pctwhite_tr pctdem_tr pctrenter_tract11 pctwlth_tract211 , fe

*Table 3 SF
use "SF_Initiatives.dta", clear
regress pctrestrict  pctwhite  i.measure_n
regress pctrestrict  pctwhite  pctrenters turnout_reg i.measure_n
