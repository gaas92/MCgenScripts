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

# Configuration parameters

fargment_pyfile="BPH-fragment.py"
#fargment_pyfile="fragment.py"
#fargment_pyfile="fragment.py"

run_configfile="BPH-run.py"
#run_configfile="BPH-run.py"
#run_configfile="BPH-run.py"

result_root="BPH-result.root"
#result_root="BPH-result.root"
#result_root="BPH-result.root"

EVENTS=250000


# Download fragment from myGitHub
curl -s -k https://raw.githubusercontent.com/gaas92/MCgenScripts/master/$fargment_pyfile --retry 3 --create-dirs -o Configuration/GenProduction/python/$fargment_pyfile

scram b
cd ../../

# cmsDriver command
cmsDriver.py Configuration/GenProduction/python/$fargment_pyfile --eventcontent RAWSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --conditions 102X_upgrade2018_realistic_v11 --beamspot Realistic25ns13TeVEarly2018Collision --step GEN --geometry DB:Extended --era Run2_2018 --python_filename $run_configfile --fileout file:$result_root --no_exec --mc -n $EVENTS || exit $? 
