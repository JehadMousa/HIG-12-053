#!/bin/bash

# Submit 500 signal injection toy jobs for each limit type.

find limits -type d  -exec fs setacl -dir '{}' -acl condor-hosts rlidkw \;

for type in llt cmb ltt 4l;
do
  echo "Submitting $type"
  submit.py --injected --condor --toys 500 --bunch-masses 10 limits/$type/*
done
