#!/bin/sh
# Use this script to download .deb packages listed in <file>
# 1️⃣️ in the original directory structure (e.g., pool/main/...) or
# 2️⃣️ all .deb packages in the current working directory using parallel downloading

get_usage()
{
	echo ""
	echo "Usage:"
	echo " $0 [option] <FILE>..."
	echo ""
	echo "Description:"
	echo "  Tool for downloading .deb packages from official ubuntu repository"
	echo "  where packages are listed in FILE with complete .deb url"
	echo "  (e.g., https://archive.ubuntu.com/ubuntu/pool/<sub directory of package>.deb)"
	echo "  Note:- Make sure each .deb package listed in a new line in the file"
	echo "Options:"
	printf " %-2s %-14s %-12s\n" "-p," "--pool" "download .deb in official repo like structure(e.g., pool/main/..) (Default)"
	printf " %-2s %-14s %-12s\n" "-f," "--parallel" "download multiple .deb packages simultaneously for fast downloading"
}

pool_download()
{
	echo "👉️ Downloading packages in official repository like directory structure..."
	echo -n "💢️ Starting 3.."
	sleep 1
	echo -n "2.."
	sleep 1
	echo -n "1.."
	sleep 1
	echo ""
	#tmp_dir=$(mktemp -d -p ./ -t XXXXX)
	wget --continue --input-file=$input_file --cut-dirs=0 --directory-prefix=$tmp_dir -nH -x -N
	echo "✅️ 💯️Done..."
	echo "🐦️ Check '$PWD/ubuntu/' directory..."
	echo ""
}

parallel_download()
{
	echo "👉️ Downloading multiple packages simultaneously, keeping all in single directory..."
	echo -n "💢️ Starting 3.."
	sleep 1
	echo -n "2.."
	sleep 1
	echo -n "1.."
	sleep 1
	echo ""
	tmp_dir="ubuntu"
	#tmp_dir=$(mktemp -d -p ./ -t XXXXX)
	aria2c -x 16 -j 4 -i $input_file --dir=$tmp_dir
	echo ""
	echo "✅️ 💯️Done..."
	echo "🐦️ Check '$PWD/$tmp_dir/' directory..."
	echo ""
}

case $# in
	1)
		input_file=$1
		pool_download
		;;
	2)
		if test  $1 = "-p" -o $1 = "--pool"
		then
			input_file=$2
			pool_download
		elif test  $1 = "-f" -o $1 = "--parallel"
		then
			input_file=$2
			parallel_download
		else
			get_usage
		fi
		;;
	*)
		get_usage
		;;
esac
exit 0
