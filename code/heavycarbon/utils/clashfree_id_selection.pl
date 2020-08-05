:- module(heavycarbon_clashfree_id_selection, 
          [
              clashfree_id_selection/3    % clashfree_id_selection(Dict,Id,MaxId)
             ,insert_with_clashfree_id/5  % insert_with_clashfree_id(DictIn,Value,DictOut,Id,MaxId)
          ]).

% ============================================================================
% Generate a new integer Id that doesn't exist as key in the passed Dict yet.
% This will mostly succeed on first try!
% ----------------------------------------------------------------------------
%
% Switch on debugging output:
%
% ?- 
%   debug(clashfree).
%
% Example usage on the command line:
%
% ?- 
%   Dict0=_{},MaxId=200,
%   clashfree_id_selection(Dict0,Id1,MaxId),   % get a random id from [0..MaxKey] not yet in "DictIn"
%   put_dict(Id1,Dict0,x,Dict1),               % store Id in DictIn, giving "DictOut"
%   clashfree_id_selection(Dict1,Id2,MaxId).   % get another random Id not yet in "DictOut"
%
% or simpler
%
% ?- 
%   Dict0=_{},MaxId=200,
%   insert_with_clashfree_id(Dict0,x,Dict1,Id1,MaxId),
%   insert_with_clashfree_id(Dict1,y,Dict2,Id2,MaxId).
%
% ============================================================================

clashfree_id_selection(Dict,Id,MaxId) :-
   assertion((nonvar(MaxId),integer(MaxId),MaxId>0)),
   assertion(is_dict(Dict)),
   assertion(var(Id)),
   endlessly_propose_id(Id,MaxId,0),
   print_clash_on_redo(Id),
   \+ get_dict(Id,Dict,_),
   !, % make deterministic
   debug(clashfree,"FOUND ~q",[Id]).

insert_with_clashfree_id(DictIn,Value,DictOut,Id,MaxId) :-
   assertion(var(DictOut)),
   clashfree_id_selection(DictIn,Id,MaxId),
   put_dict(Id,DictIn,Value,DictOut).

endlessly_propose_id(Id,MaxId,_) :- 
   random_between(0,MaxId,Id).

endlessly_propose_id(Id,MaxId,Attempts) :- 
   succ(Attempts,AttemptsPlus),
   % throw non-ISO exception if too many attempts reached
   ((AttemptsPlus < 100) -> true ; throw_too_many_attempts(MaxId,AttemptsPlus)),
   endlessly_propose_id(Id,MaxId,AttemptsPlus).

% ---
% Print only when being traversed on redo
% ---

print_clash_on_redo(_)  :- true.
print_clash_on_redo(Id) :- debug(clashfree,"CLASH for ~q",[Id]),fail.

% ---
% Throw non-ISO exception if too many attempts reached 
% (there is no good ISO exception for this)
% ---

throw_too_many_attempts(MaxId,Attempts) :-
   with_output_to(string(Txt),format("Out of Ids? Too many attempts with MaxId = ~q, Attempts = ~q",[MaxId,Attempts])),
   throw(error(too_many_attempts,context(_Trace,Txt))).

