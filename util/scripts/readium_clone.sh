#!/bin/sh
#---------------------------------------------------
# This script is configured to clone each of the five 
# main Readium repos and their submodules
# It sets each repo and submodule to the $BRANCH branch
# At completion it fetches the git hash for each submodule
# @rkwright, February 2015
#---------------------------------------------------
# make sure the supplied a version
red='\033[1;31m'
green='\033[0;32m'
NC='\033[00m' # no color
if [ $# -eq 0 ]
  then
    echo "${red}No branch tag supplied!  Exiting...${NC}"
    echo "Usage: ./readium_clone.sh <branch> [<repo-suffix>]"
    exit 1
fi

# save the argument - the branch name
BRANCH=$1
echo "${green}Cloning from branch '$BRANCH' in each repo.${NC}"

SUFFIX=''
if [ $# -eq  2 ]
  then
    SUFFIX=$2
    echo "${green}Appending sufffix '$SUFFIX' onto each app repo folder.${NC}"
fi

# save the original folder
ROOT_PWD=$(pwd)
echo "${green}Root folder = $ROOT_PWD${NC}" 

# first get rid of the old repos, if any
rm -rf readium-js-viewer$SUFFIX
rm -rf SDKLauncher-Android$SUFFIX
rm -rf SDKLauncher-iOS$SUFFIX
rm -rf SDKLauncher-OSX$SUFFIX
# rm -rf SDKLauncher-Windows$SUFFIX

# now clone each repo then ensure the submodules are on the $BRANCH requested
# Note: git flow init won't work if the master branch doesn't exist locally so
# we have to clone the master then switch to $BRANCH rather than cloning directly 
# into only $BRANCH

git clone --recursive https://github.com/readium/readium-js-viewer.git readium-js-viewer$SUFFIX
cd readium-js-viewer$SUFFIX
pwd
git checkout $BRANCH
cd readium-js
pwd
git checkout $BRANCH
cd epub-modules/epub-renderer/src/readium-shared-js
pwd
git checkout $BRANCH

cd $ROOT_PWD
git clone --recursive https://github.com/readium/SDKLauncher-Android.git SDKLauncher-Android$SUFFIX 
cd SDKLauncher-Android$SUFFIX
pwd
git checkout $BRANCH
cd readium-sdk
pwd
git checkout $BRANCH
cd ../readium-shared-js
pwd
git checkout $BRANCH

cd $ROOT_PWD
git clone --recursive https://github.com/readium/SDKLauncher-iOS.git  SDKLauncher-iOS$SUFFIX
cd SDKLauncher-iOS$SUFFIX
pwd
git checkout $BRANCH
cd readium-sdk
pwd
git checkout $BRANCH
cd ../Resources/readium-shared-js
pwd
git checkout $BRANCH

cd $ROOT_PWD
git clone --recursive https://github.com/readium/SDKLauncher-OSX.git SDKLauncher-OSX$SUFFIX
cd SDKLauncher-OSX$SUFFIX
pwd
git checkout $BRANCH
cd readium-sdk
pwd
git checkout $BRANCH
cd ../readium-shared-js
pwd
git checkout $BRANCH

# cd $ROOT_PWD
# git clone --recursive https://github.com/readium/SDKLauncher-Windows.git SDKLauncher-Windows$SUFFIX
# cd SDKLauncher-Windows$SUFFIX
# pwd
# git checkout $BRANCH
# cd readium-sdk
# pwd
# git checkout $BRANCH
# cd ../readium-shared-js
# pwd
# git checkout $BRANCH

# Now verify that the commit hashes are the same for each submodule
echo "${green}Comparing shared-js submodules${NC}"
cd $ROOT_PWD/readium-js-viewer$SUFFIX/readium-js/epub-modules/epub-renderer/src/readium-shared-js
pwd
git log -n 1 --pretty=format:"%H" $BRANCH

cd $ROOT_PWD/SDKLauncher-Android$SUFFIX/readium-shared-js
pwd
git log -n 1 --pretty=format:"%H" $BRANCH

cd $ROOT_PWD/SDKLauncher-iOS$SUFFIX/Resources/readium-shared-js
pwd
git log -n 1 --pretty=format:"%H" $BRANCH

cd $ROOT_PWD/SDKLauncher-OSX$SUFFIX/readium-shared-js
pwd
git log -n 1 --pretty=format:"%H" $BRANCH

# cd $ROOT_PWD/SDKLauncher-Windows$SUFFIX/readium-shared-js
# pwd
# git log -n 1 --pretty=format:"%H" $BRANCH

echo "${green}Comparing readium-sdk submodules${NC}"
cd $ROOT_PWD/SDKLauncher-Android$SUFFIX/readium-sdk
pwd
git log -n 1 --pretty=format:"%H" $BRANCH

cd $ROOT_PWD/SDKLauncher-iOS$SUFFIX/readium-sdk
pwd
git log -n 1 --pretty=format:"%H" $BRANCH

cd $ROOT_PWD/SDKLauncher-OSX$SUFFIX/readium-sdk
pwd
git log -n 1 --pretty=format:"%H" $BRANCH

# cd $ROOT_PWD/SDKLauncher-Windows$SUFFIX/readium-sdk
# pwd
# git log -n 1 --pretty=format:"%H" $BRANCH
