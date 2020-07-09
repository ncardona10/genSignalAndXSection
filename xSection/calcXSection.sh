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

currentFolder=/home/adminuniandes/genSignalAndXSection/xSection/
outputFolder=/home/adminuniandes/genSignalAndXSection/results/xSection/n2_${n2}_ch1_${ch1}_n1_${n1}/

# create mg5 file
rm ${currentFolder}currentRun/*

cp ${currentFolder}templates/standardMgFile.mg5 ${currentFolder}currentRun/mgFile.mg5
#cp ${currentFolder}templates/run_card.dat ${currentFolder}currentRun/run_card.dat
#cp ${currentFolder}templates/standardParamCard.dat ${currentFolder}currentRun/param_card.dat

# create ouput folder
mkdir -p $outputFolder 

sed -i "s|outputFolder|${outputFolder}|g" ${currentFolder}currentRun/mgFile.mg5

echo "launch ${outputFolder}" >> ${currentFolder}currentRun/mgFile.mg5
echo "set mneu1 ${n1}" >> ${currentFolder}currentRun/mgFile.mg5
echo "set mneu2 ${n2}" >> ${currentFolder}currentRun/mgFile.mg5
echo "set mch1 ${ch1}" >> ${currentFolder}currentRun/mgFile.mg5
echo "set nevents 1000" >> ${currentFolder}currentRun/mgFile.mg5
echo "set deltaeta 3.8" >> ${currentFolder}currentRun/mgFile.mg5

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
