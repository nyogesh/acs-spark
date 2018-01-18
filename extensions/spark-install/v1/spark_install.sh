set -e

echo $(date) " - Starting Script"

TARGETDIR=/home/core
PAYLOAD=spark_deploy.json

mkdir -p $TARGETDIR
cd $TARGETDIR

echo $(date) " - Generate marathon payload"

cat >$TARGETDIR/$PAYLOAD <<EOF
{
  "id": "/spark",
  "connected": true,
  "recovered": false,
  "TASK_UNREACHABLE": 0,
  "cmd": "/sbin/init.sh",
  "user": "nobody",
  "instances": 1,
  "cpus": 1,
  "mem": 1024,
  "disk": 0,
  "gpus": 0,
  "fetch": [
    {
      "uri": "file:///home/core/docker.tar.gz",
      "extract": true,
      "executable": false,
      "cache": false
    }
  ],
  "backoffSeconds": 1,
  "backoffFactor": 1.15,
  "maxLaunchDelaySeconds": 3600,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "mesosphere/spark:2.1.0-2.2.0-1-hadoop-2.6",
      "network": "HOST",
      "privileged": false,
      "parameters": [
        {
          "key": "user",
          "value": "nobody"
        }
      ],
      "forcePullImage": true
    }
  },
  "healthChecks": [
    {
      "gracePeriodSeconds": 5,
      "intervalSeconds": 60,
      "timeoutSeconds": 10,
      "maxConsecutiveFailures": 3,
      "portIndex": 2,
      "path": "/",
      "protocol": "HTTP",
      "ignoreHttp1xx": false
    }
  ],
  "upgradeStrategy": {
    "minimumHealthCapacity": 1,
    "maximumOverCapacity": 1
  },
  "unreachableStrategy": {
    "inactiveAfterSeconds": 300,
    "expungeAfterSeconds": 600
  },
  "killSelection": "YOUNGEST_FIRST",
  "portDefinitions": [
    {
      "port": 10000,
      "protocol": "tcp"
    },
    {
      "port": 10001,
      "protocol": "tcp"
    },
    {
      "port": 10002,
      "protocol": "tcp"
    }
  ],
  "requirePorts": true,
  "labels": {
    "DCOS_PACKAGE_RELEASE": "30",
    "DCOS_SERVICE_SCHEME": "http",
    "DCOS_PACKAGE_SOURCE": "https://universe.mesosphere.com/repo",
    "DCOS_SERVICE_NAME": "spark",
    "DCOS_PACKAGE_FRAMEWORK_NAME": "spark",
    "DCOS_SERVICE_PORT_INDEX": "2",
    "DCOS_PACKAGE_VERSION": "2.1.0-2.2.0-1",
    "DCOS_PACKAGE_NAME": "spark",
    "DCOS_PACKAGE_IS_FRAMEWORK": "false"
  },
  "env": {
    "DCOS_SERVICE_NAME": "spark",
    "NO_BOOTSTRAP": "true",
    "SPARK_DISPATCHER_MESOS_ROLE": "*",
    "SPARK_USER": "nobody",
    "SPARK_LOG_LEVEL": "INFO"
  }
}
EOF

curl -X POST http://localhost:8080/v2/apps -d @$TARGETDIR/$PAYLOAD -H "Content-type:application/json"

echo $(date) " - Clean up"

rm -rf $TARGETDIR/$PAYLOAD

echo $(date) " - Finished Script"

