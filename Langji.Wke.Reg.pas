unit Langji.Wke.Reg;

interface
uses classes,Langji.Wke.Webbrowser,Langji.Wke.TransparentPage  ;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Langji.Wke', [TWkeWebBrowser,TWkeApp,TWkeTransparentPage]);
end;

end.
