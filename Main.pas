USES sysutils,StaticList;

procedure NEW(VAR list:tList;party:string);

VAR
  item:tItem;
  comprobador:tPosL;

BEGIN
	comprobador:=findItem(party,list);
       if comprobador=null then BEGIN
           item.partyname:=party;
           item.numvotes:=null;
           insertItem(item,null,list);
           writeln('* New: party ',party);
       END
       else writeln('+ Error: New not possible');
END;

Procedure VOTE(VAR list:tList;party:string);
VAR
	position:tPosL;
	votes:integer;
	item:tItem;
	comprobador:boolean;

BEGIN
	comprobador:=TRUE;
	position:=findItem(party,list);
        if position=null then BEGIN
				 comprobador:=FALSE;
                 writeln('+ Error: Vote not possible. Party ',party,' not found. NULLVOTE');
                 position:=findItem(NULLVOTE,list);
                 party:=NULLVOTE;
        END;
        item:=getItem(position,list);
        votes:=item.numvotes+1;
        updateVotes(votes,position,list);
        if comprobador then writeln('* Vote: party ',party,' numvotes ',votes);
END;


procedure ILLEGALIZE(VAR list:tList;party:string);
VAR
	item:tItem;
	position:tPosL;
	partyvotes,nullvotes:integer;


BEGIN
	position:=findItem(party,list);
       if (position<>null)and(party<>BLANKVOTE)and(party<>NULLVOTE) then BEGIN
			item:=getItem(position,list);
			partyvotes:=item.numvotes;
			item:=getItem(findItem(NULLVOTE,list),list);
			nullvotes:=item.numvotes;
			updateVotes(nullvotes+partyvotes,findItem(NULLVOTE,list),list);
			deleteAtPosition(position,list);
			writeln('* Illegalize: party ',party);
       END
       else writeln('+ Error: Illegalize not possible');

END;


procedure STATS(list:tList;totalvoters:integer);
VAR
        totalvotes,votes:integer;
	position:tPosL;
	item:tItem;
BEGIN
        totalvotes:=0;
	votes:=0;
	position:=first(list);
        repeat
                item:=getItem(position,list);
                totalvotes:=totalvotes+item.numvotes;
                position:=position+1;
        until position>last(list);
        position:=first(list);
        repeat
                item:=getItem(position,list);
                votes:=item.numvotes;
                writeln('Party ',item.partyname,' votes ',votes,' (',100*votes/totalvotes:0:2,'%)');
                position:=position+1;
        until position>last(list);
        writeln('Participation: ',totalvotes,' votes from ',totalvoters,' voters (',100*totalvotes/totalvoters:0:2,'%)');




END;



procedure readTasks(filename:string );

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

      {Show the task --> Change by the adequate operation}
      writeln('********************');

         if task='N' then BEGIN
			writeln(code,' ',task,': party ',partyOrVoters);
			NEW(list,partyOrVoters);
			END;
         if task='V' then BEGIN
			writeln(code,' ',task,': party ',partyOrVoters);
			VOTE(list,partyOrVoters);
			END;
	if task='I' then BEGIN
			writeln(code,' ',task,': party ',partyOrVoters);
			ILLEGALIZE(list,partyOrVoters);
			END;
	if task='S' then BEGIN
			writeln(code,' ',task,': totalvoters ',partyOrVoters);
			STATS(list,strtoint(partyOrVoters));
			END;
  END;
   Close(usersFile);

END;

{Main program}
BEGIN

	if (paramCount>0) then
		readTasks(ParamStr(1))
	else
		readTasks('new.txt');
          readln();

END.
