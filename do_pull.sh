#!/bin/bash


cd NEW-LIMITS/cmb
# Move the 140 GeV mass point to separate directory
rm -rf pulls
cp -r 140 pulls

cd pulls

combineCards.py *.txt > everything.txt

for card in `ls *.txt`
do
  echo $card
  name=`echo $card | sed "s|.txt||"`
  echo $name
  combine -M MaxLikelihoodFit --minimizerStrategy=2 --robustFit=1 --minimizerStrategyForMinos=2 $card -m 140 &> $name.combine.txt
  #combine -M MaxLikelihoodFit $card -m 140 &> $name.combine.txt
  python $CMSSW_BASE/src/HiggsAnalysis/CombinedLimit/test/diffNuisances.py mlfit.root -f html > $name.pulls.html
  python $CMSSW_BASE/src/HiggsAnalysis/CombinedLimit/test/diffNuisances.py mlfit.root -a -f html > $name.pulls.all.html
  python $CMSSW_BASE/src/HiggsAnalysis/CombinedLimit/test/diffNuisances.py mlfit.root -g $name.pulls.png > $name.pulls.txt
  mv mlfit.root $card.fit.root
done
