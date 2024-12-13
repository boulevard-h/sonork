#!/bin/bash

# 加载环境变量，确保动态链接库路径正确
source ~/.profile

# 显示脚本用法
echo "Usage: start.sh <shard_num> <N> <f> <B> <R> <start_num> <num> <tx_num>"

# 示例调用：
# ./start.sh 3 4 1 2000 1 0 8 20000

# 将参数存储到变量中以提高可读性
shard_num=$1   # 分片数量
N=$2           # 每个分片中的节点数量
f=$3           # 每个分片中的拜占庭节点数量
B=$4           # BFT batch size
R=$5           # 每次测试的轮数
start_num=$6   # 起始节点编号
num=$7         # 节点的 TX queue 的大小
tx_num=$8      # 跨片交易数量

# 清理旧交易文件并生成新的交易
rm -f ./TXs
touch TXs
python3 ./dumbobft/core/tx_generator.py --shard_num "$shard_num" --tx_num "$tx_num"

# 启动节点
shard_id=0
while [ "$shard_id" -lt "$shard_num" ]; do
    node_id=0
    while [ "$node_id" -lt "$N" ]; do
        # 判断是否需要启动节点
        if [ $(( shard_id * N + node_id )) -ge "$start_num" ] && [ $(( shard_id * N + node_id )) -lt $(( start_num + num )) ]; then
            echo "Starting node $node_id in shard $shard_id..."
            python3 run_socket_node.py \
                --sid 'sidA' \
                --id "$node_id" \
                --shard_id "$shard_id" \
                --shard_num "$shard_num" \
                --N "$N" \
                --f "$f" \
                --B "$B" \
                --R "$R" \
                --tx_num "$tx_num" &
            
            # 删除旧的日志文件
            rm -f "./log/consensus-node-$(( shard_id * N + node_id )).log"
        else
            echo "Node $node_id in shard $shard_id is not in the start range. Skipping..."
        fi
        node_id=$(( node_id + 1 ))
    done
    shard_id=$(( shard_id + 1 ))
done

# 等待所有后台进程完成
wait

echo "All nodes finished. Returning to command line prompt."
exec "$SHELL"