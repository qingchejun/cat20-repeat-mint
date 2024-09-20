#!/bin/bash

# 定义命令
command="sudo yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5"

# 使用正则表达式提取tokenID和数量
if [[ $command =~ mint\ -i\ ([^\ ]+)\ ([0-9]+) ]]; then
    tokenid="${BASH_REMATCH[1]}"
    amount="${BASH_REMATCH[2]}"
else
    echo "无法从命令中提取参数，请检查命令格式"
    exit 1
fi

while true; do
    # 显示当前参数并请求确认
    echo "当前参数："
    echo "TokenID: $tokenid"
    echo "数量: $amount"
    
    read -p "这些参数正确吗？(y/n): " confirm
    if [[ $confirm != [Yy]* ]]; then
        read -p "请输入新的TokenID: " new_tokenid
        read -p "请输入新的数量: " new_amount
        tokenid=${new_tokenid:-$tokenid}
        amount=${new_amount:-$amount}
        command="sudo yarn cli mint -i $tokenid $amount"
    fi

    # 显示将要执行的命令
    echo "即将执行的命令: $command"
    
    # 再次确认
    read -p "确认执行? (y/n): " execute
    if [[ $execute != [Yy]* ]]; then
        echo "操作已取消"
        exit 0
    fi

    # 执行命令
    $command

    # 检查命令执行结果
    if [ $? -ne 0 ]; then
        echo "命令执行失败，退出循环"
        exit 1
    fi

    echo "命令执行成功"
    
    # 询问是否继续
    read -p "是否继续下一次MINT? (y/n): " continue
    if [[ $continue != [Yy]* ]]; then
        echo "脚本执行结束"
        exit 0
    fi

    # 等待1秒
    sleep 1
done