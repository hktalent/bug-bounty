xx=`pwd`
echo $xx
cd md
chmod +x up.sh
./up.sh
cd $xx
find . -type f -name "*.py.zip" -delete
find . -type f -name ".DS_Store" -delete
find . -type f -name "LICENSE" -delete
find . -type f -name "LICENSE.*" -delete
find . -type f -name "CHANGELOG.*" -delete

python3 main.py
git add md data
git commit -m "up" .
git push

