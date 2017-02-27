
DIR=$(dirname "$0")

cd $DIR/..

# $(tput bold)$(tput setaf 3)>>> Publishing to surge.sh\e[0m

if [[ $(git status -s) ]]; then
	echo "    The working directory is dirty. Please commit any pending changes"
	exit 1
fi

echo "    Deleting old publication"
rm -rf public
mkdir public

echo "    Generating site"
hugo

echo "    Publishing to surge.sh"
surge ./public towry.me
