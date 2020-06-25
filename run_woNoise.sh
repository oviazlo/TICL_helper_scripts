# runTheMatrix.py -w upgrade -l 23289.0 --showMatrix --extended
THISDIR=`pwd`
echo "Init cmssw in current dir: ${THISDIR}"
eval `scramv1 runtime -sh`

PREFIX="/afs/cern.ch/work/o/oviazlo/HGCAL_DPG"
INPUT_FILE=$PREFIX"/pre7_kappa_5_noNoise/CMSSW_11_1_0_pre7/src/23289.0_SingleMuPt15Eta1p7_2p7+SingleMuPt15Eta1p7_2p7_2026D49_GenSimHLBeamSpotFull+DigiFullTrigger_2026D49+RecoFullGlobal_2026D49+HARVESTFullGlobal_2026D49/step2.root"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/23289.0_SingleMuPt15Eta1p7_2p7+SingleMuPt15Eta1p7_2p7_2026D49_GenSimHLBeamSpotFull+DigiFullTrigger_2026D49+RecoFullGlobal_2026D49+HARVESTFullGlobal_2026D49"
NEVENTS=1000

if [ ! -d $DIR ]
    then
        mkdir $DIR
fi

# cd $DIR
# cmsDriver.py SingleMuPt15Eta1p7_2p7_cfi  --conditions auto:phase2_realistic_T15 -n 1000 --era Phase2C9 --eventcontent FEVTDEBUG --relval 9000,100 -s GEN,SIM --datatier GEN-SIM --beamspot HLLHC --geometry Extended2026D49 --fileout file:step1.root  --nThreads 12 > step1_SingleMuPt15Eta1p7_2p7+SingleMuPt15Eta1p7_2p7_2026D49_GenSimHLBeamSpotFull+DigiFullTrigger_2026D49+RecoFullGlobal_2026D49+HARVESTFullGlobal_2026D49.log  2>&1
#
# cd $DIR
# cmsDriver.py step2 --customise SimCalorimetry/HGCalSimProducers/hgcalDigitizer_cfi.HGCal_disableNoise --conditions auto:phase2_realistic_T15 -s DIGI:pdigi_valid,L1,L1TrackTrigger,DIGI2RAW,HLT:@fake2 --datatier GEN-SIM-DIGI-RAW -n $NEVENTS --geometry Extended2026D49 --era Phase2C9 --eventcontent FEVTDEBUGHLT --filein  file:step1.root  --fileout file:step2.root  --nThreads 12 > step2_SingleMuPt15Eta1p7_2p7+SingleMuPt15Eta1p7_2p7_2026D49_GenSimHLBeamSpotFull+DigiFullTrigger_2026D49+RecoFullGlobal_2026D49+HARVESTFullGlobal_2026D49.log  2>&1

cd $DIR
cmsDriver.py step3 --customise SimCalorimetry/HGCalSimProducers/hgcalDigitizer_cfi.HGCal_disableNoise --conditions auto:phase2_realistic_T15 -n $NEVENTS --era Phase2C9 --eventcontent FEVTDEBUGHLT,MINIAODSIM,DQM --runUnscheduled  -s RAW2DIGI,L1Reco,RECO,RECOSIM,PAT,VALIDATION:@phase2Validation+@miniAODValidation,DQM:@phase2+@miniAODDQM --datatier GEN-SIM-RECO,MINIAODSIM,DQMIO --geometry Extended2026D49 --filein  file:$INPUT_FILE --fileout file:step3.root  --nThreads 1 > step3_SingleMuPt15Eta1p7_2p7+SingleMuPt15Eta1p7_2p7_2026D49_GenSimHLBeamSpotFull+DigiFullTrigger_2026D49+RecoFullGlobal_2026D49+HARVESTFullGlobal_2026D49.log  2>&1

cd $DIR
cmsDriver.py step4  --conditions auto:phase2_realistic_T15 -s HARVESTING:@phase2Validation+@phase2+@miniAODValidation+@miniAODDQM --scenario pp --filetype DQM --geometry Extended2026D49 --era Phase2C9 --mc  -n $NEVENTS  --filein file:step3_inDQM.root --fileout file:step4.root  > step4_SingleMuPt15Eta1p7_2p7+SingleMuPt15Eta1p7_2p7_2026D49_GenSimHLBeamSpotFull+DigiFullTrigger_2026D49+RecoFullGlobal_2026D49+HARVESTFullGlobal_2026D49.log  2>&1

