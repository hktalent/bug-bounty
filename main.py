import os
from pathlib import Path

"""
写一个python代码
1、遍历当前目录下的data、md目录中所有子目录中md、json文件
2、生成索引的readme.md文件，readme.md创建在当前目录中
3、同时将data、md目录中子目录名定义为readme.md中的多层菜单目录结构
4、为readme.md中所有目录结构、文件（json、md）加上github本地的相对连接
"""
current_dir = Path.cwd()
data_dir = current_dir / 'data'
md_dir = current_dir / 'md'

dirs = []
for p in [data_dir, md_dir]:
    for subpath in p.iterdir():
        if subpath.is_dir():
            dirs.append(subpath.name)

with open('README.md', 'w') as f:
    f.write('# Contents\n')
    for d in dirs:
        f.write(f' - [{d}](/{d})\n')

    for p in [data_dir, md_dir]:
        for subpath in p.iterdir():
            if subpath.is_dir():
                f.write(f'\n## {subpath.name}\n') 
                for file in subpath.iterdir():
                    if file.suffix in ['.md', '.json']:
                        f.write(f' - <a target=_black href="/{p.name}/{subpath.name}/{file.name}">{file.name}</a>\n')