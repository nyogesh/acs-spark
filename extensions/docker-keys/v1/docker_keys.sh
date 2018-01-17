set -e

echo $(date) " - Starting Script"

REPO=$1
AUTH=$2

echo $(date) " - REPO: $REPO | AUTH: $AUTH"

TARGETDIR=/home/core
DOCKERDIR=.docker
mkdir -p $TARGETDIR/$DOCKERDIR

echo $(date) " - Generating the docker config.json"

cat >$TARGETDIR/$DOCKERDIR/config.json <<EOF

{
        "auths": {
                "$REPO": {
                        "auth": "$AUTH"
                }
        }
}
EOF

echo $(date) " - Generated the docker config.json"

cd $TARGETDIR

echo $(date) " - Generated the docker config.json"

tar -cvf docker.tar.gz $DOCKERDIR

echo $(date) " - Cleaning up"

rm -rf $DOCKERDIR

echo $(date) " - Finished Script"
