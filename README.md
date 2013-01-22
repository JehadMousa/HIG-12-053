HIG-12-053
==========

Scripts for 2013 VH tau Moriond PAS

Installation
------------

Install the HiggsToTauTau limit package,


```shell
cmsrel CMSSW_5_2_5
cd CMSSW_5_2_5/src/
cmsenv
cvs co -r V02-02-08 HiggsAnalysis/CombinedLimit
cvs co -r V00-03-00 HiggsAnalysis/HiggsToTauTau
python HiggsAnalysis/HiggsToTauTau/scripts/init.py --tag V00-01-00-noModels
scram b -j 4; rehash
```

then check out this package:

```shell
git clone https://github.com/ekfriis/HIG-12-051.git
```


