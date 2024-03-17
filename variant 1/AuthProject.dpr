program AuthProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  Auth.Main in 'src\Auth.Main.pas' {Main},
  Auth.Classes in 'src\classes\Auth.Classes.pas',
  Auth.Constants in 'Auth.Constants.pas',
  Auth.CodeInputFrame in 'src\Auth.CodeInputFrame.pas' {Code: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
