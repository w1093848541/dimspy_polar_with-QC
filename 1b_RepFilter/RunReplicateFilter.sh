#PBS -k oe 
#PBS -m abe
#PBS -M youremailhere@gmail.com
#PBS -N ReplicateFilter
#PBS -l nodes=1:ppn=3,vmem=100gb,walltime=20:00

##Move to correct WD
cd $PBS_O_WORKDIR
source ../samples.conf
cd $MAIN_DIR/1b_RepFilter

##load modules
module unload python
module load dimspy/2.0

echo "Starting filtering"
##Replicate Filter: Filter irreproducible peaks from technical replicate peaklists.

dimspy replicate-filter \
--input ../1a_ProcessScans/process_scans.out \
--output RepFilter.$PBS_JOBID \
--ppm $PPM \
--replicates $REPLICATES \
--min-peak-present 3 \
--report $REPORT_DIR/RepFilterReport.$PBS_JOBID \
--ncpus $NCPUS

#other options to consider: --rsd_threshold, --filelist, --report
echo "Filtering complete, begin conversion of files"

#Create a sample list from a peak matrix object or list of peaklist objects.
dimspy create-sample-list \
--input RepFilter.$PBS_JOBID \
--output SampleList.RepFilter.$PBS_JOBID \
--delimiter tab 

echo "Creation of sample list complete"

#Write HDF5 output (peak lists) to text format.
dimspy hdf5-pls-to-txt \
--input RepFilter.$PBS_JOBID \
--output . \
--delimiter tab 

echo "Peak lists output complete"
echo "Job complete"

echo "Submitting next step"
cd ../2_AlignSamples/
qsub RunAlignSamples.sh
