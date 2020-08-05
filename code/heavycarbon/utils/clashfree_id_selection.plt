:- use_module(library('heavycarbon/utils/clashfree_id_selection.pl')).

:- begin_tests(clashfree_id_selection).

test("no id found because none left",error(too_many_attempts,context(_,_))) :-
   Dict0=_{},MaxId=1,
   clashfree_id_selection(Dict0,Id0,MaxId),
   put_dict(Id0,Dict0,x,Dict1),
   clashfree_id_selection(Dict1,Id1,MaxId),
   put_dict(Id1,Dict1,x,Dict2),
   clashfree_id_selection(Dict2,_,MaxId).

test("no id found because none left, again",error(too_many_attempts,context(_,_))) :-
   Dict0=_{},MaxId=1,
   insert_with_clashfree_id(Dict0,x,Dict1,_Id0,MaxId),
   insert_with_clashfree_id(Dict1,y,Dict2,_Id1,MaxId),
   insert_with_clashfree_id(Dict2,z,_,_,MaxId).

test("saturate the set of allowed ids [0,1] the hard way", true(Dict2 = _{0:x,1:x})) :-
   Dict0=_{},MaxId=1,
   clashfree_id_selection(Dict0,Id0,MaxId),
   put_dict(Id0,Dict0,x,Dict1),
   clashfree_id_selection(Dict1,Id1,MaxId),
   put_dict(Id1,Dict1,x,Dict2).

test("saturate the set of allowed ids [100,101] the hard way", true(Dict2 = _{100:x,101:x})) :-
   Dict0=_{},MinId=100,MaxId=101,
   clashfree_id_selection(Dict0,Id0,MinId,MaxId),
   put_dict(Id0,Dict0,x,Dict1),
   clashfree_id_selection(Dict1,Id1,MinId,MaxId),
   put_dict(Id1,Dict1,x,Dict2).

test("saturate the set of allowed ids [0,1]", true(Dict2 = _{0:x,1:x})) :-
   Dict0=_{},MaxId=1,
   insert_with_clashfree_id(Dict0,x,Dict1,_Id0,MaxId),
   insert_with_clashfree_id(Dict1,x,Dict2,_Id1,MaxId).

test("saturate the set of allowed ids [100,101]", true(Dict2 = _{100:x,101:x})) :-
   Dict0=_{},MinId=100,MaxId=101,
   insert_with_clashfree_id(Dict0,x,Dict1,_Id0,MinId,MaxId),
   insert_with_clashfree_id(Dict1,x,Dict2,_Id1,MinId,MaxId).

:- end_tests(clashfree_id_selection).
