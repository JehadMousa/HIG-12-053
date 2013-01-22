# Makefile to generate limit cards for VH
#
# Targets:
#
# llt, ltt, zh: generate cards and put them in auxiliaries/datacards
# cards: generate all cards (from above)
#
# limitdir: generate limit computation project area
#
# pulls: compute the pulls.  Stored in pulls/125

# Working directory
BASE=$(CMSSW_BASE)/src
WD=$(BASE)/HIG-12-053

# Location of the CGS and uncertainty configuration files
SETUP=$(BASE)/HiggsAnalysis/HiggsToTauTau/setup/vhtt
HTT_TEST=$(BASE)/HiggsAnalysis/HiggsToTauTau/test

# where the limit directory lives (in HIG-12-053) 
LIMITDIR=$(WD)/limits

# where the raw generated cards are generated.
CARDDIR=$(BASE)/auxiliaries/datacards
CARDS=$(BASE)/auxiliaries/datacards/sm/vhtt
COLLECT=$(BASE)/auxiliaries/datacards/collected/vhtt


################################################################################
#####  Recipes for combining all shape files ###################################
################################################################################

# Combine all 8TeV shape files
$(SETUP)/vhtt.inputs-sm-8TeV.root: $(COLLECT)/llt_2012.root $(COLLECT)/zh_2012.root $(COLLECT)/ltt_2012.root
	hadd -f $@ $^

# Combine all 7TeV shape files
$(SETUP)/vhtt.inputs-sm-7TeV.root: $(COLLECT)/llt_2011.root $(COLLECT)/zh_2011.root $(COLLECT)/ltt_2011.root
	hadd -f $@ $^

SHAPEFILE7=$(SETUP)/vhtt.inputs-sm-7TeV.root 
SHAPEFILE8=$(SETUP)/vhtt.inputs-sm-8TeV.root 


################################################################################
#####  Recipes for building EMT and MMT cards ##################################
################################################################################

LLT_CONFIGS7=$(wildcard $(SETUP)/*-sm-7TeV-00.*)
LLT_CONFIGS8=$(wildcard $(SETUP)/*-sm-8TeV-00.*)

# Recipe for building LLT cards
$(CARDS)/.llt7_timestamp: $(SHAPEFILE7) $(LLT_CONFIGS7)
	rm -f $(CARDS)/vhtt_0_7TeV*
	# $@ is the .timestamp file
	rm -f $@
	# change to base, run the setup command, and touch the .timestamp if 
	# successful
	cd $(BASE) && setup-datacards.py -p 7TeV --a sm 110-145:5 -c vhtt --sm-categories-vhtt 0 && touch $@

$(CARDS)/.llt8_timestamp: $(SHAPEFILE8) $(LLT_CONFIGS8)
	rm -f $(CARDS)/vhtt_0_8TeV*
	rm -f $@
	cd $(BASE) && setup-datacards.py -p 8TeV --a sm 110-145:5 -c vhtt --sm-categories-vhtt 0 && touch $@

llt: $(CARDS)/.llt7_timestamp $(CARDS)/.llt8_timestamp

################################################################################
#####  Recipes for building ZH cards ###########################################
################################################################################

ZH_CONFIGS7=$(wildcard $(SETUP)/*-sm-7TeV-01.*)
ZH_CONFIGS8=$(wildcard $(SETUP)/*-sm-8TeV-01.*)

# Recipe for building ZH cards
$(CARDS)/.zh7_timestamp: $(SHAPEFILE7) $(ZH_CONFIGS7)
	rm -f $(CARDS)/vhtt_1_7TeV*
	rm -f $@
	cd $(BASE) && setup-datacards.py -p 7TeV --a sm 110-145:5 -c vhtt --sm-categories-vhtt 1 && touch $@

$(CARDS)/.zh8_timestamp: $(SHAPEFILE8) $(ZH_CONFIGS8)
	rm -f $(CARDS)/vhtt_1_8TeV*
	rm -f $@
	cd $(BASE) && setup-datacards.py -p 8TeV --a sm 110-145:5 -c vhtt --sm-categories-vhtt 1 && touch $@

zh: $(CARDS)/.zh7_timestamp $(CARDS)/.zh8_timestamp

################################################################################
#####  Recipes for building LTT cards ##########################################
################################################################################

LTT_CONFIGS7=$(wildcard $(SETUP)/*-sm-7TeV-02.*)
LTT_CONFIGS8=$(wildcard $(SETUP)/*-sm-8TeV-02.*)

# Recipe for building LTT cards
$(CARDS)/.ltt7_timestamp: $(SHAPEFILE7) $(LTT_CONFIGS7)
	rm -f $(CARDS)/vhtt_2_7TeV*
	rm -f $@
	cd $(BASE) && setup-datacards.py -p 7TeV --a sm 110-145:5 -c vhtt --sm-categories-vhtt 2 && touch $@

$(CARDS)/.ltt8_timestamp: $(SHAPEFILE8) $(LTT_CONFIGS8)
	rm -f $(CARDS)/vhtt_2_8TeV*
	rm -f $@
	cd $(BASE) && setup-datacards.py -p 8TeV --a sm 110-145:5 -c vhtt --sm-categories-vhtt 2 && touch $@

ltt: $(CARDS)/.ltt7_timestamp $(CARDS)/.ltt8_timestamp

cards: zh ltt llt

################################################################################
#####  Recipes for generating the limit combo directory ########################
################################################################################

$(LIMITDIR)/.timestamp: $(CARDS)/.ltt7_timestamp $(CARDS)/.ltt8_timestamp \
  $(CARDS)/.zh7_timestamp $(CARDS)/.zh8_timestamp \
  $(CARDS)/.llt7_timestamp $(CARDS)/.llt8_timestamp
	rm -rf $(LIMITDIR)
	cd $(BASE) && setup-htt.py -o $(LIMITDIR) -c vhtt --sm-categories-vhtt "0 1 2" 110-145:5 && touch $@


limitdir: $(LIMITDIR)/.timestamp

################################################################################
#####  The single card which has everything at 125 -used to make plots #########
################################################################################

megacard_125.txt: $(LIMITDIR)/.timestamp
	combineCards.py \
	  llt7TeV=$(LIMITDIR)/cmb/125/vhtt_0_7TeV.txt \
	  llt8TeV=$(LIMITDIR)/cmb/125/vhtt_0_8TeV.txt \
	  ZH7TeV=$(LIMITDIR)/cmb/125/vhtt_1_7TeV.txt \
	  ZH8TeV=$(LIMITDIR)/cmb/125/vhtt_1_8TeV.txt \
	  ltt7TeV=$(LIMITDIR)/cmb/125/vhtt_2_7TeV.txt \
	  ltt8TeV=$(LIMITDIR)/cmb/125/vhtt_2_8TeV.txt > $@

################################################################################
#####  Computing the pulls  ####################################################
################################################################################

pulls/.timestamp: $(LIMITDIR)/.timestamp do_pull.sh
	rm -rf pulls
	mkdir -p pulls
	cp -r $(LIMITDIR)/cmb/125 pulls/125
	cp -r $(LIMITDIR)/cmb/common pulls/common
	./do_pull.sh && touch $@

pulls: pulls/.timestamp

################################################################################
#####  Making the post fit shape files for the nice plots ######################
################################################################################

# ML fit and copy the 125 combined mass point into the postfit zone
$(HTT_TEST)/.fit_timestamp: $(LIMITDIR)/.timestamp
	cd $(HTT_TEST) && ./mlfit_and_copy.py $(LIMITDIR)/cmb/125 && touch $@

$(HTT_TEST)/root_postfit/.timestamp: $(HTT_TEST)/.fit_timestamp
	# make a copy of the directory so we can mess with them.
	cp -r $(HTT_TEST)/root $(HTT_TEST)/root_postfit
	# apply all the pulls to the shapes
	cd $(HTT_TEST) && ./postfit.py root_postfit/vhtt.input_7TeV.root datacards/vhtt_1_7TeV.txt \
	  --bins eemt_zh eeet_zh eeem_zh mmme_zh mmmt_zh mmet_zh eett_zh mmtt_zh \
	  --verbose
	cd $(HTT_TEST) && ./postfit.py root_postfit/vhtt.input_7TeV.root datacards/vhtt_0_7TeV.txt \
	  --bins emt mmt --verbose
	cd $(HTT_TEST) && ./postfit.py root_postfit/vhtt.input_8TeV.root datacards/vhtt_1_8TeV.txt \
	  --bins eemt_zh eeet_zh eeem_zh mmme_zh mmmt_zh mmet_zh eett_zh mmtt_zh \
	  --verbose
	cd $(HTT_TEST) && ./postfit.py root_postfit/vhtt.input_8TeV.root datacards/vhtt_0_8TeV.txt \
	  --bins emt mmt --verbose
	# all done
	touch $@

plots/.timestamp: $(HTT_TEST)/root_postfit/.timestamp pas_plots.py
	rm -rf plots
	mkdir -p plots
	python pas_plots.py 
	python pas_plots.py --prefit
	python pas_plots.py --period 7TeV
	python pas_plots.py --period 8TeV
	touch $@

postfit: $(HTT_TEST)/root_postfit/.timestamp

plots: plots/.timestamp

.PHONY: cards zh llt ltt limitdir pulls postfit plots
