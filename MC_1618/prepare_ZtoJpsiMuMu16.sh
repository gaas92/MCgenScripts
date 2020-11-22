#!/bin/bash


# step0 GEN-SIM
export SCRAM_ARCH=slc7_amd64_gcc481
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_7_6_7/src ] ; then
  echo release CMSSW_7_6_7 already exists
else
  scram p CMSSW_7_6_7
fi
cd CMSSW_7_6_7/src
eval `scram runtime -sh`

# Configuration parameters
CHANNEL_DECAY="ZtoJpsiMuMu"
step0_fragmentfile="${CHANNEL_DECAY}_fragment.py"
step0_configfile="step0-GS-${CHANNEL_DECAY}16_run_cfg.py"
step0_resultfile="step0-GS-${CHANNEL_DECAY}16_result.root"
EVENTS=500

# Download fragment from myGitHub
curl -s -k https://raw.githubusercontent.com/gaas92/MCgenScripts/master/MC_1618/$step0_fragmentfile --retry 3 --create-dirs -o Configuration/GenProduction/python/$step0_fragmentfile
scram b
cd ../../

# taken from https://cms-pdmv.cern.ch/mcm/public/restapi/requests/get_setup/BPH-RunIIFall18GS-00251
# cmsDriver command for GEN-SIM step0
#cmsDriver.py Configuration/GenProduction/python/$step0_fragmentfile --eventcontent RAWSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --conditions 102X_upgrade2018_realistic_v11 --beamspot Realistic25ns13TeVEarly2018Collision --step GEN,SIM --geometry DB:Extended --era Run2_2018 --python_filename $step0_configfile --fileout file:$step0_resultfile --no_exec --mc -n $EVENTS; 
#cmsDriver.py Configuration/GenProduction/python/$step0_fragmentfile --eventcontent RAWSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --conditions 93X_mc2017_realistic_v3 --beamspot Realistic25ns13TeVEarly2017Collision --step GEN,SIM --geometry DB:Extended --era Run2_2017 --python_filename $step0_configfile --fileout file:$step0_resultfile --no_exec --mc -n $EVENTS;
cmsDriver.py Configuration/GenProduction/python/$step0_fragmentfile --eventcontent RAWSIM --customise SLHCUpgradeSimulations/Configuration/postLS1Customs.customisePostLS1,Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --python_filename $step0_configfile --fileout file:$step0_resultfile --conditions MCRUN2_71_V1::All --beamspot Realistic50ns13TeVCollision --step GEN,SIM --magField 38T_PostLS1 --no_exec --mc -n $EVENTS;
sed -i "20 a from IOMC.RandomEngine.RandomServiceHelper import RandomNumberServiceHelper \nrandSvc = RandomNumberServiceHelper(process.RandomNumberGeneratorService)\nrandSvc.populate()" $step0_configfile

# step1 DIGI, DATAMIX, L1, DIGIRAW, HLT
export SCRAM_ARCH=slc7_amd64_gcc530
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_8_0_21/src ] ; then
  echo release CMSSW_8_0_21 already exists
else
  scram p CMSSW CMSSW_8_0_21
fi
cd CMSSW_8_0_21/src
eval `scram runtime -sh`
scram b
cd ../..

# Configuration parameters
step1_configfile="step1-PREMIXRAW-${CHANNEL_DECAY}16_run_cfg.py"
step1_resultfile="step1-PREMIXRAW-${CHANNEL_DECAY}16_result.root"

# taken from https://cms-pdmv.cern.ch/mcm/public/restapi/requests/get_setup/BPH-RunIIAutumn18DRPremix-00163
# cmsDriver command for DIGI,DATAMIX,L1,DIGI2RAW,HLT step1
#cmsDriver.py  --python_filename $step1_configfile --eventcontent PREMIXRAW --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM-RAW --fileout file:$step1_resultfile --pileup_input "dbs:/Neutrino_E-10_gun/RunIISummer17PrePremix-PUAutumn18_102X_upgrade2018_realistic_v15-v1/GEN-SIM-DIGI-RAW" --conditions 102X_upgrade2018_realistic_v15 --step DIGI,DATAMIX,L1,DIGI2RAW,HLT:@relval2018 --procModifiers premix_stage2 --geometry DB:Extended --filein file:$step0_resultfile --datamix PreMix --era Run2_2018 --no_exec --mc -n $EVENTS;
#cmsDriver.py  --python_filename $step1_configfile --eventcontent PREMIXRAW --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM-RAW --fileout file:$step1_resultfile --pileup_input "dbs:/Neutrino_E-10_gun/RunIISummer17PrePremix-MCv2_correctPU_94X_mc2017_realistic_v9-v1/GEN-SIM-DIGI-RAW" --conditions 94X_mc2017_realistic_v11 --step DIGIPREMIX_S2,DATAMIX,L1,DIGI2RAW,HLT:2e34v40 --filein file:$step0_resultfile --datamix PreMix --era Run2_2017 --no_exec --mc -n $EVENTS;
cmsDriver.py  --python_filename $step1_configfile --eventcontent PREMIXRAW --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM-RAW --fileout file:$step1_resultfile --pileup_input "dbs:/Neutrino_E-10_gun/RunIISpring15PrePremix-PUMoriond17_80X_mcRun2_asymptotic_2016_TrancheIV_v2-v2/GEN-SIM-DIGI-RAW" --conditions 80X_mcRun2_asymptotic_2016_TrancheIV_v6 --step DIGIPREMIX_S2,DATAMIX,L1,DIGI2RAW, HLT:@frozen2016 --filein file:$step0_resultfile  --datamix PreMix --era Run2_2016 --no_exec --mc -n $EVENTS;
sed -i "20 a from IOMC.RandomEngine.RandomServiceHelper import RandomNumberServiceHelper\nrandSvc = RandomNumberServiceHelper(process.RandomNumberGeneratorService)\nrandSvc.populate()" $step1_configfile


# step2 AODSIM
#same CMSSW

# Configuration parameters
step2_configfile="step2-AODSIM-${CHANNEL_DECAY}16_run_cfg.py"
step2_resultfile="step2-AODSIM-${CHANNEL_DECAY}16_result.root"

# cmsDriver command for RAW2DIGI,L1Reco,RECO,RECOSIM,EI step2
#cmsDriver.py  --python_filename $step2_configfile --eventcontent AODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier AODSIM --fileout file:$step2_resultfile --conditions 102X_upgrade2018_realistic_v15 --step RAW2DIGI,L1Reco,RECO,RECOSIM,EI --procModifiers premix_stage2 --filein file:$step1_resultfile --era Run2_2018 --runUnscheduled --no_exec --mc -n $EVENTS; 
#cmsDriver.py  --python_filename $step2_configfile --eventcontent AODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier AODSIM --fileout file:$step2_resultfile --conditions 94X_mc2017_realistic_v11 --step RAW2DIGI,RECO,RECOSIM,EI --filein file:$step1_resultfile --era Run2_2017 --runUnscheduled --no_exec --mc -n $EVENTS;
cmsDriver.py  --python_filename $step2_configfile --eventcontent AODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier AODSIM --fileout file:$step2_resultfile --conditions 80X_mcRun2_asymptotic_2016_TrancheIV_v6 --step RAW2DIGI,RECO,EI --filein file:$step1_resultfile  --era Run2_2016 --runUnscheduled --no_exec --mc -n $EVENTS;
sed -i "20 a from IOMC.RandomEngine.RandomServiceHelper import RandomNumberServiceHelper\nrandSvc = RandomNumberServiceHelper(process.RandomNumberGeneratorService)\nrandSvc.populate()" $step2_configfile


# step3 MINIAODSIM
#same CMSSW

# Configuration parameters 
step3_configfile="step3-MINIAODSIM-${CHANNEL_DECAY}16_run_cfg.py"
step3_resultfile="step3-MINIAODSIM-${CHANNEL_DECAY}16_result.root"

# cmsDriver command for MINIAOD
export SCRAM_ARCH=slc7_amd64_gcc530
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_8_0_21/src ] ; then
  echo release CMSSW_8_0_21 already exists
else
  scram p CMSSW CMSSW_8_0_21
fi
cd CMSSW_8_0_21/src
eval `scram runtime -sh`
scram b
cd ../..

#cmsDriver.py  --python_filename $step3_configfile --eventcontent MINIAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier MINIAODSIM --fileout file:$step3_resultfile --conditions 102X_upgrade2018_realistic_v15 --step PAT --geometry DB:Extended --filein file:$step2_resultfile --era Run2_2018 --runUnscheduled --no_exec --mc -n $EVENTS;
#cmsDriver.py  --python_filename $step3_configfile --eventcontent MINIAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier MINIAODSIM --fileout file:$step3_resultfile --conditions 94X_mc2017_realistic_v14 --step PAT --scenario pp --filein file:$step2_resultfile --era Run2_2017,run2_miniAOD_94XFall17 --runUnscheduled --no_exec --mc -n $EVENTS;
cmsDriver.py  --python_filename $step3_configfile --eventcontent MINIAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier MINIAODSIM --fileout file:$step3_resultfile --conditions 94X_mcRun2_asymptotic_v3 --step PAT --filein file:$step2_resultfile --era Run2_2016,run2_miniAOD_80XLegacy --runUnscheduled --no_exec --mc -n $EVENTS;