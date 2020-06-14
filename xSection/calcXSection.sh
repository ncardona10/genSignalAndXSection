#!/bin/bash

# check input arguments
if [ "$#" -ne 3 ]; then
    echo "Need 3 parameters to run: n2, ch1 and n1"
    exit 2
fi

n2=$1
ch1=$2
n1=$3

echo Using n2 = $n2, ch1 = $ch1 and n1 = $n1

currentFolder=/home/aflorez/genSignalAndXSection/xSection/
outputFolder=/home/aflorez/genSignalAndXSection/results/xSection/n2_${n2}_ch1_${ch1}_n1_${n1}/

# create mg5 file
cp ${currentFolder}templates/standardMgFile.mg5 ${currentFolder}currentRun/mgFile.mg5
# cp ${currentFolder}templates/standardParamCard.dat ${currentFolder}currentRun/param_card.dat

# create ouput folder
mkdir -p $outputFolder 

sed -i "s|outputFolder|${outputFolder}|g" ${currentFolder}currentRun/mgFile.mg5

# run mg5_aMC mg5File to create stuff in folder of line 2
# mg5_aMC ${currentFolder}currentRun/mgFile.mg5

# in own paramcard file, change masses
# sed -i "s/      1000022 5.000000e+01 # mneu1/      1000022 ${n1} # mneu1/g" ${currentFolder}currentRun/param_card.dat
# sed -i "s/      1000023 1.000000e+02 # mneu2/      1000023 ${n2} # mneu2/g" ${currentFolder}currentRun/param_card.dat
# sed -i "s/      1000024 7.500000e+01 # mch1/      1000024 ${ch1} # mch1/g" ${currentFolder}currentRun/param_card.dat

# cp ${currentFolder}currentRun/param_card.dat ${outputFolder}Cards/param_card_default.dat
# cp ${currentFolder}templates/run_card.dat ${outputFolder}Cards/run_card_default.dat

# cp ${currentFolder}currentRun/param_card.dat ${outputFolder}Cards/param_card.dat
# cp ${currentFolder}templates/run_card.dat ${outputFolder}Cards/run_card.dat

echo "launch ${outputFolder}" >> ${currentFolder}currentRun/mgFile.mg5
echo "set mneu1 ${n1}" >> ${currentFolder}currentRun/mgFile.mg5
echo "set mneu2 ${n2}" >> ${currentFolder}currentRun/mgFile.mg5
echo "set mch1 ${ch1}" >> ${currentFolder}currentRun/mgFile.mg5
echo "set nevents 10000" >> ${currentFolder}currentRun/mgFile.mg5
# echo "${outputFolder}Cards/param_card.dat" >> ${currentFolder}currentRun/mgFile.mg5
# echo "${outputFolder}Cards/run_card.dat" >> ${currentFolder}currentRun/mgFile.mg5

#log the output for post processing
echo "running mg5_aMC ${currentFolder}currentRun/mgFile.mg5"
script -c "mg5_aMC ${currentFolder}currentRun/mgFile.mg5" -q ${currentFolder}logXSection.txt

# remove files from output folder. They are too heavy 
rm -rf ${outputFolder}/*

cp ${currentFolder}logXSection.txt "${outputFolder}xsectionLog.txt"

# get cross section values
xsection=$(cat ${currentFolder}logXSection.txt | grep "Cross-section" | awk '{print $3}')
xsectionerr=$(cat ${currentFolder}logXSection.txt | grep "Cross-section" | awk '{print $5}')
nevents=$(cat ${currentFolder}logXSection.txt | grep "Nb of events" | awk '{print $5}')

echo "xsection = $xsection, xsectionerr = $xsectionerr and nevents = $nevents"
echo "saving results to ${outputFolder}xsection.dat"

#write them to file
echo "n2,ch1,n1,xsection,xsectionerr,nevents" > "${outputFolder}xsection.dat"
echo "${n2},${ch1},${n1},${xsection},${xsectionerr},${nevents}" >> "${outputFolder}xsection.dat"

# remove temp logXsection file 
rm ${currentFolder}logXSection.txt
