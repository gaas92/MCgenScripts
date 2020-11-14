 #!/bin/bash

START=0
#Configuration 

SCRAM="slc7_amd64_gcc700"
#RELEASE FOR EVERY STEP
#NOTE! AOD STEP REQUIRES SAME RELEASE W.R.T MINIAOD
#AT LEAST FOR THIS MC PRODUCTION
GEN_REL="CMSSW_10_2_20_UL"
RECO_REL="CMSSW_10_2_5"
CHANNEL_DECAY="ZtoJpsiMuMu"


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
	cmsRun -e -j ${CHANNEL_DECAY}_step1.log step1-PREMIXRAW-${CHANNEL_DECAY}_BPH-FW-NF_run_cfg.py
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

	cmsRun -e -j ${CHANNEL_DECAY}_step2.log step2-AODSIM-${CHANNEL_DECAY}_BPH-FW-NF_run_cfg.py
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

	cmsRun -e -j FrameworkJobReport.xml  step3-MINIAODSIM-${CHANNEL_DECAY}_BPH-FW-NF_run_cfg.py
	#cleaning
	#rm -rfv step2-DR-${CHANNEL_DECAY}.root
fi