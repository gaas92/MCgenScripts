from CRABClient.UserUtilities import config
import datetime
import time

config = config()

ts = time.time()
st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d-%H-%M')

channel = 'ZtoJpsiMuMu'
gen_frag = '_BPH'
#gen_frag = '_BPH-FW'
#gen_frag = '_BPH-NoISR'
#gen_frag = '_BPH-NoFSR'
#gen_frag = '_BPH-NoFSR-FW'
gen_var = gen_frag+'_run_cfg.py'
year = '2018'
step = 'PrivateMC-'+year
nEvents = 2000
NJOBS = 100
mygen = "step0-GS-"+channel+gen_var
#myrun = 'step0-GS-ups2s2ups1spipi_cfg.py'
myname = step+'-'+channel

config.General.requestName = step+'-'+channel+'-'+st
config.General.transferOutputs = True
config.General.transferLogs = False
config.General.workArea = 'crab_'+step+gen_frag+'-'+channel

config.JobType.allowUndistributedCMSSW = True
config.JobType.pluginName = 'PrivateMC'
config.JobType.psetName = mygen

# For SIM  
#config.JobType.inputFiles = ['step1-DR-'+channel+'_cfg.py',
#                             'step2-DR-'+channel+'_cfg.py',
#                             'step3-MiniAOD-'+channel+'_cfg.py',
#                             'step4-NanoAOD-'+channel+'_cfg.py']

config.JobType.disableAutomaticOutputCollection = True
config.JobType.eventsPerLumi = 10000
config.JobType.numCores = 1
config.JobType.maxMemoryMB = 3500
config.JobType.scriptExe = 'gen_job.sh'
#config.JobType.scriptArgs = ["0"]

config.JobType.outputFiles = ['step0-GS-'+channel+gen_frag+'-result.root']
#config.JobType.outputFiles = ['step0-GS-b_kmumu_PHSPS.root', 'step3-MiniAOD-b_kmumu_PHSPS.root', 'step4-NanoAOD-b_kmumu_PHSPS.root']

config.Data.outputPrimaryDataset = myname
config.Data.splitting = 'EventBased'
config.Data.unitsPerJob = nEvents
config.Data.totalUnits = config.Data.unitsPerJob * NJOBS
#config.Data.outLFNDirBase = '/store/user/hcrottel/'
config.Data.publication = False

config.Site.storageSite = 'T2_CH_CERNBOX'
