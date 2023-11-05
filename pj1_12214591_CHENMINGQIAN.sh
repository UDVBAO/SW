#!/bin/bash

U_ITEM="/home/chen/SW/u.item"
U_DATA="/home/chen/SW/u.data"
U_USER="/home/chen/SW/u.user"

PS3='Enter your choice [ 1-9 ]: '
options=(
  "--------------------------"
  "User Name: CHENMINGQIAN"
  "Student Number: 12214591"
  "[ MENU ]"
  "1.Get the data of the movie identified by a specific 'movie id' from 'u.item'"
  "2.Get the data of action genre movies from 'u.item'"
  "3.Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
  "4.Delete the ‘IMDb URL’ from ‘u.item'"
  "5.Get the data about users from 'u.user'"
  "6.Modify the format of 'release date' in 'u.item'"
  "7.Get the data of movies rated by a specific 'user id' from 'u.data'"
  "8.Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
  "9.Exit"
  "--------------------------"
)
huoqu_dianying_shuju() {
  local dianying_id=$1
  grep "^$dianying_id|" "$U_ITEM"
}

liebiao_dongzuo_dianying() {
  awk -F'|' -v dongzuo_leixing="1" '$6 == dongzuo_leixing {print $1, $2}' "$U_ITEM" | sort -n | head -10
}

jisuan_pingjun_fenshu() {
  awk -F'|' -v dianying_id="$1" '$2 == dianying_id {zonghe+=$3; shuliang++} END {if (shuliang > 0) printf "average rating of %d: %.5f\n", dianying_id, zonghe/shuliang; else print "No ratings for movie id", dianying_id;}' "$U_DATA"
}

shanchu_IMDb_URL() {
  awk -F'|' '{print $1, $2, $3, $4, "", $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23}' "$U_ITEM" | head -10
}

xianshi_yonghu_shuju() {
  awk -F'|' '{print "user", $1, "is", $2, "years old", $3, $4}' "$U_USER" | head -10
}

genggai_fabu_riqi_geshi() {
  awk -F'|' 'BEGIN {OFS=FS} {gsub("-", "", $3); print $0}' "$U_ITEM" | tail -10
}

xianshi_yonghu_pingfen() {
  awk -F'|' -v yonghu_id="$1" '$1 == yonghu_id {print $2}' "$U_DATA" | sort -n | uniq
}

jisuan_zhuanjia_fenshu() {
  awk -F'|' 'NR==FNR && $2>=20 && $2<=29 && $4=="programmer" {zhuanjia[$1]; next} FNR!=NR && ($1 in zhuanjia) {zonghe[$2]+=$3; shuliang[$2]++} END {for (dianying in zonghe) if (shuliang[dianying] > 0) printf "%d %.5f\n", dianying, zonghe[dianying]/shuliang[dianying]}' "$U_USER" "$U_DATA" | sort -n
}

select opt in "${options[@]}"
do
  case $opt in
    "${options[0]}")
      read -p "Please enter the 'movie id’(1~1682): " dianying_id
      huoqu_dianying_shuju "$dianying_id"
      ;;
    "${options[1]}")
      liebiao_dongzuo_dianying
      ;;
    "${options[2]}")
      read -p "Please enter the 'movie id’(1~1682): " dianying_id
      jisuan_pingjun_fenshu "$dianying_id"
      ;;
    "${options[3]}")
      shanchu_IMDb_URL
      ;;
    "${options[4]}")
      xianshi_yonghu_shuju
      ;;
    "${options[5]}")
      genggai_fabu_riqi_geshi
      ;;
    "${options[6]}")
      read -p "Please enter the ‘user id’(1~943): " yonghu_id
      xianshi_yonghu_pingfen "$yonghu_id"
      ;;
    "${options[7]}")
      jisuan_zhuanjia_fenshu
      ;;
    "${options[8]}")
      echo "Bye!"
      break
      ;;
    *)
      echo "Invalid option $REPLY"
      ;;
  esac
done

