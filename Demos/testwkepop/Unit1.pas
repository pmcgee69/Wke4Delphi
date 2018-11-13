unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Langji.Wke.customPage, Vcl.StdCtrls ;

type
  TForm1 = class(TForm)
    Button1: TButton;
    WkePopupPage1: TWkePopupPage;
    Memo1: TMemo;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
     uses Langji.Wke.lib;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin

  Memo1.Text :=GetSourceByWke(Edit1.Text ,false,2000);

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  WkePopupPage1.ShowWebPage;
  WkePopupPage1.LoadUrl(Edit1.Text );
end;



//注意加入下面的初始化节，否则会报错。

initialization
  WkeLoadLibAndInit;

finalization
  if not wkeIsInDll then
      WkeFinalizeAndUnloadLib;

end.
