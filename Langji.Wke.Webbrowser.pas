{ ******************************************************* }
{ }
{ WKE FOR DELPHI }
{ }
{ 版权所有 (C) 2018 Langji }
{ }
{ QQ:231850275 }
{ }
{ ******************************************************* }

unit Langji.Wke.Webbrowser;

// ==============================================================================
// WKE FOR DELPHI
// ==============================================================================

interface

{$I delphiver.inc}


uses
{$IFDEF DELPHI15_UP}
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.graphics, Vcl.Forms,
  System.Generics.Collections,
{$ELSE}
  SysUtils, Classes, Controls, graphics, Forms,
{$ENDIF}
  Messages, windows, Langji.Miniblink.libs, Langji.Miniblink.types, Langji.Wke.types,
  Langji.Wke.IWebBrowser,
  Langji.Wke.lib;

type
  TWkeWebBrowser = class;

  TOnNewWindowEvent = procedure(Sender: TObject; sUrl: string; navigationType: wkeNavigationType;
    windowFeatures: PwkeWindowFeatures; var openflg: TNewWindowFlag; var webbrow: TWkeWebBrowser)
    of object;

  TOnmbJsBindFunction = procedure(Sender: TObject; const msgid: Integer; const msgText: string)
    of object;

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
    procedure DoOnNewWindow(Sender: TObject; sUrl: string; navigationType: wkeNavigationType;
      windowFeatures: PwkeWindowFeatures; var wvw: wkeWebView);
  public
    FWkeWebPages: TList{$IFDEF DELPHI15_UP}<TWkeWebBrowser>{$ENDIF};
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure loaded; override;
    function CreateWebbrowser(Aparent: TWincontrol): TWkeWebBrowser; overload;
    function CreateWebbrowser(Aparent: TWincontrol; Ar: Trect): TWkeWebBrowser; overload;
    procedure CloseWebbrowser(Abrowser: TWkeWebBrowser);
  published
    property WkelibLocation: string read GetWkeLibLocation write SetWkeLibLocation;
    property UserAgent: string read GetWkeUserAgent write SetWkeUserAgent;
    property CookieEnabled: boolean read FCookieEnabled write SetCookieEnabled;
    property CookiePath: string read GetWkeCookiePath write SetWkeCookiePath;
    property OnNewWindow: TOnNewWindowEvent read FOnNewWindow write FOnNewWindow;
  end;

  // 浏览页面
  TWkeWebBrowser = class(TWincontrol)
  private
    thewebview: TwkeWebView;
    FwkeApp: TWkeApp;
    FCanBack, FCanForward: boolean;
    FLocalUrl, FLocalTitle: string; // 当前Url Title
    FpopupEnabled: boolean; // 允许弹窗
    FCookieEnabled: boolean;
    FZoomValue: Integer;
    FLoadFinished: boolean; // 加载完
    FIsmain: boolean;
    FPlatform: TwkePlatform;
    FDocumentIsReady: boolean; // 加载完

    FCookiePath: string;
    FUserAgent: string;
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
    FOnPromptBox: TOnPromptBoxEvent;
    FOnDownload: TOnDownloadEvent;
    FOnMouseOverUrlChange: TOnUrlChangeEvent;
    FOnConsoleMessage: TOnConsoleMessgeEvent;
    FOnLoadUrlEnd: TOnLoadUrlEndEvent;
    FOnLoadUrlBegin: TOnLoadUrlBeginEvent;
    FOnmbBindFunction: TOnmbJsBindFunction;
    function GetZoom: Integer;
    procedure SetZoom(const Value: Integer);

    // webview
    procedure DoWebViewTitleChange(Sender: TObject; const sTitle: string);
    procedure DoWebViewUrlChange(Sender: TObject; const sUrl: string);
    procedure DoWebViewMouseOverUrlChange(Sender: TObject; sUrl: string);
    procedure DoWebViewLoadStart(Sender: TObject; sUrl: string; navigationType: wkeNavigationType;
      var Cancel: boolean);
    procedure DoWebViewLoadEnd(Sender: TObject; sUrl: string; loadresult: wkeLoadingResult);
    procedure DoWebViewCreateView(Sender: TObject; sUrl: string; navigationType: wkeNavigationType;
      windowFeatures: PwkeWindowFeatures; var wvw: Pointer);
    procedure DoWebViewAlertBox(Sender: TObject; smsg: string);
    function DoWebViewConfirmBox(Sender: TObject; smsg: string): boolean;
    function DoWebViewPromptBox(Sender: TObject; smsg, defaultres, Strres: string): boolean;
    procedure DoWebViewConsoleMessage(Sender: TObject; const AMessage, sourceName: string;
      sourceLine: Cardinal; const stackTrack: string);
    procedure DoWebViewDocumentReady(Sender: TObject);
    procedure DoWebViewWindowClosing(Sender: TObject);
    procedure DoWebViewWindowDestroy(Sender: TObject);
    function DoWebViewDownloadFile(Sender: TObject; sUrl: string): boolean;
    procedure DoWebViewLoadUrlEnd(Sender: TObject; sUrl: string; job: Pointer; buf: Pointer;
      len: Integer);
    procedure DoWebViewLoadUrlStart(Sender: TObject; sUrl: string; out bhook, bHandle: boolean);
    procedure DoWebViewJsCallBack(Sender: TObject; param: Pointer; es: TmbJsExecState;
      v: TmbJsValue);
    procedure DombJsBingFunction(Sender: TObject; const msgid: Integer; const response: string);
    procedure WM_SIZE(var msg: TMessage); message WM_SIZE;
    function GetCanBack: boolean;
    function GetCanForward: boolean;
    function GetCookieEnable: boolean;
    function GetLocationTitle: string;
    function GetLocationUrl: string;
    // function GetMediaVolume: Single;
    function GetLoadFinished: boolean;
    function GetWebHandle: Hwnd;
    /// <summary>
    /// 格式为：PRODUCTINFO=webxpress; domain=.fidelity.com; path=/; secure
    /// </summary>
    procedure SetCookie(const Value: string);
    function GetCookie: string;
    procedure SetLocaStoragePath(const Value: string);
    procedure SetHeadless(const Value: boolean);
    procedure SetTouchEnabled(const Value: boolean);
    procedure SetProxy(const Value: TwkeProxy);
    procedure SetDragEnabled(const Value: boolean);
    procedure setOnAlertBox(const Value: TOnAlertBoxEvent);
    procedure SetWkeCookiePath(const Value: string);
    procedure SetUserAgent(const Value: string);
    procedure SetNewPopupEnabled(const Value: boolean);
    function getDocumentReady: boolean;
    function GetContentHeight: Integer;
    function GetContentWidth: Integer;

    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure WndProc(var msg: TMessage); override;
    procedure setPlatform(const Value: TwkePlatform);
    property SimulatePlatform: TwkePlatform read FPlatform write setPlatform;
  public
    { Public declarations }
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure CreateWebView;
    procedure GoBack;
    procedure GoForward;
    procedure Refresh;
    procedure Stop;
    procedure LoadUrl(const Aurl: string);
    /// <summary>
    /// 加载HTMLCODE
    /// </summary>
    procedure LoadHtml(const Astr: string);
    /// <summary>
    /// 加载文件
    /// </summary>
    procedure LoadFile(const AFile: string);
    /// <summary>
    /// 执行js 返回值 为执行成功与否
    /// </summary>
    function ExecuteJavascript(const js: string): boolean;

    /// <summary>
    /// 执行js并得到string返回值
    /// </summary>
    function GetJsTextResult(const js: string): string;
    /// <summary>
    /// 执行js并得到boolean返回值
    /// </summary>
    function GetJsBoolResult(const js: string): boolean;

    /// <summary>
    /// 取webview 的DC
    /// </summary>
    function GetWebViewDC: HDC;
    procedure SetFocusToWebbrowser;
    procedure ShowDevTool; // 2018.3.14
    /// <summary>
    /// 取源码
    /// </summary>
    function GetSource: string;

    /// <summary>
    /// 模拟鼠标
    /// </summary>
    /// <param name=" msg">WM_MouseMove 等</param>
    /// <param name=" x,y">坐标</param>
    /// <param name=" flag">wke_lbutton 左键 、右键等 </param>
    procedure MouseEvent(const msg: Cardinal; const x, y: Integer;
      const flag: Integer = WKE_LBUTTON);
    /// <summary>
    /// 模拟键盘
    /// </summary>
    /// <param name=" flag">WKE_REPEAT等</param>
    procedure KeyEvent(const vkcode: Integer; const flag: Integer = 0);
    property CanBack: boolean read GetCanBack;
    property CanForward: boolean read GetCanForward;
    property LocationUrl: string read GetLocationUrl;
    property LocationTitle: string read GetLocationTitle;
    property LoadFinished: boolean read GetLoadFinished; // 加载完成
    property mainwkeview: TwkeWebView read thewebview;
    property WebViewHandle: Hwnd read GetWebHandle;
    property isMain: boolean read FIsmain;
    property IsDocumentReady: boolean read getDocumentReady;
    property Proxy: TwkeProxy write SetProxy;
    property ZoomPercent: Integer read GetZoom write SetZoom;
    property Headless: boolean write SetHeadless;
    property TouchEnabled: boolean write SetTouchEnabled;
    property DragEnabled: boolean write SetDragEnabled;
    property ContentWidth: Integer read GetContentWidth;
    property ContentHeight: Integer read GetContentHeight;
  published
    property Align;
    property Color;
    property Visible;
    property WkeApp: TWkeApp read FwkeApp write FwkeApp;
    property UserAgent: string read FUserAgent write SetUserAgent;
    property CookieEnabled: boolean read FCookieEnabled write FCookieEnabled default true;
    property CookiePath: string read FCookiePath write SetWkeCookiePath;
    /// <summary>
    /// Cookie格式为：PRODUCTINFO=webxpress; domain=.fidelity.com; path=/; secure
    /// </summary>
    property Cookie: string read GetCookie write SetCookie;
    property LocalStoragePath: string write SetLocaStoragePath;
    property PopupEnabled: boolean read FpopupEnabled write SetNewPopupEnabled default true;
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
    property OnMouseOverUrlChanged: TOnUrlChangeEvent read FOnMouseOverUrlChange write
      FOnMouseOverUrlChange; // 2018.3.14
    property OnConsoleMessage: TOnConsoleMessgeEvent read FOnConsoleMessage write FOnConsoleMessage;
    property OnLoadUrlBegin: TOnLoadUrlBeginEvent read FOnLoadUrlBegin write FOnLoadUrlBegin;
    property OnLoadUrlEnd: TOnLoadUrlEndEvent read FOnLoadUrlEnd write FOnLoadUrlEnd;
    property OnmbJsBindFunction: TOnmbJsBindFunction read FOnmbBindFunction write FOnmbBindFunction;
  end;

implementation

uses // dialogs,
  math;



// ==============================================================================
// 回调事件
// ==============================================================================

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
  TWkeWebBrowser(param).DoWebViewMouseOverUrlChange(TWkeWebBrowser(param),
    wkeWebView.GetString(url));
end;

procedure DoLoadEnd(webView: wkeWebView; param: Pointer; url: wkeString; result: wkeLoadingResult;
  failedReason: wkeString); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewLoadEnd(TWkeWebBrowser(param), wkeWebView.GetString(url), result);
end;

var
  tmpSource: string = '';
  FmbjsES: TmbJsExecState;
  Fmbjsvalue: TmbJsValue;
  FmbjsgetValue: boolean;

function DoGetSource(p1, p2, es: jsExecState): jsValue;
var
  s: string;
begin
  s := es.ToTempString(es.Arg(0));
  tmpSource := s;
  result := 0;
end;

function DoLoadStart(webView: wkeWebView; param: Pointer; navigationType: wkeNavigationType; url:
  wkeString): boolean; cdecl;
var
  Cancel: boolean;
begin
  Cancel := false;
  TWkeWebBrowser(param).DoWebViewLoadStart(TWkeWebBrowser(param), wkeWebView.GetString(url),
    navigationType, Cancel);
  result := not Cancel;
end;

function DoCreateView(webView: wkeWebView; param: Pointer; navigationType: wkeNavigationType; url:
  wkeString; windowFeatures: PwkeWindowFeatures): wkeWebView; cdecl;
var
  pt: Pointer;
begin
  TWkeWebBrowser(param).DoWebViewCreateView(TWkeWebBrowser(param), wkeWebView.GetString(url),
    navigationType, windowFeatures, pt);
  result := wkeWebView(pt);
end;

procedure DoPaintUpdated(webView: wkeWebView; param: Pointer; HDC: HDC; x: Integer; y: Integer; cx:
  Integer; cy: Integer); cdecl;
begin

end;

procedure DoAlertBox(webView: wkeWebView; param: Pointer; msg: wkeString); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewAlertBox(TWkeWebBrowser(param), wkeWebView.GetString(msg));
end;

function DoConfirmBox(webView: wkeWebView; param: Pointer; msg: wkeString): boolean; cdecl;
begin
  result := TWkeWebBrowser(param).DoWebViewConfirmBox(TWkeWebBrowser(param),
    wkeWebView.GetString(msg));
end;

function DoPromptBox(webView: wkeWebView; param: Pointer; msg: wkeString; defaultResult: wkeString;
  sresult: wkeString): boolean; cdecl;
begin
  result := TWkeWebBrowser(param).DoWebViewPromptBox(TWkeWebBrowser(param),
    wkeWebView.GetString(msg),
    wkeWebView.GetString(defaultResult), wkeWebView.GetString(sresult));
end;

procedure DoConsoleMessage(webView: wkeWebView; param: Pointer; level: wkeMessageLevel; const
  AMessage, sourceName: wkeString; sourceLine: Cardinal; const stackTrack: wkeString); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewConsoleMessage(TWkeWebBrowser(param),
    wkeWebView.GetString(AMessage),
    wkeWebView.GetString(sourceName), sourceLine, wkeWebView.GetString(stackTrack));
end;

procedure DocumentReady(webView: wkeWebView; param: Pointer); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewDocumentReady(TWkeWebBrowser(param));
end;

function DoWindowClosing(webWindow: wkeWebView; param: Pointer): boolean; cdecl;
begin
  TWkeWebBrowser(param).DoWebViewWindowClosing(TWkeWebBrowser(param));
end;

procedure DoWindowDestroy(webWindow: wkeWebView; param: Pointer); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewWindowDestroy(TWkeWebBrowser(param));
end;

function DodownloadFile(webView: wkeWebView; param: Pointer; url: PansiChar): boolean; cdecl;
// url: wkeString): boolean; cdecl;
begin
  result := TWkeWebBrowser(param).DoWebViewDownloadFile(TWkeWebBrowser(param), StrPas(url));
  // wkeWebView.GetString(url));
end;

procedure DoOnLoadUrlEnd(webView: wkeWebView; param: Pointer; const url: PansiChar; job: Pointer;
  buf: Pointer; len: Integer); cdecl;
begin
  TWkeWebBrowser(param).DoWebViewLoadUrlEnd(TWkeWebBrowser(param), StrPas(url), job, buf, len);
end;

function DoOnLoadUrlBegin(webView: wkeWebView; param: Pointer; url: PansiChar; job: Pointer)
  : boolean; cdecl;
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

function DombOnLoadUrlBegin(webView: TmbWebView; param: Pointer; const url: PansiChar; job: Pointer)
  : boolean; stdcall;
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


// ----------------------------mb回调------------------------------------//

procedure DombTitleChange(webView: TmbWebView; param: Pointer; const title: PansiChar); stdcall;
var
  s: string;
begin
  s := UTF8Decode(StrPas(title));
  TWkeWebBrowser(param).DoWebViewTitleChange(TWkeWebBrowser(param), s);
end;

procedure DombUrlChange(webView: TmbWebView; param: Pointer; const url: PansiChar; bcanback,
  bcanforward: boolean); stdcall;
begin
  TWkeWebBrowser(param).DoWebViewUrlChange(TWkeWebBrowser(param), UTF8Decode(StrPas(url)));
end;

function DombLoadStart(webView: TmbWebView; param: Pointer; navigationType: TmbNavigationType; const
  url: PansiChar): boolean; stdcall;
var
  Cancel: boolean;
begin
  Cancel := false;
  TWkeWebBrowser(param).DoWebViewLoadStart(TWkeWebBrowser(param), UTF8Decode(StrPas(url)),
    wkeNavigationType(navigationType), Cancel);
  result := not Cancel;
end;

procedure DombLoadEnd(webView: TmbWebView; param: Pointer; frameId: TmbWebFrameHandle; const url:
  PansiChar; lresult: TmbLoadingResult; const failedReason: PansiChar); stdcall;
begin
  if frameId = mbWebFrameGetMainFrame(webView) then
    TWkeWebBrowser(param).DoWebViewLoadEnd(TWkeWebBrowser(param), UTF8Decode(StrPas(url)),
      wkeLoadingResult(lresult));
end;

function DombCreateView(webView: TmbWebView; param: Pointer; navigationType: TmbNavigationType;
  const url: PansiChar; const windowFeatures: PmbWindowFeatures): TmbWebView; stdcall;
var
  xhandle: Hwnd;
  wv: TmbWebView;
begin
  wv := nil;
  TWkeWebBrowser(param).DoWebViewCreateView(TWkeWebBrowser(param), UTF8Decode(StrPas(url)),
    wkeNavigationType(navigationType), PwkeWindowFeatures(windowFeatures), wv);
  result := wv;
end;

procedure DombDocumentReady(webView: TmbWebView; param: Pointer;
  frameId: TmbWebFrameHandle); stdcall;
begin
  TWkeWebBrowser(param).DoWebViewDocumentReady(TWkeWebBrowser(param));
end;

procedure DoMbAlertBox(webView: TmbWebView; param: Pointer; const msg: PansiChar); stdcall;
begin
  TWkeWebBrowser(param).DoWebViewAlertBox(TWkeWebBrowser(param), UTF8Decode(StrPas(msg)));
end;

function DombConfirmBox(webView: TmbWebView; param: Pointer; const msg: PansiChar)
  : boolean; stdcall;
begin
  result := TWkeWebBrowser(param).DoWebViewConfirmBox(TWkeWebBrowser(param),
    UTF8Decode(StrPas(msg)));
end;

function DombPromptBox(webView: TmbWebView; param: Pointer; const msg: PansiChar; const
  defaultResult: PansiChar; sresult: PansiChar): boolean; stdcall;
begin
  result := TWkeWebBrowser(param).DoWebViewPromptBox(TWkeWebBrowser(param), UTF8Decode(StrPas(msg)),
    UTF8Decode(StrPas(defaultResult)), UTF8Decode(StrPas(sresult)));
end;

procedure DombConsole(webView: TmbWebView; param: Pointer; level: TmbConsoleLevel; const smessage:
  PansiChar; const sourceName: PansiChar; sourceLine: Cardinal;
  const stackTrace: PansiChar); stdcall;
begin
  TWkeWebBrowser(param).DoWebViewConsoleMessage(TWkeWebBrowser(param), UTF8Decode(StrPas(smessage)),
    UTF8Decode(StrPas(sourceName)), sourceLine, UTF8Decode(StrPas(stackTrace)));
end;

function DombClose(webView: TmbWebView; param: Pointer; unuse: Pointer): boolean; stdcall;
begin
  TWkeWebBrowser(param).DoWebViewWindowClosing(TWkeWebBrowser(param));
end;

function DombDestory(webView: TmbWebView; param: Pointer; unuse: Pointer): boolean; stdcall;
begin
  result := false;
  // TWkeWebBrowser(param).DoWebViewWindowDestroy(TWkeWebBrowser(param));
end;

function DombPrint(webView: TmbWebView; param: Pointer; step: TmbPrintintStep; HDC: HDC; const
  settings: TmbPrintintSettings; pagecount: Integer): boolean; stdcall;
begin

end;

// function DombDownload(webView: TmbWebView; param: Pointer; const url: PAnsiChar): boolean; stdcall;
// begin
// result := TWkeWebBrowser(param).DoWebViewDownloadFile(TWkeWebBrowser(param), UTF8Decode(StrPas(url)));
// end;

procedure DoMbThreadDownload(webView: TmbWebView; param: Pointer; expectedContentLength: DWORD;
  const url, mime, disposition: PChar; job: Tmbnetjob; databind: PmbNetJobDataBind); stdcall;
begin
  TWkeWebBrowser(param).DoWebViewDownloadFile(TWkeWebBrowser(param), UTF8Decode(StrPas(url)));
end;

procedure DombGetCanBack(webView: TmbWebView; param: Pointer; state: TMbAsynRequestState;
  b: boolean); stdcall;
begin
  if state = kMbAsynRequestStateOk then
    TWkeWebBrowser(param).FCanBack := b;
end;

procedure DombGetCanForward(webView: TmbWebView; param: Pointer; state: TMbAsynRequestState;
  b: boolean); stdcall;
begin
  if state = kMbAsynRequestStateOk then
    TWkeWebBrowser(param).FCanForward := b;
end;

procedure Dombjscallback(webView: TmbWebView; param: Pointer; es: TmbJsExecState;
  v: TmbJsValue); stdcall;
begin
  // TWkeWebBrowser(param).DoWebViewJsCallBack(TWkeWebBrowser(param), param, es, v);
  FmbjsES := es;
  Fmbjsvalue := v;
  FmbjsgetValue := true;
end;

procedure DombJsBingCallback(webView: TmbWebView; param: Pointer; es: TmbJsExecState; queryId: Int64;
  customMsg: Integer; const request: PansiChar); stdcall;
begin

  if customMsg = mbgetsourcemsg then
  begin
    tmpSource := UTF8Decode(StrPas(request));
    // OutputDebugString(PChar(tmpSource));
    FmbjsgetValue := true;
  end
  else
  begin
    TWkeWebBrowser(param).DombJsBingFunction(TWkeWebBrowser(param), customMsg,
      UTF8Decode(StrPas(request)));
    mbResponseQuery(webView, queryId, customMsg, PansiChar('DelphiCallback'));
  end;

end;

{ TWkeWebBrowser }

constructor TWkeWebBrowser.Create(Aowner: TComponent);
begin
  inherited;
  Color := clwhite;
  FZoomValue := 100;
  FCookieEnabled := true;
  FpopupEnabled := true;
  { FUserAgent :=
    'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.1650.63 Safari/537.36 Langji.MiniBlink 1.1';
  }
  FPlatform := wp_Win32;
  FLocalUrl := '';
  FLocalTitle := '';

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
    FIsmain := WkeLoadLibAndInit;
  CreateWebView;
end;

procedure TWkeWebBrowser.CreateWebView;
var
  wkeset: wkeSettings;
begin
  if UseFastMB then
  begin
    thewebview := mbCreateWebWindow(MB_WINDOW_TYPE_CONTROL, handle, 0, 0, Width, height);
    if Assigned(thewebview) then
    begin
      mbShowWindow(thewebview, true);
      SetWindowLong(mbGetHostHWND(thewebview), GWL_STYLE, GetWindowLong(mbGetHostHWND(thewebview),
        GWL_STYLE) or WS_CHILD or WS_TABSTOP or WS_CLIPCHILDREN or WS_CLIPSIBLINGS);

      mbResize(thewebview, Width, height);

      mbOnTitleChanged(thewebview, DombTitleChange, Self);
      mbOnURLChanged(thewebview, DombUrlChange, Self);
      mbOnNavigation(thewebview, DombLoadStart, Self);
      mbOnLoadingFinish(thewebview, DombLoadEnd, Self);
      // if Assigned(FwkeApp) or Assigned(FOnCreateView) then
      mbOnCreateView(thewebview, DombCreateView, Self);
      mbOnDocumentReady(thewebview, DombDocumentReady, Self);
      if Assigned(FOnAlertBox) then
        mbOnAlertBox(thewebview, DoMbAlertBox, Self);
      if Assigned(FOnConfirmBox) then
        mbOnConfirmBox(thewebview, DombConfirmBox, Self);
      if Assigned(FOnPromptBox) then
        mbOnPromptBox(thewebview, DombPromptBox, Self);
      if Assigned(FOnConsoleMessage) then
        mbOnConsole(thewebview, DombConsole, Self);

      mbOnClose(thewebview, DombClose, Self);
      mbOnDestroy(thewebview, DombDestory, Self);
      mbOnPrinting(thewebview, DombPrint, Self);
      mbOnJsQuery(thewebview, DombJsBingCallback, Self);
      mbOnDownloadInBlinkThread(thewebview, DoMbThreadDownload, Self);

      mbCanGoBack(thewebview, DombGetCanBack, Self);
      mbCanGoForward(thewebview, DombGetCanForward, Self);
      mbOnLoadUrlBegin(thewebview, DombOnLoadUrlBegin, Self);
      if FUserAgent <> '' then
        mbSetUserAgent(thewebview, PansiChar(FUserAgent));
      if DirectoryExists(FCookiePath) then
        mbSetCookieJarPath(thewebview, PWideChar(FCookiePath));

      if FpopupEnabled then
        mbSetNavigationToNewWindowEnable(thewebview, true);
    end;
    exit;
  end;

  thewebview := wkeCreateWebWindow(WKE_WINDOW_TYPE_CONTROL, handle, 0, 0, Width, height);

  if Assigned(thewebview) then
  begin
    ShowWindow(thewebview.WindowHandle, SW_NORMAL);
    SetWindowLong(thewebview.WindowHandle, GWL_STYLE, GetWindowLong(thewebview.WindowHandle,
      GWL_STYLE) or WS_CHILD or WS_TABSTOP or WS_CLIPCHILDREN or WS_CLIPSIBLINGS);

    thewebview.SetOnTitleChanged(DoTitleChange, Self);
    thewebview.SetOnURLChanged(DoUrlChange, Self);
    thewebview.SetOnNavigation(DoLoadStart, Self);
    thewebview.SetOnLoadingFinish(DoLoadEnd, Self);
    // if Assigned(FwkeApp) or Assigned(FOnCreateView) then
    thewebview.SetOnCreateView(DoCreateView, Self);
    thewebview.SetOnPaintUpdated(DoPaintUpdated, Self);
    if Assigned(FOnAlertBox) then
      thewebview.setOnAlertBox(DoAlertBox, Self);
    if Assigned(FOnConfirmBox) then
      thewebview.SetOnConfirmBox(DoConfirmBox, Self);
    if Assigned(FOnPromptBox) then
      thewebview.SetOnPromptBox(DoPromptBox, Self);
    if Assigned(FOnDownload) then
      thewebview.SetOnDownload(DodownloadFile, Self);
    if Assigned(FOnMouseOverUrlChange) then
      wkeOnMouseOverUrlChanged(thewebview, DoMouseOverUrlChange, Self);

    thewebview.SetOnConsoleMessage(DoConsoleMessage, Self);
    thewebview.SetOnDocumentReady(DocumentReady, Self);
    thewebview.SetOnWindowClosing(DoWindowClosing, Self);
    thewebview.SetOnWindowDestroy(DoWindowDestroy, Self);

    wkeOnLoadUrlBegin(thewebview, DoOnLoadUrlBegin, Self);

    if FUserAgent <> '' then
      wkeSetUserAgent(thewebview, PansiChar(AnsiString(FUserAgent)));
    wkeSetCookieEnabled(thewebview, FCookieEnabled);
    if DirectoryExists(FCookiePath) and Assigned(wkeSetCookieJarPath) then
      wkeSetCookieJarPath(thewebview, PWideChar(FCookiePath));
    wkeSetNavigationToNewWindowEnable(thewebview, FpopupEnabled);

    wkeSetCspCheckEnable(thewebview, false); // 关闭跨域检查
    jsBindFunction('GetSource', DoGetSource, 1);
  end;
end;

procedure TWkeWebBrowser.DombJsBingFunction(Sender: TObject; const msgid: Integer;
  const response: string);
begin
  if Assigned(FOnmbBindFunction) then
    FOnmbBindFunction(Self, msgid, response);
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
    FOnConfirmBox(Self, smsg, result);
end;

procedure TWkeWebBrowser.DoWebViewConsoleMessage(Sender: TObject; const AMessage, sourceName: string;
  sourceLine: Cardinal; const stackTrack: string);
begin
  if Assigned(FOnConsoleMessage) then
    FOnConsoleMessage(Self, AMessage, sourceName, sourceLine);

end;

procedure TWkeWebBrowser.DoWebViewCreateView(Sender: TObject; sUrl: string; navigationType:
  wkeNavigationType; windowFeatures: PwkeWindowFeatures; var wvw: Pointer);
var
  newFrm: TForm;
  view: wkeWebView;
begin
  // if Assigned(FwkeApp) then
  // begin
  // ShowMessage('backs');
  // FwkeApp.DoOnNewWindow(self, sUrl, navigationType, windowFeatures, view);
  //
  // wvw := view;
  // exit;
  // end;

  if Assigned(FOnCreateView) then
  begin
    FOnCreateView(Self, sUrl, navigationType, windowFeatures, view);
    wvw := view;
    // exit;
  end;

  if not Assigned(wvw) then
  begin
    if UseFastMB then
    begin
      wvw := mbCreateWebWindow(MB_WINDOW_TYPE_POPUP, 0, windowFeatures.x, windowFeatures.y,
        800, 600);
      mbShowWindow(wvw, true);
      mbMoveToCenter(wvw);
    end
    else
    begin
      wvw := wkeCreateWebWindow(WKE_WINDOW_TYPE_POPUP, 0, windowFeatures.x, windowFeatures.y,
        windowFeatures.Width, windowFeatures.height);
      wkeShowWindow(wvw, true);
    end;
  end
  else
  begin
    if UseFastMB then
    begin
      if (mbGetHostHWND(wvw) = 0) then
        wvw := thewebview;
    end
    else
    begin
      if wkeGetWindowHandle(wvw) = 0 then
        wvw := thewebview;
    end;
  end;
end;

procedure TWkeWebBrowser.DoWebViewDocumentReady(Sender: TObject);
begin
  FDocumentIsReady := true;
  if Assigned(FOnDocumentReady) then
    FOnDocumentReady(Self);
end;

function TWkeWebBrowser.DoWebViewDownloadFile(Sender: TObject; sUrl: string): boolean;
begin
  if Assigned(FOnDownload) then
    FOnDownload(Self, sUrl);
end;

procedure TWkeWebBrowser.DoWebViewJsCallBack(Sender: TObject; param: Pointer; es: TmbJsExecState; v:
  TmbJsValue); // js返回值
begin

end;

procedure TWkeWebBrowser.DoWebViewLoadEnd(Sender: TObject; sUrl: string;
  loadresult: wkeLoadingResult);
begin
  FLoadFinished := true;
  FLocalUrl := sUrl;
  if Assigned(FOnLoadEnd) then
    FOnLoadEnd(Self, sUrl, loadresult);
end;

procedure TWkeWebBrowser.DoWebViewLoadStart(Sender: TObject; sUrl: string; navigationType:
  wkeNavigationType; var Cancel: boolean);
begin
  FLoadFinished := false;
  FDocumentIsReady := false;
  FLocalUrl := sUrl;
  if Assigned(FOnLoadStart) then
    FOnLoadStart(Self, sUrl, navigationType, Cancel);
end;

procedure TWkeWebBrowser.DoWebViewLoadUrlEnd(Sender: TObject; sUrl: string; job, buf: Pointer;
  len: Integer);
begin
  if Assigned(FOnLoadUrlEnd) then
    FOnLoadUrlEnd(Self, sUrl, buf, len);
end;

procedure TWkeWebBrowser.DoWebViewLoadUrlStart(Sender: TObject; sUrl: string;
  out bhook, bHandle: boolean);
begin
  // bhook:=true 表示hook会触发onloadurlend 如果只是设置 bhandle=true表示 ，只是拦截这个URL
  if Assigned(FOnLoadUrlBegin) then
    FOnLoadUrlBegin(Self, sUrl, bhook, bHandle);
end;

procedure TWkeWebBrowser.DoWebViewMouseOverUrlChange(Sender: TObject; sUrl: string);
begin
  if Assigned(FOnMouseOverUrlChange) then
    FOnMouseOverUrlChange(Self, sUrl);
end;

function TWkeWebBrowser.DoWebViewPromptBox(Sender: TObject;
  smsg, defaultres, Strres: string): boolean;
begin
  if Assigned(FOnPromptBox) then
    FOnPromptBox(Self, smsg, defaultres, Strres, result);
end;

procedure TWkeWebBrowser.DoWebViewTitleChange(Sender: TObject; const sTitle: string);
begin
  FLocalTitle := sTitle;
  if Assigned(FOnTitleChange) then
    FOnTitleChange(Self, sTitle);
end;

procedure TWkeWebBrowser.DoWebViewUrlChange(Sender: TObject; const sUrl: string);
begin
  if Assigned(FOnUrlChange) then
    FOnUrlChange(Self, sUrl);
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

function TWkeWebBrowser.ExecuteJavascript(const js: string): boolean; // 执行js
var
  newjs: AnsiString;
  r: jsValue;
  es: jsExecState;
  x: Integer;
begin
  if UseFastMB then
  begin
    result := false;
    newjs := UTF8Encode('try { ' + js + '; return 1; } catch(err){ return 0;}');
    if Assigned(thewebview) then
    begin
      FmbjsgetValue := false;
      mbRunJs(thewebview, mbWebFrameGetMainFrame(thewebview), PansiChar(newjs), true,
        Dombjscallback, Self, nil);
      x := 0;
      repeat
        Sleep(120);
        Application.ProcessMessages;
      until (x > 15) or FmbjsgetValue;
      if FmbjsgetValue then
      begin
        if '1' = StrPas(mbJsToString(FmbjsES, Fmbjsvalue)) then
          result := true;
      end;

    end;
    exit;
  end;

  result := false;
  newjs := 'try { ' + js + '; return 1; } catch(err){ return 0;}';
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
  x: Integer;
begin
  result := '';

  if UseFastMB then
  begin
    if Assigned(thewebview) then
    begin
      FmbjsgetValue := false;
      mbRunJs(thewebview, mbWebFrameGetMainFrame(thewebview), PansiChar(AnsiString(js)), true,
        Dombjscallback, Self, nil);
      x := 0;
      repeat
        Sleep(120);
        Application.ProcessMessages;
      until (x > 15) or FmbjsgetValue;
      if FmbjsgetValue then
      begin
        result := StrPas(mbJsToString(FmbjsES, Fmbjsvalue));
      end;
    end;
    exit;
  end;

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
  x: Integer;
begin
  result := false;
  if UseFastMB then
  begin
    if Assigned(thewebview) then
    begin
      FmbjsgetValue := false;
      mbRunJs(thewebview, mbWebFrameGetMainFrame(thewebview), PansiChar(AnsiString(js)), true,
        Dombjscallback, Self, nil);
      x := 0;
      repeat
        Sleep(120);
        Application.ProcessMessages;
      until (x > 15) or FmbjsgetValue;
      if FmbjsgetValue then
      begin
        result := mbJsToboolean(FmbjsES, Fmbjsvalue);
      end;
    end;
    exit;
  end;

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
  begin
    if UseFastMB then
      result := FCanBack
    else
      result := thewebview.CanGoBack;
  end;
end;

function TWkeWebBrowser.GetCanForward: boolean;
begin

  if Assigned(thewebview) then
  begin
    if UseFastMB then
      result := FCanForward
    else
      result := thewebview.CanGoForward;
  end;
end;

function TWkeWebBrowser.GetContentHeight: Integer;
begin
  result := 0;
  if UseFastMB then
    exit;
  if Assigned(thewebview) then
    result := wkeGetContentHeight(thewebview);
end;

function TWkeWebBrowser.GetContentWidth: Integer;
begin
  result := 0;
  if UseFastMB then
    exit;
  if Assigned(thewebview) then
    result := wkeGetContentWidth(thewebview);
end;

function TWkeWebBrowser.GetCookie: string;
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      result := mbGetCookieOnBlinkThread(thewebview)
    else
      result := thewebview.Cookie;
  end;
end;

function TWkeWebBrowser.GetCookieEnable: boolean;
begin

  if Assigned(thewebview) then
  begin
    if UseFastMB then
      result := true
    else
      result := thewebview.CookieEnabled;
  end;

end;

function TWkeWebBrowser.getDocumentReady: boolean;
begin
  result := false;
  if Assigned(thewebview) then
  begin
    if not UseFastMB then
      FDocumentIsReady := wkeIsDocumentReady(thewebview);
    result := FDocumentIsReady;
  end;
end;

function TWkeWebBrowser.GetLoadFinished: boolean;
begin
  result := FLoadFinished;
end;

function TWkeWebBrowser.GetLocationTitle: string;
begin

  if Assigned(thewebview) then
  begin
    if UseFastMB then
      result := FLocalTitle
    else
      result := wkeGetTitleW(thewebview);
  end;

end;

function TWkeWebBrowser.GetLocationUrl: string;
begin

  if Assigned(thewebview) then
  begin
    if UseFastMB then
      result := FLocalUrl
    else
      result := wkeGetUrl(thewebview);
  end;

end;

function TWkeWebBrowser.GetSource: string; // 取源码
begin
  // if Assigned(thewebview) then
  // result := wkeGetSource(thewebview);
  tmpSource := '';
  if Assigned(thewebview) then
  begin
    if UseFastMB then
    begin
      FmbjsgetValue := false;
      mbRunJs(thewebview, mbWebFrameGetMainFrame(thewebview),
        'function onNative(customMsg, response) {console.log("on~~mbQuery:" + response);} ' +
        'window.mbQuery(0x4001, document.getElementsByTagName("html")[0].outerHTML, onNative);',
        true, Dombjscallback, Self, nil);
      repeat
        Sleep(200);
        Application.ProcessMessages;
      until FmbjsgetValue;
    end
    else
    begin
      ExecuteJavascript('GetSource(document.getElementsByTagName("html")[0].outerHTML);');
    end;
    Sleep(100);
    result := tmpSource;
  end;
end;

function TWkeWebBrowser.GetWebHandle: Hwnd;
begin
  result := 0;
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      result := mbGetHostHWND(thewebview)
    else
      result := thewebview.WindowHandle;
  end;

end;

function TWkeWebBrowser.GetWebViewDC: HDC;
begin
  result := 0;
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      result := GetDC(mbGetHostHWND(thewebview))
    else
      result := wkeGetViewDC(thewebview);
  end;

end;

procedure TWkeWebBrowser.SetUserAgent(const Value: string);
begin
  if UseFastMB then
  begin
    if Value <> '' then
      mbSetUserAgent(thewebview, PansiChar(AnsiString(Value)));
  end
  else
  begin
    if Value <> '' then
      wkeSetUserAgent(thewebview, PansiChar(AnsiString(Value)));
  end;
  FUserAgent := Value;
end;

procedure TWkeWebBrowser.SetWkeCookiePath(const Value: string);
begin
  if DirectoryExists(Value) then
    FCookiePath := Value;

  if Assigned(thewebview) then
  begin
    if UseFastMB then
      mbSetCookieJarFullPath(thewebview, PWideChar(Value))
    else
      wkeSetCookieJarPath(thewebview, PWideChar(Value));
  end;
end;

function TWkeWebBrowser.GetZoom: Integer;
begin

  if Assigned(thewebview) then
  begin
    if UseFastMB then
      result := Trunc(power(1.2, mbGetZoomFactor(thewebview)) * 100)
    else
      result := Trunc(power(1.2, thewebview.ZoomFactor) * 100)
  end
  else
    result := 100;
end;

procedure TWkeWebBrowser.GoBack;
var
  wv: TmbWebView;
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
    begin
      if FCanBack then
        mbGoBack(thewebview);
    end
    else
    begin
      if thewebview.CanGoBack then
        thewebview.GoBack;
    end;
  end;
end;

procedure TWkeWebBrowser.GoForward;
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
    begin
      if FCanForward then
        mbGoForward(thewebview);
    end
    else
    begin
      if thewebview.CanGoForward then
        thewebview.GoForward;
    end;
  end;
end;

procedure TWkeWebBrowser.KeyEvent(const vkcode, flag: Integer);
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
    begin
      mbFireKeyDownEvent(thewebview, vkcode, flag, false);
      Sleep(10);
      mbFireKeyUpEvent(thewebview, vkcode, flag, false);
    end
    else
    begin
      wkeFireKeyDownEvent(thewebview, vkcode, flag, false);
      Sleep(10);
      wkeFireKeyUpEvent(thewebview, vkcode, flag, false);
    end;
  end;
end;

procedure TWkeWebBrowser.LoadFile(const AFile: string);
begin
  if Assigned(thewebview) and FileExists(AFile) then
  begin
    FLoadFinished := false;
    if UseFastMB then
      mbLoadURL(thewebview, PansiChar(AnsiString(UTF8Encode('file:///' + AFile))))
    else
      thewebview.LoadFile(AFile);
  end;

end;

procedure TWkeWebBrowser.LoadHtml(const Astr: string);
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      mbLoadHtmlWithBaseUrl(thewebview, PansiChar(AnsiString(Astr)), 'about:blank')
    else
      thewebview.LoadHtml(Astr);
  end;

end;

procedure TWkeWebBrowser.LoadUrl(const Aurl: string);
begin

  if Assigned(thewebview) then
  begin
    if UseFastMB then
      mbLoadURL(thewebview, PansiChar(AnsiString(UTF8Encode(Aurl))))
    else
    begin
      thewebview.LoadUrl(Aurl);
      thewebview.MoveWindow(0, 0, Width, height);
    end;
  end;
end;

procedure TWkeWebBrowser.MouseEvent(const msg: Cardinal; const x, y, flag: Integer);
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      mbFireMouseEvent(thewebview, msg, x, y, flag)
    else
      wkeFireMouseEvent(thewebview, msg, x, y, flag);
  end;
end;

procedure TWkeWebBrowser.Refresh;
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      mbReload(thewebview)
    else
      thewebview.Reload;
  end;
end;

procedure TWkeWebBrowser.SetCookie(const Value: string); // 设置cookie----------
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      mbSetCookie(thewebview, PansiChar(FLocalUrl), PansiChar(Value))
    else
      thewebview.SetCookie(Value);
  end;
end;

procedure TWkeWebBrowser.SetFocusToWebbrowser;
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      SendMessage(mbGetHostHWND(thewebview), WM_ACTIVATE, 1, 0)
    else
    begin
      thewebview.SetFocus;
      SendMessage(thewebview.WindowHandle, WM_ACTIVATE, 1, 0);
    end;
  end;
end;

procedure TWkeWebBrowser.SetDragEnabled(const Value: boolean);
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      mbSetDragDropEnable(thewebview, Value)
    else
      wkeSetDragEnable(thewebview, Value);
  end;

end;

procedure TWkeWebBrowser.SetHeadless(const Value: boolean);
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      mbSetHeadlessEnabled(thewebview, Value)
    else
      wkeSetHeadlessEnabled(thewebview, Value);
  end;

end;

procedure TWkeWebBrowser.SetTouchEnabled(const Value: boolean);
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      exit
    else
      wkeSetTouchEnabled(thewebview, Value);
  end;
end;

procedure TWkeWebBrowser.SetLocaStoragePath(const Value: string);
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      mbSetLocalStorageFullPath(thewebview, PWideChar(Value))
    else
      thewebview.LocalStoragePath := Value;
  end;

end;

procedure TWkeWebBrowser.SetNewPopupEnabled(const Value: boolean);
begin
  FpopupEnabled := Value;
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      mbSetNavigationToNewWindowEnable(thewebview, Value)
    else
      wkeSetNavigationToNewWindowEnable(thewebview, Value);
  end;
end;

procedure TWkeWebBrowser.setOnAlertBox(const Value: TOnAlertBoxEvent);
begin
  FOnAlertBox := Value;
  if Assigned(thewebview) then
    thewebview.setOnAlertBox(DoAlertBox, Self);
end;

procedure TWkeWebBrowser.setPlatform(const Value: TwkePlatform);
begin
  if not Assigned(thewebview) then
    exit;
  if UseFastMB then
    exit;
  if FPlatform <> Value then
  begin
    case Value of
      wp_Win32:
        wkeSetDeviceParameter(thewebview, PansiChar('navigator.platform'),
          PansiChar('Win32'), 0, 0);
      wp_Android:
        begin
          wkeSetDeviceParameter(thewebview, PansiChar('navigator.platform'),
            PansiChar('Android'), 0, 0);
          wkeSetDeviceParameter(thewebview, PansiChar('screen.width'), PansiChar('800'), 400, 0);
          wkeSetDeviceParameter(thewebview, PansiChar('screen.height'), PansiChar('1600'), 800, 0);
        end;
      wp_Ios:
        wkeSetDeviceParameter(thewebview, PansiChar('navigator.platform'),
          PansiChar('Android'), 0, 0);
    end;
    FPlatform := Value;
  end;
end;

procedure TWkeWebBrowser.SetProxy(const Value: TwkeProxy);
var
  xproxy: TmbProxy;
  shost: AnsiString;
begin

  if Assigned(thewebview) then
  begin
    if UseFastMB then
    begin
      with xproxy do
      begin
        mtype := TmbProxyType(Value.AType);
        shost := Value.hostname;
        StrPCopy(hostname, shost);
        port := Value.port;
        shost := Value.username;
        StrPCopy(username, shost);
        shost := Value.password;
        StrPCopy(password, shost);
      end;
      mbSetProxy(thewebview, @xproxy)
    end
    else
      wkeSetViewProxy(thewebview, Value);
  end;

end;

procedure TWkeWebBrowser.ShowDevTool;
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      mbSetDebugConfig(thewebview, 'showDevTools', PansiChar(AnsiToUtf8(ExtractFilePath(ParamStr(0))
        + '\front_end\inspector.html')))
    else
      wkeSetDebugConfig(thewebview, 'showDevTools', PansiChar(AnsiToUtf8(ExtractFilePath(ParamStr(0))
        + '\front_end\inspector.html')));
  end;

end;

procedure TWkeWebBrowser.SetZoom(const Value: Integer);
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      mbSetZoomFactor(thewebview, LogN(1.2, Value / 100))
    else
      thewebview.ZoomFactor := LogN(1.2, Value / 100);
  end;
end;

procedure TWkeWebBrowser.Stop;
begin
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      mbStopLoading(thewebview)
    else
      thewebview.StopLoading;
  end;

end;

procedure TWkeWebBrowser.WM_SIZE(var msg: TMessage);
begin
  inherited;
  if Assigned(thewebview) then
  begin
    if UseFastMB then
      MoveWindow(mbGetHostHWND(thewebview), 0, 0, Width, height, true)
    else
      thewebview.MoveWindow(0, 0, Width, height);
  end;

end;

procedure TWkeWebBrowser.WndProc(var msg: TMessage);
var
  hndl: Hwnd;
begin
  case msg.msg of
    WM_SETFOCUS:
      begin
        hndl := GetWindow(handle, GW_CHILD);
        if hndl <> 0 then
          PostMessage(hndl, WM_SETFOCUS, msg.WParam, 0);
        inherited WndProc(msg);
      end;
    CM_WANTSPECIALKEY: // VK_RETURN,
      if not(TWMKey(msg).CharCode in [VK_LEFT .. VK_DOWN, VK_ESCAPE, VK_TAB]) then // 2018.07.26
        msg.result := 1
      else
        inherited WndProc(msg);
    WM_GETDLGCODE:
      msg.result := DLGC_WANTARROWS or DLGC_WANTCHARS or DLGC_WANTTAB;
  else
    inherited WndProc(msg);
  end;

end;









// procedure ShowLastError;
// var
// ErrorCode: DWORD;
// ErrorMessage: Pointer;
// begin
// ErrorCode := GetLastError;
// FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or Format_MESSAGE_FROM_SYSTEM, nil, ErrorCode, 0, @ErrorMessage, 0, nil);
// showmessage('GetLastError Result: ' + IntToStr(ErrorCode) + #13 + 'Error Description: ' + string(Pchar(ErrorMessage)));
// end;

{ TWkeApp }

constructor TWkeApp.Create(Aowner: TComponent);
begin
  inherited;
  FWkeWebPages := TList{$IFDEF DELPHI15_UP}<TWkeWebBrowser>{$ENDIF}.Create;
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
  if csDesigning in ComponentState then
    exit;
  WkeLoadLibAndInit;

end;

procedure TWkeApp.CloseWebbrowser(Abrowser: TWkeWebBrowser);
begin
  FWkeWebPages.Remove(Abrowser);
end;

function TWkeApp.CreateWebbrowser(Aparent: TWincontrol; Ar: Trect): TWkeWebBrowser;
var
  newBrowser: TWkeWebBrowser;
begin
  if (wkeLibHandle = 0) and (mbLibHandle = 0) then
    RaiseLastOSError;
  newBrowser := TWkeWebBrowser.Create(Aparent);
  newBrowser.WkeApp := Self;
  newBrowser.Parent := Aparent;
  newBrowser.BoundsRect := Ar;
  newBrowser.OnCreateView := DoOnNewWindow;
  // 设置初始值
  if FUserAgent <> '' then
    newBrowser.UserAgent := FUserAgent;
  newBrowser.CookieEnabled := FCookieEnabled;
  if DirectoryExists(FCookiePath) then
    newBrowser.CookiePath := FCookiePath;
  FWkeWebPages.Add(newBrowser);
  result := newBrowser;
  if UseFastMB then
  begin
    mbSetNavigationToNewWindowEnable(newBrowser.thewebview, true);
    mbSetCspCheckEnable(newBrowser.thewebview, false);
  end
  else
  begin
    wkeSetNavigationToNewWindowEnable(newBrowser.thewebview, true);
    wkeSetCspCheckEnable(newBrowser.thewebview, false);
  end;
end;

function TWkeApp.CreateWebbrowser(Aparent: TWincontrol): TWkeWebBrowser;
var
  newBrowser: TWkeWebBrowser;
begin
  newBrowser := CreateWebbrowser(Aparent, Rect(0, 0, 100, 100));
  newBrowser.Align := alClient;
  result := newBrowser;
end;

procedure TWkeApp.DoOnNewWindow(Sender: TObject; sUrl: string; navigationType: wkeNavigationType;
  windowFeatures: PwkeWindowFeatures; var wvw: wkeWebView);
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
          wvw := NewwebPage.thewebview;

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
  FCookiePath := Value;
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
