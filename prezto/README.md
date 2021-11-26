# prezto 初始化脚本


## Prezto 介绍

Prezto 官方仓库的介绍很简单，简单到只说 Prezto 是一个 zsh 配置框架，集成了一些主题、插件等。但是如果细说的话，其实 Prezto 最早应该是 oh-my-zsh 的 fork 版本，然后 Prezto 被一点点重写，现在已经基本看不到 oh-my-zsh 的影子了。不过唯一可以肯定的是，性能以及易用性上比 oh-my-zsh 好得多。

> Prezto has been rewritten by the author who wanted to achieve a good zsh setup by ensuring all the scripts are making use of zsh syntax. It has a few more steps to install but should only take a few minutes extra. —- John Stevenson

## Prezto 安装

Prezto 安装按照仓库文档的方法安装即可:

### zsh 安装

首先确定已经安装了 zsh，如果没有安装则需要通过相应系统的包管理器等工具进行安装:

```
# macOS(最新版本的 macOS 已经默认安装了 zsh)
brew install zsh

# Ubuntu
apt install zsh -yCopy
```

### 克隆仓库

在仓库进行克隆时一般分为两种情况，一种默认克隆到 `"${ZDOTDIR:-$HOME}/.zprezto"` 目录(标准安装):

```
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"Copy
```

另一种高级用户可能使用 `XDG_CONFIG_HOME` 配置:

```
# 克隆仓库
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}/.zprezto"

# 调整 Prezto 的 XDG_CONFIG_HOME 配置
# 该配置需要写入到 $HOME/.zshenv 中
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export ZDOTDIR="${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}"
source "$ZDOTDIR/.zshenv"Copy
```

### 创建软连接

Prezto 的安装方式比较方便定制化，在主仓库克隆完成后，只需要将相关的初始化加载配置软连接到 `$HOME` 目录即可:

```
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
doneCopy
```

不过需要注意的是上面的命令在某些 shell 脚本里直接写可能会有兼容性问题，在这种情况下可以直接通过命令进行简单处理:

```
for rcfile in $(ls ${ZDOTDIR:-$HOME}/.zprezto/runcoms/* | xargs -n 1 basename | grep -v README); do
    target="${ZDOTDIR:-$HOME}/.${rcfile:t}"
    ln -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/${rcfile}" "${target}"
doneCopy
```

至此，Prezto 算是安装完成，重新登录 shell 即可看到效果。

## 细节调整

### 更换主题

默认情况下 Prezto 使用 sorin 这个主题，如果对默认主题不满意可以通过 `prompt` 命令切换:

```
# 列出当前支持的主题
prompt -l

# 直接在命令行上展示所有主题样式(预览)
prompt -p

# 临时试用某个主题
prompt 主题名称

# 保存该主题到配置中(使用)
prompt -s 主题名称Copy
```

[![img](https://gitee.com/yuchi-shentang/upload-img/raw/master/img/2021-11-09_22-24__2021-11-09_22-22__Uxo7e0.png)](https://cdn.oss.link/markdown/Uxo7e0.png)

### grep 高亮

默认情况下 Prezto 在执行 grep 时会对结果进行高亮处理，在某些终端主题上可能会很影响观感:

[![img](https://gitee.com/yuchi-shentang/upload-img/raw/master/img/2021-11-09_22-24__S5H0HX.png)](https://cdn.oss.link/markdown/S5H0HX.png)

grep 高亮是在 `utility` 插件中被开启的，可以通过在 `~/.zpreztorc` 中增加以下配置关闭:

```
zstyle ':prezto:module:utility:grep' color 'no'Copy
```

### 命令、语法高亮

Prezto 通过 syntax-highlighting 插件提供了各种语法高亮配置，通过解开以下配置的注释开启更多的自动高亮:

```
# Set syntax highlighters.
# By default, only the main highlighter is enabled.
zstyle ':prezto:module:syntax-highlighting' highlighters \
  'main' \
  'brackets' \
  'pattern' \
  'line' \
  'cursor' \
  'root'Copy
```

[![img](https://gitee.com/yuchi-shentang/upload-img/raw/master/img/2021-11-09_22-24__2021-11-09_22-22__m6D71F.png)](https://cdn.oss.link/markdown/m6D71F.png)

**需要注意的是，默认 root 高亮开启后，root 用户所有执行命令都会高亮，这样可能在主题配色上导致看不清输入的命令，可以简单的移除 root 高亮配置即可。**

### 自定义命令高亮

在 `syntax-highlighting` 插件中启用了 `pattern` 高亮后，可以通过以下配置设置一些自定义的命令高亮配置，例如 `rm -rf` 等:

```
# Set syntax pattern styles.
zstyle ':prezto:module:syntax-highlighting' pattern \
  'rm*-rf*' 'fg=white,bold,bg=red'Copy
```

[![img](https://gitee.com/yuchi-shentang/upload-img/raw/master/img/2021-11-09_22-24__sveZAs.png)](https://cdn.oss.link/markdown/sveZAs.png)

### 历史命令搜索

oh-my-zsh 通过上下箭头按键来快速搜索历史命令是一个非常实用的功能，在切换到 Perzto 后会发现上下箭头的搜索变成了全命令的模糊匹配；例如输入 `vim` 然后上下翻页会匹配到位于命令中间带有 `vim` 字样的历史命令:

[![img](https://gitee.com/yuchi-shentang/upload-img/raw/master/img/2021-11-09_22-24__2021-11-09_22-22__FwkGH9.png)](https://cdn.oss.link/markdown/FwkGH9.png)

解决这个问题需要将 `history-substring-search` 插件依赖的 `zsh-history-substring-search` 切换到 master 分支并增加 `HISTORY_SUBSTRING_SEARCH_PREFIXED` 变量配置:

```
# 切换 zsh-history-substring-search 到 master 分支
(cd ~/.zprezto/modules/history-substring-search/external && git checkout master)

# 在 ~/.zshrc 中增加环境变量配置
export HISTORY_SUBSTRING_SEARCH_PREFIXED=trueCopy
```

同时历史搜索里还有一个问题是同样的命令如果出现多次会被多次匹配，解决这个问题需要增加以下变量:

```
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=trueCopy
```

## 其他插件

文章 [来源](https://mritd.com/2021/09/22/migrate-from-oh-my-zsh-to-prezto/)；


