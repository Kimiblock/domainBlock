function getList(){
	lines=$(cat sub.list | wc -l)
	lines=$(expr ${lines} + 2)
	l=1
	while [[ ${l} -lt ${lines} ]]; do
		url=$(cat sub.list | head -n ${l} | tail -n 1)
		l=$(expr ${l} + 1)
		echo "Downloading ${url}"
		curl \
			"${url}" \
			-o /tmp/domainBlock-${RANDOM}.txt \
			-L \
			--silent \
			--progress-bar \
			--show-error
	done
}

function getGeosite(){
	lines=$(cat geosite | wc -l)
	lines=$(expr ${lines} + 2)
	l=2
	while [[ ${l} -lt ${lines} ]]; do
		url=$(cat geosite | head -n ${l} | tail -n 1)
		l=$(expr ${l} + 1)
		echo "Downloading ${url}"
		curl "https://github.com/v2fly/domain-list-community/raw/master/data/${url}"\
			-o /tmp/domainBlock-${RANDOM}.geosite \
			-L \
			--silent \
			--progress-bar \
			--show-error
	done
	cat /tmp/domainBlock-*.geosite | grep -v "# " >/tmp/domainBlock-geosite.txt
}

function mergeList(){
	echo "[Info] Merging"
	cat /tmp/domainBlock-*.txt >/tmp/domainBlock.txt
	cat dnsRefuse.txt | grep -v "# " >>/tmp/domainBlock.txt
	awk '!seen[$0]++' /tmp/domainBlock.txt >domainBlock.txt
	rm /tmp/domainBlock*.txt
}

getList
getGeosite
mergeList