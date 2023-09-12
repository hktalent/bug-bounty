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

all_subdirs = []

def doFile(file,subdir):
    if file.suffix in ['.md', '.json', '.pdf']:
        name = re.sub(r"\.(md|json|pdf)$", "", file.name)
        name = re.sub(r"[-_]", " ", name)
        f.write(f' - <a target=_blank href="/{subdir.relative_to(current_dir)}/{file.name}">{name}</a>\n')
def get_all_subdirs(path):
    for p in path.iterdir():
        if p.is_dir():
            all_subdirs.append(p)
            get_all_subdirs(p)
            
get_all_subdirs(data_dir)
get_all_subdirs(md_dir)
all_subdirs.append(data_dir)
all_subdirs.append(md_dir)

with open('README.md', 'w') as f:
    f.write('# 目录\n')
    
    for d in all_subdirs:
        name = re.sub(r"[-_]", " ", d.name)
        f.write(f' - <a href="/{d.relative_to(current_dir)}">{name}</a>\n')

    for subdir in all_subdirs:
        has_files = False
        for file in subdir.iterdir():
            if file.suffix in ['.md', '.json', '.pdf']:
                has_files = True
                break 
        if has_files or any(p.is_dir() for p in subdir.iterdir()):
            f.write(f'\n## {subdir.name}\n')
            
            for file in subdir.iterdir():
                if file.suffix in ['.md', '.json', '.pdf']:
                    name = re.sub(r"\.(md|json|pdf)$", "", file.name)
                    name = re.sub(r"[-_]", " ", name)
                    f.write(f' - <a target=_blank href="/{subdir.relative_to(current_dir)}/{file.name}">{name}</a>\n')