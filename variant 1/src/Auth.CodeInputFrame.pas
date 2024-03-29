unit Auth.CodeInputFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, Auth.Classes,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, FMX.Edit, System.Math,
  System.ImageList, FMX.ImgList, FMX.Effects, FMX.Ani, Auth.MainFrame;

type
  TCode = class(TFrameMain)
    LayoutClient: TLayout;
    RectangleFrame: TRectangle;
    VertScrollBoxContent: TVertScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    RectangleBG: TRectangle;
    RectangleConfirm: TRectangle;
    edit_code: TEdit;
    img_mail: TImage;
    Button_confirm: TButton;
    LayoutExit: TLayout;
    Button_Cross: TButton;
    ImageList: TImageList;
    ShadowEffect1: TShadowEffect;
    ShadowEffect: TShadowEffect;
    procedure FrameResize(Sender: TObject);
    procedure edit_codeTyping(Sender: TObject);
    procedure Button_CrossClick(Sender: TObject);
    procedure Button_CrossMouseEnter(Sender: TObject);
    procedure Button_CrossMouseLeave(Sender: TObject);
    procedure Button_confirmClick(Sender: TObject);
    procedure edit_codeMouseLeave(Sender: TObject);
    procedure edit_codeMouseEnter(Sender: TObject);
  private
    { Private declarations }
    FProcCallback: TProc<TCode, Boolean>;
    FScreenMode: TScreenMode;
    FLayoutClientWidth, FLayoutClientHeight: Single;
  protected
    procedure SetScreenMode(const Value: TScreenMode); override;
  public
    property ScreenMode: TScreenMode read FScreenMode write SetScreenMode;
    constructor Create(AOwner: TComponent); override;
    class procedure Execute(AParent: TControl; ProcSet: TProc<TCode>; ProcExecuted: TProc<TCode, Boolean>);
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TCode }

procedure TCode.Button_confirmClick(Sender: TObject);
begin
  //Do Someting
end;

procedure TCode.Button_CrossClick(Sender: TObject);
begin
  if Assigned(FProcCallback) then
    FProcCallback(Self, True);
  Release;
end;

procedure TCode.Button_CrossMouseEnter(Sender: TObject);
begin
  Button_Cross.ImageIndex := 1;
end;

procedure TCode.Button_CrossMouseLeave(Sender: TObject);
begin
  Button_Cross.ImageIndex := 0;
end;

constructor TCode.Create(AOwner: TComponent);
begin
  inherited;
  Name := '';
  FLayoutClientWidth := LayoutClient.Width;
  FLayoutClientHeight := LayoutClient.Height;
end;

procedure TCode.edit_codeMouseEnter(Sender: TObject);
begin
  ShadowEffect.Enabled := True;
  RectangleConfirm.Stroke.Kind := TBrushKind.Solid;
  RectangleConfirm.Stroke.Color := $FFC6A3A8;
end;

procedure TCode.edit_codeMouseLeave(Sender: TObject);
begin
  ShadowEffect.Enabled := False;
  RectangleConfirm.Stroke.Kind := TBrushKind.None;
end;

procedure TCode.edit_codeTyping(Sender: TObject);
begin
  if edit_code.Text.Length > 0 then
    Button_confirm.Enabled := True
  else Button_confirm.Enabled := False;
end;

class procedure TCode.Execute(AParent: TControl; ProcSet: TProc<TCode>;
  ProcExecuted: TProc<TCode, Boolean>);
begin
  var Frame := TCode.Create(AParent);
  Frame.Opacity := 0;
  Frame.Parent := AParent;
  Frame.FProcCallback := ProcExecuted;
  Frame.Align := TAlignLayout.Contents;
  TAnimator.AnimateFloat(Frame, 'Opacity', 1, 0.25, TAnimationType.InOut, TInterpolationType.Cubic);
  Frame.BringToFront;
  if Assigned(ProcSet) then
    ProcSet(Frame);
end;

procedure TCode.FrameResize(Sender: TObject);
begin
  LayoutClient.Width := Min(FLayoutClientWidth, Width);
  LayoutClient.Height := Min(FLayoutClientHeight, Height);
end;

procedure TCode.SetScreenMode(const Value: TScreenMode);
begin
  inherited;
  FScreenMode := Value;
  if (FScreenMode = TScreenMode.Minimal) then
  begin
    LayoutClient.Align := TAlignLayout.Client;
    RectangleFrame.Corners := [];
  end
  else
  begin
    LayoutClient.Align := TAlignLayout.Center;
    LayoutClient.Height := 290;
    LayoutClient.Width := 320;
    RectangleFrame.Corners := AllCorners;
  end;
  FrameResize(nil);
end;

end.
