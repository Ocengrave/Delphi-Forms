unit Auth.Classes;

interface

uses
  System.SysUtils, Inifiles, System.IOUtils, Auth.Constants, FMX.Dialogs;

type
  TScreenMode = (Maximal, Medium, Minimal);

  TTheme = (Default, Purple);

  TSettings = class (TMemIniFile)
    private
      procedure SetTheme(const Value: TTheme);
      procedure SetHeight(const Value: integer);
      procedure SetWidth(const Value: integer);

      function GetTheme: TTheme;
      function GetHeight: integer;
      function GetWidth: integer;
    public
      property Theme: TTheme read GetTheme write SetTheme;
      property Width: integer read GetWidth write SetWidth;
      property Height: integer read GetHeight write SetHeight;
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

function TSettings.GetWidth: integer;
var
  i: integer;
begin
  i := ReadInteger('Settings', 'Width', DEFAULT_WIDTH);
  if i < MIN_WIDTH then
  begin
      SetWidth(MIN_WIDTH);
      UpdateFile;
      Result := MIN_WIDTH;
  end
  else
    Result := i;
end;

function TSettings.GetHeight: integer;
var
  i: integer;
begin
  i := ReadInteger('Settings', 'Height', MIN_HEIGHT);
  if i < MIN_HEIGHT then
  begin
      SetHeight(MIN_HEIGHT);
      Result := MIN_HEIGHT;
      UpdateFile;
  end
  else
    Result := i;
end;

procedure TSettings.SetHeight(const Value: integer);
begin
  if ReadString('Settings', 'Height', #13#10) = #13#10 then
    WriteInteger('Settings', '// Minimal height: 480 '#13#10 +'Height', Value)
  else
    WriteInteger('Settings', 'Height', Value)
end;

procedure TSettings.SetWidth(const Value: integer);
begin
  if ReadString('Settings', 'Width', #13#10) = #13#10 then
    WriteInteger('Settings', '// Minimal width: 320 '#13#10 +'Width', Value)
  else
    WriteInteger('Settings', 'Width', Value)
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
