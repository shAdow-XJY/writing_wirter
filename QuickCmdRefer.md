## skill quick refer
### branch
1. git checkout -b v1.0.0
2. git checkout v1.0.0
3. git push --set-upstream origin v1.0.0
4. git branch -d v1.0.0

### calculate code lines
git log --since=2020-01-01 --until=2023-12-01 --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }'
### lib Dir lines count
test/code_line_compute: main() function

### rebuild project
```
    delete windows/mac/linux
    flutter create .
```
```
    # 进入工程目录，删除android目录
    rm -rf android
     
    # 重新创建java语言的android目录
    flutter create -a java .
     
    # 重新创建kotlin语言的android目录
    flutter create -a kotlin .
```
```
    # 进入工程目录，删除ios
    rm -rf ios 
     
    # 重新创建指定swift语言的ios目录
    flutter create -i swift .
     
    # 重新创建指定objective-c 语言的ios目录
    flutter create -i objc .  
```