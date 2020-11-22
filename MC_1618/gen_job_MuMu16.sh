 #!/bin/bash

START=0
#Configuration 

GEN_SCRAM="SCRAM_ARCH=slc7_amd64_gcc481"
RECO_SCRAM="SCRAM_ARCH=slc7_amd64_gcc530"
#RELEASE FOR EVERY STEP
#NOTE! AOD STEP REQUIRES SAME RELEASE W.R.T MINIAOD
#AT LEAST FOR THIS MC PRODUCTION
GEN_REL="CMSSW_7_1_25_patch1"
RECO_REL="CMSSW_8_0_21"
CHANNEL_DECAY="ZtoJpsiMuMu16"


if [ $START -le 0 ];
then
	echo "\n\n==================== cmssw environment prepration Gen step ====================\n\n"
	source /cvmfs/cms.cern.ch/cmsset_default.sh
	export SCRAM_ARCH=$SCRAM

	if [ -r $GEN_REL/src ] ; then
	  echo release $GEN_REL already exists
	else
	  scram p CMSSW $GEN_REL
	fi
	cd $GEN_REL/src
	eval `scram runtime -sh`

	scram b
	cd ../../

	echo "==================== PB: CMSRUN starting Gen step ===================="
	cmsRun -e -j ${CHANNEL_DECAY}_step0.log  -p PSet.py
    #cmsRun -e -j FrameworkJobReport.xml -p PSet.py
	#cmsRun -j ${CHANNEL_DECAY}_step0.log -p step0-GS-${CHANNEL_DECAY}_cfg.py
fi

if [ $START -le 1 ];
then
	echo "\n\n==================== cmssw environment prepration Reco step ====================\n\n"
	source /cvmfs/cms.cern.ch/cmsset_default.sh
	export SCRAM_ARCH=$SCRAM
	if [ -r $RECO_REL/src ] ; then
	  echo release $RECO_REL already exists
	else
	  scram p CMSSW $RECO_REL
	fi
	cd $RECO_REL/src
	eval `scram runtime -sh`
	scram b
	cd ../../

	echo "==================== PB: CMSRUN starting Reco step ===================="
	cmsRun -e -j ${CHANNEL_DECAY}_step1.log step1-PREMIXRAW-${CHANNEL_DECAY}_run_cfg.py
	#cleaning
	#rm -rfv step0-GS-${CHANNEL_DECAY}.root
fi

if [ $START -le 2 ];
then
	echo "================= PB: CMSRUN starting Reco step 2 ===================="
	if [ -r $RECO_REL/src ] ; then
	  echo release $RECO_REL already exists
	else
	  scram p CMSSW $RECO_REL
	fi
	cd $RECO_REL/src
	eval `scram runtime -sh`
	scram b
	cd ../../

	cmsRun -e -j ${CHANNEL_DECAY}_step2.log step2-AODSIM-${CHANNEL_DECAY}_run_cfg.py
fi

if [ $START -le 3 ];
then
	echo "================= PB: CMSRUN starting step 3 ===================="
	if [ -r $RECO_REL/src ] ; then
	  echo release $RECO_REL already exists
	else
	  scram p CMSSW $RECO_REL
	fi
	cd $RECO_REL/src
	eval `scram runtime -sh`
	scram b
	cd ../../

	cmsRun -e -j FrameworkJobReport.xml  step3-MINIAODSIM-${CHANNEL_DECAY}_run_cfg.py
	#cleaning
	#rm -rfv step2-DR-${CHANNEL_DECAY}.root
fi