function getList(){
	lines=$(cat sub.list | wc -l)
	lines=$(expr ${lines} + 2)
	l=1
	while [[ ${l} -lt ${lines} ]]; do
		url=$(cat sub.list | head -n ${l} | tail -n 1)
		l=$(expr ${l} + 1)
		echo "Downloading ${url}"
		curl "${url}" -o /tmp/domainBlock-${RANDOM}.txt -L
	done
}

function mergeList(){
	cat /tmp/domainBlock-*.txt >/tmp/domainBlock.txt
	cat dnsRefuse.txt >>/tmp/domainBlock.txt
	awk '!seen[$0]++' /tmp/domainBlock.txt >domainBlock.txt
	rm /tmp/domainBlock*.txt
}

getList
mergeList