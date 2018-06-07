unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Langji.Wke.Webbrowser, Vcl.Imaging.jpeg,// QWorker,
  Langji.Wke.types,
  Vcl.StdCtrls ;

type
  TForm1 = class(TForm)
    WkeWebBrowser1: TWkeWebBrowser;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure WkeWebBrowser1TitleChange(Sender: TObject; sTitle: string);
    procedure WkeWebBrowser1CreateView(Sender: TObject; sUrl: string;
      navigationType: wkeNavigationType; windowFeatures: PwkeWindowFeatures;
      var wvw: wkeWebView);
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

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage(WkeWebBrowser1.GetSource);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  WkeWebBrowser1.LoadFile('f:\GaodeMap.html');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  WkeWebBrowser1.LoadUrl('http://www.langjisky.com/GaodeMap.html');
end;

procedure TForm1.WkeWebBrowser1CreateView(Sender: TObject; sUrl: string;
  navigationType: wkeNavigationType; windowFeatures: PwkeWindowFeatures;
  var wvw: wkeWebView);
begin
//  wvw :=wkewebbrowser1.mainwkeview;
end;

procedure TForm1.WkeWebBrowser1TitleChange(Sender: TObject; sTitle: string);
begin
  Caption :=sTitle;
end;

end.
