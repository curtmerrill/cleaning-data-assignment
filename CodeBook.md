# Codebook

The data in `data/tidy.csv` have been extracted using `run_analysis.R`.

## Columns

### subject

A categorical ID number for each subject test.

### activity

A categorical string labeling the type of activity being measured.

### Others

The other variables are continuous variables with values between -1 and 1.

The variable names obey the following naming convention:

#### Time/Four  

Variables starting with **Time** are calculations from the time-domain
signals.

Variables with **Four** have had a Fast Fourier Transform applied to the signals.

#### Body/Gravity

Variables with **Body** are based on the accelerometers output, without Gravity. 

Variables with **Gravity** are based on the accelerometers output, isolating the effect of gravity.

#### Acc/Gyro

**Acc** referes to Accelerometer data.

**Gyro** refers to Gyroscopic data.

#### Mean/Stdev

**Mean** and **Stdev** refer to calculated means and standard deviations, respectively.

#### X/Y/Z

If the variable name ends in a **X**, **Y** or **Z**, it refers to the motion along that axis.
