function fish_functions
    # print_string "Load fish_functions.fish completed."
end

function print_current_directory
    printf "%s ≻≻ %s%s%s\n" (set_color green) (set_color bryellow) (pwd) (set_color normal)
end

function counter
    set -l file_num (math (ls -l | grep "^-" | wc -l))
    set -l hidden_file_num (math (ls -la | grep "^-" | wc -l) - $file_num)
    set -l dir_num (math (ls -l | grep "^d" | wc -l))
    set -l hidden_dir_num (math (ls -la | grep "^d" | wc -l) - 2 - $dir_num)
    set -l line '--------------------------------------------------'
    print_string "FILE | visible: $file_num | hidden: $hidden_file_num"
    print_string "PATH | visible: $dir_num | hidden: $hidden_dir_num"
    printf "%s%s%s\n" (set_color yellow) $line (set_color normal)
end

function counter_plus
    counter
    set -l all_file_num (find . -type f | wc -l)
    set -l all_subpath_num (math (find . -type d | wc -l) - 1)
    print_string "Number of files in all subpaths (including hidden files): $all_file_num"
    print_string "Number of all subpaths (including hidden paths): $all_subpath_num"
end

function fish_user_key_bindings
    bind \cj "echo ''; print_current_directory; ls -av; counter; commandline -f repaint"
end

function fish_greeting
    set -l pc_kernel_version (uname -v)
    set -l pc_kernel_release (uname -r)
    set -l pc_processor (uname -p)
    set -l pc_machine_type (uname -m)
    set -l pc_host_name (uname -n)
    set -l time_now (date)
    if command -sq figlet
        set logo (figlet "MemoPixel")
    else
        set logo (echo "memopixel.com")
    end
    set -l line '--------------------------------------------------'
    printf '%s\n' (set_color green) $line (set_color yellow) $logo (set_color green) $line
    printf '%s%s%s%s\n' (set_color green) 'Kernel version: ' (set_color yellow) $pc_kernel_version
    printf '%s%s%s%s\n' (set_color green) 'Kernel release: ' (set_color yellow) $pc_kernel_release
    printf '%s%s%s%s\n' (set_color green) 'Processor: ' (set_color yellow) $pc_processor
    printf '%s%s%s%s\n' (set_color green) 'Machine type: ' (set_color yellow) $pc_machine_type
    printf '%s%s%s%s\n' (set_color green) 'Host name: ' (set_color yellow) $pc_host_name
    printf '%s%s%s%s\n' (set_color green) 'Login time: ' (set_color yellow) $time_now
    printf '%s%s%s\n' (set_color green) $line (set_color normal)
end
