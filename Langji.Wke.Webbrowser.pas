unit Langji.Wke.Webbrowser;

interface
{$I delphiver.inc}

uses
{$IFDEF DELPHI16_UP}
  System.SysUtils, System.Classes, Vcl.Controls, vcl.graphics,  Vcl.Forms, System.Generics.Collections,
{$ELSE}
    SysUtils,Classes,Controls,Graphics,forms,
{$ENDIF}
 Messages, windows, Langji.Wke.types, Langji.Wke.IWebBrowser, Langji.Wke.lib;

type
  TWkeWebBrowser = class;

  TOnNewWindowEvent = procedure(Sender: TObject; sUrl: string; navigationType: wkeNavigationType; windowFeatures: PwkeWindowFeatures; var openflg: TNewWindowFlag; var webbrow: Twkewebbrowser) of object;

  TWkeApp = class(TComponent)
  private
    FCookieEnabled: boolean;
    FCookiePath: string;
    FUserAgent: string;
    FOnNewWindow: TOnNewWindowEvent;
    function GetWkeCookiePath: string;
    function GetWkeLibLocation: string;
    function GetWkeUserAgent: string;
    procedure SetCookieEnabled(const Value: boolean);
    procedure SetWkeCookiePath(const Value: string);
    procedure SetWkeLibLocation(const Value: string);
    procedure SetWkeUserAgent(const Value: string);
    procedure DoOnNewWindow(Sender: TObject; sUrl: string; navigationType: wkeNavigationType; windowFeatures: PwkeWindowFeatures; var wvw: wkeWebView);
  public
    FWkeWebPages: TList{$IFDEF DELPHI16_UP}<TWkeWebBrowser>{$ENDIF} ;
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure loaded; override;
    function CreateWebbrowser(Aparent: TWincontrol): TWkeWebBrowser; overload;
    function CreateWebbrowser(Aparent: TWincontrol; Ar: Trect): TWkeWebBrowser; overload;
    procedure CloseWebbrowser(Abrowser: TWkewebbrowser);
  published
    property WkelibLocation: string read GetWkeLibLocation write SetWkeLibLocation;
    property UserAgent: string read GetWkeUserAgent write SetWkeUserAgent;
    property CookieEnabled: boolean read FCookieEnabled write SetCookieEnabled;
    property CookiePath: string read GetWkeCookiePath write SetWkeCookiePath;
    property OnNewWindow: TOnNewWindowEvent read FOnNewWindow write FOnNewWindow;
  end;


  //浏览页面
  TWkeWebBrowser = class(TWinControl)//,IWkeWebbrowser )
  private
    thewebview: TwkeWebView;
    FZoomValue: Integer;
    FLoadFinished: boolean;
    FTransparent:boolean;
    FOnLoadEnd: TOnLoadEndEvent;
    FOnTitleChange: TOnTitleChangeEvent;
    FOnLoadStart: TOnBeforeLoadEvent;
    FOnUrlChange: TOnUrlChangeEvent;
    FOnCreateView: TOnCreateViewEvent;
    FOnDocumentReady: TNotifyEvent;
    FOnWindowClosing: TNotifyEvent;
    FOnWindowDestroy: TNotifyEvent;
    FOnAlertBox: TOnAlertBoxEvent;
    FOnConfirmBox: TOnConfirmBoxEvent;
    FwkeApp: TWkeApp;
    FCookieEnabled: Boolean;
    FwkeCookiePath: string;
    FwkeUserAgent: string;
    FOnPromptBox: TOnPromptBoxEvent;
    function GetZoom: Integer;
    procedure SetZoom(const Value: Integer);

     //webview
    procedure DoWebViewTitleChange(Sender: TObject; sTitle: string);
    procedure DoWebViewUrlChange(Sender: TObject; sUrl: string);
    procedure DoWebViewLoadStart(Sender: TObject; sUrl: string; navigationType: wkeNavigationType; var Cancel: boolean);
    procedure DoWebViewLoadEnd(Sender: TObject; sUrl: string; loadresult: wkeLoadingResult);
    procedure DoWebViewCreateView(Sender: TObject; sUrl: string; navigationType: wkeNavigationType; windowFeatures: PwkeWindowFeatures; var wvw: wkeWebView);
    procedure DoWebViewAlertBox(Sender: TObject; smsg: string);
    function DoWebViewConfirmBox(Sender: TObject; smsg: string): boolean;
    function DoWebViewPromptBox(Sender: TObject; smsg, defaultres, Strres: string): boolean;
    procedure DoWebViewConsoleMessage(Sender: TObject; smsg: wkeConsoleMessage);
    procedure DoWebViewDocumentReady(Sender: TObject);
    procedure DoWebViewWindowClosing(Sender: TObject);
    procedure DoWebViewWindowDestroy(Sender: TObject);
    procedure WM_SIZE(var msg: TMessage); message WM_SIZE;
    function GetCanBack: boolean;
    function GetCanForward: boolean;
    function GetCookieEnable: boolean;
    function GetLocationTitle: string;
    function GetLocationUrl: string;
    function GetMediaVolume: Single;
    function GetTransparent: boolean;
    procedure SetTransparent(const Value: Boolean);
    function GetLoadFinished: Boolean;
    function GetWebHandle: Hwnd;
    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    property Transparent: Boolean read GetTransparent write SetTransparent;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateWebView;
    procedure GoBack;
    procedure GoForward;
    procedure Refresh;
    procedure Stop;
    procedure LoadUrl(const Aurl: string);
    procedure LoadHtml(const Astr: string);
    procedure LoadFile(const AFile: string);
    procedure ExecuteJavascript(const js: string);
    procedure SetFocusToWebbrowser;
    property CanBack: boolean read GetCanBack;
    property CanForward: boolean read GetCanForward;
    property LocationUrl: string read GetLocationUrl;
    property LocationTitle: string read GetLocationTitle;
    property LoadFinished: Boolean read GetLoadFinished;       //加载完成
    property mainwkeview: TWkeWebView read thewebview;
    property WkeApp: TWkeApp read FwkeApp write FwkeApp;

  published
    property Align;
    property Color;
    property WebViewHandle:Hwnd read GetWebHandle;

    property UserAgent: string read FwkeUserAgent write FwkeUserAgent;
    property CookieEnabled: Boolean read FCookieEnabled write FCookieEnabled default true;
    property CookiePath: string read FwkeCookiePath write FWkeCookiePath;
    property ZoomPercent: Integer read GetZoom write SetZoom;
    property OnTitleChange: TOnTitleChangeEvent read FOnTitleChange write FOnTitleChange;
    property OnUrlChange: TOnUrlChangeEvent read FOnUrlChange write FOnUrlChange;
    property OnBeforeLoad: TOnBeforeLoadEvent read FOnLoadStart write FOnLoadStart;
    property OnLoadEnd: TOnLoadEndEvent read FOnLoadEnd write FOnLoadEnd;
    property OnCreateView: TOnCreateViewEvent read FOnCreateView write FOnCreateView;
    property OnWindowClosing: TNotifyEvent read FOnWindowClosing write FOnWindowClosing;
    property OnWindowDestroy: TNotifyEvent read FOnWindowDestroy write FOnWindowDestroy;
    property OnDocumentReady: TNotifyEvent read FOnDocumentReady write FOnDocumentReady;
    property OnAlertBox: TOnAlertBoxEvent read FOnAlertBox write FOnAlertBox;
    property OnConfirmBox: TOnConfirmBoxEvent read FOnConfirmBox write FOnConfirmBox;
    property OnPromptBox: TOnPromptBoxEvent read FOnPromptBox write FOnPromptBox;
  end;

implementation

uses
  math;



//==============================================================================
// 回调事件
//==============================================================================

procedure DoTitleChange(webView: wkeWebView; param: Pointer; title: wkeString); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewTitleChange(TWkeWebBrowser(param), wkeWebView.GetString(title));
end;

procedure DoUrlChange(webView: wkeWebView; param: Pointer; url: wkeString); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewUrlChange(TWkeWebBrowser(param), wkeWebView.GetString(url));
end;

procedure DoLoadEnd(webView: wkeWebView; param: Pointer; url: wkeString; result: wkeLoadingResult; failedReason: wkeString); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewLoadEnd(TWkeWebBrowser(param), wkeWebView.GetString(url), result);
end;

function DoLoadStart(webView: wkeWebView; param: Pointer; navigationType: wkeNavigationType; url: wkeString): Boolean; cdecl;
var
  cancel: boolean;
begin
  cancel := false;
  TWkeWebBrowser(param).DoWebViewLoadStart(TWkeWebBrowser(param), wkeWebView.GetString(url), navigationType, cancel);
  result := not cancel;
end;

function DoCreateView(webView: wkeWebView; param: Pointer; navigationType: wkeNavigationType; url: wkeString; windowFeatures: PwkeWindowFeatures): wkeWebView; cdecl;
begin
  TWkeWebBrowser(param).DoWebViewCreateView(TWkeWebBrowser(param), wkeWebView.GetString(url), navigationType, windowFeatures, result);
end;

procedure DoPaintUpdated(webView: wkeWebView; param: Pointer; hdc: hdc; x: Integer; y: Integer; cx: Integer; cy: Integer); cdecl;
begin

end;

procedure DoAlertBox(webView: wkeWebView; param: Pointer; msg: wkeString); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewAlertBox(TWkeWebBrowser(param), wkeWebView.GetString(msg));
end;

function DoConfirmBox(webView: wkeWebView; param: Pointer; msg: wkeString): Boolean; cdecl;
begin
  result := TWkeWebBrowser(param).DoWebViewConfirmBox(TWkeWebBrowser(param), wkeWebView.GetString(msg));
end;

function DoPromptBox(webView: wkeWebView; param: Pointer; msg: wkeString; defaultResult: wkeString; sresult: wkeString): Boolean; cdecl;
begin
  result := TWkeWebBrowser(param).DoWebViewPromptBox(TWkeWebBrowser(param), wkeWebView.GetString(msg), wkeWebView.GetString(defaultResult), wkeWebView.GetString(sresult));
end;

procedure DoConsoleMessage(webView: wkeWebView; param: Pointer; var AMessage: wkeConsoleMessage); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewConsoleMessage(TWkeWebBrowser(param), AMessage);
end;

procedure DocumentReady(webView: wkeWebView; param: Pointer); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewDocumentReady(TWkeWebBrowser(param));
end;

function DoWindowClosing(webWindow: wkeWebView; param: Pointer): Boolean; cdecl;
begin
  TWkeWebBrowser(param).DoWebViewWindowClosing(TWkeWebBrowser(param));
end;

procedure DoWindowDestroy(webWindow: wkeWebView; param: Pointer); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewWindowDestroy(TWkeWebBrowser(param));
end;








{ TWkeWebBrowser }

constructor TWkeWebBrowser.Create(AOwner: TComponent);
begin
  inherited;
  Color := clwhite;
  FZoomValue := 100;
  FCookieEnabled := true;
  FwkeUserAgent := 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36 Langji.Wke 1.0';
 // FBackImage:=TPicture.Create;
end;

destructor TWkeWebBrowser.Destroy;
begin
 // FBackImage.Free;
  if not Assigned(FwkeApp) then
    WkeFinalizeAndUnloadLib;
  inherited;
end;

procedure TWkeWebBrowser.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited;
  WkeLoadLibAndInit;
  if wkeLibHandle = 0 then
    Exit;
  CreateWebView;
end;

procedure TWkeWebBrowser.CreateWebView;
begin
//  if FTransparent  then
//    thewebview := wkeCreateWebWindow(WKE_WINDOW_TYPE_TRANSPARENT , handle, 0, 0, Width, height)
//  else
    thewebview := wkeCreateWebWindow(WKE_WINDOW_TYPE_CONTROL, handle, 0, 0, Width, height);
  if Assigned(thewebview) then
  begin
//    if FTransparent  then
//    begin
//      windows.SetParent(thewebview.WindowHandle,handle);
//    end;
    ShowWindow(thewebview.WindowHandle, SW_NORMAL);
    thewebview.SetOnTitleChanged(DoTitleChange, self);
    thewebview.SetOnURLChanged(DoUrlChange, self);
    thewebview.SetOnNavigation(DoLoadStart, self);
    thewebview.SetOnLoadingFinish(DoLoadEnd, self);
    if Assigned(FwkeApp) or Assigned(FOnCreateView) then
      thewebview.SetOnCreateView(DoCreateView, self);
    thewebview.SetOnPaintUpdated(DoPaintUpdated, self);
    if Assigned(FOnAlertBox) then
      thewebview.SetOnAlertBox(DoAlertBox, self);
    if Assigned(FOnConfirmBox) then
    thewebview.SetOnConfirmBox(DoConfirmBox, self);
    if Assigned(FOnPromptBox) then
    thewebview.SetOnPromptBox(DoPromptBox, self);
    thewebview.SetOnConsoleMessage(DoConsoleMessage, self);
    thewebview.SetOnDocumentReady(DocumentReady, self);
    thewebview.SetOnWindowClosing(DoWindowClosing, self);
    thewebview.SetOnWindowDestroy(DoWindowDestroy, self);
    if FwkeUserAgent <> '' then
      wkeSetUserAgent(thewebview, PansiChar(AnsiString(FwkeUserAgent)));
    wkeSetCookieEnabled(thewebview, FCookieEnabled);
    if DirectoryExists(FwkeCookiePath) and Assigned(wkeSetCookieJarPath) then
      wkeSetCookieJarPath(thewebview, PwideChar(FwkeCookiePath));
  end;
end;

procedure TWkeWebBrowser.DoWebViewAlertBox(Sender: TObject; smsg: string);
begin
  if Assigned(FOnAlertBox) then
    FOnAlertBox(Self, smsg);
end;

function TWkeWebBrowser.DoWebViewConfirmBox(Sender: TObject; smsg: string): boolean;
begin
  result := false;
  if Assigned(FOnConfirmBox) then
    FOnConfirmBox(self, smsg, result);
end;

procedure TWkeWebBrowser.DoWebViewConsoleMessage(Sender: TObject; smsg: wkeConsoleMessage);
begin

end;

procedure TWkeWebBrowser.DoWebViewCreateView(Sender: TObject; sUrl: string; navigationType: wkeNavigationType; windowFeatures: PwkeWindowFeatures; var wvw: wkeWebView);

begin
  if Assigned(FOnCreateView) then
    FOnCreateView(self, sUrl, navigationType, windowFeatures, wvw);
  if wvw <> nil then
  begin
    if wvw.WindowHandle =0 then  wvw:=thewebview ;
  end;
end;

procedure TWkeWebBrowser.DoWebViewDocumentReady(Sender: TObject);
begin
  if Assigned(FOnDocumentReady) then
    FOnDocumentReady(Self);
end;

procedure TWkeWebBrowser.DoWebViewLoadEnd(Sender: TObject; sUrl: string; loadresult: wkeLoadingResult);
begin
  if Assigned(FOnLoadEnd) then
    FOnLoadEnd(Self, sUrl, loadresult);
  FLoadFinished := true;
end;

procedure TWkeWebBrowser.DoWebViewLoadStart(Sender: TObject; sUrl: string; navigationType: wkeNavigationType; var Cancel: boolean);
begin
  if Assigned(FOnLoadStart) then
    FOnLoadStart(self, sUrl, navigationType, Cancel);
  FLoadFinished := false;
end;

function TWkeWebBrowser.DoWebViewPromptBox(Sender: TObject; smsg, defaultres, Strres: string): boolean;
begin

end;

procedure TWkeWebBrowser.DoWebViewTitleChange(Sender: TObject; sTitle: string);
begin
  if Assigned(FOnTitleChange) then
    FOnTitleChange(self, sTitle);
end;

procedure TWkeWebBrowser.DoWebViewUrlChange(Sender: TObject; sUrl: string);
begin
  if Assigned(FOnUrlChange) then
    FOnUrlChange(self, sUrl);
end;

procedure TWkeWebBrowser.DoWebViewWindowClosing(Sender: TObject);
begin
  if Assigned(FOnWindowClosing) then
    FOnWindowClosing(Self);
end;

procedure TWkeWebBrowser.DoWebViewWindowDestroy(Sender: TObject);
begin
  if Assigned(FOnWindowDestroy) then
    FOnWindowDestroy(Self);
end;

procedure TWkeWebBrowser.ExecuteJavascript(const js: string);
begin
  if Assigned(thewebview) then
    thewebview.RunJS(js);
end;

function TWkeWebBrowser.GetCanBack: boolean;
begin
  if Assigned(thewebview) then
    result := thewebview.CanGoBack;
end;

function TWkeWebBrowser.GetCanForward: boolean;
begin
  if Assigned(thewebview) then
    result := thewebview.CanGoForward;
end;

function TWkeWebBrowser.GetCookieEnable: boolean;
begin
  if Assigned(thewebview) then
    result := thewebview.CookieEnabled;
end;

function TWkeWebBrowser.GetLoadFinished: Boolean;
begin
  result := FLoadFinished;
end;

function TWkeWebBrowser.GetLocationTitle: string;
begin
  if Assigned(thewebview) then
    result := wkeGetName(thewebview);
end;

function TWkeWebBrowser.GetLocationUrl: string;
begin
  if Assigned(thewebview) then
    result := wkeGetTitleW(thewebview);
end;

function TWkeWebBrowser.GetMediaVolume: Single;
begin
  if Assigned(thewebview) then
    result := thewebview.MediaVolume;
end;

function TWkeWebBrowser.GetTransparent: boolean;
begin
    result := FTransparent;
end;

function TWkeWebBrowser.GetWebHandle: Hwnd;
begin
  result :=0;
  if Assigned(thewebview) then
    result :=thewebview.WindowHandle;
end;

procedure TWkeWebBrowser.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
end;

function TWkeWebBrowser.getZoom: Integer;
begin
  if Assigned(thewebview) then
    result := Trunc(power(1.2, thewebview.ZoomFactor) * 100)
  else
    result := 100;
end;

procedure TWkeWebBrowser.GoBack;
begin
  if Assigned(thewebview) then
  begin
    if thewebview.CanGoBack then
      thewebview.GoBack;
  end;
end;

procedure TWkeWebBrowser.GoForward;
begin
  if Assigned(thewebview) then
  begin
    if thewebview.CanGoForward then
      thewebview.GoForward;
  end;
end;

procedure TWkeWebBrowser.LoadFile(const AFile: string);
begin
  if Assigned(thewebview) then
    thewebview.LoadFile(AFile);
end;

procedure TWkeWebBrowser.LoadHtml(const Astr: string);
begin
  if Assigned(thewebview) then
    thewebview.LoadHTML(Astr);
end;

procedure TWkeWebBrowser.LoadUrl(const Aurl: string);
begin
  if Assigned(thewebview) then
  begin
    thewebview.LoadURL(Aurl);
  end;
end;

procedure TWkeWebBrowser.Refresh;
begin
  if Assigned(thewebview) then
    thewebview.Reload;
end;

procedure TWkeWebBrowser.SetFocusToWebbrowser;
begin
  if Assigned(thewebview) then
    thewebview.SetFocus;
end;

procedure TWkeWebBrowser.SetZoom(const Value: Integer);
begin
  if Assigned(thewebview) then   //  wkeSetZoomFactor(thewebview,0.1);
    thewebview.ZoomFactor := LogN(1.2, Value / 100);
end;

procedure TWkeWebBrowser.Stop;
begin
  if Assigned(thewebview) then
    thewebview.StopLoading;
end;

procedure TWkeWebBrowser.WM_SIZE(var msg: TMessage);
begin
  inherited;
  if Align = alClient then
  begin
    if Assigned(thewebview) then
      thewebview.MoveWindow(0, 0, Width, Height);
  end;
end;


{ TWkeApp }

constructor TWkeApp.Create(Aowner: TComponent);
begin
  inherited;
  FWkeWebPages := TList{$IFDEF DELPHI16_UP}<TWkeWebBrowser>{$ENDIF}.create;
end;

destructor TWkeApp.Destroy;
begin
  FWkeWebPages.Clear;
  FWkeWebPages.Free;
  WkeFinalizeAndUnloadLib;
  inherited;
end;

procedure TWkeApp.loaded;
begin
  inherited;
  WkeLoadLibAndInit;
end;

procedure TWkeApp.CloseWebbrowser(Abrowser: TWkewebbrowser);
begin
  FWkeWebPages.Remove(Abrowser);
end;

function TWkeApp.CreateWebbrowser(Aparent: TWincontrol; Ar: Trect): TWkeWebBrowser;
var
  newBrowser: TWkeWebBrowser;
begin
  if wkeLibHandle = 0 then
    RaiseLastOSError;
  newBrowser := TWkeWebBrowser.Create(Aparent);
  newBrowser.WkeApp := self;
  newBrowser.Parent := Aparent;
  newBrowser.BoundsRect := Ar;
  newBrowser.OnCreateView := DoOnNewWindow;
  //设置初始值
  if FUserAgent <> '' then
    newBrowser.UserAgent := FUserAgent;
  newBrowser.CookieEnabled := FCookieEnabled;
  if DirectoryExists(FCookiePath) then
    newBrowser.CookiePath := FCookiePath;
  FWkeWebPages.Add(newBrowser);
  result := newBrowser;
end;

function TWkeApp.CreateWebbrowser(Aparent: TWincontrol): TWkeWebBrowser;
var
  newBrowser: TWkeWebBrowser;
begin
  newBrowser := CreateWebbrowser(Aparent, Rect(0, 0, 100, 100));
  newBrowser.Align := alClient;
  result := newBrowser;
end;

procedure TWkeApp.DoOnNewWindow(Sender: TObject; sUrl: string; navigationType: wkeNavigationType; windowFeatures: PwkeWindowFeatures; var wvw: wkeWebView);
var
  Openflag: TNewWindowFlag;
  NewwebPage: TWkeWebBrowser;
  newFrm: TForm;
begin
  Openflag := nwf_NewPage;
  NewwebPage := nil;
  if Assigned(FOnNewWindow) then
    FOnNewWindow(Self, sUrl, navigationType, windowFeatures, Openflag, NewwebPage);
  case Openflag of
    nwf_Cancel:
      wvw := nil;
    nwf_NewPage:
      begin
        if NewwebPage <> nil then
          wvw := NewwebPage.thewebview
        else
        begin
          newFrm := TForm.Create(nil);
          newFrm.BoundsRect := Rect(windowFeatures.x, windowFeatures.y, windowFeatures.x + windowFeatures.width, windowFeatures.y + windowFeatures.height);
          newFrm.Show;
          wvw := wkeCreateWebWindow(WKE_WINDOW_TYPE_CONTROL, newFrm.handle, 0, 0, newFrm.Width, newFrm.height);
          ShowWindow(wvw.WindowHandle, SW_NORMAL);
          newFrm.Caption := sUrl;
        end;

      end;
    nwf_OpenInCurrent:
      wvw := TWkeWebBrowser(Sender).thewebview;
  end;
end;

function TWkeApp.GetWkeCookiePath: string;
begin
  result := FCookiePath;
end;

function TWkeApp.GetWkeLibLocation: string;
begin
  result := wkeLibFileName;
end;

function TWkeApp.GetWkeUserAgent: string;
begin
  result := FUserAgent;
end;

procedure TWkeApp.SetCookieEnabled(const Value: boolean);
begin
  FCookieEnabled := Value;
end;

procedure TWkeApp.SetWkeCookiePath(const Value: string);
begin
  FCookiepath := Value;
end;

procedure TWkeApp.SetWkeLibLocation(const Value: string);
begin
  if FileExists(Value) then
    wkeLibFileName := Value;
end;

procedure TWkeApp.SetWkeUserAgent(const Value: string);
begin
  FUserAgent := Value;
end;

end.

