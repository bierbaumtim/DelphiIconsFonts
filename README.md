# Delphi - Font Awesome

DelphiIconsFonts is a powerful repository designed to make working with icons and fonts in Delphi applications seamless and efficient. Whether you’re building modern UI applications or enhancing existing projects, this library provides a structured way to manage and integrate scalable icons and custom fonts.

## Features

- **Icon Integration**: Easily embed scalable vector icons into your Delphi applications.
- **Font Management**: Simplify the use of custom fonts in your projects.
- **High Performance**: Optimized for fast rendering and smooth integration.
- **Cross-Platform Compatibility**: Supports platforms like Windows, macOS, and more.
- **Customizability**: Fully customizable icons and font sizes, styles, and colors.

## Getting Started

Follow these steps to get started with DelphiIconsFonts in your project:

### Prerequisites

- [Delphi IDE](https://www.embarcadero.com/products/delphi) installed on your machine.
- Basic knowledge of Delphi programming.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/bierbaumtim/DelphiIconsFonts.git
   ```
2. Add the necessary files to your Delphi project.
3. Configure the required paths in your Delphi IDE.

### Usage

1. Import the library into your project:
   ```pascal
   uses
     DelphiIconsFonts;
   ```
2. Load the required fonts in your application:
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

## Updating Icons

To update the icons in your project, follow these steps:

1. **Copy OTF Files**: Ensure that the `.otf` (OpenType Font) files for the updated icons are added to the appropriate directory in your project.
2. **Recompile Resources**: Recompile the resource files in your Delphi project to include the updated icons.
3. **Run the Python Script**: Execute the provided Python script to process and integrate the new icons into your project. This step ensures that the icons are properly registered and available for use.

   Example:
   ```bash
   python icons_font_gen.py
   ```

4. Test your application to ensure the new icons are displayed correctly.

## Examples

Check out the `examples` folder in the repository for detailed usage scenarios and sample projects.

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature-name`).
3. Commit your changes (`git commit -m "Add feature"`).
4. Push to the branch (`git push origin feature-name`).
5. Open a Pull Request.

## Issues

If you encounter any issues or have feature requests, please open an [issue](https://github.com/bierbaumtim/DelphiIconsFonts/issues).

## License

This project is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute it.