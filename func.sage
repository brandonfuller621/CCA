def DetermineCCA(Grp, LIMIT_AUT_ORDER, PRINT_STRUCT, PRINT_GRP_GEN, DO_CCA, STOP_FIRST_NONCCA, PRINT_GPH, ALL_NONAFFINE_AUT, PRINT_CCA):
    #Print the structure of the group.
    if PRINT_STRUCT:
        print gap.StructureDescription(Grp)

    AutGrp = gap.AutomorphismGroup(Grp)

    #Run All Minimum Generating Sets Algorithm and store results in MinGenSet.
    MinGenSet = gap.AMGS(Grp, LIMIT_AUT_ORDER)

    #Print the Generators if desired
    if PRINT_GRP_GEN:
        print MinGenSet

    #Determine if group is CCA or not if desired.
    if DO_CCA:
        nonCCA = False
	for GenSet in MinGenSet:
	    if STOP_FIRST_NONCCA and nonCCA:
	        break

	    #Create Cayley graph with natural edge colours
            CayGph = Graph()
	    GrpElmts = gap.Enumerator(Grp)
	    CayGph.add_vertices(GrpElmts)
	    for i in range(1, gap.Length(GenSet)+1):
	        for g in GrpElmts:
		    CayGph.add_edge(g, g*GenSet[i], str(i))

            #Sage function to get colour preserving automorphisms of graph
            CayGphAutGrp = CayGph.automorphism_group(edge_labels = True)

	    if PRINT_GPH:
	        print "================================="
		print "Connection Set: ", GenSet

	    if gap(CayGphAutGrp.order()) == gap.Order(Grp):
	        if PRINT_GPH:
		    print "This Cayley Graph is CCA."
		    print "================================="
		continue

	    B1 = True
            if gap.Order(Grp) <= gap.Order(AutGrp):
	        #Determine whether an automorphism is not affine by checking
		#if l(gh) = l(g)l(h) for all g,h in the group and all l
		#with l(e) = e [e being the identity of the group]
	        for l in CayGphAutGrp:
		    if l(GrpElmts[1]) == GrpElmts[1]:
		        for g1 in GrpElmts:
			    for g2 in GrpElmts:
			        if l(g1*g2) != l(g1)*l(g2):
				    B1 = False
				    if PRINT_GPH:
				        print "Non-affine Automorphism: ", l
				    break
                            if B1 == False:
			        break
                    if B1 == False and not ALL_NONAFFINE_AUT:
		        break
            else:
	        #Determine whether an automorphism is not affine by checking
		#if l acts like an elements of the automorphism group with all
		#l(e) = e [e being the identity of the group]
	        AutGrpElmts = gap.Enumerator(AutGrp)
		for l in CayGphAutGrp:
		    if l(GrpElmts[1]) == GrpElmts[1]:
		        B2 = False
			for a in AutGrpElmts:
			    B3 = True
			    for e in GrpElmts:
			        if e^a != l(e):
				    B3 = False
				    break
		            if B3 == True:
			        B2 = True
				break
		        if B2 == False:
			    B1 = False
			    if PRINT_GPH:
			        print "Non-affine Automorphism: ", l
				if not ALL_NONAFFINE_AUT:
				    break
            if B1:
	        if PRINT_GPH:
	            print "This Cayley Graph is CCA."
		    print "================================="
            else:
	        if PRINT_GPH:
		    print "This Cayley Graph is Not CCA."
		    print "================================="
		nonCCA = True
	if nonCCA:
	    if PRINT_CCA:
	        print "This Group is Not CCA."
	    return 0
	else:
	    if PRINT_CCA:
	        print "This Group is CCA."
	    return 1
    return -1
