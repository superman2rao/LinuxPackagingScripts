#!/bin/bash

##This script file will first download dists directory and its subdirectory allowed by --accept-regex and --reject-regex and then fetch it package path and than download .deb packages in pool directory with original like directory structure
#To downloads dists directory content in original like repo run below
wget --recursive --no-parent -nH \
	--cut-dirs=1 --reject="index.html*" --accept="*.gz,*.xz" \
	--accept-regex='.*(binary-amd64)/.*' --reject-regex='.*(binary-amd64)/by-hash' \
	http://archive.ubuntu.com/ubuntu/dists/{noble,noble-updates}/{main,restricted,universe,multiverse}/{binary-amd64,binary-i386,cnf,dep11,i18n}



##if you want to download other files/directories such as cnf, dep11, i18n modify accordingly Example command given below
#wget --recursive --no-parent -nH \
#	--cut-dirs=1 --reject="index.html*" --accept="*.gz,*.xz" \
#	--accept-regex='.*(cnf|binary-amd64|i18n|dep11)/.*' --reject-regex='.*(cnf|binary-amd64|i18n|dep11)/by-hash' \
#	http://archive.ubuntu.com/ubuntu/dists/{noble,noble-updates,noble-backports}/{main,restricted,universe,multiverse}/{binary-amd64,cnf,dep11,i18n}


CWD=$(pwd)
UBUNTU_MIRROR="http://archive.ubuntu.com/ubuntu"
TMPFILENAME="all-deb-urls.txt"
TOTALREPOSIZE=0
truncate -s 0 $TMPFILENAME

while IFS= read -r -d '' file; do
	COUNT=0
	PACKAGEFPATH=$file
	for i in `zcat "$PACKAGEFPATH" | grep  -e "^Size:" | awk {'print $2'}`; do COUNT=$(($COUNT+$i)); done
	echo "Processing file: $PACKAGEFPATH (Download Size: $COUNT)"
	TOTALREPOSIZE=$(($TOTALREPOSIZE+$COUNT))
	zcat "$PACKAGEFPATH" | grep "^Filename: " | awk -v mirror="$UBUNTU_MIRROR" '{print mirror "/" $2}' >> $TMPFILENAME
done < <(find dists/ -type f -name "*.gz" -print0)

echo "Total Download Size: $TOTALREPOSIZE"

#📦 Final Directory Structure
#If you want to download and replicate the original directory structure (e.g., pool/main/...), 
#use below command to download :

wget --continue --input-file=$TMPFILENAME --cut-dirs=1 -nH -x

#To download in parallel, use aria2c, it will not make original like directory structure:

#aria2c -x 16 -j 4 -i $TMPFILENAME