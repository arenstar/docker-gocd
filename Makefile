server:
	cd gocd-server; docker build -t arenstar/gocd-server .
agent:
	cd gocd-agent; docker build -t arenstar/gocd-agent .

gocd:
	docker-compose -f ./docker-compose.gocd.yml -p gocd up -d
gocd-down:
	docker-compose -f ./docker-compose.gocd.yml -p gocd down

setup:
	rm -rf /opt/gocd/* /opt/gocd/.netrc
	mkdir -p /opt/gocd/sudoers.d
	echo "machine bitbucket.org login ci password 1234567890" > /opt/gocd/.netrc
	echo 'go ALL=(ALL) NOPASSWD:ALL' > /opt/gocd/sudoers.d/gocd-sudo-escalation
	echo 'admin:{SHA}W6ph5Mm5Pz8GgiULbPgzG37mj9g=' > /opt/gocd/htpasswd
	ssh-keygen -q -t rsa -C "gocd" -N "" -f id_rsa
	cat id_rsa.pub > /opt/gocd/authorized_keys && chmod 600 /opt/gocd/authorized_keys
	cp id_rsa*  /opt/gocd/. && rm id_rsa*
	cp go_notify.conf /opt/gocd/go_notify.conf

install:
	apt-get update
	apt-get -y install
	echo 'Defaults    env_keep+=SSH_AUTH_SOCK' > /etc/sudoers.d/ssh_auth_sock
	curl -sSL https://get.docker.com/ | sh
	curl -sSL "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-Linux-x86_64" > /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
