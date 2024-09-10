#!/bin/bash

# 実行権限を与える
# chmod +x pcstat.sh

# 引数で指定された秒数だけスリープする
# 秒数が指定されていない場合は1秒間
sleep_interval=${1:-1}

# 指定された秒数だけ繰り返す
count=0

while true; do
    # ネットワークの統計情報を取得する関数
    get_network_stats() {
        # /proc/net/dev ファイルからeth0の情報を抽出
        eth0_info=$(cat /proc/net/dev | grep -E '^\s*eth0:')
        
        # eth0の情報が取得できない場合は何もしない
        if [ -z "$eth0_info" ]; then
            return
        fi

        # eth0の情報から各統計データを抽出
        rx_packets=$(echo "$eth0_info" | awk '{print $2}')
        rx_errors=$(echo "$eth0_info" | awk '{print $4}')
        tx_packets=$(echo "$eth0_info" | awk '{print $10}')
        tx_errors=$(echo "$eth0_info" | awk '{print $12}')

        # RXエラー率を計算
        if [ "$rx_packets" -ne 0 ]; then
            rx_error_rate=$(awk "BEGIN { printf \"%.2f\", ($rx_errors / $rx_packets) * 100 }")
        else
            rx_error_rate=0
        fi

        # 流通パケット数を計算
        total_packets=$((rx_packets + tx_packets))

        # 曜日を日本語に変換
        case "$(date +%u)" in
            1) day_of_week="月曜日" ;;
            2) day_of_week="火曜日" ;;
            3) day_of_week="水曜日" ;;
            4) day_of_week="木曜日" ;;
            5) day_of_week="金曜日" ;;
            6) day_of_week="土曜日" ;;
            7) day_of_week="日曜日" ;;
        esac

        # 時刻を取得 (JST)
        timestamp=$(TZ=JST-9 date "+%Y年 %m月 %d日 $day_of_week %T JST")
    }

    get_network_stats
    count=$((count + sleep_interval))
{   echo "---------------$((count - sleep_interval))[sec]---------------" # 経過秒数の出力
    echo "$timestamp"
    echo "RXパケット数: $rx_packets"
    echo "RXエラー数: $rx_errors"
    echo "TXパケット数: $tx_packets"
    echo "TXエラー数: $tx_errors"
    echo "RXエラー率: $rx_error_rate"
    echo "流通パケット数: $total_packets"
    echo "------------------------------------"
    sleep "$sleep_interval"
} | tee -a nstat-log.txt #ターミナル表示とファイルへの入力
done
