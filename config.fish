if status --is-interactive
    abbr --add --global a "eval (anyenv init - fish | source)"
    abbr --add --global gst "git status"
end

if test (count $path_odv) = 0
    set -U path_odv $HOME/OneDrive/main
end

if test (count $path_dbx) = 0
    set -U path_dbx $HOME/Dropbox/main
end

if test (count $path_work) = 0
    set -U path_work $HOME/work
end

if test (count $path_key) = 0
    set -U path_key $HOME/work/keys
end

alias odv="goto $path_odv"
alias dbx="goto $path_dbx"
alias work="goto $path_work"
alias key="goto $path_key"

if test -e $path_odv
    set path_doc $path_odv/doc; alias doc="goto $path_doc"
    set path_note $path_doc/note; alias note="goto $path_note"
end

if test -e $path_key
    set domain (cat $path_key/info/domain)
    set port (cat $path_key/info/port)
    set option (cat $path_key/info/option)
    set host_tablet (cat $path_key/info/host_tablet)
    set port_tablet (cat $path_key/info/port_tablet)
    set key $path_key/key/key
end

if test -e $path_anyenv
    # path_anenv
    set path_anyenv "$HOME/.anyenv"; alias ae="goto $path_anyenv"
    set path_pyenv "$path_anyenv/envs/pyenv"; alias pe="goto $path_pyenv"
    set path_pyenv_versions "$path_pyenv/versions"; alias vs="goto $path_pyenv_versions; pyenv versions"
    # python_versions
    set p21 2.7; set p22 15; set p31 3.7; set p32 6
    set path_s2 "$path_pyenv_versions/$p21.$p22/lib/python$p21/site-packages"
    set path_s3 "$path_pyenv_versions/$p31.$p32/lib/python$p31/site-packages"
    alias s2="goto $path_s2"; alias s3="goto $path_s3"
    alias to2="set-python $p21 $p22"; alias to3="set-python $p31 $p32"
end

# py_tools
alias combine_pdf_adf="exec_py combine_pdf_adf"
alias ftp_get_put="exec_py ftp_get_put"
alias generate_score="exec_py generate_score"
alias hosting_http="exec_py hosting_http"
alias show_path="exec_py show_path"
alias srt_player_utf8="exec_py srt_player_utf8"
# cleaner
alias rmds="clean .DS_Store"
alias rmdt="find . -name \"._*\" -size 4k -print0 | xargs -0 rm -v"
alias rmelc="clean *.elc"
# simply alias
alias e="emacs -nw"; alias c="emacsclient -t"
alias l="ls -avhl"; alias p="python"; alias t="tmux";
alias d="du -csh"; alias da="du -hd 1 | sort -h"
alias ..="goto .."; alias exe="exec $SHELL -l"
alias grep="grep --color=auto"
alias opensync="sudo open -a FreeFileSync"
alias mount_disk="sudo umount /dev/disk3s1; ntfs disk3s1 NTFS; sudo open -a FreeFileSync"

export LS_COLORS='ow=04;34'
# export DISPLAY=:0.0
if string match -q "*microsoft*" (uname -a)
    set -x DISPLAY (cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
    set -x PULSE_SERVER tcp:(grep nameserver /etc/resolv.conf | awk '{print $2}')
end

if test (uname) = "Darwin"
    # export PATH=/usr/local/opt/coreutils/libexec/gnubin:${PATH}
    # export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}
    # alias sshd='sudo /usr/sbin/sshd'
    # alias emacs='/usr/local/Cellar/emacs/26.1_1/bin/emacs'
    # alias emacs='/usr/local/Cellar/emacs/26.3/bin/emacs-26.3'
else if test (uname) = "Linux"
    # alias o="onedrive --synchronize --download-only"
end

if test (count $if_init_anyenv) = 0
    set -U if_init_anyenv "false"
end

if test $if_init_anyenv = "true"
    if not test (count $TMUX) = 0
	eval (anyenv init - fish | source)
	# status --is-interactive; and source (anyenv init -|psub)
    end
end

main_functions
fish_functions
network_functions
set_functions
util_functions
