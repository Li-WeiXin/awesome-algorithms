#!/bin/zsh

# 添加 GitHub SSH 密钥到 SSH agent
ssh-add -K ~/.ssh/id_rsa_github

# 进入项目目录
cd /Users/weixin.li/fontEnd_Learning/awesome-algorithms

# 获取远程仓库的最新更改
git fetch origin

# 检查本地是否有未提交的更改
if ! git diff-index --quiet HEAD; then
  # 暂存本地更改
  git stash push -m "Auto-stashed changes $(date)" 
  echo "[$(date)] Local changes stashed" >> auto-push.log
fi

# 拉取远程更改 (带错误处理)
pull_output=$(git pull --no-rebase --no-commit origin master 2>&1)
pull_result=$?

if [ $pull_result -ne 0 ]; then
  echo "[$(date)] Failed to pull remote changes (exit code: $pull_result)" >> auto-push.log
  echo "[$(date)] Pull output: $pull_output" >> auto-push.log
  
  # 如果有暂存的更改，尝试恢复
  if git stash list | grep -q "Auto-stashed changes"; then
    git stash pop
    echo "[$(date)] Stashed changes restored after pull failure" >> auto-push.log
  fi
  
  # 退出脚本避免进一步的问题
  exit 1
else
  echo "[$(date)] Successfully pulled remote changes" >> auto-push.log
fi

# 检查是否有之前暂存的更改
if git stash list | grep -q "Auto-stashed changes"; then
  # 恢复之前暂存的更改
  git stash pop
  echo "[$(date)] Stashed changes restored" >> auto-push.log
fi

# 添加所有更改
git add .

# 检查是否有更改需要提交
if ! git diff-index --quiet HEAD; then
  # 提交更改
  git commit -m "Auto commit - $(date -u)"
  
  # 推送到远程仓库 (假设默认分支是 master)
  push_output=$(git push origin master 2>&1)
  push_result=$?
  
  if [ $push_result -eq 0 ]; then
    echo "[$(date)] Changes pushed successfully" >> auto-push.log
  else
    echo "[$(date)] Failed to push changes with exit code: $push_result" >> auto-push.log
    echo "[$(date)] Error details: $push_output" >> auto-push.log
  fi
else
  echo "[$(date)] No changes to commit" >> auto-push.log
fi