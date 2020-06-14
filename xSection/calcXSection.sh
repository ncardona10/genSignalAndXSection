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

# create mg5 file
cp ./templates/standardMgFile.mg5 ./currentRun/mgFile.mg5
cp ./templates/standardParamCard.dat ./currentRun/param_card.dat

outputFolder=../results/xSection/n2_${n2}_ch1_${ch1}_n1_${n1}/

# create ouput folder
mkdir -p $outputFolder 

sed -i "s/outputFolder/..\/results\/xSection\/n2_${n2}_ch1_${ch1}_n1_${n1}/g" ./currentRun/mgFile.mg5

# run mg5_aMC mg5File to create stuff in folder of line 2
mg5_aMC ./currentRun/mgFile.mg5

# in own paramcard file, change masses
sed -i "s/      1000022 5.000000e+01 # mneu1/      1000022 ${n1} # mneu1/g" ./currentRun/param_card.dat
sed -i "s/      1000023 1.000000e+02 # mneu2/      1000023 ${n2} # mneu2/g" ./currentRun/param_card.dat
sed -i "s/      1000024 7.500000e+01 # mch1/      1000024 ${ch1} # mch1/g" ./currentRun/param_card.dat

cp ./currentRun/param_card.dat ${outputFolder}Cards/param_card.dat
cp ./templates/run_card.dat ${outputFolder}Cards/run_card.dat

echo "launch " >> ./currentRun/mgFile.mg5
echo "/home/aflorez/genSignalAndXSection/results/xSection/n2_${n2}_ch1_${ch1}_n1_${n1}/Cards/param_card.dat" >> ./currentRun/mgFile.mg5
echo "/home/aflorez/genSignalAndXSection/results/xSection/n2_${n2}_ch1_${ch1}_n1_${n1}/Cards/run_card.dat" >> ./currentRun/mgFile.mg5

#log the output for post processing
script -c 'mg5_aMC ./currentRun/mgFile.mg5' -q ./logXSection.txt
cp ./logXSection.txt "${outputFolder}xsectionLog.txt"

# get cross section values
xsection=$(cat logXSection.txt | grep "Cross-section" | awk '{print $3}')
xsectionerr=$(cat logXSection.txt | grep "Cross-section" | awk '{print $5}')
nevents=$(cat logXSection.txt | grep "Nb of events" | awk '{print $5}')

echo "xsection = $xsection, xsectionerr = $xsectionerr and nevents = $nevents"
echo "saving results to ${outputFolder}xsection.dat"

#write them to file
echo "n2,ch1,n1,xsection,xsectionerr,nevents" > "${outputFolder}xsection.dat"
echo "${n2},${ch1},${n1},${xsection},${xsectionerr},${nevents}" >> "${outputFolder}xsection.dat"

# remove temp logXsection file 
rm ./logXSection.txt
