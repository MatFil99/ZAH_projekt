/*********************************************
 * OPL 20.1.0.0 Model
 * Author: walde
 * Creation Date: 18 maj 2021 at 18:15:18
 *********************************************/
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
{string} Miasta =...;
{int} Miesiace = ...;
{int} TMiesiace = Miesiace diff {1};

int miasta_len = card(Miasta);
int miesiace_len = card(Miesiace);

// parametry
float l[Miasta][Miesiace] =...; // maksymalna liczba klientow w danym miescie i miesiacu
float k[Miasta][Miesiace] =...; // sredni koszt jaki nalezy przeznaczyc, by obsluzyc jednego klienta
								// w danym miescie i miesiacu
float o[Miasta][Miesiace] =...; // minimalny procent szacunkowego obs³u¿enia klientów
float w[Miasta][Miesiace] =...; // Maksymalna ró¿nica wzglêdnego szacunkowego obs³u¿enia klientów w miescie i miesiacu od sredniego obsluzenia w calym roku

float p =...; // szacunkowy przychod za klienta (jednakowy w kazdym miescie i miesiacu)
//float w =...; // 
float b0 =...; // calkowity budzet
float c =...; // procent zwracanego budzetu



// zmienne decyzyjne
dvar int+ x[Miasta][Miesiace];  // szacunkowa liczba klientow, ktora chcemy obsluzyc w danym miescie i miesiacu
dvar float+ s;			        // œredni szacunkowy stosunek liczby obs³ugiwanych klientów
dvar float+ b[Miesiace];		// budzet jakim dysponujemy w miesiacu m
//dvar float+ pozBud;				// zmienna kontrolna wyœwietlaj¹ca pozosta³y bud¿et
//dvar float+ lokBud[Miasta][Miesiace];  // zmienna kontrolna wyœwietlaj¹ca rozlokowany bud¿et
dvar float+ wzglObs[Miasta][Miesiace];

// funkcja celu
maximize
  sum( t in Miesiace )
    sum( m in Miasta )
      (x[m][t]*(p-k[m][t]));

// ograniczenia
subject to{
 
//1  
  ogrBudzetu: 
    forall( t in Miesiace )
	   sum( m in Miasta )
		  x[m][t]*k[m][t] <= b[t];


//2
  ogrMinKlient:
  forall( t in Miesiace )
	forall( m in Miasta )
  	    x[m][t] / l[m][t] >= o[m][t];
  	    	
  	
//3  
  forall( t in Miesiace )
	forall( m in Miasta )
	  ogrMaksLiczKlient:
  	    x[m][t] <= l[m][t];
  	  
          
//4 
  ogrSredniaObs:
  	sum( t in Miesiace )
      sum( m in Miasta )
        x[m][t] / (l[m][t] * miasta_len * miesiace_len) == s;
        
  // nie chcemy zniknac z rynku w zadnym miescie
//5.1
    forall( t in Miesiace )
      forall( m in Miasta )
        ogrRownObsl1:
          x[m][t]/l[m][t] - s <= w[m][t];
          
//5.2
     forall( t in Miesiace )
      forall( m in Miasta )
        ogrRownObsl2:
          x[m][t]/l[m][t] - s >= -w[m][t];
     
//6
	ogrMiesiecznyBudzet:
	 forall( t in TMiesiace )
	   b[t] == b[t-1] + sum(m in Miasta) x[m][t]*(c*p-k[m][t]);
	 
	ogrPoczatkoweBudzet:  
	   b[1] == b0;

//ograniczenie dla zmiennej kontrolnej     		
//     ogrBudCalc:
//     	pozBud == b[t] - sum( t in Miesiace, m in Miasta) x[m][t]*k[m][t];
     	
//ograniczenie dla zmiennej kontrolnej     		
//     ogrBudLok:
//	     forall( t in Miesiace )
//	      forall( m in Miasta )
//	     	lokBud[m][t] == x[m][t]*k[m][t];
 
 	ogrWzglObsl:
 		forall(m in Miasta)
 		  forall(t in Miesiace)
 		    wzglObs[m][t] == x[m][t]/l[m][t];
 
}
 