server:
	cd gocd-server; docker build -t arenstar/gocd-server .
agent:
	cd gocd-agent; docker build -t arenstar/gocd-agent .
