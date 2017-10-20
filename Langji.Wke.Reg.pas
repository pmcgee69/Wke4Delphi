unit Langji.Wke.Reg;

interface
uses classes,Langji.Wke.webbrowser,Langji.Wke.TransparentPage  ;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Langji.Wke', [TWkeWebBrowser,TWkeApp,TWkeTransparentPage]);
end;

end.
