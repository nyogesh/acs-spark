set -e

echo $(date) " - Starting Script"

export PATH=/home/ynataraj/bin:$PATH
mkdir /home/ynataraj/bin
cd /home/ynataraj/bin

echo $(date) " - Downloading dcos cli"
curl -O https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.8/dcos
chmod +x dcos

echo $(date) " - Set dcos url to localhost"
dcos config set core.dcos_url http://localhost

echo $(date) " - Install spark"
dcos package install spark

echo $(date) " - Finished Script"

