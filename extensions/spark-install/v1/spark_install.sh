mkdir bin
curl -O https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.8/dcos
chmod +x dcos
mv dcos bin/
dcos config set core.dcos_url http://localhost
dcos package install spark