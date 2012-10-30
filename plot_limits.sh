#!/bin/bash

cd VHTT
#plot asymptotic $CMSSW_BASE/src/HiggsAnalysis/HiggsToTauTau/python/layouts/sm_htt_tt_layout.py tt
plot asymptotic $CMSSW_BASE/src/HiggsAnalysis/HiggsToTauTau/python/layouts/sm_vhtt_layout.py llt
plot asymptotic $CMSSW_BASE/src/HiggsAnalysis/HiggsToTauTau/python/layouts/sm_vhtt_layout.py 4l
plot asymptotic $CMSSW_BASE/src/HiggsAnalysis/HiggsToTauTau/python/layouts/sm_vhtt_layout.py cmb

#cp llt_sm.pdf llt_sm_asymp.pdf
#cp tt_sm.pdf tt_sm_asymp.pdf
#cp cmb_sm.pdf cmb_sm_asymp.pdf
#cp 4l_sm.pdf 4l_sm_asymp.pdf

root -b -q '../../HiggsAnalysis/HiggsToTauTau/macros/compareLimits.C+("limits_limit.root", "cmb,4l,llt", true, false, "sm-xsex", 0, 15, false,"  Preliminary, H#rightarrow#tau#tau, #sqrt{s} = 7-8 TeV, L=17 fb^{-1}")'
root -b -q '../../HiggsAnalysis/HiggsToTauTau/macros/compareLimits.C+("limits_limit.root", "cmb,4l,llt", false, true, "sm-xsex", 0, 15, false,"  Preliminary, H#rightarrow#tau#tau, #sqrt{s} = 7-8 TeV, L=17 fb^{-1}")'

#cd ../ALL-LIMITS
#plot asymptotic $CMSSW_BASE/src/HiggsAnalysis/HiggsToTauTau/python/layouts/sm_htt_layout.py cmb
#cp cmb_sm.pdf cmb_sm_asymp.pdf

#ln -s ../STANDARD-LIMITS/cmb HIG-12-018
#plot asymptotic $CMSSW_BASE/src/HiggsAnalysis/HiggsToTauTau/python/layouts/sm_htt_layout.py HIG-12-018
#root -b -q '../../HiggsAnalysis/HiggsToTauTau/macros/compareLimits.C+("limits_sm.root", "cmb,HIG-12-018", true, false, "sm-xsex", 0, 5, false)'
#root -b -q '../../HiggsAnalysis/HiggsToTauTau/macros/compareLimits.C+("limits_sm.root", "cmb,HIG-12-018", false, true, "sm-xsex", 0, 5, false)'
