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
                       'PartonLevel:ISR = off',
                       '23:addChannel 1 1.00 100 13 -13 443',
#                       '23:addChannel 1 1.00 100 11 -11 443',
                       '23:onMode = off',
                       '23:doForceWidth = on'
                       '23:onIfMatch 13 -13 443',
#                       '23:onIfMatch 11 -11 443',
                       '443:onMode = off',
                       '443:onIfMatch 13 -13'
#                       '23:m0=11.0',
#                       '23:mWidth =0.00'
),
                parameterSets = cms.vstring(
                        'pythia8CommonSettings',
                        'pythia8CP5Settings',
                        'pythiaEtab',
                )
        )
)

mumugenfilter = cms.EDFilter("MCSingleParticleFilter",
    Status      = cms.untracked.vint32(1, 1, 1, 1),
    MinPt       = cms.untracked.vdouble(2.0, 2.0, 2.0, 2.0),
    MinP        = cms.untracked.vdouble(0., 0., 0., 0.),
    MaxEta      = cms.untracked.vdouble(2.7, 2.7, 2.7, 2.7),
    MinEta      = cms.untracked.vdouble(-2.7, -2.7, -2.7, -2.7),
    ParticleID = cms.untracked.vint32(13, -13, 13, -13),
)

ProductionFilterSequence = cms.Sequence(generator+mumugenfilter)
