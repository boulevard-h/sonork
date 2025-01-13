#!/bin/bash

# 指定 hosts.config 文件路径
CONFIG_FILE="hosts.config"

# 检查文件是否存在
if [[ ! -f $CONFIG_FILE ]]; then
    echo "Error: $CONFIG_FILE not found!"
    exit 1
fi

# 遍历文件中的每一行
while read -r line; do
    # 跳过空行或注释行
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # 解析字段：id, priv_id, pub_ip, port
    id=$(echo "$line" | awk '{print $1}')
    priv_ip=$(echo "$line" | awk '{print $2}')
    pub_ip=$(echo "$line" | awk '{print $3}')
    port=$(echo "$line" | awk '{print $4}')

    # 检查 priv_ip 是否为 127.0.0.1
    if [[ "$priv_ip" == "127.0.0.1" ]]; then
        # 检查端口是否被占用
        occupied_pid=$(lsof -i TCP:"$port" -sTCP:LISTEN -t 2>/dev/null)

        if [[ -n "$occupied_pid" ]]; then
            echo "Port $port is occupied by process $occupied_pid. Killing it..."
            # 杀掉对应的进程
            kill -9 "$occupied_pid"
            if [[ $? -eq 0 ]]; then
                echo "Process $occupied_pid killed successfully."
            else
                echo "Failed to kill process $occupied_pid."
            fi
        else
            echo "Port $port is not occupied."
        fi
    fi
done < "$CONFIG_FILE"

echo "Script execution completed."