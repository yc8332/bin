#!/bin/sh
#**********************************************************************
# Description       :lang
# version           :0.1
#**********************************************************************
#-------------------VAR------------------------------------------------
#-------------------FUN------------------------------------------------
main(){
	cd /home/ywgx/data/language/zh_CN/
	for i in `grep 威望 * -R -l`;do sed -i 's/威望/信义/g' $i;done
	for i in `grep 会员 * -R -l`;do sed -i 's/会员/鸿雁/g' $i;done
	for i in `grep 帖子 * -R -l`;do sed -i 's/帖子/文章/g' $i;done
	for i in `grep 游客 * -R -l`;do sed -i 's/游客/过客/g' $i;done
	for i in `grep 发帖 * -R -l`;do sed -i 's/发帖/写文章/g' $i;done
	for i in `grep 回帖 * -R -l`;do sed -i 's/回帖/回文/g' $i;done
	for i in `grep 该帖 * -R -l`;do sed -i 's/该帖/该文章/g' $i;done
	for i in `grep 此帖 * -R -l`;do sed -i 's/此帖/此文章/g' $i;done
	for i in `grep 主帖 * -R -l`;do sed -i 's/主帖/主文/g' $i;done
	for i in `grep 资料浏览 * -R -l`;do sed -i 's/资料浏览/浏览/g' $i;done
	for i in `grep 主题帖 * -R -l`;do sed -i 's/主题帖/主题文/g' $i;done
	for i in `grep 论坛 * -R -l`;do sed -i 's/论坛//g' $i;done
	for i in `grep 此版块还没有任何内容。 * -R -l`;do sed -i 's/此版块还没有任何内容。/新大陆/g' $i;done
	for i in `grep 暂无新帖 * -R -l`;do sed -i 's/暂无新帖/暂无新文/g' $i;done
	for i in `grep 搜索功能仅限鸿雁使用 * -R -l`;do sed -i 's/搜索功能仅限鸿雁使用//g' $i;done
	for i in `grep 没有新帖 * -R -l`;do sed -i 's/没有新帖/暂无/g' $i;done
	for i in `grep 此用户从未发言。 * -R -l`;do sed -i 's/此用户从未发言。/鸿雁未语/g' $i;done
	for i in `grep 写文章排行 * -R -l`;do sed -i 's/写文章排行/书写排行/g' $i;done
}
#-------------------PROGRAM--------------------------------------------
main

