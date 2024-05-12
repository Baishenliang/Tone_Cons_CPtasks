# Tone and consonant categorical perception (code only)

## 程序安装和维护指南
### 简介
github上面的代码只是整个实验程序中的代码和数据部分。大文件并不上传到github，而是通过线下介质传输（可以问我拿）。
### 具体操作
#### Step1: 下载github仓库
1. fork到自己的github账户里
2. 安装git，用git将自己账户里fork的仓库pull到本地，命名为Exp  
    （用fork的好处：可以自己随意改代码，不担心影响主仓库；如果需要合并到本仓库，pull request） 
#### Step2: 在本地文件夹（Exp）中添加空文件夹
由于github在push时候会省略空文件夹，一些空文件夹要手动添加进去  
**请通知我**，我会用everything指令"C:\lbs_pyprojects\SCNU_tACS_project\Exp empty:"搜索出所有空文件夹，然后告诉你要添加哪些空文件夹  
empty的搜索结果保存在：  "C:\lbs_pyprojects\SCNU_tACS_project\Exp_empty_direct.csv"  
#### Step3: 我通过储存介质把大文件以及转移代码发给你：
**目录：**  
    a. Exp_nocode：储存大文件的文件夹  
    b. bsliang_input_largefiles.m：将大文件夹里的文件转移到Exp中的脚本  
    c. bsliang_extract_largefiles.m：将Exp中的大文件转移到Exp_nocode中的脚本（基本上只需要我用）  
**执行方法：**  
将Exp_nocode和bsliang_input_largefiles.m置于和Exp同一水平的路径内，运行bsliang_input_largefiles.m即可。
#### Step4: 日常维护：
1. 平时每次做完实验或者修改完代码的，记得commit和push到自己的远程仓库里，通过pull request来向我申请合并到主仓库里
2. <font color='red'> 预实验生成的被试个体化刺激材料（存在预实验和正式实验的ind_stimmat路径里）因为太大没有在git仓库里，主试记得定期备份以免不测。</font>
