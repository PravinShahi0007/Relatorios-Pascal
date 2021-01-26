unit uExemplo;

interface

uses 
  Contnrs,InvokeRegistry;

type

THistorico = class(Tremotable)
private
   FHistNome,FHistData,FHistFone,FHistQtd : string;
public
   property HistNome                  : String read FHistNome         write FHistNome;
   property HistData                  : String read FHistData         write FHistData;
   property HistFone                  : String read FHistFone         write FHistFone;
   property HistQtd                   : String read FHistQtd          write FHistQtd;
end;

TListaHistorico = class(Tremotable)
private
    FListaHistorico: TObjectList;
    
    function GetCount: integer; 
    function GetHistorico(Index: integer): THistorico;
  public
    constructor Create;
    destructor Destroy; override; 

    function Add(AHistorico: THistorico): Integer;

    property Count: integer read GetCount;
    property Historico[Index: integer]: THistorico read GetHistorico;
  end;

implementation


function TListaHistorico.Add(AHistorico: THistorico): Integer;
begin
  Result := FListaHistorico.Add(AHistorico);
end; 

constructor TListaHistorico.Create;
begin 
  FListaHistorico := TObjectList.Create;
end; 

destructor TListaHistorico.Destroy;
begin 
  FListaHistorico.Free;
  inherited;
end; 

function TListaHistorico.GetCount: integer;
begin
  Result := FListaHistorico.Count;
end;

function TListaHistorico.GetHistorico(Index: integer): THistorico;
begin
  Result := THistorico(FListaHistorico.Items[Index]);
end;

end.
