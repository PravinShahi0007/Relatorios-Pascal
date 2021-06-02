unit uFuncoes;

interface

Uses
    SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
    Dialogs, Printers, DB, dbctrls, Stdctrls, Math, uFunc;

{  Functions  }
Function CemExtenso(StrValor: string): string;
Function ValorExtenso(Valor: extended): string;
function AllTrim(OQue : String) : String;
function PadLeft(StrToPad: String; LenToPad: Integer; StrFill: String) : String;
function PadRight(StrToPad: String; LenToPad: Integer; StrFill: String) : String;
Function Space(Numero : Integer) : string;
function ValidaData(sData : String) : Boolean;
function DiadaSemana(Data : TDateTime) : String;
function DiaSemanaAbrev(Data : TDateTime) : String;
function LetraSemana(Data : TDateTime) : String;
function CompData(sDataIni, sDataFim, sMensagem1, sMensagem2 : String) : Boolean;
function MesExtenso(Data : TDateTime) : string;
function Mes(Data : TDateTime) : string;
function NomeEstado(Sigla : String) : String;
function VerificaEstado(Sigla : String) : Boolean;
function ValidaNum(sNum : String) : Boolean;
function Confirma_Exclusao : Boolean;
function Formata_CPFCGC(Valor, Tipo: String) : string;
function Formata_CEP(CEP : String) : string;
function Formata_CFOP(CFOP: String) : string;
function Formata_Codigo_Produto(PRODUTO: String) : string;
function Substitui_Caracteres(Letras : String) : String;
function Verifica_Caracteres(Letras, TipoPessoa : String) : Boolean;
function Ver_Caracteres(Letras, VerBranco : String) : Boolean;
function Verifica_Historico(Letras, VerBranco : String) : Boolean;
function Elimina_Caracteres(Letras, Elimina, Novo : String) : String;
function Conta_Domingos(Dia, Mes, Ano : Integer) : Integer;
function Ultimo_Dia(Mes, Ano : Word) : Word;
//=============================================================
function VerificaFloat(sValor:String) : Boolean;
function VerificaVariavel( Variavel : Variant ) : Boolean;
function BiosDate: String;
function CorrentPrinter :String;
function DateMais(Dat:TDateTime;Numdias:Integer): TDateTime;
function JanelaExiste(Classe,Janela:String) :Boolean;
function DelphiCarregado : Boolean;
function DetectaDrv(const drive : char): boolean;
function DifDateUtil(dataini,datafin:string):integer;
function DifHora(Inicio,Fim : String):String;
function DiscoNoDrive(const drive : char): boolean;
function ExisteInt(Texto:String): Boolean;
function GetDefaultPrinterName : string;
function GetMemoryTotalPhys : DWord;
function IdadeAtual(Nasc : TDate): Integer;
function IdadeN(Nascimento:TDateTime) : String;
function isdigit(c:char):boolean;
function IsPrinter : Boolean;
function MemoryReturn(Categoria: integer): integer;
function NumeroSerie(Unidade:PChar):String;
function CPUSpeed: Double;
function NumeroDeCores : Integer;
function Percentdisk(unidade: byte): Integer;
function SystemDateTime(tDate: TDateTime; tTime: TDateTime): Boolean;
function TestaCgc(xCGC: String):Boolean;
function TestaCPF(xCPF: string) : Boolean;
function validapis(Dado : String) : boolean;
function AnoBis(Data: TDateTime): Boolean;
function mod11( cod: string; flg:longint ):string;
function Gera_Digito11( cod: String ) : String;
function Gera_DigFuncionario( cod: String ) : String;
function Gera_Digito_Contrato( cod: String ) : String;
function Gera_Digito_CtaContabil( cod: String ) : String;
function Pergunta(Mensagem,Cabecalho : String) : Boolean;
function GeraDatas(Data : TDateTime; FatorSoma : Integer ) : TDateTime;
function ValidaHora(sHora :String) : Boolean;
function DifDias(DataVenc:TDateTime; DataAtual:TDateTime): Real;
function Divide(Dividendo, Divisor : Variant): Real;
function Trunca_Numero(Numero : Variant; Decimais : Integer): Real;
function Inteiro(Numero : Variant): String;
function Decimais(Numero : Variant; Decimais : Integer): String;
function iif(Test: boolean; TrueR, FalseR: string): string; overload;
function iif(Test: boolean; TrueR, FalseR: integer): integer; overload;
function iif(Test: boolean; TrueR, FalseR: extended): extended; overload;

{ Procedures }
procedure Adverte(Mensagem,Cabecalho : String);
procedure Informacao(Mensagem,Cabecalho : String);
procedure Ampulheta;
procedure Seta;
procedure Delay(iMSecs: Integer);
procedure TestaData(Campo : TField; sData : String);
procedure Verifica_Data(Campo : TField; sData : String);
procedure Transforma_Hora(var pHora : String; pValor : String; var pHoras : Real; var pMinutos : Real );
procedure Transf_Hora(var pHora : String; pValor : Real; var pHoras : Real; var pMinutos : Real);
function Extenso(Mnum:currency):String;

var resultado : word;
    dDatavalida : TDateTime;
    iNumValido : Integer;
    dHoravalida : TTime;

implementation

//------------ Funções implementadas--------------------------------------
function Extenso(Mnum:currency): String;

    function NrBaixos(mNumB : Integer): String;
    const
         mStrNumB: array[0..18] of pChar = ('UM','DOIS','TRES','QUATRO',
                                            'CINCO','SEIS','SETE','OITO',
                                            'NOVE','DEZ','ONZE','DOZE',
                                            'TREZE','QUATORZE','QUINZE',
                                            'DEZESSEIS','DEZESSETE',
                                            'DEZOITO','DEZENOVE');
     begin
          result := mStrNumb[mNumB -1]+' ';
     end;

     function Nrmedios(mNumM : Integer): String;
     var
        mStrNumM, mStrDig : String;
     begin
          if mNumM < 20 then
             Result := NrBaixos(mNumM)
          else
          begin
               Result := '';
               mStrDig := '00'+IntToStr(mNumm);
               mStrDig := Copy(mStrDig,Length(mStrDig)-1,2);
               mStrNumM := 'VINTE    TRINTA    QUARENTA'+
                           'CINQUENTASESSENTA SETENTA  '+
                           'OITENTA  NOVENTA  ';
               Result := TrimRight(copy(mStrNumM,((StrToInt(mStrDig[1])-2)*9)+1,9))+' ';
               if StrToInt(mStrdig[2]) > 0 then
                  Result := Result + 'E '+ NrBaixos(StrToInt(mStrDig[2]));
          end;
     end;

     function NrAltos(mNumA:Integer): String;
     var
        mStrNumA,mStrDig : String;
     begin
          if mNumA = 100 then
             Result := 'CEM '
          else
          begin
               Result := '';
               mStrDig := '00'+IntToStr(mNumA);
               mStrDig := Copy(mStrDig,Length(mStrDig)-2,3);
               mStrNuma:= 'CENTO       DUZENTOS    TREZENTOS   '+
                          'QUATROCENTOSQUINHENTOS  SEISCENTOS  '+
                          'SETECENTOS  OITOCENTOS  NOVECENTOS  ';
               if StrToint(mStrDig[1]) > 0 then
                  Result := TrimRight(copy(mStrNumA,((StrToInt(mStrdig[1])-1)*12)+1,12))+' ';
               if StrToInt(copy(mStrdig,2,2)) > 0 then
               begin
                    if length(result) > 0 then
                       Result:= Result + 'E ';
                    Result := Result +NrMedios(StrToInt(copy(mStrdig,2,2)));
               end;
          end;
     end;

var
   mStrNomes,StrPart,mNumString: String;
   i, numpart,mPos:integer; partDec: Real;
begin
     Result := '';
     mNumString := FormatFloat('00000000000000',mNum*100);
     mStrnomes := 'BILHAO  BILHOES MILHAO  MILHOES '+
                  ' MIL    MIL     ';
     for i:=1 to 4 do
     begin
          StrPart := Copy(mNumString,((i-1)*3)+1,3);
          numPart := StrToInt(strPart);
          if numPart = 1 then
             mpos := 1
          else
              mpos:= 8;
          if numPart > 0 then
          begin
               if Length(result) > 0 then
                  Result := Result + ', ';
               Result :=Result + NrAltos(numPart);
               Result := Result + TrimRight(copy(mStrNomes,((i-1)*16) + mpos,8));
               if not i = 4 then
                  Result := Result + ' ';
          end;
     end;

     if Length(Result) > 0 then
     begin
          if Int(mNum) =1 then
             Result:=Result + 'REAL'
          else
              result:=Result + ' REAIS ';
     end;

     if frac(mNum) > 0 then
     begin
          if Length(Result)>0 then
             Result:=Result+' E ';
          PartDec:=(mNum - Int(mnum))*100;
          numpart := Trunc(partdec);
          if partdec = 1 then
             Result := Result + 'UM CENTAVO '
          else
              Result:=Result + Nrmedios(NumPart) + 'CENTAVOS ';
     end;

     Result:=Result+'* * * * * * * * ';
     Extenso := Result;
end;

function iif(Test: boolean; TrueR, FalseR: string): string;
begin
    if Test then
        Result := TrueR
    else
        Result := FalseR;
end;

function iif(Test: boolean; TrueR, FalseR: integer): integer;
begin
    if Test then
        Result := TrueR
    else
        Result := FalseR;
end;

function iif(Test: boolean; TrueR, FalseR: extended): extended;
begin
    if Test then
        Result := TrueR
    else
        Result := FalseR;
end;

function CemExtenso(StrValor: string): string;
  const cCent: array[0..8] of string = ('cento', 'duzentos', 'trezentos',
								'quatrocentos', 'quinhentos', 'seicentos',
								'setecentos', 'oitocentos', 'novecentos');
	   cDez: array[0..8] of string = ('dez','vinte','trinta',
							    'quarenta', 'cinquenta', 'sessenta',
							    'setenta', 'oitenta', 'noventa');
	   cVint: array[0..8] of string = ('onze', 'doze', 'treze',
								'quatorze','quinze','dezesseis',
								'dezessete','dezoito','dezenove');
	   cUnit: array[0..8] of string = ('um', 'dois', 'três',
								'quatro', 'cinco', 'seis',
								'sete', 'oito', 'nove');
var iVal: array[0..2] of integer;
	 cExt: string;
	 iCode, iValor: integer;
begin
	cExt := '';
	Val(Copy(StrValor, 1, 1), iVal[0], iCode);
	Val(Copy(StrValor, 2, 1), iVal[1], iCode);
	Val(Copy(StrValor, 3, 1), iVal[2], iCode);
	Val(StrValor, iValor, iCode);
	if iValor > 0 then
	begin
		if iValor = 100 then
			cExt := 'cem'
		else
		begin
			if iVal[0] > 0 then
			begin
				cExt := cCent[iVal[0] - 1];
				if (iVal[1] + iVal[2]) > 0 then
					cExt := cExt + ' e '
				else
					cExt := cExt + ' ';
			end;
			if (iVal[1] = 1) and (iVal[2] > 0) then
				cExt := cExt + cVint[iVal[2] - 1]
			else
			begin
				if iVal[1] > 0 then
				begin
					cExt := cExt + cDez[iVal[1] - 1];
					if iVal[2] > 0 then
						cExt := cExt + ' e '
					else
						cExt := cExt + ' ';
				end;
				if iVal[2] > 0 then
					cExt := cExt + cUnit[iVal[2] - 1];
			end;
		end;
	end;
	CemExtenso := cExt + ' ';
end;

function ValorExtenso(Valor: extended): string;
const cCifra: array[0..5,0..1] of string = (('trilhao', 'trilhoes'),
                                            ('bilhao',  'bilhoes'),
                                            ('milhao',  'milhoes'),
                                            ('mil',     'mil'),
                                            ('',        ''),
                                            ('centavo', 'centavos'));
var iTrilhoes, iBilhoes, iMilhoes, iMilhares, iCentenas, iCentavos, iCode: integer;
	 cExtenso, cStr, cTrilhoes, cBilhoes, cMilhoes, cMilhares, cCentenas, cCentavos: string;
begin
	cExtenso := '';
	if Valor > 0.0 then
	begin
		cStr := FormatFloat ('000000000000000.00', Valor);
		cTrilhoes := Copy(cStr,  1, 3);
		cBilhoes  := Copy(cStr,  4, 3);
		cMilhoes  := Copy(cStr,  7, 3);
		cMilhares := Copy(cStr, 10, 3);
		cCentenas := Copy(cStr, 13, 3);
		cCentavos := Copy(cStr, 17, 2);
		Val(cTrilhoes, iTrilhoes, iCode);
		Val(cBilhoes,  iBilhoes, iCode);
		Val(cMilhoes,  iMilhoes, iCode);
		Val(cMilhares, iMilhares, iCode);
		Val(cCentenas, iCentenas, iCode);
		Val(cCentavos, iCentavos, iCode);
		if iTrilhoes > 0 then
		begin
			cExtenso := CemExtenso (cTrilhoes);
			if iTrilhoes = 1 then
				cExtenso := cExtenso + cCifra[0][0]
			else
				cExtenso := cExtenso + cCifra[0][1];
			if ((iBilhoes = 0) and (iMilhoes = 0) and (iMilhares = 0) and (iCentenas = 0)) then
				cExtenso := cExtenso + ' de '
			else
			begin
				if (((iBilhoes > 0) and (iMilhoes = 0) and (iMilhares = 0) and (iCentenas = 0) and (iCentavos = 0)) or
					((iMilhoes > 0) and (iBilhoes = 0) and (iMilhares = 0) and (iCentenas = 0) and (iCentavos = 0)) or
					((iMilhares > 0) and (iBilhoes = 0) and (iMilhoes = 0) and (iCentenas = 0) and (iCentavos = 0)) or
					((iCentenas > 0) and (iBilhoes = 0) and (iMilhoes = 0) and (iMilhares = 0) and (iCentavos = 0)) or
					((iCentavos > 0) and (iBilhoes = 0) and (iMilhoes = 0) and (iMilhares = 0) and (iCentenas = 0))) then
					cExtenso := cExtenso + ' e '
				else
					cExtenso := cExtenso + ', ';
			end;
		end;
		if iBilhoes > 0 then
		begin
			cExtenso := cExtenso + CemExtenso (cBilhoes);
			if iBilhoes = 1 then
				cExtenso := cExtenso + cCifra[1][0]
			else
				cExtenso := cExtenso + cCifra[1][1];
			if ((iMilhoes = 0) and (iMilhares = 0) and (iCentenas = 0)) then
				cExtenso := cExtenso + ' de '
			else
			begin
				if (((iMilhoes > 0) and (iMilhares = 0) and (iCentenas = 0) and (iCentavos = 0)) or
					((iMilhares > 0) and (iMilhoes = 0) and (iCentenas = 0) and (iCentavos = 0)) or
					((iCentenas > 0) and (iMilhoes = 0) and (iMilhares = 0) and (iCentavos = 0)) or
					((iCentavos > 0) and (iMilhoes = 0) and (iMilhares = 0) and (iCentenas = 0))) then
					cExtenso := cExtenso + ' e '
				else
					cExtenso := cExtenso + ', ';
			end;
		end;
		if iMilhoes > 0 then
		begin
			cExtenso := cExtenso + CemExtenso (cMilhoes);
			if iMilhoes = 1 then
				cExtenso := cExtenso + cCifra[2][0]
			else
				cExtenso := cExtenso + cCifra[2][1];
			if ((iMilhares = 0) and (iCentenas = 0)) then
				cExtenso := cExtenso + ' de '
			else
			begin
				if (((iMilhares > 0) and (iCentenas = 0) and (iCentavos = 0)) or
                                    ((iCentenas > 0) and (iMilhares = 0) and (iCentavos = 0)) or
                                    ((iCentavos > 0) and (iMilhares = 0) and (iCentenas = 0))) then
                                      cExtenso := cExtenso + ' e '
				else
					cExtenso := cExtenso + ', ';
			end;
		end;
		if iMilhares > 0 then
		begin
			cExtenso := cExtenso + CemExtenso (cMilhares);
			if iMilhares = 1 then
				cExtenso := cExtenso + cCifra[3][0]
			else
				cExtenso := cExtenso + cCifra[3][1];
			if (iCentenas = 0) then
				cExtenso := cExtenso + ' '
			else
			begin
				if (((iCentenas > 0) and (iCentavos = 0)) or
					((iCentavos > 0) and (iCentenas = 0))) then
					cExtenso := cExtenso + ' e '
				else
					cExtenso := cExtenso + ', ';
			end;
		end;
		if iCentenas > 0 then
		begin
			cExtenso := cExtenso + CemExtenso (cCentenas);
			if iMilhares = 1 then
				cExtenso := cExtenso + cCifra[4][0]
			else
				cExtenso := cExtenso + cCifra[4][1];
		end;
		if ((iTrilhoes > 0) or (iBilhoes > 0) or (iMilhoes > 0) or (iMilhares > 0) or (iCentenas > 0)) then
		begin
			if Valor >= 2.0 then
				cExtenso := cExtenso + 'reais'
			else
				cExtenso := cExtenso + 'real';
			if iCentavos > 0 then
				cExtenso := cExtenso + ' e '
			else
				cExtenso := cExtenso + '';
			if iCentavos > 0 then
			begin
				cCentavos := FormatFloat('000', iCentavos);
				cExtenso := cExtenso + CemExtenso(cCentavos);
				if iCentavos = 1 then
					cExtenso := cExtenso + cCifra[5][0]
				else
					cExtenso := cExtenso + cCifra[5][1];
				if Valor < 1.0 then
					cExtenso := cExtenso + ' de real'
				else
					cExtenso := cExtenso + '';
			end;
		end;
	end;
	ValorExtenso := AnsiUpperCase (cExtenso);
end;
{-----------------------------------------------------------------------------}
{ Função : retira todos os em brancos da string                               }
{ Parametros : OQue - string que será retirado os brancos                     }
{ Retorno :  String                                                           }
{-----------------------------------------------------------------------------}
function AllTrim(OQue : String) : String;
Begin
     While Pos(' ',OQue) > 0 do
           Delete(OQue,Pos(' ',OQue),1);
     result := OQue;
end;

{-----------------------------------------------------------------------------}
{ Função : Abrir janela de mensagem com o ícone de advertência                }
{ Parametros : mensagem - string que conterá a mensagem                       }
{              cabecalho - cabecalho da caixa, vazio será assumido "Atenção"  }
{-----------------------------------------------------------------------------}
Procedure Adverte(Mensagem,Cabecalho : String);
Begin
     if cabecalho = '' then
        cabecalho := 'Atenção';

     MessageBeep(MB_ICONASTERISK);
     resultado := Application.MessageBox(Pchar(Mensagem),PChar(Cabecalho),
                  MB_APPLMODAL+MB_OK+MB_ICONWARNING);
end;
{-----------------------------------------------------------------------------}
{ Função : Abrir janela de mensagem com o ícone de informação                 }
{ Parametros : mensagem - string que conterá a mensagem                       }
{              cabecalho - cabecalho da caixa, vazio será assumido "Atenção"  }
{-----------------------------------------------------------------------------}
Procedure Informacao(Mensagem,Cabecalho : String);
Begin
     if cabecalho = '' then
        cabecalho := 'Informação';
     resultado := Application.MessageBox(Pchar(Mensagem),PChar(Cabecalho),
                  MB_APPLMODAL+MB_OK+MB_ICONEXCLAMATION);
end;

{-----------------------------------------------------------------------------}
{ Função : Abrir janela de mensagem com o ícone de pergunta                   }
{ Parametros : mensagem - string que conterá a mensagem                       }
{              cabecalho - cabecalho da caixa, vazio será assumido "Pergunta" }
{-----------------------------------------------------------------------------}
function Pergunta(Mensagem,Cabecalho : String) : Boolean;
Begin
     if cabecalho = '' then
        cabecalho := 'Pergunta...';

     if Application.MessageBox(Pchar(Mensagem),PChar(Cabecalho),
                               MB_APPLMODAL+MB_ICONQUESTION+MB_DEFBUTTON2+
                               MB_YESNO) = IDNO THEN
        Result := False
     else
         Result := True;
end;

{-----------------------------------------------------------------------------}
{ Função : retira todos os caracteres da esquerda da string                   }
{ Parametros : StrToPad - String para retirar os caracteres,                  }
{ LenToPad - tamanho para ser retirado, StrFill - caracter para ser eliminado }
{ Retorno :  String                                                           }
{-----------------------------------------------------------------------------}
function PadLeft(StrToPad: String; LenToPad: Integer; StrFill: String) : String;
var
   cStr : String;
   iCont, iLimite: Integer;
begin
     cStr := '';
     iLimite := LenToPad - Length(StrToPad);
     if LenToPad > Length(StrToPad) then
        for iCont := 1 to iLimite do
            cStr := cStr + StrFill;
     PadLeft := cStr + StrToPad;
end;

{-----------------------------------------------------------------------------}
{ Função : retira todos os caracteres da direita da string                    }
{ Parametros : StrToPad - String para retirar os caracteres,                  }
{ LenToPad - tamanho para ser retirado, StrFill - caracter para ser eliminado }
{ Retorno :  String                                                           }
{-----------------------------------------------------------------------------}
function PadRight(StrToPad: String; LenToPad: Integer; StrFill: String) : String;
var
   cStr : String;
   iCont, iLimite: Integer;
begin
     cStr := '';
     iLimite := LenToPad - Length(StrToPad);
     if LenToPad > Length(StrToPad) then
        for iCont := 1 to iLimite do
            cStr := cStr + StrFill;
     PadRight := StrToPad + cStr;
end;

{-----------------------------------------------------------------------------}
{ Validar Datas                                                               }
{ Parametros :  DATA - string que conterá a daa que será avaliada             }
{ Retorno : Boolean - TRUE se Inválida                                        }
{-----------------------------------------------------------------------------}
function ValidaData(sData :String) : Boolean;
Begin
     Result := False;  // se a data for válida retorna FALSE
     if AllTrim(sData) <> '//' then
     begin
         Try
            dDatavalida := StrToDate(sData);
         Except on EConvertError do
            begin
                 ShowMessage('Data Inválida!');
                 Result := True; // se a data for inválida retorna TRUE
            end;
         end;
     end;
end;

{-----------------------------------------------------------------------------}
{ Retorna o dia da semana                                                     }
{ Parametros :  DATA - Data atual                                             }
{ Retorno : string com o dia da semana                                        }
{-----------------------------------------------------------------------------}
function DiadaSemana(Data : TDateTime) : String;
Var
   i : integer;
Const
     cSemana : Array[1..7] of string = ( 'Domingo','Segunda-Feira',
                                         'Terca-Feira','Quarta-Feira',
                                         'Quinta-Feira','Sexta-Feira',
                                         'Sabado' );
Begin
     i := DayOfWeek(Data);
     if i = 0 then
     begin
          Result := 'Dia inválido!!!';
          Exit;
     end;
     Result := cSemana[i];
end;

function LetraSemana(Data : TDateTime) : String;
Var
   i : integer;
Const
     cSemana : Array[1..7] of string = ( 'D','S','T','Q','U','E','A' );
Begin
     i := DayOfWeek(Data);
     if i = 0 then
     begin
          Result := 'Dia inválido!!!';
          Exit;
     end;
     Result := cSemana[i];
end;

{-----------------------------------------------------------------------------}
{ Retorna a abreviatura do dia da semana                                      }
{ Parametros :  DATA - Data atual                                             }
{ Retorno : string com a abreviatura do dia da semana                         }
{-----------------------------------------------------------------------------}
function DiaSemanaAbrev(Data : TDateTime) : String;
Var
   i : integer;
Const
     cSemana : Array[1..7] of string = ( 'Dom','Seg','Ter','Qua','Qui','Sex',
                                         'Sab' );
Begin
     i := DayOfWeek(Data);
     if i = 0 then
     begin
          Result := 'Dia inválido!!!';
          Exit;
     end;
     Result := cSemana[i];
end;

function Space(Numero : Integer) : String;
var
   sSpace : String;
   i : Integer;
begin
     sSpace := '';
     for i := 1 to Numero do
         sSpace := sSpace + ' ';
     Result := sSpace;
end;

{------------------------------------------------------------------------------}
{ Testar se a Data Final é menor que a Data Inicial                            }
{ Parametros :  sDataIni - string que contera a data inicial                   }
{               sDataFim - string que contera a data final                     }
{ Retorno : Boolean - TRUE se Data Final menor  que inicial                    }
{------------------------------------------------------------------------------}
function CompData(sDataIni, sDataFim, sMensagem1, sMensagem2 : String) : Boolean;
Begin
     Result := FALSE; // se a data inicial maior que a data final
     if (alltrim(sDataIni) <> '//') and (alltrim(sDataIni) <> '//') then
     begin
          if StrToDate(sDataIni) > StrToDate(sDataFim) then
          begin
              Adverte(sMensagem2+' '+'deve ser maior que '+' '+sMensagem1,'');
              Result := True; // se a data inicial menor que a data final
          end;
     end;
end;

{------------------------------------------------------------------------------}
{ Retornar o mes por extenso                                                   }
{ Parametros :  Data - data atual                                              }
{ Retorno : string com o mes                                                   }
{------------------------------------------------------------------------------}
function MesExtenso(Data : TDateTime) : string;
var
   wDia, wMes, wAno : Word;
Const
     cMeses : Array[1..12] of String = ( 'Janeiro','Fevereiro','Marco',
                                         'Abril','Maio','Junho','Julho',
                                         'Agosto','Setembro','Outubro',
                                         'Novembro','Dezembro' );
begin
     DecodeDate(Data, wDia, wMes, wAno);
     Result := cMeses[wMes];
end;

{------------------------------------------------------------------------------}
{ Retornar a sigla do mes                                                      }
{ Parametros :  Data - Data atual                                              }
{ Retorno : string com a sigla do mes                                          }
{------------------------------------------------------------------------------}
function Mes(Data : TDateTime) : string;
var
   wDia, wMes, wAno : Word;
Const
     cMeses : Array[1..12] of String = ( 'JAN','FEV','MAR','ABR','MAI','JUN',
                                         'JUL','AGO','SET','OUT','NOV','DEZ' );
begin
     DecodeDate(Data, wDia, wMes, wAno);
     Result := cMeses[wMes];
end;

{--------------------------------------------------------------------------}
{ Retornar o nome do estado por extenso                                    }
{ Parametros :  Sigla - string que conterá a sigla do estado               }
{ Retorno : String com o nome do estado                                    }
{--------------------------------------------------------------------------}
function NomeEstado(Sigla : String) : String;
var
   iPosicao, iIndice : Integer;
Const
     cEstados : Array[1..29] of String = ( 'Acre','Alagoas','Amazonas','Amapá',
                                           'Bahia','Ceará','Distrito Federal',
                                           'Espírito Santo','Goiás','Maranhão',
                                           'Minas Gerais','Mato Grosso do Sul',
                                           'Mato Grosso','Para','Paraíba',
                                           'Pernambuco','Piaui','Paraná',
                                           'Rio de Janeiro','Rondônia',
                                           'Rio Grande do Norte','Roraima',
                                           'Rio Grande do Sul','Santa Catarina',
                                           'Sergipe','São Paulo','Tocantins',
                                           'Fernando de Noronha', 'Estrangeiro' );
     cSiglas : Array[1..29] of String =  ( 'AC','AL','AM','AP','BA','CE','DF',
                                           'ES','GO','MA','MG','MS','MT','PA',
                                           'PB','PE','PI','PR','RJ','RO','RN',
                                           'RR','RS','SC','SE','SP','TO','FN',
                                           'EX' );
begin
     iPosicao := 0;
     for iIndice := 1 to High(cSiglas) do
     begin
          if cSiglas[iIndice] = Sigla then
             iPosicao := iIndice;
     end;
     if iPosicao = 0 then
        Result := 'Sigla de estado inválida!'
     else
         Result := cEstados[iPosicao];
end;

{----------------------------------------------------------------------------}
{ Verifica se o estado é valido ou não                                       }
{ Parametros : Sigla - string que conterá a sigla do estado                  }
{ Retorno : Booleano - se TRUE estado OK, se FALSE estado invalido           }
{----------------------------------------------------------------------------}
function VerificaEstado(Sigla : String) : Boolean;
var
   iPosicao, iIndice : Integer;
Const
     cSiglas : Array[1..29] of String =  ( 'AC','AL','AM','AP','BA','CE','DF',
                                           'ES','GO','MA','MG','MS','MT','PA',
                                           'PB','PE','PI','PR','RJ','RO','RN',
                                           'RR','RS','SC','SE','SP','TO','FN',
                                           'EX' );
begin
     iPosicao := 0;
     for iIndice := 1 to High(cSiglas) do
     begin
          if cSiglas[iIndice] = Sigla then
             iPosicao := iIndice;
     end;
     if iPosicao = 0 then
        Result := False
     else
         Result := True;
end;

{--------------------------------------------------------------------------}
{ Validar Numeros                                                          }
{ Parametros :  NUM - string que conterá numero que será avaliado          }
{ Retorno : Boolean - TRUE se Inválido                                     }
{--------------------------------------------------------------------------}
function ValidaNum(sNum :String) : Boolean;
Begin
     Result := False;  // se numero for válido retorna FALSE
     if AllTrim(sNum) <> '' then
     begin
         Try
            iNumValido := StrToInt(sNum);
         Except on EConvertError do
         begin
             Result := True; // se numero for inválido retorna TRUE
         end;
         end;
     end;
end;

Function Confirma_Exclusao : Boolean;
begin
     if Application.MessageBox('Confirma Exclusão do Registro?','Confirmação',
                               MB_APPLMODAL+MB_ICONQUESTION+MB_DEFBUTTON2+
                               MB_OKCANCEL) = IDCANCEL THEN
        Result := False
     else
         Result := True;
end;

Procedure Ampulheta;
Begin
     Screen.Cursor:=crHourGlass;
end;

Procedure Seta;
Begin
     Screen.Cursor:=crDefault;
end;

// Tipo: F- Fisica - CPF
//       J- Juridica - CGC
function Formata_CPFCGC(Valor, Tipo: String) : string;
begin
     if Tipo = 'F' then
     begin
          Result := Copy(Valor,1,3)+'.'+Copy(Valor,4,3)+'.'+
                    Copy(Valor,7,3)+'-'+Copy(Valor,10,2);
     end
     else
     begin
          Result := Copy(Valor,1,2)+'.'+Copy(Valor,3,3)+'.'+
                    Copy(Valor,6,3)+'/'+Copy(Valor,9,4)+'-'+
                    Copy(Valor,13,2);
     end;
end;

function Formata_CEP(CEP: String) : string;
begin
     Result := Copy(CEP,1,5)+'-'+Copy(CEP,6,3);
end;

function Formata_CFOP(CFOP: String) : string;
begin
     Result := Copy(CFOP,1,1)+'.'+Copy(CFOP,2,2);
end;

function Formata_Codigo_Produto(PRODUTO: String) : string;
begin
     Result := Copy(PRODUTO,1,2)+'.'+Copy(PRODUTO,3,2)+'.'+
               Copy(PRODUTO,5,2)+'.'+Copy(PRODUTO,7,2)+'.'+Copy(PRODUTO,9,1);
end;

//=======================================================================
//=======================================================================
//=======================================================================
//=======================================================================
// Retorna a data da fabricação do Chip da Bios do sistema
function BiosDate: String;
begin
     result := string(pchar(ptr($FFFF5)));
end;

// Retorna a impressora padrão do windows
// Requer a unit printers declarada na clausula uses da unit
function CorrentPrinter :String;
var
   Device : array[0..255] of char;
   Driver : array[0..255] of char;
   Port   : array[0..255] of char;
   hDMode : THandle;
begin
     Printer.GetPrinter(Device, Driver, Port, hDMode);
     Result := Device+' na porta '+Port;
end;

{ Soma um determinado número de dias a uma data }
function DateMais(Dat:TDateTime;Numdias:Integer): TDateTime;
begin
     Dat := Dat + Numdias;
     Result := Dat;
end;

{ Estas funções servem para verificar
 se o delphi está carregado ou não}
Function JanelaExiste(Classe,Janela:String) :Boolean;
var
   PClasse,PJanela : array[0..79] of char;
begin
     if Classe = '' then
        PClasse[0] := #0
     else
         StrPCopy(PClasse,Classe);
     if Janela = '' then
        PJanela[0] := #0
     else
         StrPCopy(PJanela,Janela);
     if FindWindow(PClasse,PJAnela) <> 0 then
        result := true
     else
         Result := false;
end;

Function DelphiCarregado : Boolean;
begin
//     Result :=  False;
     if JanelaExiste('TPropertyInspector','Object Inspector') then
     begin
          result := True;
     end
     else
     begin
          result := False;
     end;
end;

(*{ No evento OnCreate do form coloque:}
if not DelphiCarregado then
   showmessage('Delphi está ativo, bom menino!')
else
begin
     Showmessage('Vc não poderá utilizar esta aplicação! Mau garoto!');
     application.terminate;
end;*)

{Detecta quantas unidade possui no computador}
function DetectaDrv(const drive : char): boolean;
var
   Letra: string;
begin
     Letra := drive + ':\';
     if GetDriveType(PChar(Letra)) < 2 then
     begin
          result := False;
     end
     else
     begin
          result := True;
     end;
end;

// Retorna quantos dias tem um referido mes do ano


{Retorna a quantidade de dias uteis entre duas datas}
function DifDateUtil(dataini,datafin:string):integer;
var a,b,c:tdatetime;
    ct,s:integer;
begin
     if StrToDate(DataFin) < StrtoDate(DataIni) then
     begin
          Result := 0;
          exit;
     end;
     ct := 0;
     s := 1;
     a := strtodate(dataFin);
     b := strtodate(dataIni);
     if a > b then
     begin
          c := a;
          a := b;
          b := c;
          s := 1;
     end;
     a := a + 1;
     while (dayofweek(a)<>2) and (a <= b) do
     begin
          if dayofweek(a) in [2..6] then
          begin
               inc(ct);
          end;
          a := a + 1;
     end;
     ct := ct + round((5*int((b-a)/7)));
     a := a + (7*int((b-a)/7));
     while a <= b do
     begin
          if dayofweek(a) in [2..6] then
          begin
               inc(ct);
          end;
          a := a + 1;
     end;
     if ct < 0 then
     begin
          ct := 0;
     end;
     result := s*ct;
end;

{Retorna a diferença entre duas horas}
function DifHora(Inicio,Fim : String):String;
var
   FIni,FFim : TDateTime;
begin
     Fini := StrTotime(Inicio);
     FFim := StrToTime(Fim);
     If (Inicio > Fim) then
     begin
          Result := TimeToStr((StrTotime('23:59:59')-Fini)+FFim)
     end
     else
     begin
          Result := TimeToStr(FFim-Fini);
     end;
end;

{Detecta se há disco no Drive}
function DiscoNoDrive(const drive : char): boolean;
var
   DriveNumero : byte;
   EMode : word;
begin
     EMode := 0;
     result := false;
     DriveNumero := ord(Drive);
     if DriveNumero >= ord('a') then
     begin
          dec(DriveNumero,$20);
          EMode := SetErrorMode(SEM_FAILCRITICALERRORS);
     end;
     try
        if DiskSize(DriveNumero-$40) = -1 then
        begin
             Result := False;
        end
        else
        begin
             Result := True;
        end;
     Except
           SetErrorMode(EMode);
     end;
end;

{Testa se em uma string existe um numero inteiro valido ou não}
function ExisteInt(Texto:String): Boolean;
var
   i, iIndice :integer;
   bResultado : Boolean;
begin
     for iIndice := 1 to Length(Trim(Texto)) do
     begin
          i := 0;
          //bResultado := (Copy(Texto,iIndice,1) in ['0','1','2','3','4','5','6','7','8','9']);

          try
             i := StrToInt(Copy(Texto,iIndice,1));
             bResultado := True;
          except
               begin
                    bResultado := False;
                    Break;
               end
          end;
          if i>0 then
             i := 1;
     end;
     Result := bResultado;
end;

// Retorna o nome da impressora padrão do Windows
function GetDefaultPrinterName : string;
begin
     if(Printer.PrinterIndex > 0)then
     begin
          Result := Printer.Printers[Printer.PrinterIndex];
     end
     else
     begin
          Result := 'Nenhuma impressora Padrão foi detectada';
     end;
end;

// Retorna o total de memoria do computador
function GetMemoryTotalPhys : DWord;
var
   ms : TMemoryStatus;
begin
     ms.dwLength := SizeOf( ms );
     GlobalMemoryStatus( ms );
     Result := ms.dwTotalPhys;
end;

// Retorna a idade Atual de uma pessoa a partir da data de nascimento
// Esta função retorna a idade em formato integer
function IdadeAtual(Nasc : TDate): Integer;
Var AuxIdade, Meses : String;
    MesesFloat : Real;
    IdadeInc, IdadeReal : Integer;
begin
     AuxIdade := Format('%0.2f', [(Date - Nasc) / 365.6]);
     Meses := FloatToStr(Frac(StrToFloat(AuxIdade)));
     if AuxIdade = '0' then
     begin
          Result := 0;
          Exit;
     end;
     if Meses[1] = '-' then
     begin
          Meses := FloatToStr(StrToFloat(Meses) * -1);
     end;
     Delete(Meses, 1, 2);
     if Length(Meses) = 1 then
     begin
          Meses := Meses + '0';
     end;
     if (Meses <> '0') And (Meses <> '') then
     begin
          MesesFloat := Round(((365.6 * StrToInt(Meses)) / 100) / 30.47)
     end
     else
     begin
          MesesFloat := 0;
     end;
     if MesesFloat <> 12 then
     begin
          IdadeReal := Trunc(StrToFloat(AuxIdade)); // + MesesFloat;
     end
     else
     begin
          IdadeInc := Trunc(StrToFloat(AuxIdade));
          Inc(IdadeInc);
          IdadeReal := IdadeInc;
     end;
     Result := IdadeReal;
end;

// Retorna a idade de uma pessoa a partir da data de nascimento
function IdadeN(Nascimento:TDateTime) : String;
Type
    Data = Record
           Ano : Word;
           Mes : Word;
           Dia : Word;
    End;
Const
     Qdm:String = '312831303130313130313031'; // Qtde dia no mes
Var
   Dth : Data;                         // Data de hoje
   Dtn : Data;                         // Data de nascimento
   anos, meses, dias, nrd : Shortint;  // Usadas para calculo da idade
begin
     DecodeDate(Date,Dth.Ano,Dth.Mes,Dth.Dia);
     DecodeDate(Nascimento,Dtn.Ano,Dtn.Mes,Dtn.Dia);
     anos := Dth.Ano - Dtn.Ano;
     meses := Dth.Mes - Dtn.Mes;
     if meses < 0 then
     begin
          Dec(anos);
          meses := meses+12;
     end;
     dias := Dth.Dia - Dtn.Dia;
     if dias < 0 then
     begin
          nrd := StrToInt(Copy(Qdm,(Dth.Mes-1)*2-1,2));
          if ((Dth.Mes-1)=2) and ((Dth.Ano Div 4)=0) then
          begin
               Inc(nrd);
          end;
          dias := dias+nrd;
          meses := meses-1;
     end;
     Result := IntToStr(anos)+' Anos '+IntToStr(meses)+
               ' Meses '+IntToStr(dias)+' Dias';
end;

// Testa se o dado é um digito (numero) ou
// um caractere qualquer
function isdigit(c:char):boolean;
begin
     result := c in ['0'..'9']
end;

{Testa se a impressora está ativa ou não, retornando .t.
 em caso positivo}
function IsPrinter : Boolean;
Const
    PrnStInt  : Byte = $17;
    StRq      : Byte = $02;
    PrnNum    : Word = 0;  { 0 para LPT1, 1 para LPT2, etc. }
Var
   nResult : byte;
Begin  (* IsPrinter*)
     Asm
        mov ah,StRq;
        mov dx,PrnNum;
        Int $17;
        mov nResult,ah;
     end;
     IsPrinter := (nResult and $80) = $80;
End;

// Retorna a memoria do sistema
// voce pode usar a tabela abaixo para fazer as devidas modificações
Function MemoryReturn(Categoria: integer): integer;
var
   MemoryStatus: TMemoryStatus;
   Retval : Integer;
begin
     RetVal := 0;
     MemoryStatus.dwLength:= sizeof(MemoryStatus);
     GlobalMemoryStatus(MemoryStatus);
     if categoria > 8 then
     begin
          Retval := 0;
     end;
     case categoria of
          1: Retval := MemoryStatus.dwTotalPhys;     // bytes de memória física
          2: Retval := MemoryStatus.dwLength;        // sizeof(MEMORYSTATUS)
          3: Retval := MemoryStatus.dwMemoryLoad;    // percentual de memória em uso
          4: Retval := MemoryStatus.dwAvailPhys;     // bytes livres de memória física
          5: Retval := MemoryStatus.dwTotalPageFile; // bytes de paginação de arquivo
          6: Retval := MemoryStatus.dwAvailPageFile; // bytes livres de paginação de arquivo
          7: Retval := MemoryStatus.dwTotalVirtual;  // bytes em uso de espaço de endereço
          8: Retval := MemoryStatus.dwAvailVirtual;  // bytes livres
     end;
     result := Retval;
end;

{Retorna o Número serial da unidade especificada}
function NumeroSerie(Unidade:PChar):String;
var
   VolName,SysName : AnsiString;
   SerialNo,MaxCLength,FileFlags : DWord;
begin
     try
        SetLength(VolName,255);
        SetLength(SysName,255);
        GetVolumeInformation(Unidade,PChar(VolName),255,@SerialNo,
        MaxCLength,FileFlags,PChar(SysName),255);
        result := IntToHex(SerialNo,8);
     except
           result := ' ';
     end;
end;

{Retorna a porcentagem de espaço livre em uma unidade de disco}
function Percentdisk(unidade: byte): Integer;
var
   A,B, Percentual : longint;
begin
     if DiskFree(Unidade)<> -1 then
     begin
          A := DiskFree(Unidade) div 1024;
          B := DiskSize(Unidade) div 1024;
          Percentual:=(A*100) div B;
          result := Percentual;
     end
     else
     begin
          result := -1;
     end;
end;

{Permite que você altere a data e a hora do sistema}
function SystemDateTime(tDate: TDateTime; tTime: TDateTime): Boolean;
var
   tSetDate: TDateTime;
   vDateBias: Variant;
   tSetTime: TDateTime;
   vTimeBias: Variant;
   tTZI: TTimeZoneInformation;
   tST: TSystemTime;
begin
     GetTimeZoneInformation(tTZI);
     vDateBias := tTZI.Bias / 1440;
     tSetDate := tDate + vDateBias;
     vTimeBias := tTZI.Bias / 1440;
     tSetTime := tTime + vTimeBias;
     with tST do
     begin
          wYear := StrToInt(FormatDateTime('yyyy', tSetDate));
          wMonth := StrToInt(FormatDateTime('mm', tSetDate));
          wDay := StrToInt(FormatDateTime('dd', tSetDate));
          wHour := StrToInt(FormatDateTime('hh', tSettime));
          wMinute := StrToInt(FormatDateTime('nn', tSettime));
          wSecond := StrToInt(FormatDateTime('ss', tSettime));
          wMilliseconds := 0;
     end;
     SystemDateTime := SetSystemTime(tST);
end;

{Testa se o CGC é válido ou não}
function TestaCgc(xCGC: String):Boolean;
Var
   d1,d4,xx,nCount,fator,resto,digito1,digito2 : Integer;
   Check : String;
   LocalResult : Boolean;
begin
     d1 := 0;
     d4 := 0;
     xx := 1;
     for nCount := 1 to Length( xCGC )-2 do
     begin
          if Pos( Copy( xCGC, nCount, 1 ), '/-.' ) = 0 then
          begin
               if xx < 5 then
               begin
                    fator := 6 - xx;
               end
               else
               begin
                    fator := 14 - xx;
               end;
               d1 := d1 + StrToInt( Copy( xCGC, nCount, 1 ) ) * fator;
               if xx < 6 then
               begin
                    fator := 7 - xx;
               end
               else
               begin
                    fator := 15 - xx;
               end;
               d4 := d4 + StrToInt( Copy( xCGC, nCount, 1 ) ) * fator;
               xx := xx+1;
          end;
     end;
     resto := (d1 mod 11);
     if resto < 2 then
     begin
          digito1 := 0;
     end
     else
     begin
          digito1 := 11 - resto;
     end;
     d4 := d4 + 2 * digito1;
     resto := (d4 mod 11);
     if resto < 2 then
     begin
          digito2 := 0;
     end
     else
     begin
          digito2 := 11 - resto;
     end;
     Check := IntToStr(Digito1) + IntToStr(Digito2);
     if Check <> copy(xCGC,succ(length(xCGC)-2),2) then
     begin
          LocalResult := False;
     end
     else
     begin
          LocalResult := True;
     end;

    if localResult then
       localResult := not ((Length(Trim(xCGC)) <> 14) or
                           (Trim(xCGC) = '11111111111111') or
                           (Trim(xCGC) = '22222222222222') or
                           (Trim(xCGC) = '33333333333333') or
                           (Trim(xCGC) = '44444444444444') or
                           (Trim(xCGC) = '55555555555555') or
                           (Trim(xCGC) = '66666666666666') or
                           (Trim(xCGC) = '77777777777777') or
                           (Trim(xCGC) = '88888888888888') or
                           (Trim(xCGC) = '99999999999999') or
                           (Trim(xCGC) = '00000000000000'));

     Result := LocalResult;
end;

{Testa se o número do pis é válido ou não}
function validapis(Dado : String) : boolean;
var
   i, wsoma, Wm11, Wdv,wdigito : Integer;
begin
     if AllTrim(Dado) <> '' Then
     begin
          wdv := strtoint(copy(Dado, 11, 1));
          wsoma := 0;
          wm11 := 2;
          for i := 1 to 10 do
          begin
               wsoma := wsoma + (wm11 *strtoint(copy(Dado,11 - I, 1)));
               if wm11 < 9 then
               begin
                    wm11 := wm11+1
               end
               else
               begin
                    wm11 := 2;
               end;
          end;
          wdigito := 11 - (wsoma MOD 11);
          if wdigito > 9 then
          begin
               wdigito := 0;
          end;
          if wdv = wdigito then
          begin
               validapis := true;
          end
          else
          begin
               validapis := false;
          end;
     end;
end;

{Testa se um ano é bixesto, retornando True em caso positivo}
function AnoBis(Data: TDateTime): Boolean;
var
   Dia,Mes,Ano : Word;
begin
     DecodeDate(Data,Ano,Mes,Dia);
     if Ano mod 4 <> 0 then
     begin
          AnoBis := False;
     end
     else if Ano mod 100 <> 0 then
     begin
          AnoBis := True;
     end
     else if Ano mod 400 <> 0 then
     begin
          AnoBis := False;
     end
     else
     begin
          AnoBis := True;
     end;
end;

//
// Promove um estado de espera no aplicativo
//
procedure Delay(iMSecs: Integer);
var
   lnTickCount: LongInt;
begin
     lnTickCount := GetTickCount;
     repeat
           Application.ProcessMessages;
     until ((GetTickCount - lnTickCount) >= LongInt(iMSecs));
end;

function mod11( cod: string; flg:longint ):string;
var f ,C,CD, SCHK : integer;
    aa,cc:string;
begin
     schk := 0;
     CD   := 0;
     C := 1;
     COD:=TRIM(COD);

        {FLG=0 só retorna DC não avisa se esta incorreto}
        {FLG=1 retorna DC e avisa se incorreto}
 	{FLG=3 recebeu so numero s/codigo}


     if FLG=3 then COD:=COD+'0' ;
     C:=0;
     if length(cod) < 14 then for c:=length(cod) to 14-1 do cod:='0'+cod;
     cc   := cod[14];
     {showmessage(inttostr(length(cod)));
     showmessage(cod);}
     for f:=13 downto 1 do
       BEGIN
         C := C+1;
         if C > 9 then C := 2 ;
         schk:=schk + strtoint(copy(COD,f,1)) * C;
       END;
       {showmessage(inttostr(schk) );}
     CD := schk mod 11 ;
     CD := 11 - CD ;
     if CD >= 10 then CD := 0;

     str(CD:1,aa);
     if flg = 1 then if aa <> cc then showmessage('Dígito controle inválido !');

     mod11:=aa;
end;

function Gera_Digito11( cod: String ) : String;
var
     iIndice, iSoma, iDigito : Integer;
     sDigito : String;
const
     cPesos = '875432';
begin
     if Length(Cod) <> 6 then
     begin
          Informacao('Código inválido!!!!','Aviso...');
          Result := ' ';
          Exit;
     end;

     iSoma := 0;
     for iIndice := 1 to Length(Cod) do
     begin
          iSoma := iSoma + (StrToInt(Copy(Cod,iIndice,1)) *
                            StrToInt(Copy(cPesos,iIndice,1)));
     end;

     iDigito := iSoma mod 11;
     iDigito := 11 - iDigito;
     if iDigito > 9 then
        iDigito := StrToInt(Copy(IntToStr(iDigito),2,1));

     //if iDigito > 10 then
     //   iDigito := 1;


     str(iDigito:1,sDigito);
     Result := sDigito;
end;

function Gera_Digito_Contrato( cod: String ) : String;
var
     iIndice, iSoma, iDigito : Integer;
     sDigito, sContrato : String;
const
     aPesos: array[1..10] of integer = (11,10,9,8,7,6,5,4,3,2);
begin
     sContrato := Trim(Cod);
     if Length(sContrato) <> 10 then
     begin
          Informacao('Contrato inválido!!!!','Aviso...');
          Result := ' ';
          Exit;
     end;

     iSoma := 0;
     for iIndice := 1 to Length(sContrato) do
     begin
          iSoma := iSoma + (StrToInt(Copy(sContrato,iIndice,1)) *
                            aPesos[iIndice]);
     end;

     iDigito := iSoma mod 11;
     iDigito := 11 - iDigito;
     if iDigito >= 10 then
        iDigito := 0;

     str(iDigito:1,sDigito);
     Result := sDigito;
end;

function Gera_Digito_CtaContabil( cod: String ) : String;
var
     iIndice, iSoma, iDigito : Integer;
     sDigito, sConta : String;
const
     aPesos: array[1..9] of integer = (3,2,9,8,7,5,4,3,2);
begin
     sConta := Trim(Cod);
     if Length(sConta) <> 9 then
     begin
          Informacao('Conta contabil inválida!!!!','Aviso...');
          Result := ' ';
          Exit;
     end;

     iSoma := 0;
     for iIndice := 1 to Length(sConta) do
     begin
          iSoma := iSoma + (StrToInt(Copy(sConta,iIndice,1)) *
                            aPesos[iIndice]);
     end;

     iDigito := iSoma mod 11;
     iDigito := 11 - iDigito;
     if iDigito > 9 then
        iDigito := iDigito - 10;

     str(iDigito:1,sDigito);
     Result := sDigito;
end;

function Gera_DigFuncionario( cod: String ) : String;
var
     iIndice, iSoma, iDigito, iDigFunc : Integer;
     sDigito : String;
const
     cPesos = '765432';
begin
     if Length(Cod) <> 6 then
     begin
          Informacao('Código inválido!!!!','Aviso...');
          Result := ' ';
          Exit;
     end;

     iSoma := 0;
     for iIndice := 1 to Length(Cod) do
     begin
          iSoma := iSoma + (StrToInt(Copy(Cod,iIndice,1)) *
                            StrToInt(Copy(cPesos,iIndice,1)));
     end;

     iDigito := iSoma mod 11;
     iDigito := 11 - iDigito;
     if iDigito = 10 then
        iDigFunc := 0
     else
         if iDigito = 11 then
            iDigFunc := 1
         else
             iDigFunc := iDigito;

     str(iDigFunc:1,sDigito);
     Result := sDigito;
end;

procedure TestaData(Campo : TField; sData : String);
//Esta procedure testa se a data é válida...Os parâmetros passados são a tbl e CAMPO (tblProdutosCodigo)
//e o text do edit da data
var
   dData : TDateTime;
begin
     try
        dData := StrToDate(sData);
     except
           Informacao('Data invalida! Verifique!','Aviso');
           Abort;
           Exit;
     end;
     Campo.Value := dData;
end;

function Elimina_Caracteres(Letras, Elimina, Novo : String) : String;
var
   sTrabalho : String;
   bTrocou : Boolean;
begin
     sTrabalho := UpperCase(Trim(Letras));
     bTrocou := False;
     repeat
           bTrocou := (Pos(Elimina, sTrabalho) <> 0);
           sTrabalho := StringReplace(sTrabalho,
                                      Elimina,
                                      Novo,
                                      [rfReplaceAll]);
     until not bTrocou;
     Result := sTrabalho;
end;

function Substitui_Caracteres(Letras : String) : String;
var
   sFinal, sTrabalho : String;
   iIndice, iPosicao : Integer;
const
     sCaracteres = 'ÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÑÇÝŸ';
     sValidos    = 'AAAAAEEEEIIIIOOOOOUUUUNCYY';
begin
     sTrabalho := UpperCase(Trim(Letras));
     sFinal := Trim(sTrabalho);

     for iIndice := 1 to Length(Trim(sTrabalho)) do
     begin
          iPosicao := Pos(Copy(sTrabalho,iIndice,1),sCaracteres);
          if iPosicao <> 0 then
          begin
               sFinal := StringReplace(sFinal,
                                       Copy(sCaracteres,iPosicao,1),
                                       Copy(sValidos,iPosicao,1),
                                       [rfReplaceAll]);
          end;
     end;
     Result := sFinal;
end;

function Verifica_Caracteres(Letras, TipoPessoa : String) : Boolean;
var
   sTrabalho, sCaracter : String;
   iIndice : Integer;
   bRetorno, bErro : Boolean;
begin
     bRetorno := True;
     bErro := False;
     sTrabalho := UpperCase(Trim(Letras));
     for iIndice := 1 to Length(sTrabalho) do
     begin
          sCaracter := Copy(sTrabalho,iIndice,1);
          if (sCaracter <> ' ') and (not (sCaracter[1] in ['A'..'Z'])) then
          begin
               bErro := True;
               if TipoPessoa = 'J' then
                  if (sCaracter[1] in ['0'..'9']) then
                     bErro := False;
               if bErro then
               begin
                    Informacao('Caracter inválido!!!'+#13+
                               'Caracter digitado: '+sCaracter,
                               'Aviso...');
                    bRetorno := False;
                    Break;
               end;
          end;
     end;
     Result := bRetorno;
end;

// Verifica caracteres para campos de Identidade, Orgao Emissor, Endereco,
//   Complemento, Bairro  e Cidade
// Deixa "passar" letras, numeros e os caracteres / (barra) e - (hifen)
function Ver_Caracteres(Letras, VerBranco : String) : Boolean;
var
   sTrabalho, sCaracter : String;
   iIndice : Integer;
   bRetorno : Boolean;
begin
     bRetorno := True;
     sTrabalho := UpperCase(Trim(Letras));
     for iIndice := 1 to Length(sTrabalho) do
     begin
          sCaracter := Copy(sTrabalho,iIndice,1);
          if (sCaracter = ' ') then
             if (VerBranco = 'VERBRANCO') then
             begin
                  Informacao('Informação não aceita espaços em branco!!!',
                          'Aviso...');
                  bRetorno := False;
                  Break;
             end
             else
                 Continue;
          if (not (sCaracter[1] in ['A'..'Z'])) and
             (not (sCaracter[1] in ['0'..'9'])) and
             (Trim(sCaracter) <> '/') and
             (Trim(sCaracter) <> '-') then
          begin
               Informacao('Caracter inválido!!!'+#13+
                          'Caracter digitado: '+sCaracter,
                          'Aviso...');
               bRetorno := False;
               Break;
          end;
     end;
     Result := bRetorno;
end;

// Verifica caracteres para histórico
function Verifica_Historico(Letras, VerBranco : String) : Boolean;
var
   sTrabalho, sCaracter : String;
   iIndice : Integer;
   bRetorno : Boolean;
begin
     bRetorno := True;
     sTrabalho := UpperCase(Trim(Letras));
     for iIndice := 1 to Length(sTrabalho) do
     begin
          sCaracter := Copy(sTrabalho,iIndice,1);
          if (sCaracter = ' ') then
             if (VerBranco = 'VERBRANCO') then
             begin
                  Informacao('Informação não aceita espaços em branco!!!',
                          'Aviso...');
                  bRetorno := False;
                  Break;
             end
             else
                 Continue;
          if (not (sCaracter[1] in ['A'..'Z'])) and
             (not (sCaracter[1] in ['0'..'9'])) and
             (Trim(sCaracter) <> '*') and
             (Trim(sCaracter) <> '/') and
             (Trim(sCaracter) <> '-') then
          begin
               Informacao('Caracter inválido!!!'+#13+
                          'Caracter digitado: '+sCaracter,
                          'Aviso...');
               bRetorno := False;
               Break;
          end;
     end;
     Result := bRetorno;
end;

//
// Verifica se a variavel passada com parametro e nulas ou não.
// Se for nula devolve TRUE; se estiver OK devolve FALSE
//
function VerificaVariavel( Variavel : Variant ) : Boolean;
var
   bRetorno : Boolean;
begin
{     case VarType(Variavel) of
          varString : bRetorno := (VarIsNull(Variavel)) or (Trim(Variavel) = '');
          varDate : bRetorno := (VarIsNull(Variavel)) or
                                (AllTrim(DateToStr(Variavel)) = '//') or
                                (ValidaData(DateToStr(Variavel)));
          varCurrency : bRetorno := (VarIsNull(Variavel)) or (Variavel <= 0);
          varInteger : bRetorno := (VarIsNull(Variavel)) or (Variavel <= 0);
     end;
     Result := bRetorno;  }
end;

function TestaCPF(xCPF: string) : Boolean;
var
  localCPF       : string;
  localResult    : boolean;
  digit1, digit2 : integer;
  ii,soma        : integer;
begin
  localCPF := '';
  localResult := False;

  {analisa CPF no formato 999.999.999-00}
  if Length(xCPF) = 14 then
    if (Copy(xCPF,4,1)+Copy(xCPF,8,1)+Copy(xCPF,12,1) = '..-') then
      begin
      localCPF := Copy(xCPF,1,3) + Copy(xCPF,5,3) + Copy(xCPF,9,3) +
                   Copy(xCPF,13,2);
      localResult := True;
      end;

  {analisa CPF no formato 99999999900}
  if Length(xCPF) = 11 then
    begin
    localCPF := xCPF;
    localResult := True;
    end;

    {comeca a verificacao do digito}
    if localResult then
    try
      {1° digito}
      soma := 0;
      for ii := 1 to 9 do Inc(soma, StrToInt(Copy(localCPF, 10-ii, 1))*(ii+1));
      digit1 := 11 - (soma mod 11);
      if digit1 > 9 then digit1 := 0;

      {2° digito}
      soma := 0;
      for ii := 1 to 10 do Inc(soma, StrToInt(Copy(localCPF, 11-ii, 1))*(ii+1));
      digit2 := 11 - (soma mod 11);
      if digit2 > 9 then digit2 := 0;

      {Checa os dois dígitos}
      if (Digit1 = StrToInt(Copy(localCPF, 10, 1))) and
         (Digit2 = StrToInt(Copy(localCPF, 11, 1))) then
         localResult := True
      else
         localResult := False;
    except
      localResult := False;
    end;

    if localResult then
       localResult := not ((Length(Trim(xCPF)) <> 11) or
                           (Trim(xCPF) = '11111111111') or
                           (Trim(xCPF) = '22222222222') or
                           (Trim(xCPF) = '33333333333') or
                           (Trim(xCPF) = '44444444444') or
                           (Trim(xCPF) = '55555555555') or
                           (Trim(xCPF) = '66666666666') or
                           (Trim(xCPF) = '77777777777') or
                           (Trim(xCPF) = '88888888888') or
                           (Trim(xCPF) = '99999999999') or
                           (Trim(xCPF) = '00000000000'));

    Result := localResult;
end;

procedure Verifica_Data(Campo : TField; sData : String);
var
   dData : TDateTime;
begin
     try
        dData := StrToDate(sData);
     except
           Informacao('Data inválida!!!!','Aviso...');
           Abort;
           Exit;
     end;
     Campo.Value := dData;
end;

function VerificaFloat(sValor:String) : Boolean;
var
   bFloatValido : Boolean;
begin
     bFloatValido := True;
     if Trim(sValor) <> '' then
     begin
          try
             StrToFloat(sValor);
          except
                on EConvertError do
                begin
                     Informacao('Valor inválido....','Aviso...');
                     bFloatValido := False;
                end;
          end;
     end;
     Result := bFloatValido;
end;

// Gera as data para o crediario
function GeraDatas(Data : TDateTime; FatorSoma : Integer ) : TDateTime;
var
   wAno, wMes, wDia : Word;
   dtDataGerar : TDateTime;
const
     DiasNoMes: array[1..12] of Integer = ( 31, 28, 31, 30, 31, 30, 31, 31, 30,
                                            31, 30, 31);
begin
     DecodeDate(Data, wAno, wMes, wDia);

     Inc(wMes, FatorSoma);
     if wMes > 12 then // Mes maior que 12
     begin
          wMes := 1;
          Inc(wAno);
     end;

     if (wDia > 28) and (wMes = 2) then
        if not AnoBis(EncodeDate(wAno,wMes,1)) then
           wDia := DiasNoMes[wMes]
        else
        begin // É bissexto e dia maior que 29
             if wDia > 29 then
                wDia := 29
        end;

     if wMes <> 2 then
        if wDia > DiasNoMes[wMes] then
           wDia := DiasNoMes[wMes];

     Result := EncodeDate(wAno,wMes,wDia);
end;

{-----------------------------------------------------------------------------}
{ Validar Horas                                                               }
{ Parametros :  Hora - string que conterá a hora que será avaliada            }
{ Retorno : Boolean - TRUE se Inválida                                        }
{-----------------------------------------------------------------------------}
function ValidaHora(sHora :String) : Boolean;
Begin
     Result := False;  // se a hora for válida retorna FALSE
     if AllTrim(sHora) <> '//' then
     begin
         Try
            dHoravalida := StrToTime(sHora);
         Except on EConvertError do
            begin
                 Adverte('Hora Inválida !','');
                 Result := True; // se a hora for inválida retorna TRUE
            end;
         end;
     end;
end;

function DifDias(DataVenc:TDateTime; DataAtual:TDateTime): Real;
{Retorna a diferenca de dias entre duas datas}
Var Data: TDateTime;
    dia, mes, ano: Word;
begin
     if DataAtual < DataVenc then
     begin
          Result := -99;
     end
     else
     begin
          Data := DataAtual - DataVenc;
          DecodeDate( Data, ano, mes, dia);
          Result := StrToFloat(FloatToStr(Data));
     end;
end;

function Divide(Dividendo, Divisor : Variant): Real;
var
   iResDiv : Integer;
   rMultiplica, rFinal : Real;
begin
     iResDiv := Trunc( fArredonda2CasasDecimais(Dividendo / Divisor) );
     rMultiplica :=iResDiv * Divisor;
     rFinal := fArredonda2CasasDecimais(rMultiplica) -
               fArredonda2CasasDecimais(Dividendo);
     Result := rFinal;
end;

function Trunca_Numero(Numero : Variant; Decimais : Integer): Real;
var
   sNumero : String;
   iPosicao : Integer;
   rNumero : Real;
begin
     sNumero := FloatToStr(Numero);
     iPosicao := Pos(',',sNumero);
     if iPosicao = 0 then
     begin
          sNumero := sNumero + ',' +PadLeft('0',Decimais,'0');
          iPosicao := Pos(',',sNumero);
     end;
     sNumero := Copy(sNumero,1,(iPosicao-1))+','+Copy(sNumero,(iPosicao+1),Decimais);
     rNumero := StrToFloat(sNumero);
     Result := rNumero;
end;

function Inteiro(Numero : Variant): String;
var
   sNumero : String;
   iPosicao : Integer;
begin
     sNumero := FloatToStr(Numero);
     iPosicao := Pos(',',sNumero);
     if iPosicao <> 0 then
     begin
          sNumero := Copy(sNumero,1,(iPosicao-1));
     end;
     Result := sNumero;
end;

function Decimais(Numero : Variant; Decimais : Integer): String;
var
   sNumero  : String;
   iPosicao : Integer;
begin
     sNumero  := FloatToStr(Numero);
     iPosicao := Pos(',',sNumero);
     if iPosicao <> 0 then
     begin
          sNumero := Copy(sNumero,(iPosicao+1),(Length(sNumero)-iPosicao));
          sNumero := Copy(sNumero,1,Decimais);
     end
     else
         sNumero := '0';
         
     Result := sNumero;
end;


//
// Retorna a frequencia do processador usado
//
function CPUSpeed: Double;
const
     DelayTime = 500; // measure time in ms
var
   TimerHi, TimerLo: DWORD;
   PriorityClass, Priority: Integer;
begin
     PriorityClass := GetPriorityClass(GetCurrentProcess);
     Priority := GetThreadPriority(GetCurrentThread);
     SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
     SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
     Sleep(10);
     asm
        dw 310Fh // rdtsc
        mov TimerLo, eax
        mov TimerHi, edx
     end;
     Sleep(DelayTime);
     asm
        dw 310Fh // rdtsc
        sub eax, TimerLo
        sbb edx, TimerHi
        mov TimerLo, eax
        mov TimerHi, edx
     end;
     SetThreadPriority(GetCurrentThread, Priority);
     SetPriorityClass(GetCurrentProcess, PriorityClass);
     Result := TimerLo / (1000.0 * DelayTime);
end;

{Retorna a quantidade atual de cores no Windows (16, 256, 65536 = 16 ou 24 bit}
function NumeroDeCores : Integer;
var
   DC:HDC;
   BitsPorPixel: Integer;
begin
     Dc := GetDc(0); // 0 = vídeo
     BitsPorPixel := GetDeviceCaps(Dc,BitsPixel);
     Result := 2 shl (BitsPorPixel - 1);
end;

// Retorno o numero de domingos de um determinado mes
// Parametros: Mes - Mes para retorno dos domingos
//             Ano - Ano para retorno dos domingos
function Conta_Domingos(Dia, Mes, Ano : Integer) : Integer;
var
   dDataInicial, dDataFinal  : TDateTime;
   iDiasFinal, iContaDomingos : Integer;
begin
     //iDiasFinal := DiasNoMes(Ano, Mes);
     //dDataFinal := EnCodeDate(Ano,Mes,iDiasFinal);
     dDataInicial := EnCodeDate(Ano,Mes,1);
     dDataFinal   := EnCodeDate(Ano,Mes,Dia);
     iContaDomingos := 0;
     dDataInicial := dDataInicial - 1;
     while (dDataInicial <= dDataFinal) do
     begin
          dDataInicial := dDataInicial + 1;
          // Verifica se é domingo
          if DayOfWeek(dDataInicial) = 1 then
             Inc(iContaDomingos);
     end;
     Result := iContaDomingos;
end;


{function ExitWindowsEx(uFlags : integer;  		 // shutdown operation
                   dwReserved : word) : boolean; // reserved
         external 'user32.dll' name 'ExitWindowsEx';

procedure Tchau;
const
     EWX_LOGOFF   = 0; // Dá "logoff" no usuário atual
     EWX_SHUTDOWN = 1; // "Shutdown" padrão do sistema
     EWX_REBOOT   = 2; // Dá "reboot" no equipamento
     EWX_FORCE    = 4; // Força o término dos processos
     EWX_POWEROFF = 8; // Desliga o equipamento
begin
     ExitWindowsEx(EWX_FORCE, 0);
end;}

// Retorno a hora no formato hh:mm ou hhh:mm,
//         o valor da hora e o valor do minuto separadamente
// Parametros: Hora
{procedure Transforma_Hora(var pHora : String; pValor : Real; var pHoras : Real; var pMinutos : Real);
var
   iPosicao : Integer;
   sValor, sHoras, sMinutos : String;
begin
     sValor     := FloatToStr(pValor);
     iPosicao   := Pos(',',sValor);
     if iPosicao = 0 then
     begin
          sMinutos := '00';
          sHoras   := sValor;
     end
     else
     begin
          sHoras   := Copy(sValor,1,(iPosicao-1));
          sMinutos := PadRight(Copy(sValor,(iPosicao+1),(Length(sValor)-iPosicao)),2,'0');
     end;
     pHoras := StrToFloat(sHoras);
     pMinutos := StrToFloat(sMinutos);
     pHora := sHoras+':'+sMinutos;
end;}
procedure Transforma_Hora( var pHora : String; pValor : String;
                           var pHoras : Real; var pMinutos : Real );
var
   iPosicao, iMinutoInteiro, iMinutoResto : Integer;
   sValor, sHoras, sMinutos : String;
begin
     iPosicao := Pos(',',pValor);
     if iPosicao = 0 then
     begin
          sMinutos := '00';
          sHoras   := pValor;
     end
     else
     begin
          sHoras   := Copy(pValor,1,(iPosicao-1));
          sMinutos := PadLeft(Copy(pValor,(iPosicao+1),(Length(pValor)-iPosicao)),2,'0');
     end;
     pHoras := StrToFloat(sHoras);
     pMinutos := StrToFloat(sMinutos);
     if pMinutos >= 60 then
     begin
          iMinutoInteiro := Trunc(pMinutos / 60);
          iMinutoResto := Trunc(pMinutos - iMinutoInteiro * 60);
          pHoras := pHoras + iMinutoInteiro;
          pMinutos := iMinutoResto;
          sHoras := FloatToStr(pHoras);
          sMinutos := PadLeft(FloatToStr(pMinutos),2,'0');
     end;
     pHoras := StrToFloat(sHoras);
     pMinutos := StrToFloat(sMinutos);
     pHora := sHoras+':'+sMinutos;
end;

procedure Transf_Hora( var pHora : String; pValor : Real; var pHoras : Real;
                       var pMinutos : Real );
var
   iPosicao : Integer;
   sValor, sHoras, sMinutos : String;
begin
     sValor     := FloatToStr(pValor);
     iPosicao   := Pos(',',sValor);
     if iPosicao = 0 then
     begin
          sMinutos := '00';
          sHoras   := sValor;
     end
     else
     begin
          sHoras   := Copy(sValor,1,(iPosicao-1));
          sMinutos := PadRight(Copy(sValor,(iPosicao+1),(Length(sValor)-iPosicao)),2,'0');
     end;
     pHoras := StrToFloat(sHoras);
     pMinutos := StrToFloat(sMinutos);
     pHora := sHoras+':'+sMinutos;
end;

function Ultimo_Dia(Mes, Ano : Word) : Word;
var
   Data : TDateTime;
   Dia : Word;
Const
     aDias : array[1..12] of Word = (31,28,31,30,31,30,31,31,30,31,30,31);
begin
     Dia := aDias[Mes];
     if Mes = 2 then // ver ano bisexto
     begin
          Data := EncodeDate(Ano,Mes,1);
          if AnoBis(Data) then
             Dia := 29;
     end;
     Result := Dia
end;
end.

