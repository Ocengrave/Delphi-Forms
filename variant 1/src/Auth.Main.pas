unit Auth.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, Auth.Classes, FMX.Controls.Presentation, FMX.StdCtrls,
  System.ImageList, FMX.ImgList, System.Actions, FMX.ActnList, FMX.Edit, System.Threading, FMX.Ani,
  FMX.TabControl, FMX.Effects, FMX.Filter.Effects;

type
  TMain = class(TForm)
    WhiteStyle: TStyleBook;
    PurpleStyle: TStyleBook;
    LayoutClient: TLayout;
    LeftPanel: TRectangle;
    left_gradient: TBrushObject;
    LayoutContent: TLayout;
    LayoutHeader: TLayout;
    LabelSignIn: TLabel;
    LayoutIcons: TLayout;
    GridPanelLayout1: TGridPanelLayout;
    DisabledButtons: TImageList;
    Button_Linkedin: TButton;
    Button_Google: TButton;
    Button_Facebook: TButton;
    EnabledButtons: TImageList;
    LayoutHint: TLayout;
    LabelHint: TLabel;
    VerticalScrollbox: TVertScrollBox;
    LayoutLogin: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    RectangleLogin: TRectangle;
    edit_login: TEdit;
    RectanglePassword: TRectangle;
    edit_password: TEdit;
    Button_login: TButton;
    LayoutErr: TLayout;
    LabelErr: TLabel;
    LayoutSlider: TLayout;
    LabelSlide: TLabel;
    TimerSlider: TTimer;
    LayoutForgot: TLayout;
    ButtonResetPassword: TButton;
    Layout4: TLayout;
    ButtonCreate: TButton;
    VertScrollBoxCreate: TVertScrollBox;
    LayoutHeaderCreate: TLayout;
    LabelHeaderCreate: TLabel;
    LayoutCreateAccount: TLayout;
    ButtonCreateAccount: TButton;
    Layout_password_create: TLayout;
    Rectangle_create_password: TRectangle;
    edit_password_create: TEdit;
    Layout_email_create: TLayout;
    Rectangle_email_create: TRectangle;
    edit_email_create: TEdit;
    LayoutGoBack: TLayout;
    ButtonGoBack: TButton;
    Layout1: TLayout;
    LayoutInformationText: TLayout;
    LabelInformation: TLabel;
    Layout5: TLayout;
    Layout6: TLayout;
    chb_1: TCheckBox;
    chb_2: TCheckBox;
    chb_3: TCheckBox;
    img_mail: TImage;
    img_lock: TImage;
    gradient_purple: TBrushObject;
    ShadowEffect1: TShadowEffect;
    chb_remember: TCheckBox;
    LayoutCircle: TLayout;
    CircleCenter: TCircle;
    procedure FormResize(Sender: TObject);
    procedure ChangeIconState(Sender: TObject);
    procedure Button_loginClick(Sender: TObject);
    procedure TimerSliderTimer(Sender: TObject);
    procedure ButtonCreateClick(Sender: TObject);
    procedure ButtonGoBackClick(Sender: TObject);
    procedure ButtonCreateAccountClick(Sender: TObject);
    procedure edit_email_createClick(Sender: TObject);
    procedure edit_password_createClick(Sender: TObject);
    procedure ButtonThemeClick(Sender: TObject);
    procedure edit_passwordMouseEnter(Sender: TObject);
    procedure edit_passwordMouseLeave(Sender: TObject);
    procedure edit_loginMouseLeave(Sender: TObject);
    procedure edit_loginMouseEnter(Sender: TObject);
    procedure edit_passwordClick(Sender: TObject);
    procedure edit_loginClick(Sender: TObject);
  private
    { Private declarations }
    FScreenMode: TScreenMode;
    FTheme: TTheme;
    FSlideIndex: Integer;
    procedure SetScreenMode(const Value: TScreenMode);
    procedure UpdateScreenMode;
    procedure UpdateTheme;
    procedure ResetErrLabel;
    procedure MovePanelAnimFinishOnReg(Sender: TObject);
    procedure MovePanelAnimFinishFromReg(Sender: TObject);
    function LookUpEmptyFields: boolean;
    procedure SetTheme(const Value: TTheme);
    procedure LoadSettings;
  public
    { Public declarations }
    property Theme: TTheme read FTheme write SetTheme;
    property ScreenMode: TScreenMode read FScreenMode write SetScreenMode;
    property SlideIndex: Integer read FSlideIndex write FSlideIndex;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  Main: TMain;

implementation

uses
  Auth.Constants, Auth.CodeInputFrame, System.TypInfo;

{$R *.fmx}
{ TAuth }
procedure TMain.ButtonCreateAccountClick(Sender: TObject);
begin
  // Just a stub, handle the logic of data registration and validation yourself.
  if edit_email_create.Text = ''  then
  begin
    Rectangle_email_create.Stroke.Kind := TBrushKind.Solid;
    Rectangle_email_create.Stroke.Color := $FFFF0000;
  end;

  if edit_password_create.Text = ''  then
  begin
    Rectangle_create_password.Stroke.Kind := TBrushKind.Solid;
    Rectangle_create_password.Stroke.Color := $FFFF0000;
  end;

  // Do Something
  TCode.Execute(LayoutClient,
  procedure(Frame: TCode)
  begin
    Frame.ScreenMode := ScreenMode;
  end,
  procedure(Frame: TCode; Success: Boolean)
  begin
  //
  end);
end;

procedure TMain.ButtonCreateClick(Sender: TObject);
begin
  // Opening the account registration tab
  TAnimator.AnimateFloat(VerticalScrollbox, 'Opacity', 0, 0, TAnimationType.InOut, TInterpolationType.Quadratic);
  TAnimator.AnimateFloat(VertScrollBoxCreate, 'Opacity', 1, 0.75, TAnimationType.InOut, TInterpolationType.Quadratic);
  VertScrollBoxCreate.HitTest := True;
  LeftPanel.Visible := False;
  VertScrollBoxCreate.BringToFront;

  img_mail.Parent := Rectangle_email_create;
  img_lock.Parent := Rectangle_create_password;


  // Reset "Sign In"
  ResetErrLabel;
  RectanglePassword.Stroke.Kind := TBrushKind.None;
  RectangleLogin.Stroke.Kind := TBrushKind.None;
  chb_remember.IsChecked := False;

  LayoutCircle.Visible := False;

end;

procedure TMain.ButtonGoBackClick(Sender: TObject);
begin
  // Go back to the authorization slide
  TAnimator.AnimateFloat(VertScrollBoxCreate, 'Opacity', 0, 0, TAnimationType.InOut, TInterpolationType.Quadratic);
  TAnimator.AnimateFloat(VerticalScrollbox, 'Opacity', 1, 0.75, TAnimationType.InOut, TInterpolationType.Quadratic);
  VertScrollBoxCreate.HitTest := False;

  case FScreenMode of
    Maximal:
    begin
      LeftPanel.Visible := True;
      LayoutCircle.Visible := True;
    end;
    Medium: LeftPanel.Visible := false;
    Minimal: LeftPanel.Visible := false;
  end;

  VertScrollBoxCreate.SendToBack;

  // Reset Icons
  img_mail.Parent := RectangleLogin;
  img_lock.Parent := RectanglePassword;

  // Reset Edits
  Rectangle_email_create.Stroke.Kind := TBrushKind.None;
  Rectangle_create_password.Stroke.Kind := TBrushKind.None;

  // Reset checked
  chb_1.IsChecked := False;
  chb_2.IsChecked := False;
  chb_3.IsChecked := False;


end;

procedure TMain.ButtonThemeClick(Sender: TObject);
begin
  case FTheme of
    Default: SetTheme(Purple);
    Purple: SetTheme(Default);
  end;
end;

procedure TMain.Button_loginClick(Sender: TObject);
begin
  if LookUpEmptyFields and (LabelErr.Opacity <> 1)  then
  begin
    TAnimator.AnimateFloat(LabelErr, 'Opacity', 1, 0.3, TAnimationType.InOut, TInterpolationType.Quadratic);
    TAnimator.AnimateFloat(LayoutErr, 'Height', 35, 0.25, TAnimationType.InOut, TInterpolationType.Quadratic);
    LayoutForgot.Visible := True;
    Exit;                   
  end;
  // Do Something
  // User authorization logic
end;

procedure TMain.ChangeIconState(Sender: TObject);
var
  lButton: TButton;
begin
  if Assigned(TButton(Sender)) then
  begin
      lButton := TButton(Sender); 
      if lButton.Images = EnabledButtons then
        lButton.Images := DisabledButtons
      else
        lButton.Images := EnabledButtons
  end;
end;

constructor TMain.Create(AOwner: TComponent);
begin
  inherited;
  LoadSettings;
end;

destructor TMain.Destroy;
begin
  Settings.Theme := FTheme;
  Settings.Width := Width;
  Settings.Height := Height;
  Settings.SaveSetting;
  inherited;
end;

procedure TMain.LoadSettings;
begin
  FTheme := Settings.Theme;
  Width := Settings.Width;
  Height := Settings.Height;
  FScreenMode := TScreenMode.Maximal;
  FSlideIndex := 1;
  LabelSlide.Text := SLIDE_TEXT_FIRST;
  TimerSlider.Enabled := True;
  UpdateTheme;
end;


procedure TMain.edit_email_createClick(Sender: TObject);
begin
  Rectangle_email_create.Stroke.Kind := TBrushKind.None;
end;

procedure TMain.edit_loginClick(Sender: TObject);
begin
  ResetErrLabel;
end;

procedure TMain.edit_loginMouseEnter(Sender: TObject);
begin
  RectangleLogin.Stroke.Kind := TBrushKind.Solid;
  ResetErrLabel;
  case FTheme of
    Default: RectangleLogin.Stroke.Color := $FFF85930;
    Purple: RectangleLogin.Stroke.Color := $FF647DEE;
  end;
end;

procedure TMain.edit_loginMouseLeave(Sender: TObject);
begin
  RectangleLogin.Stroke.Kind := TBrushKind.None;
end;

procedure TMain.edit_passwordClick(Sender: TObject);
begin
  ResetErrLabel;
end;

procedure TMain.edit_passwordMouseEnter(Sender: TObject);
begin
  RectanglePassword.Stroke.Kind := TBrushKind.Solid;
  case FTheme of
    Default: RectanglePassword.Stroke.Color := $FFF85930;
    Purple: RectanglePassword.Stroke.Color := $FF647DEE;
  end;
end;

procedure TMain.edit_passwordMouseLeave(Sender: TObject);
begin
  RectanglePassword.Stroke.Kind := TBrushKind.None;
end;

procedure TMain.edit_password_createClick(Sender: TObject);
begin
  Rectangle_create_password.Stroke.Kind := TBrushKind.None;
end;

procedure TMain.FormResize(Sender: TObject);
begin
  if (ClientWidth < 320) then
    ScreenMode := TScreenMode.Minimal
  else if (ClientWidth < 650) then
    ScreenMode := TScreenMode.Medium
  else if (ClientWidth >= 650) then
    ScreenMode := TScreenMode.Maximal;
end;


function TMain.LookUpEmptyFields: boolean;
var
   tasks: array of ITask;
   task: ITask;
   value: integer;
   fResult: boolean;
  procedure CreateTasks;
  begin
    fResult := False;
    value := 0;
    tasks := [
           TTask.Create(procedure()
              begin
                  if edit_login.Text = ''  then
                  begin
                    RectangleLogin.Stroke.Kind := TBrushKind.Solid;
                    RectangleLogin.Stroke.Color := $FFFF0000;
                    fResult := True;
                  end;
              end
           ),
           TTask.Create(procedure()
              begin
                 if edit_password.Text = '' then
                 begin
                    RectanglePassword.Stroke.Kind := TBrushKind.Solid; 
                    RectanglePassword.Stroke.Color := $FFFF0000;
                    fResult := True;
                 end;
              end
           )
        ];
  end;
begin
  CreateTasks;
  for task in tasks do
      task.Start;
   TTask.WaitForAll(tasks);
   Result := fResult;
end;

procedure TMain.MovePanelAnimFinishFromReg(Sender: TObject);
begin
  LeftPanel.Align	:= TAlignLayout.Left;
  VerticalScrollbox.Align := TAlignLayout.Center;
  TAnimator.AnimateFloat(VerticalScrollbox, 'Opacity', 1, 0.25, TAnimationType.InOut, TInterpolationType.Quadratic);
end;

procedure TMain.MovePanelAnimFinishOnReg(Sender: TObject);
begin
  LeftPanel.Align	:= TAlignLayout.Right;
  VertScrollBoxCreate.Align := TAlignLayout.Center;
  TAnimator.AnimateFloat(VertScrollBoxCreate, 'Opacity', 1, 0.25, TAnimationType.InOut, TInterpolationType.Quadratic);
end;

procedure TMain.ResetErrLabel;
begin
  if LabelErr.Opacity = 1 then
  begin
    TAnimator.AnimateFloat(LabelErr, 'Opacity', 0, 0.3, TAnimationType.InOut, TInterpolationType.Quadratic);
    TAnimator.AnimateFloat(LayoutErr, 'Height', 0, 0.2, TAnimationType.InOut, TInterpolationType.Quadratic);
  end;
end;

procedure TMain.SetScreenMode(const Value: TScreenMode);
begin
  if FScreenMode = Value then
    Exit;
  FScreenMode := Value;
  UpdateScreenMode;

end;

procedure TMain.SetTheme(const Value: TTheme);
begin
  if FTheme = Value then
    Exit;
  FTheme := Value;
  UpdateTheme;
end;

procedure TMain.TimerSliderTimer(Sender: TObject);
begin
  { 
    Attention! It is recommended to use an interval value of at least 5000 for the slider.
    If you do not want to use the slider, it is better to just comment out the entire code in this procedure, otherwise, 
    if you change the interval value less than 5000, you may get an unexpected result

    There is a small check in this procedure that will avoid some of the problems, but make changes at your own risk!
  }
  
  FSlideIndex := FSlideIndex + 1;

  // Don't touch this "if"
  if LabelSlide.Opacity = 1 then
    TAnimator.AnimateFloat(LabelSlide, 'Opacity', 0, 1, TAnimationType.InOut, TInterpolationType.Quadratic) ;
    
  TThread.CreateAnonymousThread(
    procedure()
    begin
        Sleep(1500);
        TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          case FSlideIndex of
          1: LabelSlide.Text := SLIDE_TEXT_FIRST;
          2: LabelSlide.Text := SLIDE_TEXT_SECOND;
          3: 
          begin
            LabelSlide.Text := SLIDE_TEXT_THIRD;
            FSlideIndex := 0;
          end;
        end;
          // Don't touch this "if"
          if LabelSlide.Opacity = 0 then
            TAnimator.AnimateFloat(LabelSlide, 'Opacity', 1, 1, TAnimationType.InOut, TInterpolationType.Quadratic) ;
        end);
    end).Start;
end;

procedure TMain.UpdateScreenMode;
begin
  for var Control in LayoutClient.Controls do
  if Control is TCode then
  begin
    var Frame := TCode(Control);
    Frame.ScreenMode := self.FScreenMode;
  end;
  case FScreenMode of
      TScreenMode.Maximal:
        begin
          LeftPanel.Visible := True;
          RectangleLogin.Margins.Left := 25;
          RectangleLogin.Margins.Right := 25;
          RectanglePassword.Margins.Left := 25;
          RectanglePassword.Margins.Right := 25;
          Rectangle_create_password.Margins.Left := 25;
          Rectangle_create_password.Margins.Right := 25;
          Rectangle_email_create.Margins.Right := 25;
          Rectangle_email_create.Margins.Left := 25;
          Button_login.Margins.Left := 25;
          Button_login.Margins.Right := 25;
          LabelErr.Margins.Left := 25;
          LabelErr.Margins.Right := 25;
          TimerSlider.Enabled := True;
          chb_remember.Margins.Right := 20;
          chb_remember.Margins.Left := 23;
          LayoutCircle.Visible := True;
        end;
      TScreenMode.Medium:
        begin  
          LeftPanel.Visible := False;
          LayoutCircle.Visible := False;
        end;
      TScreenMode.Minimal:
        begin
          LeftPanel.Visible := False;
          RectangleLogin.Margins.Left := 10;
          RectangleLogin.Margins.Right := 10;
          RectanglePassword.Margins.Left := 10;
          RectanglePassword.Margins.Right := 10;
          Rectangle_create_password.Margins.Left := 20;
          Rectangle_create_password.Margins.Right := 20;
          Rectangle_email_create.Margins.Right := 20;
          Rectangle_email_create.Margins.Left := 20;
          Button_login.Margins.Left := 10;
          Button_login.Margins.Right := 10;
          LabelErr.Margins.Left := 10;
          LabelErr.Margins.Right := 10;
          TimerSlider.Enabled := False;
          VerticalScrollbox.Height := 420;
          VerticalScrollbox.Width := 310 ;
          chb_remember.Margins.Right := 8;
          chb_remember.Margins.Left := 8;
          LayoutCircle.Visible := False;
        end;
    end;
end;

procedure TMain.UpdateTheme;
begin
  case FTheme of
    Default:
      begin
        self.StyleBook := WhiteStyle;
        LeftPanel.Fill.Resource.StyleResource := left_gradient;
        CircleCenter.Fill.Resource.StyleResource := left_gradient;
      end;
    Purple:
      begin
        self.StyleBook := PurpleStyle;
        LeftPanel.Fill.Resource.StyleResource := gradient_purple;
        CircleCenter.Fill.Resource.StyleResource := gradient_purple;
      end;
  end;
  LeftPanel.Fill.Kind := TBrushKind.Resource;
  CircleCenter.Fill.Kind := TBrushKind.Resource;
  self.ApplyStyleLookup;
end;

end.
