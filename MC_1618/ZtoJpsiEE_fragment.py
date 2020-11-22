import FWCore.ParameterSet.Config as cms
from Configuration.Generator.Pythia8CommonSettings_cfi import *
from Configuration.Generator.MCTunes2017.PythiaCP5Settings_cfi import *



generator = cms.EDFilter("Pythia8GeneratorFilter",
        pythiaHepMCVerbosity = cms.untracked.bool(False),
        maxEventsToPrint = cms.untracked.int32(3),
        pythiaPylistVerbosity = cms.untracked.int32(1),
        displayPythiaCards = cms.untracked.bool(False),
        comEnergy = cms.double(13000.0),
        PythiaParameters = cms.PSet(
                pythia8CommonSettingsBlock,
                pythia8CP5SettingsBlock,
                pythiaEtab = cms.vstring(
                       'Main:timesAllowErrors = 10000',
                       'WeakSingleBoson:ffbar2gmZ = on',
                       'WeakZ0:gmZmode = 2',
#                       '23:addChannel 1 1.00 100 13 -13 443',
                       '23:addChannel 1 1.00 100 11 -11 443',
                       '23:onMode = off',
                       '23:m0=91.2',
                       '23:mWidth = 2.49',
                       '23:doForceWidth = on',
#                       '23:onIfMatch 13 -13 443',
                       '23:onIfMatch 11 -11 443',
                       '443:onMode = off',
                       '443:onIfMatch 13 -13'

),
                parameterSets = cms.vstring(
                        'pythia8CommonSettings',
                        'pythia8CP5Settings',
                        'pythiaEtab',
                )
        )
)


ProductionFilterSequence = cms.Sequence(generator)
