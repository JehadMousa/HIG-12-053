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
cvs co -r V00-03-03 HiggsAnalysis/HiggsToTauTau
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
make plots/vh_table.tex
```

or you can just run "make all", which runs everything.

Signal Injection
----------------

Do the following to make the signal injected plots.  This example works on the
_llt_ directory, substitute the _4l_, _cmb_, and _ltt_ directories to do 
the other channels.

```shell
# Run a bunch of jobs with different pseudoexperiments
submit.py --injected --condor --toys 100 --bunch-masses 10 limits/llt/*
# Collate all the results
submit.py --injected --condor --collect limits/llt/*
# Plot the results - don't forget the trailing / slash on llt/
cd limits/
plot --injected $CMSSW_BASE/src/HiggsAnalysis/HiggsToTauTau/python/layouts/sm_vhtt_injected_layout.py llt/
```

This example is for the UW cluster.  Omit the --condor option to run on LXBatch.
If you are running on the UW cluster, you'll need to enable write access to your 
working directory to the "condor-hosts" group.

```shell
find . -type d  -exec fs setacl -dir '{}' -acl condor-hosts rlidkw \;
```
