unit IconFontLoaderGP;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Generics.Collections;

type
  TFontData = record
    Data: Pointer;
    Size: DWORD;
    Handle: THandle;
  end;

  TIconFontLoader = class
  private
    FFonts: TDictionary<string, TFontData>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromResource(const ResName: string);
  end;

implementation

constructor TIconFontLoader.Create;
begin
  inherited;

  FFonts := TDictionary<string, TFontData>.Create;
end;

procedure TIconFontLoader.LoadFromResource(const ResName: string);
var
  RS: TResourceStream;
  Added: DWORD;
begin
  RS := TResourceStream.Create(HInstance, ResName, RT_RCDATA);

  try
    if FFonts.ContainsKey(ResName) then Exit;

    var vFont: TFontData;

    vFont.Size := RS.Size;
    GetMem(vFont.Data, vFont.Size);
    RS.ReadBuffer(vFont.Data^, vFont.Size);
    vFont.Handle := AddFontMemResourceEx(vFont.Data, vFont.Size, nil, @Added);
    if vFont.Handle = 0 then
      raise Exception.Create('Failed to load font resource: ' + ResName);

    FFonts.AddOrSetValue(ResName, vFont);
  finally
    FreeAndNil(RS);
  end;
end;

destructor TIconFontLoader.Destroy;
begin
  for var vItem in FFonts do begin
    if vItem.Value.Handle <> 0 then
      RemoveFontMemResourceEx(vItem.Value.Handle);

    if vItem.Value.Data <> nil then
      FreeMem(vItem.Value.Data);
  end;

  FreeAndNil(FFonts);

  inherited;
end;

end.
