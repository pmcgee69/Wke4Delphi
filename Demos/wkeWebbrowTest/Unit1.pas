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
    procedure FormShow(Sender: TObject);
    procedure WkeWebBrowser1TitleChange(Sender: TObject; sTitle: string);
    procedure WkeWebBrowser1CreateView(Sender: TObject; sUrl: string;
      navigationType: wkeNavigationType; windowFeatures: PwkeWindowFeatures;
      var wvw: wkeWebView);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
 // WkeWebBrowser1.Headless :=true;
  WkeWebBrowser1.LoadUrl('http://www.ifeng.com/');
 // WkeWebBrowser1.LoadFile('.\html\index.html');
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
 // ShowMessage(stitle);
end;

end.
