function util_functions
    # print_string "Load util_functions.fish completed."
end

function util_git
    git add .
    git status
    if test (count $argv) = 1
        git commit -m "$argv[1]"
    else
        git commit -m (date +%Y%m%d_%H-%M-%S)
    end
    git push
end

function util_jetson_nano
    if test (count $argv) = 1
	switch $argv[1]
	    case fan
		sudo sh -c "echo 20 > /sys/devices/pwm-fan/target_pwm"
	    case cam
		bash -c "DISPLAY=:0.0 gst-launch-1.0 nvarguscamerasrc ! 'video/x-raw(memory:NVMM), width=3280, height=2464, format=(string)NV12, framerate=(fraction)20/1' ! nvvidconv flip-method=2 ! nvoverlaysink -e"
	    case darknet-1
		./darknet detector demo cfg/coco.data cfg/yolov3-tiny.cfg yolov3-tiny.weights "'nvarguscamerasrc ! video/x-raw(memory:NVMM), width=3280, height=2464, format=(string)NV12, framerate=(fraction)30/1 ! nvtee ! nvvidconv flip-method=2 ! video/x-raw, width=(int)560, height=(int)420, format=(string)BGRx ! videoconvert ! appsink'"
	    case darknet-2
		./darknet detector demo cfg/coco.data cfg/yolov3-tiny.cfg yolov3-tiny.weights "'nvarguscamerasrc ! video/x-raw(memory:NVMM), width=1920, height=1080, format=(string)NV12, framerate=(fraction)30/1 ! nvtee ! nvvidconv flip-method=2 ! video/x-raw, width=(int)1280, height=(int)720, format=(string)BGRx ! videoconvert ! appsink'"
	    case test-1
		bash -c "DISPLAY=:0.0 gst-launch-1.0 nvarguscamerasrc ! 'video/x-raw(memory:NVMM), width=3280, height=2464, format=(string)NV12, framerate=(fraction)20/1' ! nvvidconv flip-method=2 ! nvoverlaysink –e"
	end
    end
end

function copy_code
    if test (count $argv) = 1
        cat $argv[1] | highlight --syntax=c -O rtf | pbcopy
    end
end


function install_emacs
    # for opensuse on windows, may need ncurses-devel package, use zypper to install.
    if test (count $argv) = 0
	print_string "Need three inputs for path, option for gif, and option for gnutls!
	-> Example: $_ user no no
	===> ./configure --prefix=$HOME/.local --with-gif=no --with-gnutls=no
	-> Example: $_ <any string> <any string> <any string>
	===> ./configure"
    else if test (count $argv) = 3
	mkdir temp_packages_will_be_delete
	cd temp_packages_will_be_delete
	wget https://ftp.gnu.org/gnu/emacs/emacs-26.2.tar.xz
	tar xf emacs-26.1.tar.xz
	rm -rf emacs-26.1.tar.xz
	cd emacs-26.1
	if test $argv[1] = "user"
	    set configure_string $configure_string "--prefix=$HOME/.local"
	end
	if test $argv[2] = "no"
	    set configure_string $configure_string "--with-gif=no"
	end
	if test $argv[3] = "no"
	    set configure_string $configure_string "--with-gnutls=no"
	end
	bash configure $configure_string
	make
	make install
	cd ../..
	print_string "If make and install are successful, you can remove the installation package."
	# rm -rf temp_packages_will_be_delete
    end
end

function install_git
    mkdir temp_packages_will_be_delete
    cd temp_packages_will_be_delete
    git clone https://github.com/git/git
    cd git
    make configure
    bash configure --prefix=$HOME/.local
    make
    make install
    cd ../..
    print_string "If make and install are successful, you can remove the installation package."
    # rm -rf temp_packages_will_be_delete
end

function install_emacs_and_git
    install_emacs_from_source
    install_git_from_source
end
