#!/bin/bash

# Make datacard project areas

masses="110 115 120 125 130 135 140 145"
#masses="110 145"

setup-htt.py -o ALL-LIMITS $masses --channels="vhtt tt em mt et mm"  -i $CMSSW_BASE/src/auxiliaries/datacards
setup-htt.py -o STANDARD-LIMITS $masses --channels="em mt et mm"  -i $CMSSW_BASE/src/auxiliaries/datacards
setup-htt.py -o NEW-LIMITS $masses --channels="vhtt tt"  -i $CMSSW_BASE/src/auxiliaries/datacards
