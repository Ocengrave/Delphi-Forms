unit Auth.Classes;

interface

uses
  System.SysUtils, Inifiles, System.IOUtils, Auth.Constants, FMX.Dialogs;

type
  TScreenMode = (Maximal, Medium, Minimal);

  TTheme = (Default, Purple);

  TSettings = class (TMemIniFile)
    private
      function GetTheme: TTheme;
      procedure SetTheme(const Value: TTheme);
    public
      property Theme: TTheme read GetTheme write SetTheme;
      procedure SaveSetting();
  end;

var
  Settings: TSettings;

implementation

uses
  System.TypInfo;


{ TSettings }
procedure TSettings.SaveSetting;
begin
  UpdateFile;
end;

function TSettings.GetTheme: TTheme;
var
  s: string;
  lTheme: TTheme;
begin
  {
    TTheme can be expanded by adding any new style,
    by default 0 element is equal to the Default style

    If changes have been made to the file config and the style with the specified name is not found,
    the Default style is applied.
  }
  s :=  ReadString('Settings', 'AppStyle', 'Default');
  for lTheme := Low(TTheme) to High(TTheme) do
  begin
    if lTheme = TTheme(GetEnumValue(Typeinfo(TTheme), s)) then
    begin
      Result := lTheme;
      Exit;
    end;
  end;
  SetTheme(TTheme(0)) ;
  UpdateFile;
  Result := TTheme(0);
end;

procedure TSettings.SetTheme(const Value: TTheme);
begin
  if ReadString('Settings', 'AppStyle', #13#10) = #13#10 then
    WriteString('Settings', '// Changes the app theme: Default, Purple'#13#10 +'AppStyle', GetEnumName(TypeInfo(TTheme), Ord(Value)));
end;


initialization
  Settings := TSettings.Create(ExtractFilePath(ParamStr(0)) + SETTINGS_NAME+'.ini');

finalization
  FreeAndNil(Settings);

end.
