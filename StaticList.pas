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
	begin
		list.fin:=0;
	end;

function isEmptyList(list:tList):boolean;
	begin
		if list.fin=NULL then isEmptyList:=true
		else isEmptyList:=false;
	end;

function first(list:tList):tPosL;
	begin
		first:=1
	end;

function last(list:tList):tPosL;
	begin
		last:=list.fin
	end;

function next(position:tPosL;list:tList):tPosL;
	begin
		if position<list.fin then next:=position+1
		else next:=NULL;
	end;

function previous(position:tPosL;list:tList):tPosL;
	begin
		if position>1 then previous:=position-1
		else previous:=NULL;
	end;

function insertItem(item:tItem;position:tPosL;var list:tlist):boolean;
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
	var
		i:integer;
	begin
		for i:=position to list.fin do
			list.item[i]:=list.item[i+1];
		list.fin:=list.fin-1;
	end;

function getItem(position:tPosL;list:tList):tItem;
	begin
		getItem:=list.item[position];
	end;

procedure updateVotes(votes:tNumVotes;position:tPosL;var list:tList);
	begin
		list.item[position].numvotes:=votes;
	end;

function findItem(party:tPartyName;list:tList):tPosL;
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

