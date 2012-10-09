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

emt_plots="final-f3-subMass.* final-subMass.*"
mmt_plots="final-f3-subMass.* final-subMass.*"
em_plots="mass.*"
mm_plots="mass.*"

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
