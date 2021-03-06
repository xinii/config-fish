function fish_prompt --description 'Write out the prompt'
    set laststatus $status
    set fish_pwd (prompt_pwd)

    if set -l git_branch (command git symbolic-ref HEAD 2>/dev/null | string replace refs/heads/ '')
	set git_branch (set_color -o blue)"$git_branch"
	if command git diff-index --quiet HEAD --
	    if set -l count (command git rev-list --count --left-right $upstream...HEAD 2>/dev/null)
		echo $count | read -l ahead behind
		if test "$ahead" -gt 0
		    set git_status "$git_status"(set_color red)⬆
		end
		if test "$behind" -gt 0
		    set git_status "$git_status"(set_color red)⬇
		end
	    end
	    for i in (git status --porcelain | string sub -l 2 | uniq)
		switch $i
		    case "."
			set git_status "$git_status"(set_color green)✚
		    case " D"
			set git_status "$git_status"(set_color red)✖
		    case "*M*"
			set git_status "$git_status"(set_color green)✱
		    case "*R*"
			set git_status "$git_status"(set_color purple)➜
		    case "*U*"
			set git_status "$git_status"(set_color brown)═
		    case "??"
			set git_status "$git_status"(set_color red)≠
		end
	    end
	else
	    set git_status (set_color green):
	end
	set git_info "($git_status$git_branch"(set_color white)")"
    end

    # set_color -b black
    printf "%s%s " (set_color -o green) (count $PATH)
    if test $laststatus -eq 0
	printf "%s✔ " (set_color -o green)
    else
	printf "%s✘ $laststatus " (set_color -o red)
    end
    if test $USER = "root"
	printf "%s" (set_color red)
    else
	printf "%s" (set_color purple)
    end
    printf "%s%s%s" $USER@ (set_color green) (prompt_hostname)
    printf "%s%s" (set_color white) ":"
    printf "%s%s" (set_color yellow) (echo $fish_pwd | sed -e "s|^$HOME|~|")
    printf "%s%s" (set_color white) $git_info
    if test $USER = "root"
	printf "%s%s" (set_color red) ' # '
    else
	printf "%s%s" (set_color white) ' ≻ '
    end
    printf "%s" (set_color normal)

end
