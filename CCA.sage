import sys

load("func.sage")
gap.eval('Read("func.g");')

#Determines how large the automorphism group order can be to use it.
LIMIT_AUT_ORDER = 1000000

#If true, the DetermineCCA function will print the GAP group structure
PRINT_STRUCT = false

#If true, the DetermineCCA function will print the set of all minimal generating sets
PRINT_GRP_GEN = false

#If true, the DetermineCCA function will process the group and check for the CCA property.
#The function will return 1 (if the group is CCA), 0 (if the group is not CCA), or -1 if
#this is set to false.
DO_CCA = true

#If true, the DetermineCCA will return immediately after the first non-CCA graph is found.
STOP_FIRST_NONCCA = true

#If true, will check for all non-affine automorphisms of the graph. PRINT_GPH should also
#be true if you want them printed.
ALL_NONAFFINE_AUT = false

#If true, the DetermineCCA will print the minimal generating set for each Cayley graph (that
#is tested, depending on if STOP_FIRST_NONCCA is true or false) and prints whether or not that 
#graph is CCA. If the graph is non-CCA it outputs a non-affine automorphism. If ALL_NONAFFINE_AUT
#is true then it outputs all the non-affine autmorphisms.
PRINT_GPH = false

#If true, the DetermineCCA will print if the group is CCA or not CCA.
PRINT_CCA = false

#A short example. This tests all groups of order 32 and outputs whether or not they are CCA.
Grps = gap.AllSmallGroups(32)
for Grp in Grps:
    cca = DetermineCCA(Grp, LIMIT_AUT_ORDER, PRINT_STRUCT, PRINT_GRP_GEN, DO_CCA, STOP_FIRST_NONCCA, PRINT_GPH, ALL_NONAFFINE_AUT, PRINT_CCA)
    if cca == 1:
        print gap.StructureDescription(Grp), " is CCA"
    else:
        print gap.StructureDescription(Grp), " is not CCA"
