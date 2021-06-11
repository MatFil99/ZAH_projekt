/*********************************************
 * OPL 20.1.0.0 Model
 * Author: student
 * Creation Date: 10 cze 2021 at 11:50:38
 *********************************************/

{int} P =...; // punkty odbioru
 
tuple ParaSasiadow{ // 2 punkty, ktore ze soba sasiaduja
  int p1;
  int p2;
}
 
tuple TrojkaSasiadow{ // 3 punkty, ktore sasiaduja ze soba
  int p1;
  int p2;
  int p3;
}
 
tuple CzworkaSasiadow{ // 4 punkty, ktore ze soba sasiaduja
  int p1;
  int p2;
  int p3;
  int p4;
}
 
{ParaSasiadow} ParyP =...; // zbior sasiadujacych par punktow odbioru
{TrojkaSasiadow} TrojkiP =...; // zbior sasiadujacych trojek punktow odbioru
{CzworkaSasiadow} CzworkiP =...; // zbior sasiadujacych czworek punktow odbioru

// Parametry
int c[P] =...; // szacowana liczba klientow w punkcie p (mozliwi do obsluzenia jedynie przez p)
int cp[ParyP] =...; // szacowana liczba klientow do obsluzenia, ktorzy moga byc obsluzeni jedynie w jednym z punktow odbioru tej pary
int ct[TrojkiP] =...; // szacowana liczba klientow w trojce punktow odbioru
int cc[CzworkiP] =...; // szacowana liczba klientow w czworce punktow odbioru

int k[P] =...; // koszt otwarcia punktu odbioru
int w =...; // przychod za obsluzonego klienta
float b =...; // dostepny budzet

// Zmienne decyzyjne
dvar boolean x[P];
dvar boolean yp[ParyP];
dvar boolean yt[TrojkiP];
dvar boolean yc[CzworkiP];

// Dodatkowe wyjscia modelu
dvar float+ zysk;
dvar float+ pozBud;

// funkcja celu
maximize
  sum(p in P) (w*c[p]-k[p])*x[p] + 
  sum(s in ParyP) w*cp[s]*yp[s] + 
  sum(s in TrojkiP) w*ct[s]*yt[s] +
  sum(s in CzworkiP) w*cc[s]*yc[s];
  
subject to{
 // 1
 ogrBudzet:
 	sum(p in P)k[p]*x[p]<=b;
 
 // 2
 ogrSasiedziPary:
 	forall(s in ParyP)
 	  yp[s]<=x[s.p1]+x[s.p2];
 	  
 ogrSasiedziTrojki:
 	forall(s in TrojkiP)
 	  yt[s]<=x[s.p1]+x[s.p2]+x[s.p3];
 	  
 ogrSasiedziCzworki:
 	forall(s in CzworkiP)
 	  yc[s]<=x[s.p1]+x[s.p2]+x[s.p3]+x[s.p4];
 	  
 	  
// dodatkowe wyjscia modelu
//  ogrZysk:
//  zysk ==   
//	  sum(p in P) (w*c[p]-k[p])*x[p] + 
//	  sum(s in ParyP) w*cp[s]*yp[s] + 
//	  sum(s in TrojkiP) w*ct[s]*yt[s] +
//	  sum(s in CzworkiP) w*cc[s]*yc[s];
//	  
//  ogrPozBud:
//  pozBud == b - sum(p in P)k[p]*x[p];
}