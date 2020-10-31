# This repository contains the scripts needed to generate a Z->V+ll sample 
- The steps needed for a correct generarion are this:
	- prepare.sh (should run a cmsDriver.py for every step, at this point is only gen step)
	- then run via cmsRun the correspondig step 
	- if want to run via CRAB, shuud use the crabJob.py that points to job.sh

## Some references to pythia:
- To be filled jeje


### Weak boson processes
- Weak boson processes: `WeakZ0:gmZmode (default = 0; minimum = 0; maximum = 2)`. Choice of full gamma^*/Z^0 structure or not in relevant processes:
	- option 0 : full gamma^*/Z^0 structure, with interference included.
	- option 1 : only pure gamma^* contribution.
	- option 2 : only pure Z^0 contribution.
	- Note: irrespective of the option used, the particle produced will always be assigned code 23 for Z^0, and open decay channels is purely dictated by what is set for the Z^0.

- Single boson
	- flag  `WeakSingleBoson:all`   (default = off)
		- Common switch for the group of a single gamma^*/Z^0 or W^+- production.

	- flag  `WeakSingleBoson:ffbar2gmZ`   (default = off) (currentry used in BPH-fragment)
		- Scattering f fbar → gamma^*/Z^0, with full interference between the gamma^* and Z^0. Code 221.

	- flag  `WeakSingleBoson:ffbar2W`   (default = off)
		- Scattering f fbar' → W^+-. Code 222.

	- flag  `WeakSingleBoson:ffbar2ffbar(s:gm)`   (default = off)
		- Scattering f fbar → gamma^* → f' fbar'. Subset of process 221, but written as a 2 → 2 process, so that pT can be used as ordering variable, e.g. in multiparton interactions. Hardcoded for the final state being either of the five quark flavours or three lepton ones. Not included in the WeakSingleBoson:all set, but included in the multiparton-interactions framework. Code 223.

	- flag  `WeakSingleBoson:ffbar2ffbar(s:gmZ)`   (default = off)
		- Scattering f fbar → gamma^*/Z^0 → f' fbar'. Equivalent to process 221, but written as a 2 → 2 process, so that pT could be used as cut or ordering variable. Final-state flavour selection is based on the Z^0 allowed decay modes, and the WeakZ0:gmZmode options are implemented. Not included in the WeakSingleBoson:all set. Code 224.

	- flag  `WeakSingleBoson:ffbar2ffbar(s:W)`   (default = off)
		- Scattering f_1 fbar_2 → W+- → f_3 f_4. Almost equivalent to process 222, but written as a 2 → 2 process, so that pT could be used as cut or ordering variable. Final-state flavour selection is based on the W allowed decay modes. There are two simplifications relative to the implementation in process 222. Firstly, it is not possible to set different decay modes for the W^+ and the W^-; instead the allowed W^+ ones will be used throughout, with charge conjugation for the W^-. Secondly, quark mass corrections are neglected in the decay angular distribution. Not included in the WeakSingleBoson:all set. Code 225.

- Links: 
	- (Electroweak Processes)[http://home.thep.lu.se/~torbjorn/pythia82html/ElectroweakProcesses.html]
	- (The Particle Data Scheme)[http://home.thep.lu.se/~torbjorn/pythia82html/ParticleDataScheme.html]
	- (ZZ pythia)[https://twiki.cern.ch/twiki/pub/CMSPublic/FCCeeHbbHccAnalysis/zz_cc.pythia]