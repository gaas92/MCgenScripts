#!/bin/bash
export SCRAM_ARCH=slc7_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_2_20_UL/src ] ; then
 echo release CMSSW_10_2_20_UL already exists
else
scram p CMSSW CMSSW_10_2_20_UL
fi
cd CMSSW_10_2_20_UL/src
eval `scram runtime -sh`

pyfile="BPH-fragment.py"
#pyfile="fragment.py"
#pyfile="fragment.py"

# Download fragment from myGitHub
curl -s -k https://raw.githubusercontent.com/gaas92/MCgenScripts/master/$pyfile --retry 3 --create-dirs -o Configuration/GenProduction/python/BPH-RunIIFall18GS-00251-fragment.py
