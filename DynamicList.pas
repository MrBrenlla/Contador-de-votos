{
TITLE: Contador de votos
AUTHOR: Brais García Brenlla
DATE: 15/03/2019
}

unit DynamicList;

interface

const
	NULL=nil;
	BLANKVOTE='B';
	NULLVOTE='N';

type
	tPosL=^tNodo;
	tPartyName=string;
	tNumVotes=word;
	tItem=record
		partyname:tPartyName;
		numvotes:tNumVotes;
	end;
	tNodo=record
		item:tItem;
		next:^tNodo;
	end;
	tList=^tNodo;

procedure createEmptyList(var list:tList);
function isEmptyList(list:tList):boolean;
function first(list:tList):tPosL;
function last(list:tList):tPosL;
function next(position:tPosL;list:tList):tPosL;
function previous(position:tPosL;list:tList):tPosL;
function insertItem(item:tItem;position:tPosL;VAR list:tlist):boolean;
procedure deleteAtPosition(VAR position:tPosL;VAR list:tlist);
function getItem(position:tPosL;list:tList):tItem;
procedure updateVotes(votes:tNumVotes;position:tPosL; list:tList);
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
		list:=NULL;
	end;




function isEmptyList(list:tList):boolean;

{
Obxectivo: Comproba se unha lista está vacía
Entradas: list, a lista que se desexa comprobar       
Saidas: Un boolean que é verdadeiro se a lista está vacía 
Precondicións: A lista ten que estar inicializada}

	begin
		if list=NULL then isEmptyList:=true
		else isEmptyList:=false;
	end;




function first(list:tList):tPosL;

{Obxectivo: Devolver a posicion do primeiro elemento
Entradas: list, a lista da que se quere atopar o primeiro elemento      
Saidas: un tPosL coa posición do primeiro elemento
Precondicións: A lista ten que estar inicializada e non ser vacia}

	begin
		first:=list
	end;




function last(list:tList):tPosL;

{Obxectivo: Devolver a posicion do primeiro elemento
Entradas: list, a lista da que se quere atopar o primeiro elemento      
Saidas: un tPosL coa posición do primeiro elemento
Precondicións: A lista ten que estar inicializada e non ser vacia}

VAR
position:tPosL;

	begin
		position:=list;
		while position^.next<>NULL do position:=position^.next;
		last:=position;
	end;



function next(position:tPosL;list:tList):tPosL;

{Obxectivo: Devolver a posicion seguinte
Entradas: list, a lista na que se quere atopar a seguinte posicion      
Saidas: un tPosL coa posición seguinte
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: devolverase NULL se non hai seguinte}

	begin
		if position=last(list) then next:=NULL
		else next:=position^.next;
	end;

function previous(position:tPosL;list:tList):tPosL;

{Obxectivo: Devolver a posicion anterior
Entradas: list, a lista na que se quere atopar a anterior posicion      
Saidas: un tPosL coa posición anterior
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: devolverase NULL se non hai anterior}

VAR
position2:tPosL;

	begin
		if position=list then previous:=NULL
		else BEGIN
			position2:=list;
			while position2^.next<>position do position2:=position2^.next;
			previous:=position2;
		end;
	end;



function insertItem(item:tItem;position:tPosL;VAR list:tlist):boolean;

{Obxectivo: Engadir un item na lista
Entradas:item, o item a engadir
         position, a posicion da lista na que se desexa engadir o item
         list, a lista na que se quere engadir o item    
Saidas: list, a lista de entrada modificada co novo item xa engadido
        un boolean que será verdadeiro se o item se engade correctamente
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida ou NULL
Postcondicións: Todos os elementos que estan despois da posicion na que se introduce poden variar de posición}

	var
	tmp:tPosL;
	begin
		
		{Insetar item se se da unha posición}
		if position<>NULL then BEGIN
			tmp:=position^.next;
			new(position^.next);
			position^.item:=item;
			position:=position^.next;
			position^.next:=tmp;
		end
		else BEGIN
		
			{Insertar item se se recibe NULL e a lista está vacía}
			if isEmptyList(list) then BEGIN 
				new(list);
				list^.item:=item
			END
			
			{Insertar item se se recibe NULL e a lista non está vacía}
			else BEGIN
				tmp:=last(list);
				new(tmp^.next);
				tmp:=tmp^.next;
				tmp^.item:=item;
			END;
		end;
		insertItem:=TRUE;
	end;



procedure deleteAtPosition(VAR position:tPosL;VAR list:tlist);

{Obxectivo: eliminar un item na lista
Entradas:position, a posicion da lista na que se desexa eliminar o item
         list, a lista na que se quere eliminar o item    
Saidas: list, a lista de entrada modificada co  item xa eliminado
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: Todos os elementos que estan despos da posicion na que se elimina poden variar de posición}

	var
		tmp:tPosL;
	begin
		if position=first(list) then list:=position^.next
		else BEGIN
			tmp:=previous(position,list);
			tmp^.next:=position^.next;
		END;
		dispose(position);
	end;



function getItem(position:tPosL;list:tList):tItem;

{Obxectivo: devolver o item que está na posición indicada da lista
Entradas:position, a posicion da lista na que está o item
         list, a lista na que se quere atopar o item    
Saidas: tItem que se atopa na posicion introducida 
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida }
	begin
		getItem:=position^.item;
	end;



procedure updateVotes(votes:tNumVotes;position:tPosL; list:tList);

{Obxectivo: modificar o número de votos de un partido sabendo a posición na lista
Entradas:votes, o novo número de votos do partido que se atpa nesa posición
         position, a posicion da lista na que se desexa eliminar o item
         list, a lista na que se quere modifica o número de votos    
Saidas: list, a lista de entrada modificada co novo número de votos na posición indicada
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións:A orde da lista non se ve modificada }
	begin
		position^.item.numvotes:=votes;
	end;
	
	
	

function findItem(party:tPartyName;list:tList):tPosL;

{Obxectivo: devolver a posición de un partido nunha lista
Entradas:party, o partido quese desexa buscar
         list, a lista na que se quere buscar o partido   
Saidas: un tPosL coa posición do partido que se busca na lista
Precondicións: A lista ten que estar inicializada
Postcondicións:Devolverase so a posición da primeira vez que apareza o partido
               Devolverase NULL se o partido non existe }
	VAR
	position,tmp:tPosL;
	begin
	if not(isEmptyList(list)) then BEGIN
		tmp:=last(list);
		position:=first(list);
		while (party<>position^.item.partyname) and (position<>tmp) do position:=next(position,list);
		if(position^.item.partyname=party) then findItem:=position
		else findItem:=NULL;
	END
	else findItem:=NULL;
	
	END;


end.
