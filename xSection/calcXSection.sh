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

# create ouput folder
mkdir ../results/xSection/n2_${n2}_ch1_${ch1}_n1_${n1} 

# run mg5_aMC mg5File to create stuff in folder of line 2

# in own paramcard file, change masses

# change param_card_default.dat and run_card_default.dat for own files 

# create a copy of the mg5file to an mg5launch file and include respective output 

# mg5_aMC mg5launchfile and log output

# process log output to retrieve the data and write it to global file
