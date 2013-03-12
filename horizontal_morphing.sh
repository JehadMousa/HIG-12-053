#!/bin/bash

# Script to provide horizontally-morphed signal mass points for all points
# required by the combination group.
# Usage: ./horizontal_morphing.sh shape_file.root 

echo "Combining VHTT shape files and running horizontal interpolation"

lltCategories="emt,mmt" 
zhCategories="mmmt_zh,mmet_zh,mmme_zh,mmtt_zh,eemt_zh,eeet_zh,eeem_zh,eett_zh" 
lttCategories="ett,mtt" 

domorph() 
{
  echo "Morphing file $1, samples $2, categories $3"
  echo "110->140, in 0.5"
  horizontal-morphing.py $1 \
    --categories="$3"\
    --samples="$2" \
    --uncerts="$4" --masses="110,115,120,125,130,135,140" --step-size=0.5
  echo "140->145, in 1.0"
  horizontal-morphing.py $1 \
    --categories="$3"\
    --samples="$2" \
    --uncerts="$4" --masses="140,145" --step-size=1
  echo "124.5->126.5, in 0.1"
  horizontal-morphing.py $1 \
    --categories="$3"\
    --samples="$2" \
    --uncerts="$4" --masses="124,125,127" --step-size=0.1
}

# some magic to generate the uncertainy names which need to be morphed for
# LTT
make_bbb_names() {
  seq 1 $2 | xargs -n 1 sh -c "echo $1\$1"  -- | xargs echo | sed "s/ /,/g"
}

morph() 
{
  domorph $1 "WH{MASS},WH_hww{MASS}"  "${lltCategories}" ""
  domorph $1 "ZH_htt{MASS},ZH_hww{MASS}"  "${zhCategories}" ""
  #domorph $1 "WH_htt{MASS}"  "${lttCategories}" \
    #`make_bbb_names CMS_vhtt_8TeV_ett_shape_WH_htt_bin_ 10`,`make_bbb_names CMS_vhtt_8TeV_mtt_shape_WH_htt_bin_ 10`,`make_bbb_names CMS_vhtt_7TeV_ett_shape_WH_htt_bin_ 1`,`make_bbb_names CMS_vhtt_7TeV_mtt_shape_WH_htt_bin_ 1`,
  domorph $1 "WH{MASS}"  "${lttCategories}" \

}

morph $1
