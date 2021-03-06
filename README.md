# TAON :dollar:

![cap1](https://user-images.githubusercontent.com/46664545/56477849-038df980-6478-11e9-9593-ac5e58fe58f0.png)
*screenshot of Figure Display*

### About
I wrote this program a while back to give myself a useful foundation for implementing some basic machine learning techniques.
There are 3 components:
- Runtime framework/GUI
- Predictive text classification
- Predictive trend analysis

This program is inherantly configured to handle the default .CSV transaction history provided by my bank, which has the following format:
```
+----------------+------+----------+-------+--------+---------+
| Transaction ID | Date | Merchant | Debit | Credit | Balance |
+----------------+------+----------+-------+--------+---------+
```
This will mean that some basic restructuring is necessary if your format is different

*note:* for the purpose of this repository, we will focus on the MATLAB portions disregarding the interface with Python, which handles the more robust implementation of the machine learning aspects. As a result, I am *not* including the compiled binaries and assuming you have access to MATLAB>=2017b in order to run the GUI.

### Running the program
```
% within the MATLAB command line, run
  TAONai.m
```
