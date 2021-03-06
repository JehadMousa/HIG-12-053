#!/bin/bash
set -e

# Make sure all the cards in the SVN work correctly.  Just runs
# text2workspace.py on each sample.

while read mass; do
  for card in `ls hcg/searches/vhtt/$mass/*.txt`;
  do
    echo $card
    text2workspace.py -m $mass $card \
      -P HiggsAnalysis.CombinedLimit.PhysicsModel:strictSMLikeHiggs \
      -o tmp.root 
    #| grep -v "Warning: decay string"
  done
done < searches_masses.txt

while read mass; do
  for card in `ls hcg/couplings/vhtt/$mass/*.txt`;
  do
    echo $card
    text2workspace.py -m $mass $card \
      -P HiggsAnalysis.CombinedLimit.PhysicsModel:strictSMLikeHiggs \
      -o tmp.root 
    #| grep -v "Warning: decay string"
  done
done < coupling_masses.txt


echo "Everything okay!"
