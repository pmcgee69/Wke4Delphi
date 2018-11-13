{*******************************************************}
{                                                       }
{       WKE FOR DELPHI                                  }
{                                                       }
{       版权所有 (C) 2018 Langji                        }
{                                                       }
{       QQ:231850275                                    }
{                                                       }
{*******************************************************}

unit Langji.Wke.Webbrowser;

//==============================================================================
// WKE FOR DELPHI
//==============================================================================



interface
{$I delphiver.inc}

uses
{$IFDEF DELPHI15_UP}
  System.SysUtils, System.Classes, Vcl.Controls, vcl.graphics, Vcl.Forms, System.Generics.Collections,
{$ELSE}
  SysUtils, Classes, Controls, Graphics, forms,
{$ENDIF}
  Messages, windows, Langji.Wke.types, Langji.Wke.IWebBrowser, Langji.Wke.lib;

type
  TWkeWebBrowser = class;

  TOnNewWindowEvent = procedure(Sender: TObject; sUrl: string; navigationType: wkeNavigationType; windowFeatures:
    PwkeWindowFeatures; var openflg: TNewWindowFlag; var webbrow: Twkewebbrowser) of object;

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
    procedure DoOnNewWindow(Sender: TObject; sUrl: string; navigationType: wkeNavigationType; windowFeatures:
      PwkeWindowFeatures; var wvw: wkeWebView);
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
 //   FTransparent: boolean;
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
    FOnDownload: TOnDownloadEvent;
    FOnMouseOverUrlChange: TOnUrlChangeEvent;
    FIsmain: Boolean;
    FPlatform: TwkePlatform;
    FOnConsoleMessage: TOnConsoleMessgeEvent;
    FOnLoadUrlEnd: TOnLoadUrlEndEvent;
    FOnLoadUrlBegin: TOnLoadUrlBeginEvent;
    FpopupEnabled: Boolean;
    function GetZoom: Integer;
    procedure SetZoom(const Value: Integer);

     //webview
    procedure DoWebViewTitleChange(Sender: TObject; sTitle: string);
    procedure DoWebViewUrlChange(Sender: TObject; sUrl: string);
    procedure DoWebViewMouseOverUrlChange(Sender: TObject; sUrl: string);
    procedure DoWebViewLoadStart(Sender: TObject; sUrl: string; navigationType: wkeNavigationType; var Cancel: boolean);
    procedure DoWebViewLoadEnd(Sender: TObject; sUrl: string; loadresult: wkeLoadingResult);
    procedure DoWebViewCreateView(Sender: TObject; sUrl: string; navigationType: wkeNavigationType; windowFeatures:
      PwkeWindowFeatures; var wvw: wkeWebView);
    procedure DoWebViewAlertBox(Sender: TObject; smsg: string);
    function DoWebViewConfirmBox(Sender: TObject; smsg: string): boolean;
    function DoWebViewPromptBox(Sender: TObject; smsg, defaultres, Strres: string): boolean;
    procedure DoWebViewConsoleMessage(Sender: TObject; const AMessage, sourceName: string; sourceLine: Cardinal; const stackTrack: string);
    procedure DoWebViewDocumentReady(Sender: TObject);
    procedure DoWebViewWindowClosing(Sender: TObject);
    procedure DoWebViewWindowDestroy(Sender: TObject);
    function DoWebViewDownloadFile(Sender: TObject; sUrl: string): boolean;
    procedure DoWebViewLoadUrlEnd(Sender: TObject; sUrl: string; job: Pointer; buf: Pointer; len: Integer);
    procedure DoWebViewLoadUrlStart(Sender: TObject; sUrl: string; out bhook, bHandle: boolean);
    procedure WM_SIZE(var msg: TMessage); message WM_SIZE;
  //  procedure WM_KEYDOWN(var msg:TMessage);message WM_KEYDOWN ;
    function GetCanBack: boolean;
    function GetCanForward: boolean;
    function GetCookieEnable: boolean;
    function GetLocationTitle: string;
    function GetLocationUrl: string;
    function GetMediaVolume: Single;
   // function GetTransparent: boolean;
   // procedure SetTransparent(const Value: Boolean);
    function GetLoadFinished: Boolean;
    function GetWebHandle: Hwnd;
    /// <summary>
    ///   格式为：PRODUCTINFO=webxpress; domain=.fidelity.com; path=/; secure
    /// </summary>
    procedure SetCookie(const Value: string);
    function GetCookie: string;
    procedure SetLocaStoragePath(const Value: string);
    procedure SetHeadless(const Value: Boolean);
    procedure SetTouchEnabled(const Value: Boolean);
    procedure SetProxy(const Value: TwkeProxy);
    procedure SetDragEnabled(const Value: boolean);
    procedure setOnAlertBox(const Value: TOnAlertBoxEvent);
    procedure setWkeCookiePath(const Value: string);
    procedure SetNewPopupEnabled(const Value: Boolean);
    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateWindowHandle(const Params: TCreateParams); override;
   // property Transparent: Boolean read GetTransparent write SetTransparent;
    procedure WndProc(var Msg: TMessage); override;
    procedure setPlatform(const Value: TwkePlatform);
    property SimulatePlatform: TwkePlatform read FPlatform write setPlatform;
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
    /// <summary>
    ///   加载HTMLCODE
    /// </summary>
    procedure LoadHtml(const Astr: string);
    /// <summary>
    ///   加载文件
    /// </summary>
    procedure LoadFile(const AFile: string);
    /// <summary>
    ///   执行js 返回值 为执行成功与否
    /// </summary>
    function ExecuteJavascript(const js: string): boolean;

    /// <summary>
    ///   执行js并得到string返回值
    /// </summary>
    function GetJsTextResult(const js: string): string;
    /// <summary>
    ///   执行js并得到boolean返回值
    /// </summary>
    function GetJsBoolResult(const js: string): boolean;
    procedure SetFocusToWebbrowser;
    procedure ShowDevTool;                        //2018.3.14
    /// <summary>
    ///  取源码
    /// </summary>
    function GetSource: string;
    property CanBack: boolean read GetCanBack;
    property CanForward: boolean read GetCanForward;
    property LocationUrl: string read GetLocationUrl;
    property LocationTitle: string read GetLocationTitle;
    property LoadFinished: Boolean read GetLoadFinished;       //加载完成
    property mainwkeview: TWkeWebView read thewebview;
    property WkeApp: TWkeApp read FwkeApp write FwkeApp;
    property WebViewHandle: Hwnd read GetWebHandle;
    property isMain: Boolean read FIsmain;
  published
    property Align;
    property Color;
    property Visible;
   // property Taborder;
    property UserAgent: string read FwkeUserAgent write FwkeUserAgent;
    property CookieEnabled: Boolean read FCookieEnabled write FCookieEnabled default true;
    property CookiePath: string read FwkeCookiePath write setWkeCookiePath;
    /// <summary>
    ///   Cookie格式为：PRODUCTINFO=webxpress; domain=.fidelity.com; path=/; secure
    /// </summary>
    property Cookie: string read GetCookie write SetCookie;
    property LocalStoragePath: string write SetLocaStoragePath;
    property ZoomPercent: Integer read GetZoom write SetZoom;
    property Headless: Boolean write SetHeadless;
    property TouchEnabled: Boolean write SetTouchEnabled;
    property DragEnabled: boolean write SetDragEnabled;           //2018.3.14
    property PopupEnabled: Boolean read FpopupEnabled write SetNewPopupEnabled default true;
    property Proxy: TwkeProxy write SetProxy;
    property OnTitleChange: TOnTitleChangeEvent read FOnTitleChange write FOnTitleChange;
    property OnUrlChange: TOnUrlChangeEvent read FOnUrlChange write FOnUrlChange;
    property OnBeforeLoad: TOnBeforeLoadEvent read FOnLoadStart write FOnLoadStart;
    property OnLoadEnd: TOnLoadEndEvent read FOnLoadEnd write FOnLoadEnd;
    property OnCreateView: TOnCreateViewEvent read FOnCreateView write FOnCreateView;
    property OnWindowClosing: TNotifyEvent read FOnWindowClosing write FOnWindowClosing;
    property OnWindowDestroy: TNotifyEvent read FOnWindowDestroy write FOnWindowDestroy;
    property OnDocumentReady: TNotifyEvent read FOnDocumentReady write FOnDocumentReady;
    property OnAlertBox: TOnAlertBoxEvent read FOnAlertBox write setOnAlertBox;
    property OnConfirmBox: TOnConfirmBoxEvent read FOnConfirmBox write FOnConfirmBox;
    property OnPromptBox: TOnPromptBoxEvent read FOnPromptBox write FOnPromptBox;
    property OnDownloadFile: TOnDownloadEvent read FOnDownload write FOnDownload;
    property OnMouseOverUrlChanged: TOnUrlChangeEvent read FOnMouseOverUrlChange write FOnMouseOverUrlChange; //2018.3.14
    property OnConsoleMessage: TOnConsoleMessgeEvent read FOnConsoleMessage write FOnConsoleMessage;
    property OnLoadUrlEnd: TOnLoadUrlEndEvent read FOnLoadUrlEnd write FOnLoadUrlEnd;
    property OnLoadUrlBegin: TOnLoadUrlBeginEvent read FOnLoadUrlBegin write FOnLoadUrlBegin;
  end;

implementation

uses  // dialogs,
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

procedure DoMouseOverUrlChange(webView: wkeWebView; param: Pointer; url: wkeString); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewMouseOverUrlChange(TWkeWebBrowser(param), wkeWebView.GetString(url));
end;

procedure DoLoadEnd(webView: wkeWebView; param: Pointer; url: wkeString; result: wkeLoadingResult; failedReason: wkeString); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewLoadEnd(TWkeWebBrowser(param), wkeWebView.GetString(url), result);
end;

var
  tmpSource: string = '';

function DoGetSource(p1, p2, es: jsExecState): jsValue;
var
  s: string;
begin
  s := es.ToTempString(es.Arg(0));
  tmpSource := s;
  result := 0;
end;

function DoLoadStart(webView: wkeWebView; param: Pointer; navigationType: wkeNavigationType; url: wkeString): Boolean; cdecl;
var
  cancel: boolean;
begin
  cancel := false;
  TWkeWebBrowser(param).DoWebViewLoadStart(TWkeWebBrowser(param), wkeWebView.GetString(url), navigationType, cancel);
  result := not cancel;
end;

function DoCreateView(webView: wkeWebView; param: Pointer; navigationType: wkeNavigationType; url: wkeString;
  windowFeatures: PwkeWindowFeatures): wkeWebView; cdecl;
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
  result := TWkeWebBrowser(param).DoWebViewPromptBox(TWkeWebBrowser(param), wkeWebView.GetString(msg), wkeWebView.GetString
    (defaultResult), wkeWebView.GetString(sresult));
end;

procedure DoConsoleMessage(webView: wkeWebView; param: Pointer; level: wkeMessageLevel; const AMessage, sourceName:
  wkeString; sourceLine: Cardinal; const stackTrack: wkeString); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewConsoleMessage(TWkeWebBrowser(param), wkeWebView.GetString(AMessage), wkeWebView.GetString
    (sourceName), sourceLine, wkeWebView.GetString(stackTrack));
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

function DodownloadFile(webView: wkeWebView; param: Pointer; url: wkeString): boolean; cdecl;
begin
  result := TWkeWebBrowser(param).DoWebViewDownloadFile(TWkeWebBrowser(param), wkeWebView.GetString(url));
end;

procedure DoOnLoadUrlEnd(webView: wkeWebView; param: Pointer; const url: pansichar; job: Pointer; buf: Pointer; len: Integer); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewLoadUrlEnd(TWkeWebBrowser(param), StrPas(url), job, buf, len);
end;

function DoOnLoadUrlBegin(webView: wkeWebView; param: Pointer; url: PAnsiChar; job: Pointer): boolean; cdecl;
var
  bhook, bHandled: boolean;
begin
  bhook := false;
  bHandled := false;
  TWkeWebBrowser(param).DoWebViewLoadUrlStart(TWkeWebBrowser(param), StrPas(url), bhook, bHandled);
  if bhook then
    if Assigned(wkeNetHookRequest) then
      wkeNetHookRequest(job);
  result := bHandled;
end;


//procedure ShowLastError;
//var
//  ErrorCode: DWORD;
//  ErrorMessage: Pointer;
//begin
//  ErrorCode := GetLastError;
//  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or Format_MESSAGE_FROM_SYSTEM, nil, ErrorCode, 0, @ErrorMessage, 0, nil);
//  showmessage('GetLastError Result: ' + IntToStr(ErrorCode) + #13 + 'Error Description: ' + string(Pchar(ErrorMessage)));
//end;

{ TWkeWebBrowser }

constructor TWkeWebBrowser.Create(AOwner: TComponent);
begin
  inherited;
  Color := clwhite;
  FZoomValue := 100;
  FCookieEnabled := true;
  FpopupEnabled := true;
  FwkeUserAgent :=
    'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.1650.63 Safari/537.36 Langji.Wke 1.0';
  FPlatform := wp_Win32;
end;

destructor TWkeWebBrowser.Destroy;
begin
  if (not Assigned(FwkeApp)) and (not wkeIsInDll) then
  begin
    if FIsmain then
      WkeFinalizeAndUnloadLib;
  end;
  inherited;
end;

procedure TWkeWebBrowser.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited;
  if (csDesigning in ComponentState) then
    exit;
  if not Assigned(FwkeApp) then
    Fismain := WkeLoadLibAndInit;
  if wkeLibHandle = 0 then
    Exit;
  CreateWebView;
end;

procedure TWkeWebBrowser.CreateWebView;
var
  wkeset: wkeSettings;
begin
  thewebview := wkeCreateWebWindow(WKE_WINDOW_TYPE_CONTROL, handle, 0, 0, Width, height);
  if Assigned(thewebview) then
  begin
    ShowWindow(thewebview.WindowHandle, SW_NORMAL);
    SetWindowLong(thewebview.WindowHandle, GWL_STYLE, GetWindowLong(thewebview.WindowHandle, GWL_STYLE) or WS_CHILD or
      WS_TABSTOP or WS_CLIPCHILDREN or WS_CLIPSIBLINGS);

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
    if Assigned(FOndownload) then
      thewebview.SetOnDownload(DoDownloadFile, Self);
    if Assigned(FOnMouseOverUrlChange) then
      wkeOnMouseOverUrlChanged(thewebview, DoMouseOverUrlChange, self);

//    if Assigned(wkeOnLoadUrlBegin) then
//      wkeOnLoadUrlBegin(thewebview, DoOnLoadUrlBegin, self);
//    if Assigned(wkeOnLoadUrlEnd) then
//      wkeOnLoadUrlEnd(thewebview, DoOnLoadUrlEnd, self);

    thewebview.SetOnConsoleMessage(DoConsoleMessage, self);
    thewebview.SetOnDocumentReady(DocumentReady, self);
    thewebview.SetOnWindowClosing(DoWindowClosing, self);
    thewebview.SetOnWindowDestroy(DoWindowDestroy, self);

    if FwkeUserAgent <> '' then
      wkeSetUserAgent(thewebview, PansiChar(AnsiString(FwkeUserAgent)));
    wkeSetCookieEnabled(thewebview, FCookieEnabled);
    if DirectoryExists(FwkeCookiePath) and Assigned(wkeSetCookieJarPath) then
      wkeSetCookieJarPath(thewebview, PwideChar(FwkeCookiePath));
    wkeSetNavigationToNewWindowEnable(thewebview, FpopupEnabled);
    wkeSetCspCheckEnable(thewebview, True);
   // wkeset.mask := 4;
   // wkeConfigure(@wkeset);
    jsBindFunction('GetSource', DoGetSource, 1);
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

procedure TWkeWebBrowser.DoWebViewConsoleMessage(Sender: TObject; const AMessage, sourceName: string; sourceLine:
  Cardinal; const stackTrack: string);
//procedure TWkeWebBrowser.DoWebViewConsoleMessage(Sender: TObject; smsg: wkeConsoleMessage);
begin
  if Assigned(FOnConsoleMessage) then
    FOnConsoleMessage(Self, AMessage, sourceName, sourceLine);
end;

procedure TWkeWebBrowser.DoWebViewCreateView(Sender: TObject; sUrl: string; navigationType: wkeNavigationType;
  windowFeatures: PwkeWindowFeatures; var wvw: wkeWebView);
begin
  if Assigned(FwkeApp) then
  begin
    FwkeApp.DoOnNewWindow(self, sUrl, navigationType, windowFeatures, wvw);
    exit;
  end;
  if Assigned(FOnCreateView) then
    FOnCreateView(self, sUrl, navigationType, windowFeatures, wvw);
  if wvw <> nil then
  begin
    if wvw.WindowHandle = 0 then
      wvw := thewebview;
  end;
end;

procedure TWkeWebBrowser.DoWebViewDocumentReady(Sender: TObject);
begin
  if Assigned(FOnDocumentReady) then
    FOnDocumentReady(Self);
end;

function TWkeWebBrowser.DoWebViewDownloadFile(Sender: TObject; sUrl: string): boolean;
begin
  if Assigned(FOndownload) then
    FOnDownload(Self, sUrl);
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

procedure TWkeWebBrowser.DoWebViewLoadUrlEnd(Sender: TObject; sUrl: string; job, buf: Pointer; len: Integer);
begin
  outputdebugstring('urlend call');
  if Assigned(FOnLoadUrlEnd) then
    FOnLoadUrlEnd(self, sUrl, buf, len);
end;

procedure TWkeWebBrowser.DoWebViewLoadUrlStart(Sender: TObject; sUrl: string; out bhook, bHandle: boolean);
begin
  if Assigned(FOnLoadUrlBegin) then
    FOnLoadUrlBegin(Self, sUrl, bhook, bHandle);
end;

procedure TWkeWebBrowser.DoWebViewMouseOverUrlChange(Sender: TObject; sUrl: string);
begin
  if Assigned(FOnMouseOverUrlChange) then
    FOnMouseOverUrlChange(self, sUrl);
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

function TWkeWebBrowser.ExecuteJavascript(const js: string): boolean;
var
  newjs: string;
  r: jsValue;
  es: jsExecState;
begin
  result := false;
  newjs := 'try { ' + js + ' return 1; } catch(err){ return 0;}';
  if Assigned(thewebview) then
  begin
    r := thewebview.RunJS(newjs);
    es := thewebview.GlobalExec;
    if es.IsNumber(r) then
    begin
      if es.Toint(r) = 1 then
        result := true;
    end;
  end;
end;

function TWkeWebBrowser.GetJsTextResult(const js: string): string;
var
  r: jsValue;
  es: jsExecState;
begin
  result := '';
  if Assigned(thewebview) then
  begin
    r := thewebview.RunJS(js);
    es := thewebview.GlobalExec;
    if es.IsString(r) then
      result := es.ToTempString(r);
  end;
end;

function TWkeWebBrowser.GetJsBoolResult(const js: string): boolean;
var
  r: jsValue;
  es: jsExecState;
begin
  result := false;
  if Assigned(thewebview) then
  begin
    r := thewebview.RunJS(js);
    es := thewebview.GlobalExec;
    if es.IsBoolean(r) then
      result := es.ToBoolean(r);
  end;
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

function TWkeWebBrowser.GetCookie: string;
begin
  if Assigned(thewebview) then
    result := thewebview.Cookie;
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
    result := wkeGetTitleW(thewebview);
end;

function TWkeWebBrowser.GetLocationUrl: string;
begin
  if Assigned(thewebview) then
    result := wkeGetUrl(thewebview);
end;

function TWkeWebBrowser.GetMediaVolume: Single;
begin
  if Assigned(thewebview) then
    result := thewebview.MediaVolume;
end;

function TWkeWebBrowser.GetSource: string;
begin
//  if Assigned(thewebview) then
//    result := wkeGetSource(thewebview);
  tmpSource := '';
  if Assigned(thewebview) then
    ExecuteJavascript('GetSource(document.getElementsByTagName("html")[0].outerHTML);');
  Sleep(100);
  result := tmpSource;
end;

function TWkeWebBrowser.GetWebHandle: Hwnd;
begin
  result := 0;
  if Assigned(thewebview) then
    result := thewebview.WindowHandle;
end;

procedure TWkeWebBrowser.setWkeCookiePath(const Value: string);
begin
  FwkeCookiePath := Value;
  if DirectoryExists(FwkeCookiePath) and Assigned(wkeSetCookieJarPath) then
    wkeSetCookieJarPath(thewebview, PwideChar(FwkeCookiePath));
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
    thewebview.LoadURL(Aurl);
  if Assigned(thewebview) then
    thewebview.MoveWindow(0, 0, Width, Height);
end;

procedure TWkeWebBrowser.Refresh;
begin
  if Assigned(thewebview) then
    thewebview.Reload;
end;

procedure TWkeWebBrowser.SetCookie(const Value: string);
begin
  if Assigned(thewebview) then
    thewebview.setcookie(Value);
end;

procedure TWkeWebBrowser.SetFocusToWebbrowser;
begin
  if Assigned(thewebview) then
  begin
    thewebview.SetFocus;
    SendMessage(thewebview.WindowHandle, WM_ACTIVATE, 1, 0);
   // SendMessage(thewebview.WindowHandle,WM_SETFOCUS,0,0);
  end;
end;

procedure TWkeWebBrowser.SetDragEnabled(const Value: boolean);
begin
  if Assigned(thewebview) then
    wkeSetDragEnable(thewebview, Value);
end;

procedure TWkeWebBrowser.SetHeadless(const Value: Boolean);
begin
  if Assigned(thewebview) then
    wkeSetHeadlessEnabled(thewebview, Value);
end;

procedure TWkeWebBrowser.SetTouchEnabled(const Value: Boolean);
begin
  if Assigned(thewebview) then
    wkeSetTouchEnabled(thewebview, Value);
end;

procedure TWkeWebBrowser.SetLocaStoragePath(const Value: string);
begin
  if Assigned(thewebview) then
    thewebview.LocalStoragePath := Value;
end;

procedure TWkeWebBrowser.SetNewPopupEnabled(const Value: Boolean);
begin
  if Assigned(thewebview) then
  begin
    FpopupEnabled := Value;
    wkeSetNavigationToNewWindowEnable(thewebview, Value);
  end;
end;

procedure TWkeWebBrowser.setOnAlertBox(const Value: TOnAlertBoxEvent);
begin
  FOnAlertBox := Value;
  if Assigned(thewebview) then
    thewebview.SetOnAlertBox(DoAlertBox, self);
end;

procedure TWkeWebBrowser.setPlatform(const Value: TwkePlatform);
begin
  if not Assigned(thewebview) then
    Exit;
  if FPlatform <> Value then
  begin
    case Value of
      wp_Win32:
        wkeSetDeviceParameter(thewebview, PAnsiChar('navigator.platform'), PAnsiChar('Win32'), 0, 0);
      wp_Android:
        begin
          wkeSetDeviceParameter(thewebview, PAnsiChar('navigator.platform'), PAnsiChar('Android'), 0, 0);
          wkeSetDeviceParameter(thewebview, PAnsiChar('screen.width'), PAnsiChar('800'), 400, 0);
          wkeSetDeviceParameter(thewebview, PAnsiChar('screen.height'), PAnsiChar('1600'), 800, 0);
        end;
      wp_Ios:
        wkeSetDeviceParameter(thewebview, PAnsiChar('navigator.platform'), PAnsiChar('Android'), 0, 0);
    end;
    FPlatform := Value;
  end;
end;

procedure TWkeWebBrowser.SetProxy(const Value: TwkeProxy);
begin
  if Assigned(thewebview) then
    wkeSetViewProxy(thewebview, Value);
end;

procedure TWkeWebBrowser.ShowDevTool;
begin
 // if Assigned(thewebview) then
 //   wkeSetDebugConfig(thewebview,'showDevTools',PAnsiChar(AnsiToUtf8(ExtractFilePath(ParamStr(0))+'\front_end\inspector.html')));
end;

procedure TWkeWebBrowser.SetZoom(const Value: Integer);
begin
  if Assigned(thewebview) then
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
  if Assigned(thewebview) then
    thewebview.MoveWindow(0, 0, Width, Height);
end;

procedure TWkeWebBrowser.WndProc(var Msg: TMessage);
var
  hndl: Hwnd;
begin
  case Msg.Msg of
    WM_SETFOCUS:
      begin
        hndl := GetWindow(Handle, GW_CHILD);
        if hndl <> 0 then
          PostMessage(hndl, WM_SETFOCUS, Msg.WParam, 0);
        inherited WndProc(Msg);
      end;
    CM_WANTSPECIALKEY:                                  // VK_RETURN,
      if not (TWMKey(Msg).CharCode in [VK_LEFT..VK_DOWN, VK_ESCAPE, VK_TAB]) then    //2018.07.26
        Msg.Result := 1
      else
        inherited WndProc(Msg);
    WM_GETDLGCODE:
      Msg.Result := DLGC_WANTARROWS or DLGC_WANTCHARS or DLGC_WANTTAB;
  else
    inherited WndProc(Msg);
  end;

end;

{ TWkeApp }

constructor TWkeApp.Create(Aowner: TComponent);
begin
  inherited;
  FWkeWebPages := TList{$IFDEF DELPHI15_UP}<TWkeWebBrowser>{$ENDIF}.create;
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
  if csDesigning in Componentstate then
    exit;
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

procedure TWkeApp.DoOnNewWindow(Sender: TObject; sUrl: string; navigationType: wkeNavigationType; windowFeatures:
  PwkeWindowFeatures; var wvw: wkeWebView);
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
          newFrm.BoundsRect := Rect(windowFeatures.x, windowFeatures.y, windowFeatures.x + windowFeatures.width,
            windowFeatures.y + windowFeatures.height);
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

