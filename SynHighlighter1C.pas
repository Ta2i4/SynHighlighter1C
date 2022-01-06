﻿{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 2.0 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: SynHighlighterSQL.pas, released 2000-04-21.
The Original Code is based on the wmSQLSyn.pas and wmSybaseSyn.pas files from
the mwEdit component suite by Martin Waldenburg and other developers, the
Initial Author of these files is Willo van der Merwe. Initial Author of
SynHighlighterSQL.pas is Michael Hieke.
Portions created by Willo van der Merwe are Copyright 1999 Willo van der Merwe.
Portions created by Michael Hieke are Copyright 2000 Michael Hieke.
Unicode translation by Maël Hörz.

This code based on SynHighlighterSQL.pas code, by Alexey Tatuyko (2022).
Code has written and tested on Delphi 10.4 (Seattle) Community Edition.
File version: v.0.1.2.3 (2022/01/07)

All Rights Reserved.
}

unit SynHighlighter1C;

{$I SynEdit.inc}

interface

uses
  System.Win.Registry, System.Generics.Collections, System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  SynEditTypes, SynEditHighlighter, SynHighlighterHashEntries, SynUnicode;

type
  TtkTokenKind = (tkComment, tkDatatype, tkDefaultPackage, tkException,
    tkFunction, tkIdentifier, tkKey, tkNull, tkNumber, tkSpace, tkPLSQL,
    tkSQLPlus, tkString, tkSymbol, tkTableName, tkUnknown, tkVariable,
    tkConditionalComment, tkDelimitedIdentifier, tkProcName, tkConsoleOutput);

  TRangeState = (rsUnknown, rsComment, rsString, rsConditionalComment,
    rsConsoleOutput);

type
  TSyn1CSyn = class(TSynCustomHighlighter)
  private
    fRange: TRangeState;
    fTokenID: TtkTokenKind;
    fKeywords: TSynHashEntryList;
    FProcNames: TStrings;
    fTableNames: TStrings;
    FTableDict: TDictionary<string, Boolean>;
    fFunctionNames: TStrings;
    fCommentAttri: TSynHighlighterAttributes;
    fConditionalCommentAttri: TSynHighlighterAttributes;
    fConsoleOutputAttri: TSynHighlighterAttributes;
    fDataTypeAttri: TSynHighlighterAttributes;
    fDefaultPackageAttri: TSynHighlighterAttributes;
    fDelimitedIdentifierAttri: TSynHighlighterAttributes;
    fExceptionAttri: TSynHighlighterAttributes;
    fFunctionAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fPLSQLAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fSQLPlusAttri: TSynHighlighterAttributes;
    fStringAttri: TSynHighlighterAttributes;
    fSymbolAttri: TSynHighlighterAttributes;
    fTableNameAttri: TSynHighlighterAttributes;
    fProcNameAttri: TSynHighlighterAttributes;
    fVariableAttri: TSynHighlighterAttributes;
    function HashKey(Str: PWideChar): Integer;
    function IdentKind(MayBe: PWideChar): TtkTokenKind;
    procedure AndSymbolProc;
    procedure AsciiCharProc;
    procedure CRProc;
    procedure EqualProc;
    procedure GreaterProc;
    procedure IdentProc;
    procedure LFProc;
    procedure LowerProc;
    procedure MinusProc;
    procedure HashProc;
    procedure NumberProc;
    procedure OrSymbolProc;
    procedure NullProc;
    procedure PlusProc;
    procedure ProcNamesChanged(Sender: TObject);
    procedure FunctionNamesChanged(Sender: TObject);
    procedure SlashProc;
    procedure SpaceProc;
    procedure QuoteProc;
    procedure BacktickProc;
    procedure BracketProc;
    procedure SymbolProc;
    procedure SymbolAssignProc;
    procedure VariableProc;
    procedure UnknownProc;
    procedure AnsiCProc;
    procedure DoAddKeyword(AKeyword: string; AKind: integer);
    procedure SetTableNames(const Value: TStrings);
    procedure TableNamesChanged(Sender: TObject);
    procedure PutTableNamesInKeywordList;
    procedure InitializeKeywordLists;
    procedure PutFunctionNamesInKeywordList;
    procedure PutProcNamesInKeywordList;
    procedure SetFunctionNames(const Value: TStrings);
    procedure SetProcNames(const Value: TStrings);
  protected
    function IsFilterStored: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function IsKeyword(const AKeyword: string): Boolean; override;
    procedure Next; override;
    function GetDefaultAttribute(Index: Integer): TSynHighlighterAttributes;
      override;
    function GetEol: Boolean; override;
    function GetRange: Pointer; override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenID: TtkTokenKind;
    function GetTokenKind: Integer; override;
    procedure ResetRange; override;
    procedure SetRange(Value: Pointer); override;
    function IsIdentChar(AChar: WideChar): Boolean; override;
    function GetKeyWords(TokenKind: Integer): string; override;
  published
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri
      write fCommentAttri;
    property ConditionalCommentAttri: TSynHighlighterAttributes
      read fConditionalCommentAttri write fConditionalCommentAttri;
    property ConsoleOutputAttri: TSynHighlighterAttributes
      read FConsoleOutputAttri write FConsoleOutputAttri;
    property DataTypeAttri: TSynHighlighterAttributes read fDataTypeAttri
      write fDataTypeAttri;
    property DefaultPackageAttri: TSynHighlighterAttributes
      read fDefaultPackageAttri write fDefaultPackageAttri;
    property DelimitedIdentifierAttri: TSynHighlighterAttributes
      read fDelimitedIdentifierAttri write fDelimitedIdentifierAttri;
    property ExceptionAttri: TSynHighlighterAttributes read fExceptionAttri
      write fExceptionAttri;
    property FunctionAttri: TSynHighlighterAttributes read fFunctionAttri
      write fFunctionAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri
      write fIdentifierAttri;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri
      write fNumberAttri;
    property PLSQLAttri: TSynHighlighterAttributes read fPLSQLAttri
      write fPLSQLAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri
      write fSpaceAttri;
    property SQLPlusAttri: TSynHighlighterAttributes read fSQLPlusAttri
      write fSQLPlusAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri
      write fStringAttri;
    property SymbolAttri: TSynHighlighterAttributes read fSymbolAttri
      write fSymbolAttri;
    property ProcNameAttri: TSynHighlighterAttributes read FProcNameAttri
      write FProcNameAttri;
    property TableNameAttri: TSynHighlighterAttributes read fTableNameAttri
      write fTableNameAttri;
    property ProcNames: TStrings read FProcNames write SetProcNames;
    property TableNames: TStrings read fTableNames write SetTableNames;
    property FunctionNames: TStrings read fFunctionNames write SetFunctionNames;
    property VariableAttri: TSynHighlighterAttributes read fVariableAttri
      write fVariableAttri;
  end;

implementation

uses
  SynEditStrConst;

const
//---1C keywords----------------------------------------------------------------
  ONESKW: string =
    'BY,CASE,GROUP,HAVING,JOIN,NULL,SELECT,WHERE,ВНУТРЕННЕЕ,ВСЕ,ВЫБОР,' +
    'ВЫБРАТЬ,ВЫРАЗИТЬ,ГДЕ,ДЛЯ,ЗНАЧЕНИЕ,И,ИЗ,ИЗМЕНЕНИЯ,ИЛИ,ИМЕЮЩИЕ,ИНАЧЕ,КАК,' +
    'КОГДА,КОНЕЦ,ЛЕВОЕ,НЕ,ОБЪЕДИНИТЬ,ПЕРВЫЕ,ПО,ПОЛНОЕ,ПРАВОЕ,РАЗЛИЧНЫЕ,' +
    'РАЗРЕШЕННЫЕ,СГРУППИРОВАТЬ,СОЕДИНЕНИЕ,ССЫЛКА,ТИП,ТИПЗНАЧЕНИЯ,ТОГДА' +
    'УПОРЯДОЧИТЬ';

//---1C functions---------------------------------------------------------------
//исправить - пока это mssql
  ONESFunctions: string =
    'ISNULL,ВОЗР,ГОД,ДЕНЬ,ДОБАВИТЬКДАТЕ,ЕСТЬNULL,КВАРТАЛ,КОЛИЧЕСТВО,МАКСИМУМ,' +
    'МЕСЯЦ,МИНИМУМ,МИНУТА,РАЗНЫХ,СЕКУНДА,СРЕДНЕЕ,СУММА,УБЫВ,ЧАС';

//---1C types-------------------------------------------------------------------
  ONESTypes: string =
    'СТРОКА,ЧИСЛО';

function TSyn1CSyn.HashKey(Str: PWideChar): Integer;
var
  FoundDoubleMinus: Boolean;

  function GetOrd: Integer;
  begin
    case Str^ of
      '_': Result := 1;
      'а'..'я': Result := 2 + Ord(Str^) - Ord('а');
      'А'..'Я': Result := 2 + Ord(Str^) - Ord('А');
      'a'..'z': Result := 2 + Ord(Str^) - Ord('a');
      'A'..'Z': Result := 2 + Ord(Str^) - Ord('A');
      '@': Result := 24;
      else Result := 0;
    end;
  end;

begin
  Result := 0;
  while IsIdentChar(Str^) do begin
    FoundDoubleMinus := (Str^ = '-') and ((Str + 1)^ = '-');
    if FoundDoubleMinus then Break;
{$IFOPT Q-}
    Result := 2 * Result + GetOrd;
{$ELSE}
    Result := (2 * Result + GetOrd) and $FFFFFF;
{$ENDIF}
    Inc(Str);
  end;
  Result := Result and $FF;
  if Assigned(fToIdent) then fStringLen := Str - fToIdent
    else fStringLen := 0;
end;

function TSyn1CSyn.IdentKind(MayBe: PWideChar): TtkTokenKind;
var
  Entry: TSynHashEntry;
begin
  fToIdent := MayBe;
  Entry := fKeywords[HashKey(MayBe)];
  while Assigned(Entry) do begin
    if Entry.KeywordLen > fStringLen then Break
      else if Entry.KeywordLen = fStringLen then
        if IsCurrentToken(Entry.Keyword) then begin
          Result := TtkTokenKind(Entry.Kind);
          Exit;
        end;
    Entry := Entry.Next;
  end;
  if fTableDict.ContainsKey(AnsiLowerCase(Copy(StrPas(fToIdent), 1,
    fStringLen)))
    then Result := tkTableName else Result := tkIdentifier;
end;

constructor TSyn1CSyn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCaseSensitive := False;
  fKeywords := TSynHashEntryList.Create;
  FProcNames := TStringList.Create;
  TStringList(FProcNames).OnChange := ProcNamesChanged;
  fTableNames := TStringList.Create;
  TStringList(fTableNames).OnChange := TableNamesChanged;
  FTableDict := TDictionary<string, Boolean>.Create;
  fFunctionNames := TStringList.Create;
  TStringList(fFunctionNames).OnChange := FunctionNamesChanged;
  fCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrComment,
    SYNS_FriendlyAttrComment);
  fCommentAttri.Style := [fsItalic];
  AddAttribute(fCommentAttri);
  fConditionalCommentAttri := TSynHighlighterAttributes.Create(
    SYNS_AttrConditionalComment, SYNS_FriendlyAttrConditionalComment);
  fConditionalCommentAttri.Style := [fsItalic];
  AddAttribute(fConditionalCommentAttri);
  fConsoleOutputAttri := TSynHighlighterAttributes.Create(
    SYNS_AttrConsoleOutput, SYNS_FriendlyAttrConsoleOutput);
  fConsoleOutputAttri.Style := [fsBold, fsUnderline];
  AddAttribute(fConsoleOutputAttri);
  fDataTypeAttri := TSynHighlighterAttributes.Create(SYNS_AttrDataType,
    SYNS_FriendlyAttrDataType);
  fDataTypeAttri.Style := [fsBold];
  AddAttribute(fDataTypeAttri);
  fDefaultPackageAttri := TSynHighlighterAttributes.Create(
    SYNS_AttrDefaultPackage, SYNS_FriendlyAttrDefaultPackage);
  fDefaultPackageAttri.Style := [fsBold];
  AddAttribute(fDefaultPackageAttri);
  fDelimitedIdentifierAttri := TSynHighlighterAttributes.Create(
    SYNS_AttrDelimitedIdentifier, SYNS_FriendlyAttrDelimitedIdentifier);
  AddAttribute(fDelimitedIdentifierAttri);
  fExceptionAttri := TSynHighlighterAttributes.Create(SYNS_AttrException,
    SYNS_FriendlyAttrException);
  fExceptionAttri.Style := [fsItalic];
  AddAttribute(fExceptionAttri);
  fFunctionAttri := TSynHighlighterAttributes.Create(SYNS_AttrFunction,
    SYNS_FriendlyAttrFunction);
  fFunctionAttri.Style := [fsBold];
  AddAttribute(fFunctionAttri);
  fIdentifierAttri := TSynHighlighterAttributes.Create(SYNS_AttrIdentifier,
    SYNS_FriendlyAttrIdentifier);
  AddAttribute(fIdentifierAttri);
  fKeyAttri := TSynHighlighterAttributes.Create(SYNS_AttrKey,
    SYNS_FriendlyAttrKey);
  fKeyAttri.Style := [fsBold];
  AddAttribute(fKeyAttri);
  fNumberAttri := TSynHighlighterAttributes.Create(SYNS_AttrNumber,
    SYNS_FriendlyAttrNumber);
  AddAttribute(fNumberAttri);
  fPLSQLAttri := TSynHighlighterAttributes.Create(SYNS_AttrPLSQL,
    SYNS_FriendlyAttrPLSQL);
  fPLSQLAttri.Style := [fsBold];
  AddAttribute(fPLSQLAttri);
  fSpaceAttri := TSynHighlighterAttributes.Create(SYNS_AttrSpace,
    SYNS_FriendlyAttrSpace);
  AddAttribute(fSpaceAttri);
  fSQLPlusAttri:=TSynHighlighterAttributes.Create(SYNS_AttrSQLPlus,
    SYNS_FriendlyAttrSQLPlus);
  fSQLPlusAttri.Style := [fsBold];
  AddAttribute(fSQLPlusAttri);
  fStringAttri := TSynHighlighterAttributes.Create(SYNS_Attrstring,
    SYNS_FriendlyAttrstring);
  AddAttribute(fStringAttri);
  fSymbolAttri := TSynHighlighterAttributes.Create(SYNS_AttrSymbol,
    SYNS_FriendlyAttrSymbol);
  AddAttribute(fSymbolAttri);
  fProcNameAttri := TSynHighlighterAttributes.Create(SYNS_AttrProcName,
    SYNS_FriendlyAttrProcName);
  AddAttribute(fProcNameAttri);
  fTableNameAttri := TSynHighlighterAttributes.Create(SYNS_AttrTableName,
    SYNS_FriendlyAttrTableName);
  AddAttribute(fTableNameAttri);
  fVariableAttri := TSynHighlighterAttributes.Create(SYNS_AttrVariable,
    SYNS_FriendlyAttrVariable);
  AddAttribute(fVariableAttri);
  SetAttributesOnChange(DefHighlightChange);
  fDefaultFilter := SYNS_FilterSQL;
  fRange := rsUnknown;
  InitializeKeywordLists;
end;

destructor TSyn1CSyn.Destroy;
begin
  fKeywords.Free;
  fProcNames.Free;
  fTableNames.Free;
  fTableDict.Free;
  fFunctionNames.Free;
  inherited Destroy;
end;

procedure TSyn1CSyn.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
end;

procedure TSyn1CSyn.AndSymbolProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if CharInSet(fLine[Run], ['=', '&']) then Inc(Run);
end;

procedure TSyn1CSyn.AsciiCharProc;
begin
  if fLine[Run] = #0 then NullProc else begin
    fTokenID := tkString;
    if (Run > 0) or (fRange <> rsString) or (fLine[Run] <> #39) then begin
      fRange := rsString;
      repeat Inc(Run) until IsLineEnd(Run) or (fLine[Run] = #39);
    end;
    if fLine[Run] = #39 then begin
      Inc(Run);
      fRange := rsUnknown;
    end;
  end;
end;

procedure TSyn1CSyn.CRProc;
begin
  fTokenID := tkSpace;
  Inc(Run);
  if fLine[Run] = #10 then Inc(Run);
end;

procedure TSyn1CSyn.EqualProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if CharInSet(fLine[Run], ['=', '>']) then Inc(Run);
end;

procedure TSyn1CSyn.GreaterProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if CharInSet(fLine[Run], ['=', '>']) then Inc(Run);
end;

procedure TSyn1CSyn.IdentProc;
var
  FoundDoubleMinus: Boolean;
begin
  fTokenID := IdentKind((fLine + Run));
  Inc(Run, fStringLen);
  if FTokenID in [tkComment, tkConsoleOutput] then
  begin
    while not IsLineEnd(Run) do
      Inc(Run);
  end
  else
    while IsIdentChar(fLine[Run]) do
    begin
      FoundDoubleMinus := (fLine[Run] = '-') and (fLine[Run + 1] = '-');
      if FoundDoubleMinus then Break;
      Inc(Run);
    end;
end;

procedure TSyn1CSyn.LFProc;
begin
  fTokenID := tkSpace;
  Inc(Run);
end;

procedure TSyn1CSyn.LowerProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  case fLine[Run] of
    '=': Inc(Run);
    '<': begin
           Inc(Run);
           if fLine[Run] = '=' then Inc(Run);
         end;
  end;
end;

procedure TSyn1CSyn.MinusProc;
begin
  Inc(Run);
  if (fLine[Run] = '-') then begin
    fTokenID := tkComment;
    repeat Inc(Run) until IsLineEnd(Run);
  end else fTokenID := tkSymbol;
end;

procedure TSyn1CSyn.HashProc;
begin
  Inc(Run);
  fTokenID := tkUnknown;
end;

procedure TSyn1CSyn.NullProc;
begin
  fTokenID := tkNull;
  Inc(Run);
end;

procedure TSyn1CSyn.NumberProc;

  function IsNumberChar: Boolean;
  begin
    case fLine[Run] of
      '0'..'9', '.', '-': Result := True;
      else Result := False;
    end;
  end;

begin
  Inc(Run);
  fTokenID := tkNumber;
  while IsNumberChar do begin
    if (FLine[Run] = '.') and (FLine[Run + 1] = '.') then Break;
    Inc(Run);
  end;
end;

procedure TSyn1CSyn.OrSymbolProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if CharInSet(fLine[Run], ['=', '|']) then Inc(Run);
end;

procedure TSyn1CSyn.PlusProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if CharInSet(fLine[Run], ['=', '+']) then Inc(Run);
end;

procedure TSyn1CSyn.FunctionNamesChanged(Sender: TObject);
begin
  InitializeKeywordLists;
end;

procedure TSyn1CSyn.ProcNamesChanged(Sender: TObject);
begin
  InitializeKeywordLists;
end;

procedure TSyn1CSyn.SlashProc;
begin
  Inc(Run);
  case fLine[Run] of
    '*':
      begin
        fRange := rsComment;
        fTokenID := tkComment;
        repeat
          Inc(Run);
          if (fLine[Run] = '*') and (fLine[Run + 1] = '/') then begin
            fRange := rsUnknown;
            Inc(Run, 2);
            Break;
          end;
        until IsLineEnd(Run);
      end;
    '=':
      begin
        Inc(Run);
        fTokenID := tkSymbol;
      end;
    else fTokenID := tkSymbol;
  end;
end;

procedure TSyn1CSyn.SpaceProc;
begin
  Inc(Run);
  fTokenID := tkSpace;
  while (FLine[Run] <= #32) and not IsLineEnd(Run) do inc(Run);
end;

procedure TSyn1CSyn.QuoteProc;
begin
  fTokenID := tkDelimitedIdentifier;
  Inc(Run);
  while not IsLineEnd(Run) do begin
    if fLine[Run] = #34 then begin
      Inc(Run);
      if fLine[Run] <> #34 then Break;
    end;
    Inc(Run);
  end;
end;

procedure TSyn1CSyn.BacktickProc;
begin
  Inc(Run);
  fTokenID := tkUnknown;
end;

procedure TSyn1CSyn.BracketProc;
begin
  fTokenID := tkDelimitedIdentifier;
  Inc(Run);
  while not IsLineEnd(Run) do begin
    if fLine[Run] = ']' then begin
      Inc(Run);
      if fLine[Run] <> ']' then Break;
    end;
    Inc(Run);
  end;
end;

procedure TSyn1CSyn.SymbolProc;
begin
  Inc(Run);
  fTokenID := tkSymbol;
end;

procedure TSyn1CSyn.SymbolAssignProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if fLine[Run] = '=' then Inc(Run);
end;

procedure TSyn1CSyn.VariableProc;
var
  i: Integer;
  FoundDoubleMinus: Boolean;
begin
  if (fLine[Run] = '@') and (fLine[Run + 1] = '@') then
    IdentProc
  else begin
    fTokenID := tkVariable;
    i := Run;
    repeat
      FoundDoubleMinus := (fLine[i] = '-') and (fLine[i + 1] = '-');
      if FoundDoubleMinus then Break;
      Inc(i);
    until not IsIdentChar(fLine[i]);
    Run := i;
  end;
end;

procedure TSyn1CSyn.UnknownProc;
begin
  Inc(Run);
  fTokenID := tkUnknown;
end;

procedure TSyn1CSyn.AnsiCProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
    else begin
      if fRange = rsConditionalComment then fTokenID := tkConditionalComment
      else fTokenID := tkComment;
      repeat
        if (fLine[Run] = '*') and (fLine[Run + 1] = '/') then begin
          fRange := rsUnknown;
          Inc(Run, 2);
          Break;
        end;
        Inc(Run);
      until IsLineEnd(Run);
    end;
  end;
end;

function TSyn1CSyn.IsKeyword(const AKeyword: string): Boolean;
var
  tk: TtkTokenKind;
begin
  tk := IdentKind(PWideChar(AKeyword));
  Result := tk in [tkDatatype, tkException, tkFunction, tkKey, tkPLSQL,
    tkDefaultPackage];
end;

procedure TSyn1CSyn.Next;
begin
  fTokenPos := Run;
  case fRange of
    rsComment, rsConditionalComment: AnsiCProc;
    rsConsoleOutput: while not IsLineEnd(Run) do Inc(Run);
    rsString: AsciiCharProc;
    else case fLine[Run] of
      #0: NullProc;
      #10: LFProc;
      #13: CRProc;
      #39: AsciiCharProc;
      '=': EqualProc;
      '>': GreaterProc;
      '<': LowerProc;
      '-': MinusProc;
      '#': HashProc;
      '|': OrSymbolProc;
      '+': PlusProc;
      '/': SlashProc;
      '&': AndSymbolProc;
      #34: QuoteProc;
      '`': BacktickProc;
      '[': BracketProc;
      ':', '@': VariableProc;
      'A'..'Z', 'a'..'z', 'А'..'Я', 'а'..'я', '_': IdentProc;
      '0'..'9': NumberProc;
      #1..#9, #11, #12, #14..#32: SpaceProc;
      '^', '%', '*', '!': SymbolAssignProc;
      '{', '}', '.', ',', ';', '?', '(', ')', ']', '~': SymbolProc;
      else UnknownProc;
    end;
  end;
  inherited;
end;

function TSyn1CSyn.GetDefaultAttribute(Index: integer):
  TSynHighlighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT: Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER: Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD: Result := fKeyAttri;
    SYN_ATTR_STRING: Result := fStringAttri;
    SYN_ATTR_WHITESPACE: Result := fSpaceAttri;
    SYN_ATTR_SYMBOL: Result := fSymbolAttri;
    else Result := nil;
  end;
end;

function TSyn1CSyn.GetEol: Boolean;
begin
  Result := Run = fLineLen + 1;
end;

function TSyn1CSyn.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

function TSyn1CSyn.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TSyn1CSyn.GetTokenAttribute: TSynHighlighterAttributes;
begin
  case GetTokenID of
    tkComment: Result := fCommentAttri;
    tkConditionalComment: Result := fConditionalCommentAttri;
    tkConsoleOutput: Result := FConsoleOutputAttri;
    tkDatatype: Result := fDataTypeAttri;
    tkDefaultPackage: Result := fDefaultPackageAttri;
    tkDelimitedIdentifier: Result := fDelimitedIdentifierAttri;
    tkException: Result := fExceptionAttri;
    tkFunction: Result := fFunctionAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkNumber: Result := fNumberAttri;
    tkPLSQL: Result := fPLSQLAttri;
    tkSpace: Result := fSpaceAttri;
    tkSQLPlus: Result := fSQLPlusAttri;
    tkString: Result := fStringAttri;
    tkSymbol: Result := fSymbolAttri;
    tkProcName: Result := FProcNameAttri;
    tkTableName: Result := fTableNameAttri;
    tkVariable: Result := fVariableAttri;
    tkUnknown: Result := fIdentifierAttri;
    else Result := nil;
  end;
end;

function TSyn1CSyn.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

procedure TSyn1CSyn.ResetRange;
begin
  fRange := rsUnknown;
end;

procedure TSyn1CSyn.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

function TSyn1CSyn.IsFilterStored: Boolean;
begin
  Result := fDefaultFilter <> SYNS_FilterSQL;
end;

function TSyn1CSyn.IsIdentChar(AChar: WideChar): Boolean;
begin
  case AChar of
    'a'..'z', 'A'..'Z', 'а'..'я', 'А'..'Я', '0'..'9', '_', '@': Result := True;
    else Result := False;
  end;
end;

procedure TSyn1CSyn.DoAddKeyword(AKeyword: string; AKind: integer);
var
  HashValue: Integer;
begin
  AKeyword := AnsiLowerCase(AKeyword);
  HashValue := HashKey(PWideChar(AKeyword));
  fKeywords[HashValue] := TSynHashEntry.Create(AKeyword, AKind);
end;

procedure TSyn1CSyn.SetTableNames(const Value: TStrings);
begin
  fTableNames.Assign(Value);
end;

procedure TSyn1CSyn.TableNamesChanged(Sender: TObject);
begin
  InitializeKeywordLists;
end;

procedure TSyn1CSyn.PutTableNamesInKeywordList;
var
  i: Integer;
  Entry: TSynHashEntry;
begin
  for i := 0 to fTableNames.Count - 1 do begin
    Entry := fKeywords[HashKey(PWideChar(fTableNames[i]))];
    while Assigned(Entry) do begin
      if AnsiLowerCase(Entry.Keyword) = AnsiLowerCase(fTableNames[i])
      then Break;
      Entry := Entry.Next;
    end;
    if (not Assigned(Entry)) and
      (not fTableDict.ContainsKey(AnsiLowerCase(fTableNames[i])))
    then FTableDict.Add(AnsiLowerCase(FTableNames[i]), True);
  end;
end;

procedure TSyn1CSyn.PutFunctionNamesInKeywordList;
var
  i: Integer;
  Entry: TSynHashEntry;
begin
  for i := 0 to (fFunctionNames.Count - 1) do begin
    Entry := fKeywords[HashKey(PWideChar(fFunctionNames[i]))];
    while Assigned(Entry) do begin
      if AnsiLowerCase(Entry.Keyword) = AnsiLowerCase(fFunctionNames[i])
      then Break;
      Entry := Entry.Next;
    end;
    if not Assigned(Entry)
    then DoAddKeyword(fFunctionNames[i], Ord(tkFunction));
  end;
end;

procedure TSyn1CSyn.PutProcNamesInKeywordList;
var
  i: Integer;
  Entry: TSynHashEntry;
begin
  for i := 0 to fProcNames.Count - 1 do begin
    Entry := fKeywords[HashKey(PWideChar(FProcNames[i]))];
    while Assigned(Entry) do begin
      if AnsiLowerCase(Entry.Keyword) = AnsiLowerCase(FProcNames[i])
      then Break;
      Entry := Entry.Next;
    end;
    if not Assigned(Entry) then DoAddKeyword(fProcNames[i], Ord(tkProcName));
  end;
end;

procedure TSyn1CSyn.InitializeKeywordLists;
var
  I: Integer;
begin
  fKeywords.Clear;
  fTableDict.Clear;
  fToIdent := nil;
  for I := 0 to Ord(High(TtkTokenKind))
  do EnumerateKeywords(I, GetKeywords(I), IsIdentChar, DoAddKeyword);
  PutProcNamesInKeywordList;
  PutTableNamesInKeywordList;
  PutFunctionNamesInKeywordList;
  DefHighlightChange(Self);
end;

procedure TSyn1CSyn.SetFunctionNames(const Value: TStrings);
begin
  FFunctionNames.Assign(Value);
end;

procedure TSyn1CSyn.SetProcNames(const Value: TStrings);
begin
  fProcNames.Assign(Value);
end;

function TSyn1CSyn.GetKeyWords(TokenKind: Integer): string;
begin
  Result := '';
  case TtkTokenKind(TokenKind) of
    tkKey: Result := ONESKW;
    tkDataType: Result := ONESTypes;
    tkFunction: Result := ONESFunctions;
  end;
end;

initialization
  RegisterPlaceableHighlighter(TSyn1CSyn);

end.
