unit Auth.MainFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, Auth.Classes;

type
  TFrameMain = class(TFrame)
  private
     FScreenMode: TScreenMode;
  protected
    procedure SetScreenMode(const Value: TScreenMode); virtual;
  public
    property ScreenMode: TScreenMode read FScreenMode write SetScreenMode;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

{ TFrameMain }

constructor TFrameMain.Create(AOwner: TComponent);
begin
  inherited;
  Name := '';
  SetFocus;
end;

procedure TFrameMain.SetScreenMode(const Value: TScreenMode);
begin
  FScreenMode := Value;
end;

end.
