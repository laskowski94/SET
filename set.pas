program proba;

const liczba_kart=81;							{Liczba kart w talii}
  maks_bez_set=21;							{Przy tej liczbie kart na stole musi lezec set}
  poczatek=12;								{Liczba kart, ktora wykladamy na stol na poczatku rozgrywki }
  dokladane_karty=3;							{Liczba kart ktora dokladamy po usunieciu seta}

type 									{typ okreslajacy wartosc danej karty}
  karty = record
    ilosc : (jeden,dwa,trzy);
    kolor : (czerwony,zielony,fioletowy);
    wypelnienie : (puste,pasiaste,pelne);
    ksztalt : (romb,fala,owal);
  end;

var talia : array [1..liczba_kart] of Byte;				{tablica w ktorej zapisujemy cala talie karty}
    stol : array [1..maks_bez_set] of Byte;				{tablica na ktorej zapisujemy karty lezace na stole}
    set1,set2,set3,wskaznik_stolu,wskaznik_talii : Byte;		{set1,set2,set3 to wskazniki ktore pokazuja na ktorych miejscach na stole lezy set}
    brakset:Boolean;							{wskaznik stolu wskazuje miejsce ostatniej karty na stole}
									{wskaznik talii wskazuje pierwsza karte w talii}
									{brakset przyjmuje wartosc true, gdy na stole nie lezy set}
procedure start;							{procedura ktora rozpoczyna gre}
var x,i : Byte;
begin
  wskaznik_talii:=1;
  wskaznik_stolu:=0;
  for i:=1 to liczba_kart do						{pobiera talie}
  begin
    read(x);
    talia[i]:=x;
  end;
  for i:=1 to maks_bez_set do stol[i]:=0;				{czyszci stol}
  while wskaznik_talii<=poczatek do					{wyklada pierwsze 12 kart na stol}
  begin
    stol[wskaznik_talii]:=talia[wskaznik_talii];
    inc(wskaznik_talii);						{wskazuje pierwsza karte w talii}
    inc(wskaznik_stolu);						{wskazuje miejsce ostatniej karty na stole}
  end;
end;

procedure stan_stolu;							{procedura wypisujaca aktualny stan stolu}
var i : Byte;
begin
  i:=1;
  write('=');
  while i<=wskaznik_stolu do
  begin
    write(' ',stol[i]);
    inc(i);
  end;
  writeln();
end;

procedure przypisanie(wartosc : Byte; var karta : karty);		{procedura ktora zamienia wartosc wyrazona liczbowa na slowny opis karty}
var x,y : Byte;
begin
  x:=(wartosc div 10);
  y:=(wartosc mod 10);
  case x of
    1,2,3 : karta.ilosc:=jeden;
    4,5,6 : karta.ilosc:=dwa;
    7,8,9 : karta.ilosc:=trzy;
  end;
  case x of
    1,4,7 : karta.kolor:=czerwony;
    2,5,8 : karta.kolor:=zielony;
    3,6,9 : karta.kolor:=fioletowy;
  end;
  case y of
    1,2,3 : karta.wypelnienie:=puste;
    4,5,6 : karta.wypelnienie:=pasiaste;
    7,8,9 : karta.wypelnienie:=pelne;
  end;
  case y of
    1,4,7 : karta.ksztalt:=romb;
    2,5,8 : karta.ksztalt:=fala;
    3,6,9 : karta.ksztalt:=owal;
  end;
end;

function porownaj(karta1,karta2,karta3 : karty) : Boolean;		{funkcja ktora przyjmuje wartosc true, gdy 3 porownywane karty daja set}
var dalej : Boolean;							{oraz wartosc false gdy karty nie daja set}
begin									{jesli 2 karty sa rowne/rozne to trzecia musi byc rowna/rozna od 2 pozostalych}
  dalej:=true;
  if (karta1.ilosc=karta2.ilosc) and (karta1.ilosc<>karta3.ilosc) then dalej:=false	{porownanie ilosci}
  else if (karta1.ilosc<>karta2.ilosc) and ((karta1.ilosc=karta3.ilosc) or (karta2.ilosc=karta3.ilosc)) then dalej:=false;
  if dalej then
  begin
    if (karta1.kolor=karta2.kolor) and (karta1.kolor<>karta3.kolor) then dalej:=false	{jesli ilosc sie zgadza, porownanie koloru}
    else if (karta1.kolor<>karta2.kolor) and ((karta1.kolor=karta3.kolor) or (karta2.kolor=karta3.kolor)) then dalej:=false;
  end;
  if dalej then
  begin
    if (karta1.wypelnienie=karta2.wypelnienie) and (karta1.wypelnienie<>karta3.wypelnienie) then dalej:=false	{porownanie wypelnienia}
    else if (karta1.wypelnienie<>karta2.wypelnienie) and ((karta1.wypelnienie=karta3.wypelnienie) or (karta2.wypelnienie=karta3.wypelnienie)) then dalej:=false;
  end;
  if dalej then
  begin
    if (karta1.ksztalt=karta2.ksztalt) and (karta1.ksztalt<>karta3.ksztalt) then dalej:=false	{porownanie ksztaltu}
    else if (karta1.ksztalt<>karta2.ksztalt) and ((karta1.ksztalt=karta3.ksztalt) or (karta2.ksztalt=karta3.ksztalt)) then dalej:=false;
  end;
  porownaj:=dalej;
end;
  
procedure znajdz_set;							{procedura znajdujaca najmniejszego seta na stole}
var   karta1,karta2,karta3 : karty;
  i,j,k : Byte;
  koniec : Boolean;
begin
  brakset:=false;
  i:=1;
  j:=2;
  k:=3;
  przypisanie(stol[i],karta1);						{najpierw przypisuje wartoscie pierwszym 3 kartom}
  przypisanie(stol[j],karta2);
  przypisanie(stol[k],karta3);
  koniec:=porownaj(karta1,karta2,karta3);				{potem je porownuje}
  while (not koniec) and (i<(wskaznik_stolu-2)) do			{jesli nie ma seta to szukam dalej}
  begin
    while (not koniec) and (j<(wskaznik_stolu-1)) do
    begin
      while (not koniec) and (k<wskaznik_stolu) do			{przeszukuje tablice trzema petlami}
      begin
	inc(k);
	przypisanie(stol[k],karta3);					{za kazdym razem gdy zwiekszam indeksy , przypisuje nowe wartosci}
	koniec:=porownaj(karta1,karta2,karta3);				{porownywanym kartom. Gdy znajde set zmienna logiczna koniec:=true i wychodzi z petli}
      end;
      if (not koniec) then
      begin
	inc(j);
	przypisanie(stol[j],karta2);
	k:=j+1;
	przypisanie(stol[k],karta3);
	koniec:=porownaj(karta1,karta2,karta3);
      end;
    end;
    if (not koniec) then
    begin
      inc(i);
      przypisanie(stol[i],karta1);
      j:=i+1;
      przypisanie(stol[j],karta2);
      k:=j+1;
      przypisanie(stol[k],karta3);
      koniec:=porownaj(karta1,karta2,karta3);
    end;
  end;
  set1:=i;								{zmienne i,j,k ustawione sa w miejscach gdzie leza karty tworzace seta}
  set2:=j;								{przypisuje ich wartosc zmiennym globalnym}
  set3:=k;
  if not koniec then brakset:=true;					{jesli nie znaleziono seta zmienna brakset przyjmuje wartosc true}
end;  

procedure wypisz_set;							{procedura wypisujaca set}
begin
  write('-');
  if not brakset then
  begin
    write(' ',stol[set1]);
    write(' ',stol[set2]);
    write(' ',stol[set3]);
  end;
  writeln();
end;
 
procedure usun_set;							{procedura usuwajaca seta ze stolu oraz ukladajaca karty na stole}
var i : Byte;
begin
  if not brakset then
  begin
    for i:=set1 to (set2-2) do stol[i]:=stol[i+1];			{petla przesuwa wszystkie karty pomiedzy set1 a set  2 o 1 miejsce}
    for i:=(set2-1) to (set3-3) do stol[i]:=stol[i+2];			{petla przesuwa karty pomiedzy set 2 a set 3 o 2 miejsca}
    for i:=(set3-2) to (wskaznik_stolu-3) do stol[i]:=stol[i+3];	{petla przesuwa karty pomiedzy set 3 a koncem stolu o 3 miejsca}
    wskaznik_stolu:=(wskaznik_stolu-3);					{zmiana konca stolu o 3 miejsca z powodu usuniecia seta}
  end;
end;
    
procedure doloz_karty;							{procedura pobierajaca 3 karty z talii i wykladajace je na stol}
var i : Byte;
begin
  for i:=1 to dokladane_karty do
  begin
    inc(wskaznik_stolu);
    stol[wskaznik_stolu]:=talia[wskaznik_talii];
    inc(wskaznik_talii);
  end;
end;

procedure gra;								{procedura grajaca}
begin
  while wskaznik_talii<liczba_kart do					{petla ktora dziala dopoki wszystkie karty z talii nie zostana wylozone}
  begin
    stan_stolu;
    znajdz_set;
    wypisz_set;
    usun_set;
    if (wskaznik_stolu<poczatek) or (brakset) then doloz_karty;
  end;									{w tym momencie nie ma zadnych kart w talii i lezy 12 kart na stole}
  repeat								
    stan_stolu;
    znajdz_set;
    if not (brakset) and (wskaznik_stolu>=1)  then
    begin
      wypisz_set;
      usun_set
    end
  until (brakset) or (wskaznik_stolu<1);				{gramy dopoki na stole nie bedzie seta lub skoncza sie karty na stole}
  if wskaznik_stolu<1 then stan_stolu;					{jesli na stole nie ma zadnych kart, wypisujemy ze stol jest pusty}
end;

begin
  start;								{program glowny}
  gra;
end.