#!/bin/bash
#PBS -k o
#PBS -l nodes=1:ppn=1:dc,cput=6:00:00,walltime=7:30:00,mem=2000mb
#PBS -M wtclark@indiana.edu
#PBS -m abe
#PBS -N svm_test
#PBS -j oe
cd /N/dc/scratch/wtclark/SCOP/PRED_COMPILE/
nohup matlab < main_svm.m > output.txt
