from CRABClient.UserUtilities import config
import datetime
import time

config = config()

ts = time.time()
st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d-%H-%M')

channel = 'ZtoJpsiMuMu'
#gen_frag = '_BPH'
gen_frag = '17'
#gen_frag = '_BPH-NoISR'
#gen_frag = '_BPH-NoFSR'
#gen_frag = '_BPH-NoFSR-FW'
gen_var = gen_frag+'_run_cfg.py'
year = '2017'
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
config.JobType.inputFiles = ['step1-PREMIXRAW-'+channel+gen_var,
                             'step2-AODSIM-'+channel+gen_var,
                             'step3-MINIAODSIM-'+channel+gen_var]

config.JobType.disableAutomaticOutputCollection = True
config.JobType.eventsPerLumi = 10000
config.JobType.numCores = 1
config.JobType.maxMemoryMB = 3500
config.JobType.scriptExe = 'gen_job_MuMu17.sh'
#config.JobType.scriptArgs = ["0"]

#config.JobType.outputFiles = ['step0-GS-'+channel+gen_frag+'-result.root']
config.JobType.outputFiles = ['step0-GS-'+channel+gen_frag+'_result.root', 'step3-MINIAODSIM-'+channel+gen_frag+'_result.root']

config.Data.outputPrimaryDataset = myname
config.Data.splitting = 'EventBased'
config.Data.unitsPerJob = nEvents
config.Data.totalUnits = config.Data.unitsPerJob * NJOBS
#config.Data.outLFNDirBase = '/store/user/hcrottel/'
config.Data.publication = False

#config.Site.storageSite = 'T2_CH_CERNBOX'
config.Data.outLFNDirBase = '/store/user/%s/Zpsi_MuMu_FWMC/' % ("gayalasa")
config.Site.storageSite = 'T3_US_FNALLPC'
