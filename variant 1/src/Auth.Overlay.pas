unit Auth.Overlay;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, Auth.Classes, FMX.Ani;

type
  TOverlay = class(TFrame)
    RectangleOverlay: TRectangle;
    private
       FScreenMode: TScreenMode;

    protected
       FProcCallback: TProc<TOverlay, Boolean>;
       procedure SetScreenMode(const Value: TScreenMode);
    public
      property ScreenMode: TScreenMode read FScreenMode write SetScreenMode;
      constructor Create(AOwner: TComponent); override;
      class procedure Execute(AParent: TControl; Proc: TProc<TOverlay>; ProcExecuted: TProc<TOverlay, Boolean>);
      procedure LoadAnimation;
  end;

implementation

{$R *.fmx}

{ TOverlay }

constructor TOverlay.Create(AOwner: TComponent);
begin
  inherited;
  Name := '';
  SetFocus;
end;

class procedure TOverlay.Execute(AParent: TControl; Proc: TProc<TOverlay>;
  ProcExecuted: TProc<TOverlay, Boolean>);
begin
  var Frame := TOverlay.Create(AParent);
    Frame.Parent := AParent;
    Frame.FProcCallback := ProcExecuted;
    Frame.Align := TAlignLayout.Contents;
    Frame.BringToFront;

    if Assigned(Proc) then
      Proc(Frame);
end;

procedure TOverlay.LoadAnimation;
begin
  TAnimator.AnimateFloat(RectangleOverlay, 'Opacity', 0.65, 0.35, TAnimationType.InOut, TInterpolationType.Quadratic);
end;

procedure TOverlay.SetScreenMode(const Value: TScreenMode);
begin
  FScreenMode := Value;
end;

end.
