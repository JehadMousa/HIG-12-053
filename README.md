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
cvs co HiggsAnalysis/HiggsToTauTau
python HiggsAnalysis/HiggsToTauTau/scripts/init.py --tag V00-01-00-noModels
# Remove any leftover shape files
rm HiggsAnalysis/HiggsAnalysis/setup/vhtt/*root
scram b -j 4; rehash
```

then check out this package:

```shell
git clone https://github.com/ekfriis/HIG-12-053.git
```

and get the latest VH datacards:

```shell
cd auxiliaries/datacards/collected/
cvs up -A -d vhtt
```

Producing Results
-----------------

All the tricks to build the results are contained in the Makefile.  The
important commands are:

```shell
cd HIG-12-053

# Run the post fit and make all the final mass distribution plots
make massplots
# Compute all the limits
make limits
# Plot the limits (they show up in limits/*pdf)
make limitplots
# Make vh_table.tex for the PAS
make vh_table.tex
```

