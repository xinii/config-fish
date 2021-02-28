function network_functions
    # print_string "Load network_functions.fish completed."
end

function serve_site
    switch $argv[1]
	case je_ssl
	    jekyll serve --host=0.0.0.0 --port=10443 --ssl-cert=_cert/cert.cert --ssl-key=_cert/cert.key
	    it 443 10443
	case je_80
	    jekyll serve --host=0.0.0.0 --port=10080
	    it 80 10080
	case php_80
	    php -S 0.0.0.0:10080
	    it 80 10080
	case *
	    print_string "input error."
    end
end

function xrea_backup_site
    tar cvjpf (date +%Y-%m-%d)-backup.tar.bz2 --exclude=./public_html/.fast-cgi-bin --exclude=./public_html/log ./public_html
end

function xrea_restore_site
    if test (count $argv) = 0
	tar xvpjf backup.tar.bz2
    else if test (count $argv) = 3
	tar xvpjf $argv[1]-$argv[2]-$argv[3]-backup.tar.bz2
    else
	print_string "Input error."
    end
end

function generate_ssh_keys
    if test (count $argv) = 0
	print_string "Please input a value (system or user) for setup."
    else if test (count $argv) = 1
	switch $argv[1]
	    case system
		sudo /usr/bin/ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -C '' -N ''
		sudo /usr/bin/ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''
		sudo /usr/bin/ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -C '' -N ''
		sudo /usr/bin/ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -C '' -N ''
	    case user
		ssh-keygen
		cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
		chmod 600 ~/.ssh/authorized_keys
		chmod 700 ~/.ssh
	end
    end
end

function port_forwarding
    sudo iptables -t nat -A PREROUTING -p tcp --dport $argv[1] -j REDIRECT --to-port $argv[2]
end

function connect_to
    # s ssh/scp xrea user   [file] [file]
    # 0 1       2    3      4      5
    # s ssh/scp fire [file] [file]
    if test $argv[1] = "ssh"
	if test $argv[2] = "g2" -o $argv[2] = "g3"
	    ssh -i $path_key/xrea/$argv[3]_$argv[2] $argv[3]@$argv[2].xrea.com
	else if test $argv[2] = "fire"
	    ssh -i $key -p $port_tablet $host_tablet
	end
    else if test $argv[1] = "scp"
	if test $argv[2] = "g2" -o $argv[2] = "g3"
	    if test (count $argv) = 5
		scp -i $path_key/xrea/$argv[3]_$argv[2] -r ./$argv[4] $argv[3]@$argv[2].xrea.com:~/$argv[5]
	    else if test (count $argv) = 4
		scp -i $path_key/xrea/$argv[3]_$argv[2] -r $argv[3]@$argv[2].xrea.com:~/$argv[4] ./
	    end
	else if test $argv[2] = "fire"
	    if test (count $argv) = 4
		scp -i $key -P $port_tablet -r ./$argv[3] $host_tablet:~/$argv[4]
	    else if test (count $argv) = 3
		scp -i $key -P $port_tablet -r $host_tablet:~/$argv[3] ./
	    end
	end
    end
end

function access_lan
    switch $argv[1]
	case 1
	    for i in $option
		set option_string "-R" $i $option_string
	    end
	    ssh xin@$domain -p $port -i $key $option_string
	case 2
	    ssh xin@$domain -p $port -i $key
	case 3
	    ssh localhost -p 10022 -i $key
	case graphic
	    ssh -Y xin@$domain -p $port -i $key
	case *
	    print_string "input error."
    end
end
