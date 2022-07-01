unit uFunc;

interface

uses
  Classes,
  DBTables,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  SysUtils,
  Windows;

function fSubSql(sField, sValue: string): string;
function fNextString(Text: string): string;
function fFillStringLeft(sText: string; cChar: char; nLength: integer): string;
function fFillStringRight(sText: string; cChar: char; nLength: integer): string;
function fDateBraUsa(sDateBra: string): string;
function fStrCat(sString1, sString2, sFlag: string): string;
function fAllTrim(sString: string): string;
function fAllTrimNumeric(sString: string): string;
function Extenso(Mnum: currency): string;
function fCheckStringDate(sString: string): boolean;
function fCheckStringFloat(sString: string): boolean;
function FRetornaMes(Num: string): string;
function fStrReplicate(sChar: string; nLength: integer): string;
function fStrCol(nPos: integer; sStr: string): string;
function fStrAlign(sStr: string; nLength: integer; sAlinhamento: string;
  sFillChar: string): string;
function GetQueryFieldName(QueryX: TQuery; StLSelect: TStringList;
  sNome: string): string;
function StrIsEmpty(sStr: string): boolean;
function fDecimalToBits(iDecimal: integer): string;
function fStringCurrencyToFloat(sString: string): double;
function fStringNumberClear(sString: string; WithVirgula: integer): string;
function fStringWOPontoOuVirg(sString, tipo: string): string;
function fExecFile(const sProgram, sDir, sParams: string; nMode: integer): THandle;
function fFindVirgula(sString: string): integer;
procedure pAjeitaValor(var sString: string; separador: string);
function fAjeitaValor(sString: string; separador: string): string;
function fTrocaPontoVirgula(sString: string): string;
function fAjeitaDecimais(Str: string; Dec: integer): string;
function fRetiraVirgula(Str: string): string;
function fArredonda(Valor: real; Separator: char): real;
function fTruncaSe3CasasDecimais(Valor: real): real;
function fTrunca2CasasDecimais(Valor: currency): currency;
function fArredonda2CasasDecimais(Valor: currency): currency;
function fHextoInt(hexa: char): integer;
function fRetiraPonto(Str: string): string;
// Funcoes da Grazziotin
function Gera_Digito11(cod: string): string;
function Gera_DigFuncionario(cod: string): string;
function Gera_Digito_Contrato(cod: string): string;
function ProximaPrestacao(Dia: TDateTime): TDateTime;

implementation

uses
  Forms,
  ShellAPI, uFuncoes;

//.....retira o caracter '.' da string....
function fRetiraPonto(Str: string): string;
var
  i: integer;
  straux: string;
begin
  straux := '';
  for i := 1 to length(Str) do
    if Str[i] <> '.' then
      Straux := Straux + Str[i];
  fRetiraPonto := StrAux;
end;

//.....se numero de casas depois da virgula >2 entao trunca...
function fTruncaSe3CasasDecimais(Valor: real): real;
var
  StrValor, StrAux: string;
  i, position, conta: integer;
  ValorAux: real;
begin
  StrValor := floattostrf(Valor, ffFixed, 9, 6);
  StrAux   := '';
  position := 0;
  conta    := 0;
  for i := 1 to length(StrValor) do
  begin
    if conta < 3 then
      StrAux := StrAux + StrValor[i];
    if StrValor[i] = ',' then
      position := i;
    if position > 0 then
      conta := conta + 1;
  end;
  fTruncaSe3CasasDecimais := StrtoFloat(StrAux);
end;

//.....se numero de casas depois da virgula >2 entao arredonda...
function fArredonda(Valor: real; Separator: char): real;
var
  str, straux: string;
  nI: integer;
begin
  // straux := '';
  // str:=floattostr(Valor);
  // for nI:=1 to length(str) do
  // begin
  //   if str[nI]
  // end;
end;

//.......Retorna o valor decimal de 1 caraxter(hexa)...................
function fHextoInt(hexa: char): integer;
begin
  try
    fHextoInt := StrToInt(hexa);
  except
    on E: Exception do
    begin
      if Upcase(hexa) = 'A' then
        fHextoInt := 10
      else if Upcase(hexa) = 'B' then
        fHextoInt := 11
      else if Upcase(hexa) = 'C' then
        fHextoInt := 12
      else if Upcase(hexa) = 'D' then
        fHextoInt := 13
      else if Upcase(hexa) = 'E' then
        fHextoInt := 14
      else if Upcase(hexa) = 'F' then
        fHextoInt := 15;
    end;
  end;
end;

//.......ajeita as casas decimais.....................
function fAjeitaDecimais(Str: string; Dec: integer): string;
begin
  Str := Trim(Str);
  if fFindVirgula(Str) = 1 then
    Str := fAjeitaValor(Str, ',')
  else
    Str := copy(Str, 1, length(Str) - Dec) + ',' + copy(Str, length(Str) - (Dec - 1), Dec);
  fAjeitaDecimais := Str;
end;

//.................................................
function fRetiraVirgula(Str: string): string;
var
  i: integer;
  Str2: string;
begin
  for i := 1 to length(Str) do
    if Str[i] <> chr(44) then
      Str2 := Str2 + Str[i];
  fRetiraVirgula := Str2;
end;


//-------------------------------------------------------
function fNextString(Text: string): string;
var
  str1, str2: string;
  cAux: char;
  LenEdit, i: integer;
begin
  LenEdit := length(Text);
  Str1 := Copy(Text, 1, LenEdit - 1);
  cAux := Text[LenEdit];
  cAux := chr(Ord(cAux) + 1);
  Str1 := Str1 + cAux;
  fNextString := Str1;
end;

//-------------------------------------------------------
function fFillStringLeft(sText: string; cChar: char; nLength: integer): string;
var
  nN: integer;
  sFill: string;

begin
  nLength := nLength - length(sText);
  sFill := sText;
  for nN := 1 to nLength do
    sFill := cChar + sFill;
  fFillStringLeft := sFill;
end;

//-------------------------------------------------------
function fFillStringRight(sText: string; cChar: char; nLength: integer): string;
var
  nN: integer;
  sFill: string;

begin
  nLength := nLength - length(sText);
  sFill   := sText;

  for nN := 1 to nLength do
    sFill := sFill + cChar;
  fFillStringRight := sFill;
end;

//-------------------------------------------------------
function fDateBraUsa(sDateBra: string): string;
var
  sDay, sMonth, sYear, sDate: string;
begin
  sDay   := copy(sDateBra, 1, 2);
  sMonth := copy(sDateBra, 4, 2);
  sYear  := copy(sDateBra, 7, length(sDateBra) - 6);
  sDate  := sMonth + '/' + sDay + '/' + sYear;
  fDateBraUsa := sDate;
end;

//-------------------------------------------------------
function fAllTrim(sString: string): string;
var
  nI: integer;
  sNewString: string;
begin
  sNewString := '';
  for nI := 1 to length(sString) do
    if sString[nI] <> ' ' then
      sNewString := sNewString + Copy(sString, nI, 1);
  fAlltrim := sNewString;
end;

//-------------------------------------------------------
//-------------------------------------------------------
function fAllTrimNumeric(sString: string): string;
var
  nI: integer;
  sNewString: string;
begin
  sNewString := '';
  for nI := 1 to length(sString) do
    if sString[nI] <> ' ' then
      if (sString[nI] = '1') or (sString[nI] = '2') or (sString[nI] = '3') or
        (sString[nI] = '4') or (sString[nI] = '5') or (sString[nI] = '6') or
        (sString[nI] = '7') or (sString[nI] = '8') or (sString[nI] = '9') or
        (sString[nI] = '0') then
        sNewString := sNewString + Copy(sString, nI, 1);
  fAllTrimNumeric := sNewString;
end;

//-------------------------------------------------------


function fCheckStringDate(sString: string): boolean;
var
  lDataValida: boolean;
begin
  lDataValida := True;
  try
    strtodate(sString);
  except
    on E: Exception do
    begin
      MessageDlg('      Data Inválida      ', mtWarning, [mbOK], 0);
      lDataValida := False;
    end;
  end;
  fCheckStringDate := lDataValida;
end;

//-------------------------------------------------------
function fCheckStringFloat(sString: string): boolean;
var
  lFloatValido: boolean;
begin
  lFloatValido := True;
  if sString <> '' then
    try
      StrToFloat(sString);
    except
      on E: Exception do
      begin
        MessageDlg('      Valor Invalido      ', mtWarning, [mbOK], 0);
        lFloatValido := False;
      end;
    end;
  fCheckStringFloat := lFloatValido;
end;

//-------------------------------------------------------
function fStrCat(sString1, sString2, sFlag: string): string;
var
  sResult: string;
begin
  sResult := '';
  if (sFlag <> 'CASE_STR1_NOT_NULL') and (sFlag <> 'CASE_STR2_NOT_NULL') then
    sResult := sString1 + sString2;

  if uppercase(sFlag) = 'CASE_STR1_NOT_NULL' then
    if sString1 <> '' then
      sResult := sString1 + sString2;

  if uppercase(sFlag) = 'CASE_STR2_NOT_NULL' then
    if sString2 <> '' then
      sResult := sString1 + sString2;

  fStrCat := sResult;
end;

//-------------------------------------------------------
function fStrReplicate(sChar: string; nLength: integer): string;
var
  sStr: string;
  i: integer;
begin
  sStr := '';
  for i := 1 to nLength do
    sStr := sStr + sChar;
  fStrReplicate := sStr;
end;

//-------------------------------------------------------
function fStrCol(nPos: integer; sStr: string): string;
var
  nAdd: integer;
begin
  nAdd := 1;
  if nPos < 1 then
  begin
    nAdd := 0;
    nPos := 0;
  end;
  fStrCol := fStrReplicate(' ', nPos - nAdd) + sStr;
end;

//-------------------------------------------------------
function fStrAlign(sStr: string; nLength: integer; sAlinhamento: string;
  sFillChar: string): string;
var
  nFill, i, j, nMod: integer;
begin
  if length(sStr) > nLength then
    sStr := copy(sStr, 0, nLength);
  sAlinhamento := fAllTrim(UpperCase(sAlinhamento));
  //......................................
  if sAlinhamento = 'RIGHT' then
  begin
    nFill := nLength - length(sStr);
    for i := 1 to nFill do
      sStr := sFillChar + sStr;
  end;

  //......................................
  if sAlinhamento = 'LEFT' then
  begin
    nFill := nLength - length(sStr);
    for i := 1 to nFill do
      sStr := sStr + sFillChar;
  end;

  //......................................
  if sAlinhamento = 'CENTER' then
  begin
    nFill := nLength - length(sStr);
    nMod  := nFill mod 2;
    j     := nFill div 2;
    if nMod = 0 then
    begin
      for i := 1 to j do
        sStr := sFillChar + sStr;
      for i := 1 to j do
        sStr := sStr + sFillChar;
    end
    else
    begin
      for i := 1 to j do
        sStr := sFillChar + sStr;
      for i := 1 to j + 1 do
        sStr := sStr + sFillChar;
    end;
  end;
  fStrAlign := sStr;
end;

//-------------------------------------------------------
{.... RETIRA DE UMA STRINGLIST SQL O NOME CORRESPONDENTE AO CAMPO sNome DO SELECT ....}
function GetQueryFieldName(QueryX: TQuery; StLSelect: TStringList;
  sNome: string): string;
var
  sField, sResult, sSelect: string;
  ListFields: TStringList;
  i, j: integer;
begin
  ListFields := TStringList.Create;
  sResult    := '';
  sSelect    := '';
  //...... Separa campos da clausa select da SQL ........

  //...... Separa field ..............
  sField := '';
  i      := 0;
  j      := 0;
  for i := 0 to StLSelect.Count - 1 do
  begin
    sSelect := StLSelect.Strings[i];
    for j := 1 to length(sSelect) do
      if sSelect[j] = ',' then
      begin
        ListFields.Add(fAlltrim(sField));
        sField := '';
      end
      else
        sField := sField + copy(sSelect, j, 1);
  end;
  if sField <> '' then
    ListFields.Add(fAlltrim(sField));

  //.... Procura Nome em Sql correspontente ao parametro sNome ........
  for i := 0 to ListFields.Count - 1 do
    if UpperCase(ListFields.Strings[i]) = fAlltrim(UpperCase(sNome)) then
      sResult := QueryX.FieldDefs[i].Name;

  if sResult = '' then
    ShowMessage('<Projetista>  Campo ' + sNome + ' não encontrado ');
  ListFields.Free;
  GetQueryFieldName := fAlltrim(uppercase(sResult));

end;

//-------------------------------------------------------
function StrIsEmpty(sStr: string): boolean;
begin

  StrIsEmpty := (length(sStr) = 0);

end;

//-------------------------------------------------------
function fSubSql(sField, sValue: string): string;
var
  sStatement: string;
begin
  sStatement := 'SUBSTRING(' + sField + ' FROM 1 FOR ' +
    IntToStr(length(sValue)) + ') = ''' + sValue + '''';
  fSubSql    := sStatement;
end;

//-------------------------------------------------------
function fDecimalToBits(iDecimal: integer): string;
var
  iNumerador: integer;
  sBits: string;
begin
  sBits      := '';
  iNumerador := iDecimal;
  while iNumerador > 1 do
  begin
    sBits      := IntToStr(iNumerador mod 2) + sBits;
    iNumerador := (iNumerador div 2);
  end;

  if iNumerador = 1 then
    sBits := '1' + sBits;
  if iNumerador = 0 then
    sBits := '0' + sBits;

  fDecimalToBits := fStrAlign(sBits, 8, 'RIGHT', '0');

end;

//-------------------------------------------------------
function fStringCurrencyToFloat(sString: string): double;
var
  nI: integer;
  Aux, x: string;
begin
  for nI := 1 to length(sString) do
  begin
    x := copy(sString, nI, 1);
    // a ... z  e ,
    if ((x >= chr(43)) and (x <= chr(57))) and (x <> chr(46)) then
      Aux := Aux + x;
  end;

  try
    fStringCurrencyToFloat := StrToFloat(Aux);
  except
    on EconvertError do
      fStringCurrencyToFloat := 0.00;
  end;
end;

//-------------------------------------------------------
function fStringNumberClear(sString: string; WithVirgula: integer): string;
var
  nI: integer;
  Aux, x: string;
begin
  for nI := 1 to length(sString) do
  begin
    x := copy(sString, nI, 1);
    // a ... z  e ,      // 44 =,      46=.
    if WithVirgula = 1 then
      if ((x >= chr(48)) and (x <= chr(57))) or (x = chr(44)) then
        Aux := Aux + x;
    if WithVirgula = 0 then
      if (x >= chr(48)) and (x <= chr(57)) then
        Aux := Aux + x;
  end;
  fStringNumberClear := Aux;
end;

//-------------------------------------------------------
function fFindVirgula(sString: string): integer;
var
  retorno, nI: integer;
  x: string;
begin
  retorno := 0;

  for nI := 1 to length(sString) do
  begin
    x := copy(sString, nI, 1);

    if x = chr(44) then
    begin
      retorno := 1;
      break;
    end;
  end;
  fFindVirgula := retorno;
end;

//-------------------------------------------------------
{ ... verifique funcao fAjeitaValor (MELHOR) ... }
procedure pAjeitaValor(var sString: string; separador: string);
var
  x, newString: string;
  nI, nPosVirgula, nNumeroDepois: integer;
  lVirgula, lNumeroAntes, lChanged: boolean;
begin

  lVirgula      := False;
  lNumeroAntes  := False;
  nNumeroDepois := -1;
  nPosVirgula   := 1;
  for nI := 1 to length(sString) do
  begin
    x := copy(sString, nI, 1);

    if x = separador {chr(44)} then //.. virgula ou ponto
    begin
      lVirgula    := True;
      nPosVirgula := nI;
    end;

    if not lVirgula then
      lNumeroAntes := True;
    if lVirgula then
      nNumeroDepois := nNumeroDepois + 1;
  end;

  if nPosVirgula = 1 then
    lNumeroAntes := False;

  if lVirgula then
  begin
    if (nNumeroDepois < 2) and (nNumeroDepois <> -1) then
    begin
      newString := sString + fStrReplicate('0', 2 - nNumeroDepois);
      lChanged  := True;
    end;
    if not lNumeroAntes then
    begin
      newString := '0' + separador + sString;
      lChanged  := True;
    end;
  end
  else
  begin
    newString := sString + separador + '00';
    lChanged  := True;
  end;

  if lChanged then
    sString := newString;

end;

//-------------------------------------------------------
function fAjeitaValor(sString: string; separador: string): string;
var
  x, newString, milhar: string;
  nI, nPosVirgula, nNumeroDepois: integer;
  lVirgula, lNumeroAntes, lChanged: boolean;
begin

  lChanged := False;
  lVirgula := False;
  lNumeroAntes := False;
  nNumeroDepois := -1;
  if separador = ',' then
    milhar := '.'
  else
    milhar := ',';

  for nI := 1 to length(sString) do
  begin
    x := copy(sString, nI, 1);

    if x = chr(44) then
    begin
      lVirgula := True;
      nPosVirgula := nI;
    end;
    if not lVirgula then
      lNumeroAntes := True;
    if lVirgula then
      nNumeroDepois := nNumeroDepois + 1;
  end;

  if lVirgula then
  begin
    if (nNumeroDepois < 2) and (nNumeroDepois <> -1) then
    begin
      newString := sString + fStrReplicate('0', 2 - nNumeroDepois);
      lChanged  := True;
    end;
    if not lNumeroAntes then
    begin
      newString := '0' + newString;  //..era sString
      lChanged  := True;
    end;
  end
  else
  begin
    if sString <> '' then
      newString := sString + separador + '00'
    else
      newString := '0' + separador + '00';
    lChanged := True;
  end;

  //if length(newString)>=7 then newString:= copy(newString,1,1) + milhar + copy(newString,2,length(newString));

  if lChanged then
    fAjeitaValor := newString
  else
    fAjeitaValor := sString;

end;

//-------------------------------------------------------
function fStringWOPontoOuVirg(sString, tipo: string): string;
var
  nI: integer;
  Aux, x: string;
begin

  for nI := 1 to length(sString) do
  begin
    x := copy(sString, nI, 1);
    // ...
    if (tipo = ',') and (x <> '.') then
      Aux := Aux + x;
    if (tipo = '.') and (x <> ',') then
      Aux := Aux + x;

  end;
  fStringWOPontoOuVirg := Aux;

end;

//-------------------------------------------------------
function fExecFile(const sProgram, sDir, sParams: string; nMode: integer): THandle;
var
  zFileName, zParams, zDir, x: array[0..79] of char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, sProgram),
    StrPCopy(zParams, sParams),
    StrPCopy(zDir, sDir), nMode);
end;

//-------------------------------------------------------
function fTrocaPontoVirgula(sString: string): string;
var
  nI: integer;
  newString: string;
begin
  newString := '';

  for nI := 1 to length(sString) do
    if copy(sString, nI, 1) = ',' then
      newString := newString + '.'
    else if copy(sString, nI, 1) = '.' then
      newString := newString + ','
    else
      newString := newString + copy(sString, nI, 1);
  fTrocaPontoVirgula := newString;
end;
//------------------------------------------------------------------------------
function fTrunca2CasasDecimais(Valor: currency): currency;
begin
  Valor := Valor * 100;
  Valor := TRUNC(Valor);
  Valor := (Valor / 100);
  fTrunca2CasasDecimais := Valor;
end;
//------------------------------------------------------------------------------
function fArredonda2CasasDecimais(Valor: currency): currency;
begin
  Valor := Valor * 100;
  Valor := ROUND(Valor);
  Valor := (Valor / 100);
  fArredonda2CasasDecimais := Valor;
end;
//------------------------------------------------------------------------------
//------------ Funções implementadas--------------------------------------
function Extenso(Mnum: currency): string;

  function NrBaixos(mNumB: integer): string;
  const
    mStrNumB: array[0..18] of pChar =
      ('UM', 'DOIS', 'TRES', 'QUATRO', 'CINCO', 'SEIS',
      'SETE', 'OITO', 'NOVE', 'DEZ', 'ONZE', 'DOZE',
      'TREZE', 'QUATORZE', 'QUINZE', 'DEZESSEIS',
      'DEZESSETE', 'DEZOITO', 'DEZENOVE');
  begin
    Result := mStrNumb[mNumB - 1] + ' ';
  end;

  function Nrmedios(mNumM: integer): string;
  var
    mStrNumM, mStrDig: string;
  begin
    if mNumM < 20 then
      Result := NrBaixos(mNumM)
    else
    begin
      Result   := '';
      mStrDig  := '00' + IntToStr(mNumm);
      mStrDig  := Copy(mStrDig, Length(mStrDig) - 1, 2);
      mStrNumM := 'VINTE    TRINTA    QUARENTA' + 'CINQUENTASESSENTA SETENTA  ' +
        'OITENTA  NOVENTA  ';
      Result   := TrimRight(copy(mStrNumM, ((StrToInt(mStrDig[1]) - 2) * 9) + 1, 9)) + ' ';
      if StrToInt(mStrdig[2]) > 0 then
        Result := Result + 'E ' + NrBaixos(StrToInt(mStrDig[2]));
    end;
  end;

  function NrAltos(mNumA: integer): string;
  var
    mStrNumA, mStrDig: string;
  begin
    if mNumA = 100 then
      Result := 'CEM '
    else
    begin
      Result   := '';
      mStrDig  := '00' + IntToStr(mNumA);
      mStrDig  := Copy(mStrDig, Length(mStrDig) - 2, 3);
      mStrNuma := 'CENTO        DUZENTOS   ' + 'TREZENTOS   QUATROCENTOS' +
        'QUINHENTOS  SEISCENTOS  SETECENTOS  ' + 'OITOCENTOS   NOVECENTOS  ';
      if StrToInt(mStrDig[1]) > 0 then
        Result := TrimRight(copy(mStrNumA, ((StrToInt(mStrdig[1]) - 1) * 12) + 1, 12)) + ' ';
      if StrToInt(copy(mStrdig, 2, 2)) > 0 then
      begin
        if length(Result) > 0 then
          Result := Result + 'E ';
        Result := Result + NrMedios(StrToInt(copy(mStrdig, 2, 2)));
      end;
    end;
  end;

var
  mStrNomes, StrPart, mNumString: string;
  i, numpart, mPos: integer;
  partDec: real;
begin
  Result     := '';
  mNumString := FormatFloat('00000000000000', mNum * 100);
  mStrnomes  := 'BILHAO  BILHOES MILHAO  MILHOES ' + ' MIL    MIL     ';
  for i := 1 to 4 do
  begin
    StrPart := Copy(mNumString, ((i - 1) * 3) + 1, 3);
    numPart := StrToInt(strPart);
    if numPart = 1 then
      mpos := 1
    else
      mpos := 8;
    if numPart > 0 then
    begin
      if Length(Result) > 0 then
        Result := Result + ', ';
      Result := Result + NrAltos(numPart);
      Result := Result + TrimRight(copy(mStrNomes, ((i - 1) * 16) + mpos, 8));
      if not i = 4 then
        Result := Result + ' ';
    end;
  end;
  ;
  if Length(Result) > 0 then
    if Int(mNum) = 1 then
      Result := Result + 'REAL'
    else
      Result := Result + ' REAIS ';
  if frac(mNum) > 0 then
  begin
    if Length(Result) > 0 then
      Result := Result + ' E ';
    PartDec := (mNum - Int(mnum)) * 100;
    numpart := Trunc(partdec);
    if partdec = 1 then
      Result := Result + 'UM CENTAVO '
    else
      Result := Result + Nrmedios(NumPart) + 'CENTAVOS ';
  end;
  Result  := Result + '* * * * * * * * ';
  Extenso := Result;
end;
//------------------------------------------------------------------------------
function FRetornaMes(Num: string): string;
begin
  if (Num = '01') or (Num = '1') then
    FRetornaMes := 'JANEIRO'
  else if (Num = '02') or (Num = '2') then
    FRetornaMes := 'FEVEREIRO'
  else if (Num = '03') or (Num = '3') then
    FRetornaMes := 'MARCO'
  else if (Num = '04') or (Num = '4') then
    FRetornaMes := 'ABRIL'
  else if (Num = '05') or (Num = '5') then
    FRetornaMes := 'MAIO'
  else if (Num = '06') or (Num = '6') then
    FRetornaMes := 'JUNHO'
  else if (Num = '07') or (Num = '7') then
    FRetornaMes := 'JULHO'
  else if (Num = '08') or (Num = '8') then
    FRetornaMes := 'AGOSTO'
  else if (Num = '09') or (Num = '9') then
    FRetornaMes := 'SETEMBRO'
  else if (Num = '10') then
    FRetornaMes := 'OUTUBRO'
  else if (Num = '11') then
    FRetornaMes := 'NOVEMBRO'
  else if (Num = '12') then
    FRetornaMes := 'DEZEMBRO';
end;
//------------------------------------------------------------------------------
function Gera_Digito11(cod: string): string;
var
  iIndice, iSoma, iDigito: integer;
  sDigito: string;
const
  cPesos = '9875432';
begin
  if Length(Cod) <> 7 then
  begin
    Informacao('Código inválido!!!!', 'Aviso...');
    Result := ' ';
    Exit;
  end;

  iSoma := 0;
  for iIndice := 1 to Length(Cod) do
    iSoma := iSoma + (StrToInt(Copy(Cod, iIndice, 1)) *
      StrToInt(Copy(cPesos, iIndice, 1)));

  iDigito := iSoma mod 11;
  iDigito := 11 - iDigito;
  if iDigito > 9 then
    iDigito := StrToInt(Copy(IntToStr(iDigito), 2, 1));

  //if iDigito > 10 then
  //   iDigito := 1;


  str(iDigito: 1, sDigito);
  Result := sDigito;

end;
//-------------------------------------------------------------------------------------------
function Gera_DigFuncionario(cod: string): string;
var
  iIndice, iSoma, iDigito, iDigFunc: integer;
  sDigito: string;
const
  cPesos = '765432';
begin
  if Length(Cod) <> 6 then
  begin
    MessageDlg('Código inválido!!!!', mtWarning, [mbOK], 0);
    Result := ' ';
    Exit;
  end;

  iSoma := 0;
  for iIndice := 1 to Length(Cod) do
    iSoma := iSoma + (StrToInt(Copy(Cod, iIndice, 1)) *
      StrToInt(Copy(cPesos, iIndice, 1)));

  iDigito := iSoma mod 11;
  iDigito := 11 - iDigito;
  if iDigito = 10 then
    iDigFunc := 0
  else if iDigito = 11 then
    iDigFunc := 1
  else
    iDigFunc := iDigito;

  str(iDigFunc: 1, sDigito);
  Result := sDigito;
end;
//--------------------------------------------------------------------------------
function Gera_Digito_Contrato(cod: string): string;
var
  iIndice, iSoma, iDigito: integer;
  sDigito, sContrato: string;
const
  aPesos: array[1..10] of integer = (11, 10, 9, 8, 7, 6, 5, 4, 3, 2);
begin
  sContrato := Trim(Cod);
  if Length(sContrato) <> 10 then
  begin
    MessageDlg('Contrato inválido!!!!', mtWarning, [mbOK], 0);
    Result := ' ';
    Exit;
  end;

  iSoma := 0;
  for iIndice := 1 to Length(sContrato) do
    iSoma := iSoma + (StrToInt(Copy(sContrato, iIndice, 1)) *
      aPesos[iIndice]);

  iDigito := iSoma mod 11;
  iDigito := 11 - iDigito;
  if iDigito >= 10 then
    iDigito := 0;

  str(iDigito: 1, sDigito);
  Result := sDigito;
end;
//---------------------------------------------------------------------------------
function ProximaPrestacao(Dia: TDateTime): TDateTime;
var
  Year, Month, Day, DayAux: word;
begin
  // pega a data
  DecodeDate(Dia, Year, Month, Day);
  if (Month + 1) <= 12 then
  begin
    Month := Month + 1;
    if Day < 29 then
      Result := EncodeDate(Year, Month, Day)
    else if (Day >= 29) and (Day <= 31) then
    begin
      // vai diminuindo o dia até dar
      DayAux := Day;
      while True do
        try
          Result := EncodeDate(Year, Month, DayAux);
          break;
        except
          DayAux := DayAux - 1;
        end;
    end;
  end
  else
  begin
    Month  := 1;
    Year   := Year + 1;
    Result := EncodeDate(Year, Month, Day);
  end;
end;
//---------------------------------------------------------------------------------
end.
