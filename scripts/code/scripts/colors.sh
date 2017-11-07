f=3 b=4
for j in f b; do
	for i in {0..7}; do
	    printf -v $j$i %b "\e[${!j}${i}m"
	done
done

bld=$'\e[1m'
rst=$'\e[0m'

cat << EOF

 B   R   G   Y   B   M   C   G
$f0███ $f1███ $f2███ $f3███ $f4███ $f5███ $f6███ $f7███$rst
$f0███ $f1███ $f2███ $f3███ $f4███ $f5███ $f6███ $f7███$rst
$f0███ $f1███ $f2███ $f3███ $f4███ $f5███ $f6███ $f7███$rst
$f0███ $f1███ $f2███ $f3███ $f4███ $f5███ $f6███ $f7███$rst

$bld$f0███ $f1███ $f2███ $f3███ $f4███ $f5███ $f6███ $f7███$rst
$bld$f0███ $f1███ $f2███ $f3███ $f4███ $f5███ $f6███ $f7███$rst
$bld$f0███ $f1███ $f2███ $f3███ $f4███ $f5███ $f6███ $f7███$rst
$bld$f0███ $f1███ $f2███ $f3███ $f4███ $f5███ $f6███ $f7███$rst

EOF