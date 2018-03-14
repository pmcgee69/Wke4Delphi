unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Langji.Wke.Webbrowser,
  Langji.Wke.types,
  Vcl.ExtCtrls, Vcl.Buttons;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    WkeApp1: TWkeApp;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure WkeWebBrowser1TitleChange(Sender: TObject; sTitle: string);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WkeApp1NewWindow(Sender: TObject; sUrl: string;
      navigationType: wkeNavigationType; windowFeatures: PwkeWindowFeatures;
      var openflg: TNewWindowFlag; var webbrow: TWkeWebBrowser);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    WkeWebBrowser1: TWkeWebBrowser;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  WkeWebBrowser1.GoBack;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  WkeWebBrowser1.GoForward;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  WkeWebBrowser1.loadurl(Edit1.Text); //  dailiurl);
  WkeWebBrowser1.DragEnabled :=False;
 // WkeWebBrowser1.Headless :=true;
end;



procedure TForm1.Button2Click(Sender: TObject);
begin
  WkeWebBrowser1.ShowDevTool;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  WkeWebBrowser1 := WkeApp1.CreateWebbrowser(form1);

end;

procedure TForm1.WkeApp1NewWindow(Sender: TObject; sUrl: string;
  navigationType: wkeNavigationType; windowFeatures: PwkeWindowFeatures;
  var openflg: TNewWindowFlag; var webbrow: TWkeWebBrowser);
begin
  openflg :=TNewWindowFlag.nwf_OpenInCurrent;
end;

procedure TForm1.WkeWebBrowser1TitleChange(Sender: TObject; sTitle: string);
begin
  Caption := sTitle;
end;

end.

