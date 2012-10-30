#!/bin/bash

# Collect the WH results.
# Usage: 
#    snag_wh.sh <base dir> <7TeV job tag> <8TeV job tag>

set -o errexit
set -o nounset

mkdir -p wh/emt/7TeV
mkdir -p wh/em/7TeV
mkdir -p wh/mmt/7TeV
mkdir -p wh/mm/7TeV

mkdir -p wh/emt/8TeV
mkdir -p wh/em/8TeV
mkdir -p wh/mmt/8TeV
mkdir -p wh/mm/8TeV

mkdir -p wh/fits/7TeV
mkdir -p wh/fits/8TeV

emt_plots="final-f3-subMass.* final-subMass.*"
mmt_plots="final-f3-subMass.* final-subMass.* zmm-os-fr-control.pdf"
em_plots="mass.*"
mm_plots="mass.*"
fr_fits="e_wjets_pt10_mvaidiso03_eJetPt.pdf m_wjets_pt10_pfidiso02_muonJetPt.pdf m_wjets_pt20_pfidiso02_muonJetPt.pdf"

for plot in $emt_plots;
do
  type="emt"
  cp -v $1/$2/plots/$type/$plot wh/$type/7TeV
  cp -v $1/$3/plots/$type/$plot wh/$type/8TeV
done

for plot in $mmt_plots;
do
  type="mmt"
  cp -v $1/$2/plots/$type/$plot wh/$type/7TeV
  cp -v $1/$3/plots/$type/$plot wh/$type/8TeV
done

for plot in $mm_plots;
do
  type="mm"
  cp -v $1/$2/plots/zmm/$plot wh/$type/7TeV
  cp -v $1/$3/plots/zmm/$plot wh/$type/8TeV
done

for plot in $em_plots;
do
  type="em"
  cp -v $1/$2/plots/$type/$plot wh/$type/7TeV
  cp -v $1/$3/plots/$type/$plot wh/$type/8TeV
done

for plot in $fr_fits;
do
  cp -v $1/$2/fakerate_fits/$plot wh/fits/7TeV
  cp -v $1/$3/fakerate_fits/$plot wh/fits/8TeV
done
