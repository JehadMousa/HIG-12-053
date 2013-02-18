#!/bin/bash

# Copy selected datacards to HCG SVN

echo "Copying coupling cards"
cat coupling_masses.txt | xargs -n 1 -I {} cp -r -v limits/vhtt/{} hcg/couplings/vhtt/
cp -r -v limits/vhtt/common hcg/couplings/vhtt/

echo "Copying 2nd Higgs search cards"
cat searches_masses.txt | xargs -n 1 -I {} cp -r -v limits_2ndhiggs/vhtt/{} hcg/searches/vhtt/
cp -r -v limits_2ndhiggs/vhtt/common hcg/searches/vhtt/

echo "FIXME"
perl -pi -e 's/CMS_vhtt_.*_shape_WH.*_bin.*//' hcg/*/vhtt/*/vhtt_2*txt
