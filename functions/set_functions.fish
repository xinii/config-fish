function set_functions
    # print_string "Load set_functions.fish completed."
end

function set_equal_volume_macos
    if test (count $argv) = 1
	bash -c "printf 'p *(char*)(void(*)())AudioDeviceDuck=0xc3\nq' | lldb -n $argv[1]"
    end
end

function set_ls_colors_wsl
    # eval (dircolors -b)
    # export LS_COLORS=(string replace 'ow=34;42' 'ow=04;34' "$LS_COLORS")
    export LS_COLORS='ow=04;34'
end

function set_display_wsl
    export DISPLAY=:0.0
end

function set_conf
    if test (count $argv) = 0
	print_string "Need an input."
    else if test (count $argv) = 1
	switch $argv[1]
	    case 1
	    case 2
	    case *
		print_string "input error."
	end
    end
end

function set_tmux
    ln -sf $path_dot/tmux.conf $HOME/.tmux.conf
    print_string tmux.conf" linked to "$HOME"/.tmux.conf."
end

function set_vim
    ln -sf $path_dot/vimrc $HOME/.vimrc
    print_string vimrc" linked to "$HOME"/.vimrc."
end

function set_karabiner
    ln -sf $path_dot/karabiner.json $HOME/.config/karabiner/assets/complex_modifications/xinconig_custom.json
    print_string karabiner.json" linked to "$HOME"/.config/karabiner/assets/complex_modifications/xinconig_custom.json."
end

function set_lang_ja
    set -xU LANG "ja_JP.UTF-8"
end

function set_init_anyenv_true
    set -U if_init_anyenv "true"
    print_string "anyenv will init when startup."
end

function set_init_anyenv_false
    set -U if_init_anyenv "false"
    print_string "anyenv will **NOT** init when startup."
end

function set_init_anyenv
    if test (count $argv) = 0
	print_string "Need an input, on or off"
    else if test (count $argv) = 1
	switch $argv[1]
	    case true
                set -U if_init_anyenv "true"
                print_string "anyenv will init when startup."
            case false
                set -U if_init_anyenv "false"
                print_string "anyenv will **NOT** init when startup."
        end
    end
end

function set_emacs
    if test (count $argv) = 1
	set path_emacs $path_xin/.emacs.d/.emacs.d.$argv[1]
	if test $argv[1] = "purcell"
	    git clone https://github.com/$argv[1]/emacs.d.git $path_emacs
	end
	if test -e $path_emacs
	    rm -rfv $HOME/.emacs.d
	    ln -sf $path_emacs $HOME
	    mv $HOME/.emacs.d.$argv[1] $HOME/.emacs.d
	    print_string "Emacs profile changed to $path_emacs"
	else
	    print_string "$path_emacs not exists."
	end
    end
end

function set_emacs_lisp
    if test (count $argv) = 0
	print_string "Need an input for emacs lisp setting!
	Choice 1 for emacs clipboard(c):  $_ cx | cp | cn
	(x: xclip; p: pbcopy-pbpaste; n: nothing)
	Choice 2 for emacs yatex(y):      $_ yi | ys | yn
	(i: inrinko; s: seminar; n: nothing)
	Choice 3 for cx & yi:             $_ auto
	-> Example: $_ cx
	-> Example: $_ auto"
    else if test (count $argv) = 1
	switch $argv[1]
	    case auto
		link_lisp clipboard-xclip init-clipboard
		link_lisp yatex-inrinko init-yatex
	    case cx
		link_lisp clipboard-xclip init-clipboard
	    case cp
		link_lisp clipboard-pbcopy-pbpaste init-clipboard
	    case cn
		link_lisp clipboard-nothing init-clipboard
	    case yi
		link_lisp yatex-inrinko init-yatex
	    case ys
		link_lisp yatex-seminar init-yatex
	    case yn
		link_lisp yatex-nothing init-yatex
	    case *
		print_string "Input error."
	end
    end
end

function link_lisp
    if test -e $path_mul/$argv[1].el
	ln -sf $path_mul/$argv[1].el $path_el/$argv[2].el
	print_string $argv[1]".el linked to $path_el/"$argv[2]".el."
    else
	print_string $argv[1]".el not exists."
    end
end

function link_profile
    ln -sf $path_prf/$argv[1] $HOME/$argv[2]
    print_string "$1 profile linked to $HOME/$2."
end

function backup_profile
    if test -f $HOME/$argv[1]
	if not test -d $path_xin/backup
	    mkdir $path_xin/backup
	end
	set now (date +%Y%m%d.%H%M%S)
	mv $HOME/$argv[1] $path_xin/backup/$argv[1].backup.$now
	print_string $HOME"/"$argv[1]" exist, backed up to "$path_xin/backup/$argv[1]".backup."$now"."
    end
end
