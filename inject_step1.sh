#!/bin/bash

# Submit 500 signal injection toy jobs for each limit type.

for type in llt cmb ltt 4l;
do
  echo "Submitting $type"
  submit.py --injected --condor --toys 500 --bunch-masses 10 limits/$type/*
done
