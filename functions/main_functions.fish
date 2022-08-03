function main_functions
    # print_string "Load main_functions.fish completed." 
end

function print_string
    if test (count $argv) = 1
	printf "%s%s%s" (set_color brmagenta) "=== " (set_color normal)
	printf "%s%s%s" (set_color -o AA8333) $argv[1] (set_color normal)
	printf "%s%s%s\n" (set_color brmagenta) " ===" (set_color normal)
    end
end

function install_anyenv
    if not test -e $path_anyenv
	git clone https://github.com/anyenv/anyenv.git $path_anyenv
    end
end

function init_path
    set -U fish_user_paths $path_anyenv/bin
    if test (uname) = "Darwin"
	set -U fish_user_paths /usr/local/opt/coreutils/libexec/gnubin $fish_user_paths
    end
    print_string "System environment path and anyenv initialization completed."
end

function init_python_path
    set -xU PYTHONPATH $path_pyi:$path_s3
end

function show
    if test (count $argv) = 1
        switch $argv[1]
	    case path
                for i in (seq (count $PATH))
                    echo "[$i] $PATH[$i]"
                end
            case repo
                for i in (ls)
                    cd $i
                    echo -e (set_color yellow) "\n---" (pwd) "---" (set_color normal)
                    git status
                    cd ..
                end
            case ppa
                grep -r --include '*.list' '^deb ' /etc/apt/sources.list /etc/apt/sources.list.d/
            case ppa-lite
                grep -r --include '*.list' '^deb ' /etc/apt/sources.list*
            case ppa-simple
                grep -r --include '*.list' '^deb ' /etc/apt/ | sed -re 's/^\/etc\/apt\/sources\.list((\.d\/)?|(:)?)//' -e 's/(.*\.list):/\[\1\] /' -e 's/deb http:\/\/ppa.launchpad.net\/(.*?)\/ubuntu .*/ppa:\1/'
            case ppa-cache
                apt-cache policy | grep http | awk '{print $2" "$3}' | sort -u
        end
    end
end

function goto
    if test (count $argv) = 1
	if test -e $argv[1]
	    cd $argv[1]; ls -a
	else
	    print_string $argv[1]" not exists."
	end
    end
end

function goto_site_packages
    goto $path_pyenv_versions/$argv[1].$argv[2]/lib/python$argv[1]/site-packages
end

function exec_py
    python3 ~/.config/fish/extensions/python_tools/$argv[1].py $argv[2]
end

function clean
    find . -name "$argv[1]" -exec rm -rfv {} \;
end

function clean_except
    find . ! -name "*$argv[1]"  -exec rm -rfv {} \;
end

function clean_files
    find . -name "$argv[1]" -print0 | xargs -0 rm -v # "print0"&"-0" is for handle the problem that space in file name.
end

function search_content
    find . -type f -print0 | xargs -0 grep "$argv[1]"
end

function clean_tex
    set tex_extension aux bbl blg dvi fdb_latexmk fls toc log lof lot synctex.gz
    for i in $tex_extension
	set -l file_to_be_del *.$i
	rm -fv $file_to_be_del
    end
end

function dict
    grep $argv[1] ~/.config/fish/extensions/utf8.dict -A 1 -wi --color
end

function ntfs
    sudo ntfs-3g /dev/$argv[1] /Volumes/$argv[2] -o rw,uid=501,gid=20,dmask=002,fmask=002,locale=ja_JP.UTF-8
    # ntfs-3g /dev/$1 /Volumes/$2 -olocal -oallow-other;
end

function emacsd
    if test (count $argv) = 1
        switch $argv[1]
            case start
                emacs --daemon
            case stop
                emacsclient -e '(kill-emacs)'
        end
    end
end

function wd2p
    string join '' '/mnt/' (string lower (echo (string split ':' $argv[1]) | awk '{print $1}')) '/' (echo (string split ':\\' $argv[1]) | awk '{print $2}' | string replace -a '\\' '/')
end
