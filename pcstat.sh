#!/bin/bash

# 実行権限を与える
# chmod +x pcstat.sh

# 引数で指定された秒数だけスリープする
# 秒数が指定されていない場合は1秒間
sleep_interval=${1:-1}

# 指定された秒数だけ繰り返す
count=0
while true; do
    # vmstatコマンドを使ってシステムの負荷を取得し、統計情報を抽出
    load_stats=$(vmstat 1 2 | tail -n 1)
    timestamp=$(date "+%Y年 %m月 %d日 %A %T JST")

    # CPU使用率を取得
    user_cpu=$(echo "$load_stats" | awk '{print $13}')
    system_cpu=$(echo "$load_stats" | awk '{print $14}')
    idle_cpu=$(echo "$load_stats" | awk '{print $15}')
    wait_cpu=$(echo "$load_stats" | awk '{print $16}')


    count=$((count + sleep_interval))
{   echo "---------------$((count - sleep_interval))[sec]---------------" # 経過秒数の出力
    echo "$timestamp"
    echo "CPU使用率の割合ユーザ-: $user_cpu[%]"
    echo "システム: $system_cpu[%]"
    echo "アイドル時間: $idle_cpu[%]"
    echo "IO待ち時間: $wait_cpu"
    echo "------------------------------------"
    sleep "$sleep_interval"
} | tee -a pcstat-log.txt #ターミナル表示とファイルへの入力
done
