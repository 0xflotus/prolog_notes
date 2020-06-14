# About SWI-Prolog datatypes

- This page is linked from SWI-Prolog comment section of ["Verify Type of a Term"](https://eu.swi-prolog.org/pldoc/man?section=typetest).
- The SWI-Prolog wiki has more on data types here: [SWI-Prolog datatypes](https://eu.swi-prolog.org/datatypes.txt).
- See also [data type](https://en.wikipedia.org/wiki/Data_type) at Wikipedia

## SWI Prolog data type tree

An image depicting the built-in "datatypes" one may encounter in SWI Prolog. They are 
similar to the types of other Prolog. As there is no way to define new datatypes from these
base datatypes ([algebraically](https://en.wikipedia.org/wiki/Algebraic_data_type) or
otherwise), these are the only one there are.

- [SVG file](swipl_datatype_tree/swipl_datatype_tree.svg). **The diagram in SVG format**.
  Can be visualized in a browser and easily panned & zoomed. 
- [PNG file](swipl_datatype_tree/swipl_datatype_tree.png). **The diagram in PNG format**, a bit
  awkward to use.
- [graphml file](swipl_datatype_tree/swipl_datatype_tree.graphml). **The editable diagram**
  in [graphml](http://graphml.graphdrawing.org/) format.
  Edited with the free (but not open) Java-based [yEd](https://www.yworks.com/products/yed) editor
  (Note that you have to switch off antialiasing if you use it, otherwise it feels like driving
   an ocean liner).
- [Pure text version](swipl_datatype_tree/swipl_datatype_tree.txt). Evidently not as complete. Also shown below.

The diagram may change in the future. For example, the _dict_ datatype may move out from under the _compound_ datatype. 
We will see what happens.

```text
                                                                          any T 
                                                                            |
                                                  +-------------------------+------------------------+
                                                  |                                                  |
                                                var(T)                                            nonvar(T)
                                         ("is T a variable name                                      |
                                          that is still fresh                                        |
                                     variable at this point in time?")                               |
                                                                         +---------------------------+-----------------------------+
                                                                         |                                                         |      
                                                                     atomic(T)                                                 compound(T)                                
                                                                         |                                                         |
                                      +----------------------------------+------------------------+                 +--------------+-------------+
                                      |                                  |                        |                 |                            |
                                  blob(T,_)                           string(T)                number(T)       "compound term            "compound term
                                      |                                                           |             of arity 0"                of arity > 0"
                                      |                                                           |                                              |
              +-----------------------+-----------------------+                         +---------+---------+                   +----------------+-------------+
              |                       |                       |                         |                   |                   |                |             |            
       (other blob types)    blob(T,reserved_symbol)     blob(T,text)           rational(T,Nu,De)        float(T)              dict          "head of       ...others  
      encapsulated foreign            |                    atom(T)                      |                                       |            of a list"
           resources                  |                       |                         |                                (this seems to     '[|]'(H,Rs)
                                      |                       |                         |                              be an encapsulated      [H|Rs]
                             +--------+--------+              |              +----------+----------+                     data structure)         |
                             |                 |              |              |                     |                                       (a nonlocal
                           T==[]             T\==[]           |   rational(X),\+integer(X)      integer(T)                               structure; there 
                        empty list        dict functor        |      (proper rational)                                                    may or may not
                                                              |                                                                            be an actual
                                                              |                                                                        list beyond the head)
                                           +------------------+------------------+
                                           |                  |                  |
                                      lenghth=0           length=1            atom with
                                   "the empty atom"      "character"          length>1
```

Note the representation for sequences of characters:

- SWI-Prolog _string_, a dedicated datatype (for example: `"Hello"`). Note that you can actually configure how the SWI-Prolog reader
  interpretes what is in between `"` double quotes. See the flag `double_quotes` (which can be any of `codes`, `chars`, `atom`, `string`) 
  in the manual page for [current_prolog_flag_2](https://www.swi-prolog.org/pldoc/doc_for?object=current_prolog_flag/2). For a lot
  of information about the SWI-Prolog _string_, see [The string type and its double quoted syntax](https://www.swi-prolog.org/pldoc/man?section=strings).
- The _atom_, the classical Prolog datatype for sequences of characters: `'XYZ'` or `hello`. (Not to be confused with the _atom_ or 
  of [_atomic formula_](https://en.wikipedia.org/wiki/Atomic_formula) of First-Order Logic, which is a predicate applied to some terms: _p(x,y,f(z))_.
- A _list of characters_, where Prolog "characters" are understood to be atoms of length 1: `[h, e, l, l, o]`. See 
  [`atom_chars/2`](https://www.swi-prolog.org/pldoc/doc_for?object=atom_chars/2), which relates an atom or a string to a list of characters.
- A _list of code points (codes, character codes)_. The code points are integers. In SWI-Prolog, they are 2-byte Unicode code points of the
  corresponding characters: `[104, 101, 108, 108, 111]`. See [`atom_codes/2`](https://www.swi-prolog.org/pldoc/doc_for?object=atom_codes/2), 
  which relates an atom or a string to a list of code points. This is the representation that 
  [a DCG expects](https://www.swi-prolog.org/pldoc/doc_for?object=phrase/3), but you can give it double-quoted text or a back-quoted text instead. 

## Code implementing the type tree decision sequence when going from root to leaf 

[This](code/tagging.pl) is Prolog code which follows the datatype tree above to "tag" the elements of a term.

Contains Unit Test code to be run with `rt(_).`.

Examples (all run with `once/1` to close the open choicepoint):

```logtalk
?- once(tag(X,S)).
S = var(X).

?- once(tag(100,S)).
S = int(100).

?- once(tag(100.1,S)).
S = float(100.1).

?- once(tag(1/3,S)).
S = compound(/, [gnd], [int(1), int(3)]).

?- once(tag(d{x:1,y:1,z:Z},S)).
S = dict(d, [nongnd], [atom(x)-int(1), atom(y)-int(1), atom(z)-var(Z)]).

?- once(tag([1,X,2],S)).
S = lbox([list, nongnd], int(1), lbox([list, nongnd], var(X), lbox([list, gnd], int(2), emptylist))).

?- once(tag(p(X,[1,2]),S)).
S = compound(p, [nongnd], [var(X), lbox([list, gnd], int(1), lbox([list, gnd], int(2), emptylist))]).
```

## Notes

- There is a question on Stack Overflow about this: [What are the data types in Prolog?](https://stackoverflow.com/questions/12038009/what-are-the-data-types-in-prolog)
   - Where a reference is given to [Richard A. O'Keefe's draft Prolog Standard](http://www.complang.tuwien.ac.at/ulrich/iso-prolog/okeefe.txt) (1984), a document which contains a type tree.
- [Logtalk](https://logtalk.org/) has actual datatypes and OO-style message handlers. This is achieved by setting up Prolog Modules around terms, which have the characteristics of objects (Prolog need a proper hierarchical Module system)
- Type tests seems to be non-logical but they are if one considers them to have a hidden additional argument: A term representing the "current computational state" of the system. That view probably doesn't help much.

## Reading

- For a description of datatypes, see this SWI-Prolog wiki entry:
  [SWI-Prolog datatypes](https://eu.swi-prolog.org/datatypes.txt)

- For the type-testing predicates see this SWI-Prolog manual page:
  [Verify Type of a Term](https://eu.swi-prolog.org/pldoc/man?section=typetest)

## Compound terms of arity 0 vs atoms in predicate roles vs. in function roles

In predicate role, atoms and compound terms of arity 0 are the same:

```
a   :- write(a1),nl.
a() :- write(a2),nl.

?- a.
a1
true ;
a2
true.
```

```
b :- c,c().
c :- write(c),nl.

?- b.
c
c
true.
```

In arithmetic function role, likewise. They denote constant functions:

```
?- X is pi.
X = 3.141592653589793.

?- X is pi().
X = 3.141592653589793.
```

But these are not the same syntactic structures:

```
?- pi == pi().
false.

?- pi = pi().
false.
```

See the notes on [Compound terms with zero arguments](https://eu.swi-prolog.org/pldoc/man?section=ext-compound-zero)

## Predicates for Analyzing/Constructing a Term

[See this page](term_analysis_construction/)

## On Type testing

See this '92 paper collection: https://mitpress.mit.edu/books/types-logic-programming

[Covington et al.](https://arxiv.org/abs/0911.2899) says on page 30:

> Develop your own ad hoc run-time type and mode checking system. Many problems during development (especially if the program is large and/or there are several developers involved) are caused by passing incorrect arguments. Even if the documentation is there to explain, for each predicate, which arguments are expected on entry and on successful exit, they can be, and all too often they are, overlooked or ignored. Moreover, when a “wrong” argument is passed, erratic behavior can manifest itself far from where the mistake was made (and of course, following Murphy’s laws, at the most inconvenient time).
>
> In order to significantly mitigate such problems, do take the time to write your own predicates for checking the legality of arguments on entry to and on exit from your procedures. In the production version, the goals you added for these checks can be compiled away using goal_expansion/2.

The above is fun, but is not a scalable approach. What does exist? (How is it done in Logtalk? How in Lambda Prolog?)

### plspec

There is `plspec`, a "spec" approach inspired by the "spec" approach of Clojure (Clojure being a Scheme for the JVM that
has no type checking; although there is "Typed Clojure" it does not seem to be liked or used. Clojure specs provides the possibility to add annotations to perform runtime checks on precondition, postconditions and invariants). 

- Paper: [plspec – A Specification Languagefor Prolog Data](https://www3.hhu.de/stups/downloads/pdf/plspec.pdf)
- https://github.com/wysiib/plspec

### Typed Prolog

Among others...

- Paper: [Towards Typed Prolog](https://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.456.7365) _Tom Schrijvers, Vitor Santos Costa, Jan Wielemaker, and Bart Demoen_ (2008)
- https://eu.swi-prolog.org/pack/list?p=type_check (This probably is the corresponding pack, but it is dead) 

### Simple checks at runtime

Comparing various type-testing approaches with a bit of [Unit Test Code](../code/unit_tests_for_must_be.pl)

  - Default approach which fails silently if the answer is "don't know" (the on implemented currently in most Prologs)
  - "Sufficiently instantiated" approach which throws if the answer is "don't know"
  - [`must_be/2`](https://eu.swi-prolog.org/pldoc/doc_for?object=must_be/2) approach which throws unless the answer is "yes, the type matches"
  - `can_be/2` approach which throws only if the answer is "it's never going to be that type"
  