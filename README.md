# shell-practice

シェルスクリプトの練習。

## ネットワーク状態記録スクリプト（nstat.sh）

引数で指定した秒間隔でネットワークの状態をファイルに記録するスクリプトである。

- 書式:`nstat.sh [sec]`
    - 引数を指定しない場合は、1秒間隔で記録を行う。
- 出力ファイル: 同一ディレクトリに`nstat-log.txt`を生成
- 記録内容:
    - 時刻
    - RX/TXパケット数、エラー数、エラー率
    - 流通パケット数


## Linuxシステム負荷記録スクリプト（pcstat.sh）

引数で指定した秒間隔でLinuxシステムの負荷をファイルに記録するスクリプトである。

- 書式:`pcstat.sh [sec]`
    - 引数を指定しない場合は、1秒間隔で記録を行う。
- 出力ファイル: 同一ディレクトリに`pcstat-log.txt`を生成
- 記録内容:
    - 時刻
    - CPU使用率（ユーザ、システム、アイドル時間、I/O待ち時間）