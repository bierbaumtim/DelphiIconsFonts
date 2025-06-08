#!/usr/bin/env python3
"""
Script: icon_font_consts_generator.py
Generates Delphi units with a class containing WideChar constants for each icon in each OTF/TTF file.
Usage:
    python icon_font_consts_generator.py font1.otf font2.otf ... output1.pas output2.pas ...
Each output .pas corresponds to the input font by index.
"""
import sys
import re
import os
from fontTools.ttLib import TTFont

# List of Delphi reserved words (uppercase)
DELHI_RESERVED = {
    'AND', 'ARRAY', 'ASM', 'BEGIN', 'CASE', 'CONST', 'CONSTRUCTOR', 'DESTRUCTOR',
    'DIV', 'DO', 'DOWNTO', 'ELSE', 'END', 'FILE', 'FOR', 'FUNCTION', 'GOTO',
    'IF', 'IMPLEMENTATION', 'IN', 'INHERITED', 'INLINE', 'INTERFACE', 'IS',
    'LABEL', 'MOD', 'NIL', 'NOT', 'OBJECT', 'OF', 'OPERATOR', 'OR', 'PACKAGE',
    'PROCEDURE', 'PROGRAM', 'RECORD', 'REPEAT', 'SET', 'SHL', 'SHR', 'STRING',
    'THEN', 'TO', 'TYPE', 'UNIT', 'UNTIL', 'USES', 'VAR', 'VIRTUAL', 'WHILE',
    'WITH', 'XOR'
}

def glyph_name_to_identifier(name: str) -> str:
    s = re.sub(r'[^0-9A-Za-z]', '_', name)
    s = re.sub(r'(?<=[0-9a-z])([A-Z])', r'_\1', s)
    ident = s.upper()
    if re.match(r'^[0-9]', ident):
        ident = 'NUM_' + ident
    if ident in DELHI_RESERVED:
        ident += '_'
    if len(ident) == 1:
        ident = 'CHAR_' + ident
    if not re.match(r'^[A-Z_]', ident):
        ident = '_' + ident
    return ident

def pascal_class_name_from_filename(filename: str) -> str:
    base = os.path.splitext(os.path.basename(filename))[0]
    if base.lower().startswith('u') and len(base) > 1 and base[1].isupper():
        base = base[1:]
    base = re.sub(r'\W', '', base)
    return f'TM{base}Icons'

def get_font_family_name(font: TTFont) -> str:
    name_table = font['name']
    for record in name_table.names:
        if record.nameID == 1:
            try:
                return record.toUnicode()
            except:
                return record.string.decode('utf-8', errors='replace')
    return 'UnknownFontFamily'

def generate_pas_unit(font_path: str, output_path: str):
    class_name = pascal_class_name_from_filename(output_path)
    unit_name = os.path.splitext(os.path.basename(output_path))[0]

    font = TTFont(font_path)
    cmap = font.getBestCmap()

    id_map = {}
    for codepoint, glyph in cmap.items():
        ident = glyph_name_to_identifier(glyph)
        if ident not in id_map:
            id_map[ident] = codepoint

    sorted_idents = sorted(set(id_map.keys()))

    font_family = get_font_family_name(font)

    lines = []
    lines.append(f"unit {unit_name};")
    lines.append("\ninterface")
    lines.append("\nuses")
    lines.append("  System.SysUtils;")
    lines.append("\ntype")
    lines.append(f"  {class_name} = class")
    lines.append("  public")
    lines.append(f"    const FONT_FAMILY = '{font_family}';")

    for ident in sorted_idents:
        hexcode = format(id_map[ident], 'X')
        lines.append(f"    const {ident}: WideChar = #${hexcode};")

    lines.append("  end;")
    lines.append("\nimplementation")
    lines.append("\nend.")

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))

    print(f"Generated {len(sorted_idents)} icons in {output_path} as class {class_name}")

def main():
    args = sys.argv[1:]
    if len(args) < 2 or len(args) % 2 != 0:
        print("Usage: icon_font_consts_generator.py font1.otf font2.otf ... output1.pas output2.pas ...")
        sys.exit(1)

    half = len(args) // 2
    fonts = args[:half]
    outputs = args[half:]

    for font_file, output_file in zip(fonts, outputs):
        generate_pas_unit(font_file, output_file)

if __name__ == '__main__':
    main()
