# for debugging: https://twiki.cern.ch/twiki/bin/view/CMSPublic/SWGuideMessageLogger#logdebug
DEBUG_MODE=false

CMSREL='CMSSW_11_1_0_pre7'
# BRANCH_OWNER='rovere'
# BRANCH_NAME='TICL_inReco_111X_pf'
if [ -d $CMSREL ]
    then
        cd $CMSREL/src
        eval `scramv1 runtime -sh`
        git cms-init
        # git remote add -f $BRANCH_OWNER git@github.com:$BRANCH_OWNER/cmssw.git
        # git branch $BRANCH_NAME $BRANCH_OWNER/$BRANCH_NAME
        # git checkout $BRANCH_NAME
        # git --no-pager log --name-status --oneline $BRANCH_NAME ^from-$CMSREL | awk '/\w+\/\w+\// {print $2}' | sed -e 's#\([a-zA-Z0-9]\+/[a-zA-Z0-9]\+\).*#\1#' | sort -u | xargs -n 1 git cms-addpkg
        git cms-addpkg RecoLocalCalo/HGCalRecProducers
        git cms-addpkg Validation/HGCalValidation
        git cms-addpkg RecoHGCal/TICL
        git cms-addpkg RecoLocalCalo/HGCalRecProducers
        # if [ $DEBUG_MODE ]; then
        #     git cms-addpkg RecoHGCal/Configuration
        # fi
    
        # sed -i 's/ticlTrackstersMIP/trackstersMIP/g' RecoHGCal/TICL/python/MIPStep_cff.py
        # sed -i 's/ticlTrackstersMIP/trackstersMIP/g' RecoHGCal/Configuration/python/TICL_EventContent_cff.py
        sed -i 's/nintTotNcellsperthickperlayer = cms.int32(100)/nintTotNcellsperthickperlayer = cms.int32(500)/g' Validation/HGCalValidation/python/HGVHistoProducerAlgoBlock_cfi.py

        # sed -i "37 i\'HGCAL/HGCalValidator/ticlMultiClustersFromTrackstersTrk/'," Validation/HGCalValidation/python/PostProcessorHGCAL_cfi.py
        # echo ""
        # echo "ADD MIPs to line 37 of the file:"
        # echo "vim "$CMSREL"/src/Validation/HGCalValidation/python/PostProcessorHGCAL_cfi.py"
        sed -i '19 i\cms.InputTag("ticlMultiClustersFromTrackstersMIP"),' Validation/HGCalValidation/python/HGCalValidator_cfi.py
        sed -i "38 i\'HGCAL/HGCalValidator/ticlMultiClustersFromTrackstersMIP/'," Validation/HGCalValidation/python/PostProcessorHGCAL_cfi.py
        # echo ""
        # echo ""
        # echo "ADD MIPs to line 18 of the file:"
        # echo "vim "$CMSREL"/src/Validation/HGCalValidation/python/HGCalValidator_cfi.py"
        echo ""
        echo "MODIFY lines 23 and 25 of the file:"
        echo "vim "$CMSREL"/src/RecoHGCal/TICL/python/MIPStep_cff.py"
        echo ""
        echo "MODIFY line 89 of the file:"
        echo "vim "$CMSREL"/src/RecoLocalCalo/HGCalRecProducers/plugins/HGCalCLUEAlgo.h"
        echo ""
        echo "COMPILE:"
        # if [ $DEBUG_MODE ]; then
        #     echo "cd "$CMSREL"/src; scram b -j8 USER_CXXFLAGS=\"-DEDM_ML_DEBUG\""
        # else
        echo "cd "$CMSREL"/src; scram b -j12"
        # fi
        echo ""
        echo ""
    else
        echo "INIT CMSREL:"
        echo "cmsrel "$CMSREL
        echo ""
        echo ""
fi
