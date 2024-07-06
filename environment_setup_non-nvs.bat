@ECHO OFF
ECHO Activating Anaconda base environment.
CALL conda activate
ECHO Creating conda environment and installing packages
conda env create -f environment_conda.yml