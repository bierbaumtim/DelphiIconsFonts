unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IconFontLoaderGP, IconLabelGP;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    FIconLabel: TIconLabel;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

uses uFontAwesomeBrands, uFontAwesomeSolid, uFontAwesomeRegular;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FIconLabel := TIconLabel.Create(Self);
  FIconLabel.Parent := Self;
  FIconLabel.Left := 12;
  FIconLabel.Top := 12;
  FIconLabel.FontName := TMFontAwesomeSolidIcons.FONT_FAMILY;
  FIconLabel.Icon := TMFontAwesomeSolidIcons.ALIGN_JUSTIFY;
  FIconLabel.FontSize := 48;
  FIconLabel.FontColor := clWebLightSeaGreen;
end;

end.
