#!/bin/zsh

# 进入项目目录
cd /Users/weixin.li/fontEnd_Learning/awesome-algorithms

# 添加所有更改
git add .

# 检查是否有更改需要提交
if ! git diff-index --quiet HEAD; then
  # 提交更改
  git commit -m "Auto commit - $(date -u)"
  
  # 推送到远程仓库 (假设默认分支是 master)
  git push origin master
  echo "[$(date)] Changes pushed successfully" >> auto-push.log
else
  echo "[$(date)] No changes to commit" >> auto-push.log
fi