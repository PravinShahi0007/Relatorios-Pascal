unit uAtualizacoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TForm1 = class(TForm)
    pnl1: TPanel;
    img1: TImage;
    img2: TImage;
    img3: TImage;
    imgGraz: TImage;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    procedure img1Click(Sender: TObject);
    procedure img2Click(Sender: TObject);
    procedure img3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses uRelatorio1, uRelatorio2;

{$R *.dfm}

procedure TForm1.img1Click(Sender: TObject);
begin
Form2. ShowModal;
end;

procedure TForm1.img2Click(Sender: TObject);
begin
Form3. ShowModal;
end;

procedure TForm1.img3Click(Sender: TObject);
begin
 Application.Terminate;
end;

end.
