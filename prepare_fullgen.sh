#!/bin/bash


# step0 GEN-SIM
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
step0_fragmentfile="${CHANNEL_DECAY}_BPH-FW-fragment.py"
step0_configfile="step0-GS-${CHANNEL_DECAY}_BPH-FW_run_cfg.py"
step0_resultfile="step0-GS-${CHANNEL_DECAY}_BPH-FW-result.root"
EVENTS=500

# Download fragment from myGitHub
curl -s -k https://raw.githubusercontent.com/gaas92/MCgenScripts/master/$step0_fragmentfile --retry 3 --create-dirs -o Configuration/GenProduction/python/$step0_fragmentfile
scram b
cd ../../

# taken from https://cms-pdmv.cern.ch/mcm/public/restapi/requests/get_setup/BPH-RunIIFall18GS-00251
# cmsDriver command for GEN-SIM step0
cmsDriver.py Configuration/GenProduction/python/$step0_fragmentfile --eventcontent RAWSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --conditions 102X_upgrade2018_realistic_v11 --beamspot Realistic25ns13TeVEarly2018Collision --step GEN,SIM --geometry DB:Extended --era Run2_2018 --python_filename $step0_configfile --fileout file:$step0_resultfile --no_exec --mc -n $EVENTS; 
sed -i "20 a from IOMC.RandomEngine.RandomServiceHelper import RandomNumberServiceHelper \nrandSvc = RandomNumberServiceHelper(process.RandomNumberGeneratorService)\nrandSvc.populate()" $step0_configfile

# step1 DIGI, DATAMIX, L1, DIGIRAW, HLT
export SCRAM_ARCH=slc7_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_2_5/src ] ; then
  echo release CMSSW_10_2_5 already exists
else
  scram p CMSSW CMSSW_10_2_5
fi
cd CMSSW_10_2_5/src
eval `scram runtime -sh`
scram b
cd ../..

# Configuration parameters
step1_configfile="step1-PREMIXRAW-${CHANNEL_DECAY}_BPH-FW_run_cfg.py"
step1_resultfile="step1-PREMIXRAW-${CHANNEL_DECAY}_BPH-FW-result.root"

# taken from https://cms-pdmv.cern.ch/mcm/public/restapi/requests/get_setup/BPH-RunIIAutumn18DRPremix-00163
# cmsDriver command for DIGI,DATAMIX,L1,DIGI2RAW,HLT step1
cmsDriver.py  --python_filename $step1_configfile --eventcontent PREMIXRAW --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM-RAW --fileout file:$step1_resultfile --pileup_input "dbs:/Neutrino_E-10_gun/RunIISummer17PrePremix-PUAutumn18_102X_upgrade2018_realistic_v15-v1/GEN-SIM-DIGI-RAW" --conditions 102X_upgrade2018_realistic_v15 --step DIGI,DATAMIX,L1,DIGI2RAW,HLT:@relval2018 --procModifiers premix_stage2 --geometry DB:Extended --filein file:$step0_resultfile --datamix PreMix --era Run2_2018 --no_exec --mc -n $EVENTS;
sed -i "20 a from IOMC.RandomEngine.RandomServiceHelper import RandomNumberServiceHelper\nrandSvc = RandomNumberServiceHelper(process.RandomNumberGeneratorService)\nrandSvc.populate()" $step1_configfile


# step2 AODSIM
#same CMSSW

# Configuration parameters
step2_configfile="step2-AODSIM-${CHANNEL_DECAY}_BPH-FW_run_cfg.py"
step2_resultfile="step2-AODSIM-${CHANNEL_DECAY}_BPH-FW-result.root"

# cmsDriver command for RAW2DIGI,L1Reco,RECO,RECOSIM,EI step2
cmsDriver.py  --python_filename $step2_configfile --eventcontent AODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier AODSIM --fileout file:$step2_resultfile --conditions 102X_upgrade2018_realistic_v15 --step RAW2DIGI,L1Reco,RECO,RECOSIM,EI --procModifiers premix_stage2 --filein file:$step1_resultfile --era Run2_2018 --runUnscheduled --no_exec --mc -n $EVENTS; 
sed -i "20 a from IOMC.RandomEngine.RandomServiceHelper import RandomNumberServiceHelper\nrandSvc = RandomNumberServiceHelper(process.RandomNumberGeneratorService)\nrandSvc.populate()" $step2_configfile


# step3 MINIAODSIM
#same CMSSW

# Configuration parameters 
step3_configfile="step3-MINIAODSIM-${CHANNEL_DECAY}_BPH-FW_run_cfg.py"
step3_resultfile="step3-MINIAODSIM-${CHANNEL_DECAY}_BPH-FW-result.root"

# cmsDriver command for MINIAOD
cmsDriver.py  --python_filename $step3_configfile --eventcontent MINIAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier MINIAODSIM --fileout file:$step3_resultfile --conditions 102X_upgrade2018_realistic_v15 --step PAT --geometry DB:Extended --filein file:$step2_resultfile --era Run2_2018 --runUnscheduled --no_exec --mc -n $EVENTS;