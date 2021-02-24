#PBS -k oe 
#PBS -m abe
#PBS -M youremailhere@gmail.com
#PBS -N AvgPeaks
#PBS -l nodes=1:ppn=3,vmem=20gb,walltime=2:00:00

##Move to correct WD
cd $PBS_O_WORKDIR
source ../samples.conf
cd $MAIN_DIR/6_GetPeaksAndConvert

##load modules
module unload python
module load dimspy

echo "Getting Average Peaklists"

#Get Average Peaklist: Get an average peaklist from a peak matrix object.
dimspy get-peaklists \
--input ../5_MissingVals/missingVals.* \
--output PeaksList.$PBS_JOB

dimspy get-average-peaklist \
--name-peaklist 'NAME' \
--input ../5_MissingVals/missingVals.* \
--output Avg.PeaksList.$PBS_JOB

echo "Peaks and Average Peaks Complete"

dimspy hdf5-pls-to-txt \
--input PeaksList.$PBS_JOB \
--output ./peakslist \
--delimiter tab

dimspy hdf5-pls-to-txt \
--input Avg.PeaksList.$PBS_JOB \
--output . \
--delimiter tab

echo "Conversions Complete"
echo "Step Complete"

