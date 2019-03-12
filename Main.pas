{
TITLE: Contador de votos
AUTHOR: Brais García Brenlla
DATE: 15/03/2019
}

USES sysutils,DynamicList;


procedure NEW(VAR list:tList;party:string);

{
Obxectivo: Crease un novo partido na lista
Entradas: list, é a lista na que se gardan os datos dos partidos é numero de votos
          party, é o partido que se debe engadir na lista
Saidas: list, é a mesma lista que se ten como entrada modificada para que incluia o novo partido
Postcondicións: Os partido engadidos teran os votos a 0
                se o partido xa existe este non se creará e dará Error
}

VAR
  item:tItem;
  tmp:boolean;

BEGIN
       if findItem(party,list)=null then BEGIN {Comprobamos que o elemento non sea xa existente}
           item.partyname:=party;
           item.numvotes:=0;
           tmp:=insertItem(item,null,list);
           if tmp then writeln('* New: party ',party) {Comprobamos que a inserción se producise satisfactoriamente}
           else writeln('+ Error: New not possible');
       END
       else writeln('+ Error: New not possible');
END;

Procedure VOTE(VAR list:tList;party:string);

{
Obxectivo: Engadir un voto ao partido selecionado
Entradas: list, é a lista na que se atopa o partidos ao que se quere engadir un voto
          party, é o partido ao que se quere engadir un voto
Saidas: list, a lista introducida modificada co voto que se engadiu
Postcondicións: se o partido no existe satara Error e o voto contarase como NULLVOTE 
}


VAR
	position:tPosL;
	votes:integer;
	item:tItem;
	comprobador:boolean;

BEGIN
	comprobador:=TRUE;
	position:=findItem(party,list); {Comproamos que o elemento exista na lista}
        if position=null then BEGIN {Se non existe o partido pasaría a ser NULLVOTE}
				 comprobador:=FALSE;
                 writeln('+ Error: Vote not possible. Party ',party,' not found. NULLVOTE');
                 position:=findItem(NULLVOTE,list);
                 party:=NULLVOTE;
        END;
        item:=getItem(position,list);
        votes:=item.numvotes+1;
        updateVotes(votes,position,list);
        if comprobador then writeln('* Vote: party ',party,' numvotes ',votes); {Se o partido si existia mostrase o mensaxe por pantalla}
END;


procedure ILLEGALIZE(VAR list:tList;party:string);

{
Obxectivo: eliminar un partido da lista
Entradas: list, é a lista na que se atopa o partidos que se quere eliminar
          party, é o partido  que se quere eliminar
Saidas: list, a lista introducida modificada para non ter o partido a eliminar
Postcondicións: Os votos do partido eliminado pasaran a ser parte dos votos de NULLVOTE
                Se os partidos a eliminar son "N", "B" ou un inexistete a resposta será Error e non se eliminarán
}


VAR
	item:tItem;
	position:tPosL;
	partyvotes,nullvotes:integer;


BEGIN
	position:=findItem(party,list);
       if (position<>null)and(party<>BLANKVOTE)and(party<>NULLVOTE) then BEGIN {Se o partido existe e non é nin NULLVOTE nin BLANKVOTE procedese á ilegalización}
			item:=getItem(position,list);
			partyvotes:=item.numvotes;
			item:=getItem(findItem(NULLVOTE,list),list);
			nullvotes:=item.numvotes;
			updateVotes(nullvotes+partyvotes,findItem(NULLVOTE,list),list);
			deleteAtPosition(position,list);
			writeln('* Illegalize: party ',party);
       END
       else writeln('+ Error: Illegalize not possible'); {En caso contrario mostrase error por pantalla}

END;


procedure STATS(list:tList;totalvoters:integer);

{
Obxectivo: Mostrar por pantalla numero de votos e porcentaxe de votos por partido e en total
Entradas: list, é a lista da que se desexan ver os datos
          totalvoters, o número total de votantes que hai no censo 
Saidas: Mostraranse por pantalla as estadisticas
}

VAR
	totalvotes,votes,nullvotes:integer;
	percent:real;
	
	position:tPosL;
	item:tItem;
BEGIN
        totalvotes:=0;
		votes:=0;
		
		{Facemos un reconto dos votos, separando os NULLVOTES do resto}
		position:=first(list);
		item:=getItem(position,list);
		if item.partyname<>NULLVOTE then totalvotes:=totalvotes+item.numvotes  
        else nullvotes:=item.numvotes;
        repeat
				position:=next(position,list);
                item:=getItem(position,list);
                if item.partyname<>NULLVOTE then totalvotes:=totalvotes+item.numvotes
                else nullvotes:=item.numvotes;
        until position=last(list);
        
        {Unha vez temos o reconto mostrase por pantalla o total e o porcentaxe (excepto NULLVOTES) de cada partido}
        position:=first(list);
        item:=getItem(position,list);
        votes:=item.numvotes;
        if totalvotes>0 then percent:=100*votes/totalvotes
        else percent:=0;
        if item.partyname<>NULLVOTE then writeln('Party ',item.partyname,' numvotes ',votes,' (',percent:0:2,'%)')
        else writeln('Party ',item.partyname,' numvotes ',votes);
        repeat
				position:=next(position,list);
                item:=getItem(position,list);
                votes:=item.numvotes;
                if totalvotes>0 then percent:=100*votes/totalvotes
                else percent:=0;
                if item.partyname<>NULLVOTE then writeln('Party ',item.partyname,' numvotes ',votes,' (',percent:0:2,'%)')
                else writeln('Party ',item.partyname,' numvotes ',votes);
        until position=last(list);
        
        {Finalmente mostramos o numero de votos o porcentaxe sobre os votantes totais}
        totalvotes:=totalvotes+nullvotes;
        if totalvoters>0 then percent:=100*totalvotes/totalvoters
        else percent:=0;
        writeln('Participation: ',totalvotes,' votes from ',totalvoters,' voters (',percent:0:2,'%)');
END;


procedure CLEAN(VAR list:tList);

{
Obxectivo: Vaciar a lista
Entradas: list, a lista que se desexa vaciar
Saidas: list, a lista introducida despois de vaciala
}

VAR
position:tPosL;

BEGIN
	while not isEmptyList(list) do BEGIN
		position:=first(list);
		deleteAtPosition(position,list);
	END;
END;


procedure readTasks(filename:string );

{
Obxectivo: Leerase o arquivo de texto e seguiranse as ordes que en el poña, redirixindo os datos a NEW, ILLEGALIZE, VOTE e STAT
           Ao finalizar vaciara a lista mediante o procedemento CLEAN
Entradas: filename, o nome do arquivo a leer
Saidas: Mostrara por pantalla as liñas de asteriscos e as ordes que se realizan
Precondicións: As duas primeiras orden seran facer o NEW de "B" e "N"
               Non se usará a orde NEW despois de usar a orde VOTE por primeira vez
}

VAR
   usersFile: TEXT;
   code 	 :string;
   line          : STRING;
   task          : STRING;
   partyOrVoters : STRING;
   list:tList;
BEGIN

   {process the operation file named filename}

   {$i-} { Deactivate checkout of input/output errors}
   Assign(usersFile, filename);
   Reset(usersFile);
   {$i+} { Activate checkout of input/output errors}
   IF (IoResult <> 0) THEN BEGIN
      writeln('**** Error reading '+filename);
      halt(1)
   END;

   createEmptyList(list);
   WHILE NOT EOF(usersFile) DO

   BEGIN
      { Read a line in the file and save it in different variables}
      ReadLn(usersFile, line);
      code := trim(copy(line,1,2));
      task:= line[4];
      partyOrVoters := trim(copy(line,5,8));  { trim removes blank spaces of the string}
                                          { copy(s, i, j) copies j characters of string s }
                                          { from position i }


      {Dependendo do valor "task" realizase a función correspondente}
      writeln('********************');

         if task='N' then BEGIN
			writeln(code,' ',task,': party ',partyOrVoters);
			writeln;
			NEW(list,partyOrVoters);
			END;
         if task='V' then BEGIN
			writeln(code,' ',task,': party ',partyOrVoters);
			writeln;
			VOTE(list,partyOrVoters);
			END;
	if task='I' then BEGIN
			writeln(code,' ',task,': party ',partyOrVoters);
			writeln;
			ILLEGALIZE(list,partyOrVoters);
			END;
	if task='S' then BEGIN
			writeln(code,' ',task,': totalvoters ',partyOrVoters);
			writeln;
			STATS(list,strtoint(partyOrVoters));
			END;
  END;
   Close(usersFile);
   CLEAN(list); {Ao finalizar todas as ordes vaciase a lista}

END;

{Main program}
BEGIN

	if (paramCount>0) then
		readTasks(ParamStr(1))
	else
		readTasks('new.txt');
          readln();

END.
