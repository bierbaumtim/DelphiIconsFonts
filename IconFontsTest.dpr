program IconFontsTest;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {Form1},
  IconFontLoaderGP in 'IconFontLoaderGP.pas',
  IconLabelGP in 'IconLabelGP.pas',
  uFontAwesomeRegular in 'uFontAwesomeRegular.pas',
  uFontAwesomeSolid in 'uFontAwesomeSolid.pas',
  uFontAwesomeBrands in 'uFontAwesomeBrands.pas';

{$R *.res}
{$R icons.RES}  // compiled from Icons.rc

var
  Loader: TIconFontLoader;
begin
  Application.Initialize;
  Loader := TIconFontLoader.Create;
  try
    Loader.LoadFromResource('FONT_AWESOME_REGULAR');
    Loader.LoadFromResource('FONT_AWESOME_BRANDS');
    Loader.LoadFromResource('FONT_AWESOME_SOLID');

    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TForm1, Form1);
  Application.Run;
  finally
    Loader.Free;
  end;
end.
