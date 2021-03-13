#PBS -k oe 
#PBS -m abe
#PBS -M youremailhere@gmail.com
#PBS -N ProcessScans
#PBS -l nodes=1:ppn=3,vmem=20gb,walltime=2:00:00

##Move to correct WD
cd $PBS_O_WORKDIR
pwd
source ../samples.conf
cd $MAIN_DIR/1a_ProcessScans

##load modules
module unload python
module load dimspy/2.0

##Process Scans: Process scans and/or stitch SIM windows.

dimspy process-scans \
--input $INPUT_DIR \
--output process_scans.out \
--filelist $FILE_LIST \
--function-noise noise_packets \
--snr-threshold $SNR_THRESH \
--ppm $PPM \
--min_scans 3 \
--min-fraction 0.5 \
--exclude-scan-events 50.0 620.0 full \
--report $REPORT_DIR/process_scan_report.$PBS_JOBID \
--ncpus $NCPUS

#optional parameters: --rds-threshold, --skip-stitching, --ncpus

echo "Processing Complete.  Converting Scans"

dimspy hdf5-pls-to-txt \
--input process_scans.out \
--output 1_ProcessScans/ \
--delimiter tab

echo "Conversion Complete"

echo "Submitting next job"
cd ../1b_RepFilter/
qsub RunReplicateFilter.sh
