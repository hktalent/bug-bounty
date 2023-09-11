#!/usr/bin/env python3
# -*- coding:utf-8 -*-
"""
写一个python代码
1、遍历当前目录下的data、md目录中所有子目录中md、json文件
2、生成索引的readme.md文件，readme.md创建在当前目录中
3、同时将data、md目录中子目录名定义为readme.md中的多层菜单目录结构
4、为readme.md中所有目录结构、文件（json、md）加上github本地的相对连接
"""
import os
import re
from pathlib import Path

current_dir = Path.cwd()
data_dir = current_dir / 'data'
md_dir = current_dir / 'md'

def get_all_subdirs(path):
    subdirs = []
    for p in path.iterdir():
        if p.is_dir(): 
            subdirs.append(p.name)
            subdirs.extend(get_all_subdirs(p))
    return subdirs

all_subdirs = get_all_subdirs(data_dir) + get_all_subdirs(md_dir)

with open('README.md', 'w') as f:
    f.write('# Contents\n')
    
    for d in all_subdirs:
        name = re.sub(r"[-_]", " ", d) 
        f.write(f' - <a href="/{d}">{name}</a>\n')

    def process_subdir(path):
        f.write(f'\n## {path.name}\n')

        for file in path.iterdir():
            if file.suffix in ['.md', '.json','.pdf']:
                name = re.sub(r"\.(md|json|pdf)$", "", file.name)
                name = re.sub(r"[-_]", " ", name) 
                f.write(f' - <a target=_black href="/{data_dir.name}/{path.name}/{file.name}">{name}</a>\n')

    for p in [data_dir, md_dir]:
        for subpath in p.iterdir():
            if subpath.is_dir():
                process_subdir(subpath)
                for subsubdir in subpath.iterdir():
                    if subsubdir.is_dir():
                        process_subdir(subsubdir)
