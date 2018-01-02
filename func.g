#Returns a list which are the order of the elements of L.
ListOfOrders := function(L)
  local orders;
  orders := ShallowCopy(L);
  Apply(orders, Order);
  return orders;
end;;

#Checks to see if the current generators is already a list in MG via an
#automorphism. Returns true if the current generators should be added to the
#list and false otherwise.
UAA := function (MG, EAG, SA, CG, GenG)
  local i, T, a, g, r, S, perm, permS, CGOrders;
  if Length(MG) = 0 then
    return true;
  fi;

  if SA and Factorial(Length(CG)) > Length(EAG) then
    for a in EAG do
      T := [];
      for g in CG do
        Add(T, g^a);
      od;
      Sort(T);
      for i in [1..Length(MG)] do
        if MG[i] = T then
          return false;
        fi;
      od;
    od;
    return true;
  else
    r := Length(CG);
    CGOrders := ListOfOrders(CG);
    for perm in SymmetricGroup(r) do
      for S in MG do
        if Length(S) = r then
          permS := Permuted(S, perm);
          if ListOfOrders(permS) = CGOrders then
            if (GroupHomomorphismByImages( GenG, GenG, permS, CG ) <> fail) then
              return false;
            fi;
          fi;
        fi;
      od;
    od;
    return true;
  fi;
end;;

#This is the recursive function that tries all reasonable subsets of E to find
#which ones generate all of G.
#E: elements of the group you want to consider.
#MG: the place to store the minimal generating sets.
#CG: the current generators that we are testing.
#EAG: the elements of the automorphism group of G.
#pos: the current position of E that we are considering.
#ord: the order of G.
recurs := function (E, MG, CG, EAG, SA, pos, ord)
  local GenG, L, i, B, G1, G2, l;
  
  #The group that we get from the current generators
  if Length(CG) = 0 then
    GenG := Group(E[1]);
  else
    GenG := Group(CG);
  fi;

  #if the Order of GenG = ord then we have a minimal generating set. UAA checks
  #to see if it is already in the list (via an automorphism of the group). If
  #not in the list, we add it to the list.
  if Order(GenG) = ord then
    if UAA(MG, EAG, SA, CG, GenG) then
      Add(MG, SortedList(CG));
    fi;
  else
    if pos < Length(E) + 1 then
      #If E[pos] is not already in GenG, then adding it would make GenG larger.
      #Before considering it, we test to see if it makes any other element in
      #CG useless, if it does not we recursively try with E[pos] in CG.
      if not E[pos] in GenG then
        B := true;
        L := [];
        for i in [1..Length(CG)] do
          Add(L, CG[i]);
        od;
        Add(L, E[pos]);
        G1 := Group(L);
        for i in [1..Length(L)-1] do
          if B then
            l := Remove(L,i);
            G2 := Group(L);
            Add(L,l,i);
          fi;
          if G1 = G2 then
            B := false;
            break;
          fi;
        od;
        if B then
          Add(CG, E[pos]);
          recurs(E, MG, CG, EAG, SA, pos+1, ord);
          Remove(CG);
        fi;
      fi;
      #Recursively try without using E[pos]
      recurs(E, MG, CG, EAG, SA, pos+1, ord);
    fi;
  fi;
end;;

refill:= function(pos, L, mg, MG2, EAG, SA)
  local i, mg2, g;
  mg2 := [];
  if pos > Length(mg) then
    for i in [1..Length(mg)] do
      Add(mg2, mg[i]^L[i]);
    od;
    if UAA(MG2, EAG, SA, mg2, Group(mg2)) then
      Sort(mg2);
      Add(MG2, ShallowCopy(mg2));
    fi;
  else
    for i in [1..Order(mg[pos])] do
      if GcdInt(i, Order(mg[pos])) = 1 then
        L[pos] := i;
        refill(pos+1, L, mg, MG2, EAG, SA);
      fi;
    od;
  fi;
end;;

#AMGS standing for All minimum Generating Sets.
#This function takes in two parameters, a group (G) and its elements (E)
#It first filters out elements that form similar subgroups (i.e each subgroup
#has a single representative) and then runs the recursive function which
#finds all subsets that generate G (with the representative elements).
#Afterwards it expands all the representatives to get all minimum generating
#sets and returns that list.
AMGS := function ( G, LIMIT_AUT_ORDER )
  local mg, MG, MG2, CG, pos, AG, EA, E2, i, j, G1, G2, B, L, g, E,SA;
  E := Enumerator(G);
  MG := [];
  MG2 := [];
  CG := [];
  E2 := [E[1]];
  for i in [2..Length(E)] do
    B := true;
    G1 := Group(E[i]);
    for j in [2..Length(E2)] do
      G2 := Group(E2[j]);
      if G1 = G2 then
        B := false;
        break;
      fi;
    od;
    if B then
      Add(E2, E[i]);
    fi;
  od;
  pos := 2;

  AG := AutomorphismGroup(G);
  if Order(AG) > LIMIT_AUT_ORDER then
    SA := false;
  else
    SA := true;
  fi;

  if SA then
    
    EA := Enumerator(AG);
  else
    EA := [];
  fi;
  recurs(E2, MG, CG, EA, SA, pos, Order(G));
  for mg in MG do
    L := [];
    pos := 1;
    for g in mg do
      Add(L, 0);
    od;
    refill(pos, L, mg, MG2, EA, SA);
  od;
  return MG2;
end;;

ISABE := function (G)
  local i, j, B, E;
  E := Enumerator(G);
  B := true;
  for i in [1..Length(E)] do
    for j in [1..Length(E)] do
      if not (E[i]*E[j] = E[j]*E[i]) then
        B := false;
      fi;
    od;
  od;
  return B;
end;;

ISGENDIH := function (G)
  local M, i, j, G1, G2, B, E, E2, e, e2;
  E := Enumerator(G);
  G1 := MaximalSubgroups(G);
  for G2 in G1 do
    if Order(G) = Order(G2)*2 then
      E2 := Enumerator(G2);
      B := ISABE(G2);
      if B = true then
        for e in E do
          if not (e in G2) then
            B := true;
            for e2 in E2 do
              if not (e*e2*e*e2 = E[1]) then
                B := false;
              fi;
            od;
            if B = true then
              #Print(StructureDescription(G2), "\n");
              return true;
            fi;
          fi;
        od;
      fi;
    fi;
  od;
  return false;

end;;

ISGENDIC := function (G)
  local G1, G2, B, E, E2, e, e2;
  E := Enumerator(G);
  G1 := MaximalSubgroups(G);
  for G2 in G1 do
    if Order(G) = Order(G2)*2 then
      E2 := Enumerator(G2);
      B := ISABE(G2);
      if B = true then
        for e in E do
          if not (e in G2) then
            if Order(e) = 4 then
              if e*e in G2 then
                for e2 in E2 do
                  if not (e*e*e*e2*e*e2 = E[1]) then
                    B := false;
                  fi;
                od;
                if B = true then
                  return true;
                fi;
              fi;
            fi;
          fi;
        od;
      fi;
    fi;
  od;
  return false;
end;;

Structure := function(G)
  local G1, E, e, c, C, C2, MG, tau, T1, T2, B, l, l2, Center;
  E := Enumerator(G);
  MG := AMGS(G, 1000000);
  for C in MG do
    for tau in E do
      if Order(tau) = 2 then
        B := true;
        for c in C do
          if not (tau*c*tau = c or tau*c*tau*c = E[1]) then
            B := false;
            break;
          fi;
        od;
        if B = true then
          Center := true;
          for e in E do
            if not (tau*e = e*tau) then
              Center := false;
              break;
            fi;
          od;
          T1 := [];
          for c in C do
            if c*c = tau then
              Add(T1,c);
            fi;
          od;
          for T2 in Combinations(T1) do
            C2 := [];
            for c in C do
              if not (c in T2) then
                Add(C2, c);
              fi;
            od;
            Add(C2, tau);
            G1 := Group(C2);
            if not (G1 = G) then
              if Order(G1)*2 < Order(G) or not Center then
                return true;
              fi;
            fi;
          od;
        fi;
      fi;
    od;
  od;
  return false;
end;;
