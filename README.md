# Delphi Icon Fonts Integration Example

This project demonstrates how to integrate icon fonts (specifically Font Awesome) into Delphi applications **without requiring font installation on the target system**. The fonts are embedded as resources and loaded dynamically at runtime, making your applications truly portable.

## Features

- **No System Font Installation Required**: Fonts are embedded as resources and loaded at runtime
- **Windows-Only Implementation**: Uses Windows-specific APIs for font loading  
- **Runtime Font Loading**: Dynamically loads OTF font files from embedded resources
- **Reusable Components**: Includes example components for easy icon integration
- **Font Awesome Support**: Pre-configured for Font Awesome Regular, Brands, and Solid variants
- **Memory Management**: Proper cleanup of loaded font resources

## Project Structure

### Core Components

- **`IconFontLoaderGP.pas`** - The main implementation unit for loading font files from resources. This is the reusable component that can be integrated into other Delphi projects.
- **`IconLabelGP.pas`** - An example component demonstrating how to use the loaded icon fonts in a custom control.
- **`Icons.rc`** - Resource file that embeds the OTF font files into the executable.

### Font Files

- `Font Awesome 6 Free-Regular-400.otf`
- `Font Awesome 6 Free-Solid-900.otf` 
- `Font Awesome 6 Brands-Regular-400.otf`

### Generated Units

- `uFontAwesomeRegular.pas` - Constants for regular Font Awesome icons
- `uFontAwesomeSolid.pas` - Constants for solid Font Awesome icons  
- `uFontAwesomeBrands.pas` - Constants for brand Font Awesome icons

## Prerequisites

- Delphi IDE (Windows)
- Basic knowledge of Delphi programming
- **Windows platform only** (uses Windows-specific font loading APIs)

## How It Works

1. **Font Embedding**: OTF font files are embedded as `RCDATA` resources using a resource script (`Icons.rc`)
2. **Runtime Loading**: The `TIconFontLoader` class uses Windows `AddFontMemResourceEx` API to load fonts from memory
3. **Font Usage**: Once loaded, the fonts can be used like any system font by their font family name
4. **Cleanup**: Fonts are properly unloaded when the application terminates

## Usage

### Basic Integration

1. **Copy the core unit** `IconFontLoaderGP.pas` to your project
2. **Add font resources** by creating an `Icons.rc` file with your OTF fonts:
   ```
   FONT_AWESOME_REGULAR RCDATA "Font Awesome 6 Free-Regular-400.otf"
   FONT_AWESOME_BRANDS RCDATA "Font Awesome 6 Brands-Regular-400.otf"
   FONT_AWESOME_SOLID RCDATA "Font Awesome 6 Free-Solid-900.otf"
   ```
3. **Compile the resource file** and include it in your project:
   ```pascal
   {$R icons.RES}
   ```
4. **Load fonts at application startup**:
   ```pascal
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
   ```

### Using Icons in Components

After loading, you can use the fonts in any component by setting the font name:

```pascal
// Example using a TLabel
Label1.Font.Name := TMFontAwesomeSolidIcons.FONT_FAMILY;
Label1.Font.Size := 24;
Label1.Caption := WideChar($F007); // Font Awesome user icon
```

### Example Component Usage

The project includes `TIconLabel` component as an example:

```pascal
IconLabel1.FontName := TMFontAwesomeSolidIcons.FONT_FAMILY;
IconLabel1.FontSize := 32;
IconLabel1.Icon := WideChar($F007); // User icon
IconLabel1.FontColor := clBlue;
```

## Updating Font Awesome Icons

To update to newer Font Awesome versions:

1. **Replace OTF files** with newer Font Awesome font files
2. **Update the resource file** (`Icons.rc`) if filenames changed
3. **Recompile resources**: `brcc32 Icons.rc` to generate `icons.RES`
4. **Regenerate constants** (optional): Use the Python script `icon_font_consts_gen.py` to generate updated icon constant units

## Key Classes

### TIconFontLoader

The main class for loading fonts from resources:

- `LoadFromResource(ResName: string)` - Loads a font from an embedded resource
- Automatic memory management and cleanup
- Prevents loading the same font multiple times

### TIconLabel (Example Component)

A custom control demonstrating icon font usage:

- `Icon: WideChar` - The icon character to display
- `FontName: string` - Name of the loaded icon font
- `FontSize: Integer` - Size of the icon
- `FontColor: TColor` - Color of the icon

## Limitations

- **Windows Only**: Uses Windows-specific APIs (`AddFontMemResourceEx`)
- **Runtime Dependency**: Fonts must be loaded before use
- **Memory Usage**: Fonts are kept in memory while loaded

## License

This project is provided as an example for educational purposes. Font Awesome fonts are subject to their own licensing terms.