unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Langji.Wke.Webbrowser, Vcl.Imaging.jpeg, // QWorker,
  Langji.Wke.types, Langji.Wke.lib, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    WkeWebBrowser1: TWkeWebBrowser;
    Button1: TButton;
    Panel1: TPanel;
    Button2: TButton;
    Edit1: TEdit;
    btn_back: TBitBtn;
    btn_forward: TBitBtn;
    Button3: TButton;
    procedure FormShow(Sender: TObject);
    procedure WkeWebBrowser1TitleChange(Sender: TObject; sTitle: string);
    procedure WkeWebBrowser1CreateView(Sender: TObject; sUrl: string; navigationType: wkeNavigationType; windowFeatures:
      PwkeWindowFeatures; var wvw: wkeWebView);
    procedure Button1Click(Sender: TObject);
    procedure btn_backClick(Sender: TObject);
    procedure btn_forwardClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure WkeWebBrowser1LoadEnd(Sender: TObject; sUrl: string; loadresult: wkeLoadingResult);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn_backClick(Sender: TObject);
begin
  WkeWebBrowser1.GoBack;
end;

procedure TForm1.btn_forwardClick(Sender: TObject);
begin
  WkeWebBrowser1.GoForward;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage(WkeWebBrowser1.GetSource);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  WkeWebBrowser1.LoadUrl(Edit1.Text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  WkeWebBrowser1.ShowDevTool;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  WkeWebBrowser1.LoadUrl('http://www.langjisky.com/');
end;

procedure TForm1.WkeWebBrowser1CreateView(Sender: TObject; sUrl: string; navigationType: wkeNavigationType;
  windowFeatures: PwkeWindowFeatures; var wvw: wkeWebView);
begin
//  wvw :=wkewebbrowser1.mainwkeview;
end;

procedure TForm1.WkeWebBrowser1LoadEnd(Sender: TObject; sUrl: string; loadresult: wkeLoadingResult);
begin
  Edit1.Text := WkeWebBrowser1.LocationUrl;
  btn_back.Enabled := WkeWebBrowser1.CanBack;
  btn_forward.Enabled := WkeWebBrowser1.CanForward;
end;

procedure TForm1.WkeWebBrowser1TitleChange(Sender: TObject; sTitle: string);
begin
  Caption := sTitle;
end;



//==============================================================================
// 在initialization切加入useFastMB:=true表示使用FASTMB  ，目前只针对 wkewebbrowser有效
//==============================================================================

initialization
  UseFastMB := true;

end.

