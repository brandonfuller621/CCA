import sys

load("func.sage")
gap.eval('Read("func.g");')

LIMIT_AUT_ORDER = 1000000

PRINT_STRUCT = false

PRINT_GRP_GEN = false

DO_CCA = true

STOP_FIRST_NONCCA = true

PRINT_GPH = false

ALL_NONAFFINE_AUT = false

PRINT_CCA = false

Grps = gap.AllSmallGroups(32)
for Grp in Grps:
    cca = DetermineCCA(Grp, LIMIT_AUT_ORDER, PRINT_STRUCT, PRINT_GRP_GEN, DO_CCA, STOP_FIRST_NONCCA, PRINT_GPH, ALL_NONAFFINE_AUT, PRINT_CCA)
    if cca == 1:
        print gap.StructureDescription(Grp), " is CCA"
    else:
        print gap.StructureDescription(Grp), " is not CCA"