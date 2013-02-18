#!/bin/bash

# Copy selected datacards to HCG SVN

echo "Copying coupling cards"
cat coupling_masses.txt | xargs -n 1 -I {} mdkir -p hcg/coupling/vhtt/{}
cat coupling_masses.txt | xargs -n 1 -I {} cp -v limits/vhtt/{}/*.txt hcg/coupling/vhtt/{}/
cp -r -v limits/vhtt/common hcg/searches/vhtt/

echo "Copying 2nd Higgs search cards"
cat search_masses.txt | xargs -n 1 -I {} mdkir -p hcg/searches/vhtt/{}
cat search_masses.txt | xargs -n 1 -I {} cp -v limits_2ndhiggs/vhtt/{}/*.txt hcg/searches/vhtt/{}/
cp -r -v limits_2ndhiggs/vhtt/common hcg/searches/vhtt/
