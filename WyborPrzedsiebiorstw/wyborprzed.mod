// --------------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// 5725-A06 5725-A29 5724-Y48 5724-Y49 5724-Y54 5724-Y55
// Copyright IBM Corporation 1998, 2020. All Rights Reserved.
//
// Note to U.S. Government Users Restricted Rights:
// Use, duplication or disclosure restricted by GSA ADP Schedule
// Contract with IBM Corp.
// --------------------------------------------------------------------------

// zbiory
{string} PunktyOdbioru =...;

// parametry
float koszt[PunktyOdbioru] =...; // koszt umowy
float przychod =...; // szacunkowy przychod za klienta (jednakowy dla punktow odbioru)
int liczbaKlientow[PunktyOdbioru] =...; //
int wspolniKlienci[PunktyOdbioru][PunktyOdbioru] =...; // macierz sasiedztwa (liczba wsp. klientow)
float budzet = ...;

// zmienne decyzyjne
dvar boolean x[PunktyOdbioru]; // wybrane punkty odbioru (0 - nie; 1 - tak)
dvar boolean w[PunktyOdbioru][PunktyOdbioru]; // czy punkty odbioru p1, p2 zostaly wybrane

// funkcja celu
maximize
  sum( p in PunktyOdbioru )
    (( przychod*liczbaKlientow[p] - koszt[p] ) * x[p] )
  - sum( p1 in PunktyOdbioru, p2 in PunktyOdbioru )
  	     (1/2*wspolniKlienci[p1][p2]*przychod*w[p1][p2]);

// ograniczenia
subject to{
  
  ogrBudzetu: 
      budzet>=sum(p in PunktyOdbioru)x[p]*koszt[p];

// 3 ograniczenia przypisujace zmiennej pomocniczej w wartosci iloczynu logicznego
// w[p1][p2]=x[p1]*x[p2]
  forall( p1 in PunktyOdbioru, p2 in PunktyOdbioru)
  ogrWybraniSasiedziCz1:
    x[p1]+x[p2]<=w[p1][p2]+1;
    
  forall( p1 in PunktyOdbioru, p2 in PunktyOdbioru)
    ogrWybraniSasiedziCz2:
	w[p1][p2]<=x[p1];
  
  forall( p1 in PunktyOdbioru, p2 in PunktyOdbioru)
    ogrWybraniSasiedziCz3:
	w[p1][p2]<=x[p2];	
// 
    
}
