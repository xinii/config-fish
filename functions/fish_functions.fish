function fish_functions
    # print_string "Load fish_functions.fish completed."
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
        set logo (figlet "xinii.org")
    else
        set logo (echo "xinii.org")
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
