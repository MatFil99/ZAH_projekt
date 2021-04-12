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
{string} Przedsiebiorstwa =...;

// parametry
float koszt[Przedsiebiorstwa] =...; // koszt umowy
float zysk[Przedsiebiorstwa] =...; // szacunkowy zysk przedsiebiorstwa
float kara[Przedsiebiorstwa] =...; // szacunkowa strata zysku w wyniku wyboru sasiednich przedsiebiorstw
int czySasiad[Przedsiebiorstwa][Przedsiebiorstwa] =...; // macierz sasiedztwa
float budzet = ...;

// zmienne decyzyjne
dvar boolean w[Przedsiebiorstwa]; // wybrane przedsiebiorstwa (0 - nie; 1 - tak)
dvar float bilans[Przedsiebiorstwa];

// funkcja celu
maximize
  sum( p in Przedsiebiorstwa )
    (( zysk[p] - koszt[p] ) * w[p] )
  - sum( p1 in Przedsiebiorstwa )
  	   (sum( p2 in Przedsiebiorstwa )
  	     (czySasiad[p1][p2]*w[p1]*w[p2]*kara[p1]*zysk[p1]));

// ograniczenia
subject to{
  ogrBudzetu: 
      budzet>=sum(p in Przedsiebiorstwa)w[p]*koszt[p];
  
}
