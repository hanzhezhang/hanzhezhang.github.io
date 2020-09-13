/** SET DIRECTORIES **/
global dir "~/Desktop/2020JPE"
global figdir ${dir}/figs
global dodir ${dir}/do

cd $dir

set graphics on
set scheme s2color
set more off
graph set window fontface "Times New Roman"

do ${dodir}/dataclean
do ${dodir}/fig1a
do ${dodir}/fig1b
do ${dodir}/fig1c
