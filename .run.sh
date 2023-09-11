xx=`pwd`
echo $xx
cd md
chmod +x up.sh
./up.sh
cd $xx
python3 main.py
git add md data
git commit -m "up" .
git push

