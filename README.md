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


- Links: 
	- (Electroweak Processes)[http://home.thep.lu.se/~torbjorn/pythia82html/ElectroweakProcesses.html]
	- (The Particle Data Scheme)[http://home.thep.lu.se/~torbjorn/pythia82html/ParticleDataScheme.html]
	- (ZZ pythia)[https://twiki.cern.ch/twiki/pub/CMSPublic/FCCeeHbbHccAnalysis/zz_cc.pythia]