:- use_module(library('heavycarbon/strings/string_overwriting.pl')).

:- begin_tests(string_overwriting).

repeatedly_overwrite(range(StartPos,EndPos),io(StrIn,OverwriteStr,OverwritePos,StrOut)) :-
   nonvar(StartPos),nonvar(EndPos),nonvar(StrIn),nonvar(OverwriteStr),var(OverwritePos),var(StrOut),
   between(StartPos,EndPos,OverwritePos),
   string_overwriting(StrIn,OverwriteStr,OverwritePos,StrOut),
   debug(repeatedly_overwrite,"[~d,~q],",[OverwritePos,StrOut]).

test("Repeatedly overwrite empty string",[true(T)]) :-
   OverwriteStr = "[perspiciatis]",
   string_length(OverwriteStr,OverwriteLen),
   StartPos is -OverwriteLen,
   EndPos is 10,
   bagof([OverwritePos,StrOut],
         repeatedly_overwrite(range(StartPos,EndPos),io("",OverwriteStr,OverwritePos,StrOut)),
         Bag),
   T = (Bag ==
   [[-14,""],
    [-13,"]"],
    [-12,"s]"],
    [-11,"is]"],
    [-10,"tis]"],
    [ -9,"atis]"],
    [ -8,"iatis]"],
    [ -7,"ciatis]"],
    [ -6,"iciatis]"],
    [ -5,"piciatis]"],
    [ -4,"spiciatis]"],
    [ -3,"rspiciatis]"],
    [ -2,"erspiciatis]"],
    [ -1,"perspiciatis]"],
    [  0,"[perspiciatis]"],
    [  1," [perspiciatis]"],
    [  2,"  [perspiciatis]"],
    [  3,"   [perspiciatis]"],
    [  4,"    [perspiciatis]"],
    [  5,"     [perspiciatis]"],
    [  6,"      [perspiciatis]"],
    [  7,"       [perspiciatis]"],
    [  8,"        [perspiciatis]"],
    [  9,"         [perspiciatis]"],
    [ 10,"          [perspiciatis]"]]).


test("Repeatedly overwrite nonempty string",[true(T)]) :-
   StrIn = "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
   string_length(StrIn,StrInLen),
   OverwriteStr = "[perspiciatis]",
   string_length(OverwriteStr,OverwriteLen),
   StartPos is -OverwriteLen,
   EndPos is StrInLen+10,
   bagof([OverwritePos,StrOut],
         repeatedly_overwrite(range(StartPos,EndPos),io(StrIn,OverwriteStr,OverwritePos,StrOut)),
         Bag),
   T = (Bag ==
   [[-14,"Lorem ipsum dolor sit amet, consectetur adipiscing elit"],
    [-13,"]orem ipsum dolor sit amet, consectetur adipiscing elit"],
    [-12,"s]rem ipsum dolor sit amet, consectetur adipiscing elit"],
    [-11,"is]em ipsum dolor sit amet, consectetur adipiscing elit"],
    [-10,"tis]m ipsum dolor sit amet, consectetur adipiscing elit"],
    [ -9,"atis] ipsum dolor sit amet, consectetur adipiscing elit"],
    [ -8,"iatis]ipsum dolor sit amet, consectetur adipiscing elit"],
    [ -7,"ciatis]psum dolor sit amet, consectetur adipiscing elit"],
    [ -6,"iciatis]sum dolor sit amet, consectetur adipiscing elit"],
    [ -5,"piciatis]um dolor sit amet, consectetur adipiscing elit"],
    [ -4,"spiciatis]m dolor sit amet, consectetur adipiscing elit"],
    [ -3,"rspiciatis] dolor sit amet, consectetur adipiscing elit"],
    [ -2,"erspiciatis]dolor sit amet, consectetur adipiscing elit"],
    [ -1,"perspiciatis]olor sit amet, consectetur adipiscing elit"],
    [  0,"[perspiciatis]lor sit amet, consectetur adipiscing elit"],
    [  1,"L[perspiciatis]or sit amet, consectetur adipiscing elit"],
    [  2,"Lo[perspiciatis]r sit amet, consectetur adipiscing elit"],
    [  3,"Lor[perspiciatis] sit amet, consectetur adipiscing elit"],
    [  4,"Lore[perspiciatis]sit amet, consectetur adipiscing elit"],
    [  5,"Lorem[perspiciatis]it amet, consectetur adipiscing elit"],
    [  6,"Lorem [perspiciatis]t amet, consectetur adipiscing elit"],
    [  7,"Lorem i[perspiciatis] amet, consectetur adipiscing elit"],
    [  8,"Lorem ip[perspiciatis]amet, consectetur adipiscing elit"],
    [  9,"Lorem ips[perspiciatis]met, consectetur adipiscing elit"],
    [ 10,"Lorem ipsu[perspiciatis]et, consectetur adipiscing elit"],
    [ 11,"Lorem ipsum[perspiciatis]t, consectetur adipiscing elit"],
    [ 12,"Lorem ipsum [perspiciatis], consectetur adipiscing elit"],
    [ 13,"Lorem ipsum d[perspiciatis] consectetur adipiscing elit"],
    [ 14,"Lorem ipsum do[perspiciatis]consectetur adipiscing elit"],
    [ 15,"Lorem ipsum dol[perspiciatis]onsectetur adipiscing elit"],
    [ 16,"Lorem ipsum dolo[perspiciatis]nsectetur adipiscing elit"],
    [ 17,"Lorem ipsum dolor[perspiciatis]sectetur adipiscing elit"],
    [ 18,"Lorem ipsum dolor [perspiciatis]ectetur adipiscing elit"],
    [ 19,"Lorem ipsum dolor s[perspiciatis]ctetur adipiscing elit"],
    [ 20,"Lorem ipsum dolor si[perspiciatis]tetur adipiscing elit"],
    [ 21,"Lorem ipsum dolor sit[perspiciatis]etur adipiscing elit"],
    [ 22,"Lorem ipsum dolor sit [perspiciatis]tur adipiscing elit"],
    [ 23,"Lorem ipsum dolor sit a[perspiciatis]ur adipiscing elit"],
    [ 24,"Lorem ipsum dolor sit am[perspiciatis]r adipiscing elit"],
    [ 25,"Lorem ipsum dolor sit ame[perspiciatis] adipiscing elit"],
    [ 26,"Lorem ipsum dolor sit amet[perspiciatis]adipiscing elit"],
    [ 27,"Lorem ipsum dolor sit amet,[perspiciatis]dipiscing elit"],
    [ 28,"Lorem ipsum dolor sit amet, [perspiciatis]ipiscing elit"],
    [ 29,"Lorem ipsum dolor sit amet, c[perspiciatis]piscing elit"],
    [ 30,"Lorem ipsum dolor sit amet, co[perspiciatis]iscing elit"],
    [ 31,"Lorem ipsum dolor sit amet, con[perspiciatis]scing elit"],
    [ 32,"Lorem ipsum dolor sit amet, cons[perspiciatis]cing elit"],
    [ 33,"Lorem ipsum dolor sit amet, conse[perspiciatis]ing elit"],
    [ 34,"Lorem ipsum dolor sit amet, consec[perspiciatis]ng elit"],
    [ 35,"Lorem ipsum dolor sit amet, consect[perspiciatis]g elit"],
    [ 36,"Lorem ipsum dolor sit amet, consecte[perspiciatis] elit"],
    [ 37,"Lorem ipsum dolor sit amet, consectet[perspiciatis]elit"],
    [ 38,"Lorem ipsum dolor sit amet, consectetu[perspiciatis]lit"],
    [ 39,"Lorem ipsum dolor sit amet, consectetur[perspiciatis]it"],
    [ 40,"Lorem ipsum dolor sit amet, consectetur [perspiciatis]t"],
    [ 41,"Lorem ipsum dolor sit amet, consectetur a[perspiciatis]"],
    [ 42,"Lorem ipsum dolor sit amet, consectetur ad[perspiciatis]"],
    [ 43,"Lorem ipsum dolor sit amet, consectetur adi[perspiciatis]"],
    [ 44,"Lorem ipsum dolor sit amet, consectetur adip[perspiciatis]"],
    [ 45,"Lorem ipsum dolor sit amet, consectetur adipi[perspiciatis]"],
    [ 46,"Lorem ipsum dolor sit amet, consectetur adipis[perspiciatis]"],
    [ 47,"Lorem ipsum dolor sit amet, consectetur adipisc[perspiciatis]"],
    [ 48,"Lorem ipsum dolor sit amet, consectetur adipisci[perspiciatis]"],
    [ 49,"Lorem ipsum dolor sit amet, consectetur adipiscin[perspiciatis]"],
    [ 50,"Lorem ipsum dolor sit amet, consectetur adipiscing[perspiciatis]"],
    [ 51,"Lorem ipsum dolor sit amet, consectetur adipiscing [perspiciatis]"],
    [ 52,"Lorem ipsum dolor sit amet, consectetur adipiscing e[perspiciatis]"],
    [ 53,"Lorem ipsum dolor sit amet, consectetur adipiscing el[perspiciatis]"],
    [ 54,"Lorem ipsum dolor sit amet, consectetur adipiscing eli[perspiciatis]"],
    [ 55,"Lorem ipsum dolor sit amet, consectetur adipiscing elit[perspiciatis]"],
    [ 56,"Lorem ipsum dolor sit amet, consectetur adipiscing elit [perspiciatis]"],
    [ 57,"Lorem ipsum dolor sit amet, consectetur adipiscing elit  [perspiciatis]"],
    [ 58,"Lorem ipsum dolor sit amet, consectetur adipiscing elit   [perspiciatis]"],
    [ 59,"Lorem ipsum dolor sit amet, consectetur adipiscing elit    [perspiciatis]"],
    [ 60,"Lorem ipsum dolor sit amet, consectetur adipiscing elit     [perspiciatis]"],
    [ 61,"Lorem ipsum dolor sit amet, consectetur adipiscing elit      [perspiciatis]"],
    [ 62,"Lorem ipsum dolor sit amet, consectetur adipiscing elit       [perspiciatis]"],
    [ 63,"Lorem ipsum dolor sit amet, consectetur adipiscing elit        [perspiciatis]"],
    [ 64,"Lorem ipsum dolor sit amet, consectetur adipiscing elit         [perspiciatis]"],
    [ 65,"Lorem ipsum dolor sit amet, consectetur adipiscing elit          [perspiciatis]"]]).

:- end_tests(string_overwriting).

