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
cvs co -r V00-03-10 HiggsAnalysis/HiggsToTauTau
python HiggsAnalysis/HiggsToTauTau/scripts/init.py --tag V00-01-00-noModels
# Remove any leftover shape files
rm HiggsAnalysis/HiggsToTauTau/setup/vhtt/*root
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
make plotlimits
# Make vh_table.tex for the PAS
make plots/vh_table.tex
```

or you can just run "make all", which runs everything.

Signal Injection
----------------

Do the following to make the signal injected plots.  
```shell
# Run a bunch of jobs with different pseudoexperiments
./inject_step1.sh
# Wait for those jobs to all finish, then collect all the results
./inject_step2.sh
# Plot the results 
./inject_step3.sh
```

This example is for the UW cluster.  Omit the --condor option in the scripts to
run on LXBatch.  

Uploading to HCG SVN
--------------------

https://twiki.cern.ch/twiki/bin/view/CMS/HiggsCombinationMoriond2013#Inputs

Checkout the vhtt area of the HCG SVN.  

```shell
svn co svn+ssh://svn.cern.ch/reps/cmshcg/trunk/moriond2013/searches/vhtt hcg/searches/vhtt
svn co svn+ssh://svn.cern.ch/reps/cmshcg/trunk/moriond2013/couplings/vhtt hcg/couplings/vhtt
```

Generate all intermediate masses required by the HCG group.  Additionally,
generate cards with the "Two Higgs format", where the SM Higgs 125 is considered
as a background.

```shell
MASSLIST=coupling_masses.txt make limitdir
MASSLIST=searches_masses.txt SECONDHIGGS=1 make limitdir
```

The cards with second Higgs appear in auxiliaries_2ndhiggs/.../. Now run

```shell
./copy_to_hcg_svn.sh
```

to copy the appropriate cards into the HCG SVN area, then svn commit.  You can
double check that all the datacards are OK by running:

```shell
./double_check_svn_cards.sh
```

