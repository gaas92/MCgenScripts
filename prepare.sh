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
CHANNEL_DECAY="ZtoJpsiMuMu"


fargment_pyfile="${CHANNEL_DECAY}_BPH-fragment.py"
#fargment_pyfile="${CHANNEL_DECAY}_BPH-NoISR-fragment.py"
#fargment_pyfile="${CHANNEL_DECAY}_fragment.py"

run_configfile="step0-GS-${CHANNEL_DECAY}_BPH_run_cfg.py"
#run_configfile="step0-GS-${CHANNEL_DECAY}_BPH-NoISR-run_cfg.py"
#run_configfile="step0-GS-${CHANNEL_DECAY}_BPH-run_cfg.py"

result_root="step0-GS-${CHANNEL_DECAY}_BPH-result.root"
#result_root="step0-GS-${CHANNEL_DECAY}_BPH-NoISR-result.root"
#result_root="step0-GS-${CHANNEL_DECAY}_BPH-result.root"

EVENTS=5


# Download fragment from myGitHub
curl -s -k https://raw.githubusercontent.com/gaas92/MCgenScripts/master/$fargment_pyfile --retry 3 --create-dirs -o Configuration/GenProduction/python/$fargment_pyfile

scram b
cd ../../

# cmsDriver command
#cmsDriver.py Configuration/GenProduction/python/$fargment_pyfile --eventcontent RAWSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --conditions 102X_upgrade2018_realistic_v11 --beamspot Realistic25ns13TeVEarly2018Collision --step GEN --geometry DB:Extended --era Run2_2018 --python_filename $run_configfile --fileout file:$result_root --no_exec --mc -n $EVENTS || exit $?; 
cmsDriver.py Configuration/GenProduction/python/$fargment_pyfile --eventcontent RAWSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --conditions 102X_upgrade2018_realistic_v11 --beamspot Realistic25ns13TeVEarly2018Collision --step GEN --geometry DB:Extended --era Run2_2018 --python_filename $run_configfile --fileout file:$result_root --no_exec --mc -n $EVENTS; 
sed -i "20 a from IOMC.RandomEngine.RandomServiceHelper import RandomNumberServiceHelper \nrandSvc = RandomNumberServiceHelper(process.RandomNumberGeneratorService)\nrandSvc.populate()" $run_configfile 