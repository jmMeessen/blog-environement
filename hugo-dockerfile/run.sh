#!/usr/bin/env sh

WATCH="${HUGO_WATCH:=false}"
SLEEP="${HUGO_REFRESH_TIME:=-1}"
BUILD_DRAFTS="${HUGO_BUILD_DRAFTS:=false}"
echo "HUGO_WATCH:" $WATCH
echo "HUGO_REFRESH_TIME:" $HUGO_REFRESH_TIME
echo "HUGO_THEME:" $HUGO_THEME
echo "HUGO_BASEURL" $HUGO_BASEURL

if [[ $BUILD_DRAFTS != 'false' ]]; then
   draft_cmd="--buildDrafts"
else
   draft_cmd=""
fi


HUGO=/usr/bin/hugo

rm -rf /src/*
rm -rf /src/.git
rm -rf /src/.gitignore
git clone https://github.com/jmMeessen/blog-the-captains-shack.git /src
if [ -z ${WORK_BRANCH+x} ]; then 
   echo "processing master branch"; 
else 
   echo "Processing the '$WORK_BRANCH' branch";
   git -C /src checkout --track origin/${WORK_BRANCH}
fi



while [ true ]
do
    if [[ $HUGO_WATCH != 'false' ]]; then
	echo "Watching..."
        git -C /src pull	
        $HUGO server --watch=true ${draft_cmd} --source="/src" --theme="$HUGO_THEME" --destination="/output" --baseUrl="$HUGO_BASEURL" || exit 1
    else
	echo "Building one time..."
        git -C /src pull
        $HUGO ${draft_cmd} --source="/src" --theme="$HUGO_THEME" --destination="/output" --baseUrl="$HUGO_BASEURL" || exit 1
    fi

    if [[ $HUGO_REFRESH_TIME == -1 ]]; then
        exit 0
    fi
    echo "Sleeping for $HUGO_REFRESH_TIME seconds..."
    sleep $SLEEP
done

