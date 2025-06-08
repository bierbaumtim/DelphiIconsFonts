unit IconLabelGP;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Graphics;

type
  TIconLabel = class(TCustomControl)
  private
    FIcon: WideChar;
    FFontName: string;
    FFontSize: Integer;
    FFontColor: TColor;

    procedure SetIcon(Value: WideChar);
    procedure SetFontName(const Value: string);
    procedure SetFontSize(Value: Integer);
    procedure SetFontColor(Value: TColor);

    function GetScaledFontHeight(DC: HDC): Integer;
    procedure UpdateControlSize;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;

  published
    property Icon: WideChar read FIcon write SetIcon;
    property FontName: string read FFontName write SetFontName;
    property FontSize: Integer read FFontSize write SetFontSize default 24;
    property FontColor: TColor read FFontColor write SetFontColor default clBlack;
    property Align;
    property Anchors;
    property Visible;
    property Color;
  end;

implementation

{ TIconLabel }

constructor TIconLabel.Create(AOwner: TComponent);
begin
  inherited;

  ControlStyle := ControlStyle + [csOpaque];
  FFontSize := 24;
  FFontColor := clBlack;
  Color := clBtnFace;
  FIcon := WideChar($F007);
  UpdateControlSize;
end;

procedure TIconLabel.SetIcon(Value: WideChar);
begin
  if FIcon <> Value then
  begin
    FIcon := Value;
    UpdateControlSize;
    Invalidate;
  end;
end;

procedure TIconLabel.SetFontName(const Value: string);
begin
  if FFontName <> Value then
  begin
    FFontName := Value;
    UpdateControlSize;
    Invalidate;
  end;
end;

procedure TIconLabel.SetFontSize(Value: Integer);
begin
  if FFontSize <> Value then
  begin
    FFontSize := Value;
    UpdateControlSize;
    Invalidate;
  end;
end;

procedure TIconLabel.SetFontColor(Value: TColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    Invalidate;
  end;
end;

function TIconLabel.GetScaledFontHeight(DC: HDC): Integer;
begin
  // convert point size to logical pixels
  Result := -MulDiv(FFontSize, GetDeviceCaps(DC, LOGPIXELSY), 72);
end;

procedure TIconLabel.UpdateControlSize;
var
  DC: HDC;
  LogFont: TLogFontW;
  hFont, oldFont: HGDIOBJ;
  sz: TSize;
begin
  if (FFontName = '') or (FIcon = '') then Exit;
  DC := GetDC(0);
  try
    ZeroMemory(@LogFont, SizeOf(LogFont));
    LogFont.lfHeight := GetScaledFontHeight(DC);
    LogFont.lfCharSet := DEFAULT_CHARSET;
    LogFont.lfOutPrecision := OUT_TT_ONLY_PRECIS;
    LogFont.lfClipPrecision := CLIP_DEFAULT_PRECIS;
    LogFont.lfQuality := CLEARTYPE_QUALITY;
    LogFont.lfPitchAndFamily := FF_DONTCARE;
    LogFont.lfWeight := FW_NORMAL;
    StringToWideChar(FFontName, LogFont.lfFaceName, LF_FACESIZE);
    hFont := CreateFontIndirectW(LogFont);
    if hFont = 0 then Exit;
    oldFont := SelectObject(DC, hFont);
    GetTextExtentPoint32W(DC, PWideChar(FIcon), Length(FIcon), sz);
    SelectObject(DC, oldFont);
    DeleteObject(hFont);
  finally
    ReleaseDC(0, DC);
  end;
  // add small padding
  Width := sz.cx + 4;
  Height := sz.cy + 4;
end;

procedure TIconLabel.Paint;
var
  LogFont: TLogFontW;
  hFont, oldFont: HGDIOBJ;
  DC: HDC;
  R: TRect;
  Flags: UINT;
begin
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);
  if (FFontName = '') or (FIcon = '') then Exit;

  ZeroMemory(@LogFont, SizeOf(LogFont));
  LogFont.lfHeight := GetScaledFontHeight(Canvas.Handle);
  LogFont.lfCharSet := DEFAULT_CHARSET;
  LogFont.lfOutPrecision := OUT_TT_ONLY_PRECIS;
  LogFont.lfClipPrecision := CLIP_DEFAULT_PRECIS;
  LogFont.lfQuality := CLEARTYPE_QUALITY;
  LogFont.lfPitchAndFamily := FF_DONTCARE;
  LogFont.lfWeight := FW_NORMAL;
  StringToWideChar(FFontName, LogFont.lfFaceName, LF_FACESIZE);

  hFont := CreateFontIndirectW(LogFont);
  if hFont = 0 then Exit;
  DC := Canvas.Handle;
  oldFont := SelectObject(DC, hFont);

  SetBkMode(DC, TRANSPARENT);
  SetTextColor(DC, ColorToRGB(FFontColor));

  R := ClientRect;
  Flags := DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOCLIP;
  DrawTextW(DC, PWideChar(FIcon), Length(FIcon), R, Flags);

  SelectObject(DC, oldFont);
  DeleteObject(hFont);
end;

end.
