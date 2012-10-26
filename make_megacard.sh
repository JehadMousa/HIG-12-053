#!/bin/bash

COMBO_DIR=VHTT

combineCards.py \
  llt7TeV=$COMBO_DIR/cmb/125/vhtt_0_7TeV.txt \
  llt8TeV=$COMBO_DIR/cmb/125/vhtt_0_8TeV.txt \
  ZH8TeV=$COMBO_DIR/cmb/125/vhtt_1_8TeV.txt \
  ZH7TeV=$COMBO_DIR/cmb/125/vhtt_1_7TeV.txt > megacard_125.txt

combineCards.py \
  llt7TeV=$COMBO_DIR/cmb/140/vhtt_0_7TeV.txt \
  llt8TeV=$COMBO_DIR/cmb/140/vhtt_0_8TeV.txt \
  ZH8TeV=$COMBO_DIR/cmb/140/vhtt_1_8TeV.txt \
  ZH7TeV=$COMBO_DIR/cmb/140/vhtt_1_7TeV.txt > megacard_140.txt
