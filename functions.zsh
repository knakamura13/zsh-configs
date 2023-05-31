# Docker functions
clean() {
	docker kill $(docker ps -q)&>/dev/null;
	docker rmi $(docker images -a -q);
}

# Git functions
rm-branch() {
	git push --delete origin $1; 
	git branch -D $1;
	echo "Deleted branch '$1' from origin and local repos.";
}

rm-tag() {
	git push origin: $1;
	git tag --delete $1;
	echo "Deleted tag '$1' from origin and local repos.";
}

# Web dev functions
ng-component() {
	vared -cp 'Component name: ' name;
	ng g m components/$name && ng g c components/$name;
}

# Utility functions
trim-snapshots() {
	for snapshot in $(tmutil listlocalsnapshotdates | grep -v :); do sudo tmutil deletelocalsnapshots $snapshot; done;
}

clean-files() {
	# Delete files ending with " 2".
	fd -H --glob "* 2*" -X rm -rf;

	# Delete DS_Store files.
	fd -H '^\.DS_Store$' -tf -X rm;
}

my-find() {
	find $1 -type $2 -name "$3" 2>&1 | grep -v "find: ";
}

fix-ssh() {
	ssh-copy-id $1 && ssh $1;
}

search() {
	if [ -z "$1" ]; then
		# First parameter is not set.
		echo "search: no search term provided";
		return;
	elif [ "$1" = "-h" ]; then
		# First parameter is --help or -h.
		echo "usage: search \"{grep search term}\" {directory}";
		return;
	fi

	if [ -z "$2" ]; then
		# Second parameter is not set.
		dir=$PWD;
	else
		# Assign the value of the second parameter to a variable.
		dir=$2;
	fi

	echo "Searching for instances of \"$1\" in: $dir";

	# Remove mode: automatic wrapping.
	tput rmam;

	# Perform a grep search recursively in the provided directory.
	grep -R --exclude=\*.{jar,map} --exclude-dir={.git,cas,vendor,logs} "$1" $dir | sed -e "s!$dir!!" | grep "$1";

	# Set mode: automatic wrapping.
	tput smam;
}
