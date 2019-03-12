{
TITLE: Contador de votos
AUTHOR: Brais García Brenlla
DATE: 15/03/2019
}


unit StaticList;

interface

const
	MAX=25;
	NULL=0;
	BLANKVOTE='B';
	NULLVOTE='N';

type
	tPosL=0..MAX;
	tPartyName=string;
	tNumVotes=word;
	tItem=record
		partyname:tPartyName;
		numvotes:tNumVotes;
	end;
	tList=record
	item:array[1..MAX] of tItem;
	fin:integer;
	end;

procedure createEmptyList(var list:tList);
function isEmptyList(list:tList):boolean;
function first(list:tList):tPosL;
function last(list:tList):tPosL;
function next(position:tPosL;list:tList):tPosL;
function previous(position:tPosL;list:tList):tPosL;
function insertItem(item:tItem;position:tPosL;var list:tlist):boolean;
procedure deleteAtPosition(position:tPosL;var list:tlist);
function getItem(position:tPosL;list:tList):tItem;
procedure updateVotes(votes:tNumVotes;position:tPosL;var list:tList);
function findItem(party:tPartyName;list:tList):tPosL;

implementation



procedure createEmptyList(var list:tList);

{
Obxectivo: Crea unha lista vacía
Entradas: list, a lista que se desexa inicializar       
Saidas: list, é a mesma lista que se ten como entrada inicializada 
Postcondicións: A lista  non conten elementos
}

	begin
		list.fin:=0;
	end;




function isEmptyList(list:tList):boolean;

{
Obxectivo: Comproba se unha lista está vacía
Entradas: list, a lista que se desexa comprobar       
Saidas: Un boolean que é verdadeiro se a lista está vacía 
Precondicións: A lista ten que estar inicializada}

	begin
		if list.fin=NULL then isEmptyList:=true
		else isEmptyList:=false;
	end;




function first(list:tList):tPosL;

{Obxectivo: Devolver a posicion do primeiro elemento
Entradas: list, a lista da que se quere atopar o primeiro elemento      
Saidas: un tPosL coa posición do primeiro elemento
Precondicións: A lista ten que estar inicializada e non ser vacia}

	begin
		first:=1
	end;




function last(list:tList):tPosL;

{Obxectivo: Devolver a posicion do primeiro elemento
Entradas: list, a lista da que se quere atopar o primeiro elemento      
Saidas: un tPosL coa posición do primeiro elemento
Precondicións: A lista ten que estar inicializada e non ser vacia}

	begin
		last:=list.fin
	end;



function next(position:tPosL;list:tList):tPosL;

{Obxectivo: Devolver a posicion seguinte
Entradas: list, a lista na que se quere atopar a seguinte posicion      
Saidas: un tPosL coa posición seguinte
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: devolverase NULL se non hai seguinte}

	begin
		if position<list.fin then next:=position+1
		else next:=NULL;
	end;

function previous(position:tPosL;list:tList):tPosL;

{Obxectivo: Devolver a posicion anterior
Entradas: list, a lista na que se quere atopar a anterior posicion      
Saidas: un tPosL coa posición anterior
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: devolverase NULL se non hai anterior}

	begin
		if position>1 then previous:=position-1
		else previous:=NULL;
	end;



function insertItem(item:tItem;position:tPosL;var list:tlist):boolean;

{Obxectivo: Engadir un item na lista
Entradas:item, o item a engadir
         position, a posicion da lista na que se desexa engadir o item
         list, a lista na que se quere engadir o item    
Saidas: list, a lista de entrada modificada co novo item xa engadido
        un boolean que será verdadeiro se o item se engade correctamente
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida ou NULL
Postcondicións: Todos os elementos que estan despos da posicion na que se introduce poden variar de posición}

	var
		i,n:integer;
	begin
		if (list.fin=MAX) then insertItem:=FALSE
		else BEGIN
			list.fin:=list.fin+1;
			if (position=NULL) then n:=list.fin
			else n:=position;
				for i:=list.fin-1 downto n do
					list.item[i+1]:=list.item[i];
			list.item[n]:=item;
			insertItem:=TRUE;
		end;
	end;



procedure deleteAtPosition(position:tPosL;var list:tlist);

{Obxectivo: eliminar un item na lista
Entradas:position, a posicion da lista na que se desexa eliminar o item
         list, a lista na que se quere eliminar o item    
Saidas: list, a lista de entrada modificada co  item xa eliminado
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: Todos os elementos que estan despos da posicion na que se elimina poden variar de posición}

	var
		i:integer;
	begin
		for i:=position to list.fin do
			list.item[i]:=list.item[i+1];
		list.fin:=list.fin-1;
	end;



function getItem(position:tPosL;list:tList):tItem;

{Obxectivo: devolver o item que está na posición indicada da lista
Entradas:position, a posicion da lista na que está o item
         list, a lista na que se quere atopar o item    
Saidas: tItem que se atopa na posicion introducida 
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida}
               
	begin
		getItem:=list.item[position];
	end;



procedure updateVotes(votes:tNumVotes;position:tPosL;var list:tList);

{Obxectivo: modificar o número de votos de un partido sabendo a posición na lista
Entradas:votes, o novo número de votos do partido que se atpa nesa posición
         position, a posicion da lista na que se desexa eliminar o item
         list, a lista na que se quere modifica o número de votos    
Saidas: list, a lista de entrada modificada co novo número de votos na posición indicada
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións:A orde da lista non se ve modificada }

	begin
		list.item[position].numvotes:=votes;
	end;
	
	
	

function findItem(party:tPartyName;list:tList):tPosL;

{Obxectivo: devolver a posición de un partido nunha lista
Entradas:party, o partido quese desexa buscar
         list, a lista na que se quere buscar o partido   
Saidas: un tPosL coa posición do partido que se busca na lista
Precondicións: A lista ten que estar inicializada
Postcondicións:Devolverase so a posición da primeira vez que apareza o partido
               Devolverase NULL se o partido non existe }
               
	var
		i,pos:tPosL;
	begin
		pos:=NULL;
		i:=0;
		repeat
			i:=i+1;
			if list.item[i].partyname=party then pos:=i;
		until (list.item[i].partyname=party)or(i=list.fin+1);
		findItem:=pos;
	end;


end.

