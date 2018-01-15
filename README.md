# CCA
Code to determine whether groups are CCA or not.

This code was written using Sage (Version 7.6), GAP (Version 4.8.6) and requires the GAP Small Groups library to be installed. Information on the Small Group Library and GAP can be found here: https://www.gap-system.org/Packages/sgl.html.

Usage:
-The two files func.g and func.sage contain the main functions that are used to determine the CCA property in a group. They are both needed. CCA.sage is a sample program which uses the two functions of the two files func.g and func.sage.
-There are three main ways to use these functions.
  1) From command line and having a program that uses the functions (for example CCA.sage) you can run the program using the sage commands. For example on linux 'sage CCA.sage' would run the sample program and output CCA or non-CCA for each group of order 32.
  2) From sage command line type in both lines 3 and 4 (without the outside quotations) from the sample CCA.sage file 'load("func.sage")' and 'gap.eval('Read("func.g");')' and use the functions as needed. Both files need to be in the current directory.
  3) From Sage Notebook.
