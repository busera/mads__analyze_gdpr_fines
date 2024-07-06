@ECHO OFF
ECHO Activating Anaconda base environment.
::CALL conda activate
Call C:\ProgramData\Anaconda3\Scripts\activate.bat
ECHO Creating conda environment and installing packages
conda env create -f environment_conda.yml