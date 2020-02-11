DOCKER_NETWORK = hbase
ENV_FILE = hadoop.env
# current_branch := $(shell git rev-parse --abbrev-ref HEAD)
current_branch := 2.2.3-hadoop3.2.1-java8
build:
	docker build -t myy92715/hbase-base:$(current_branch) ./base
	docker build -t myy92715/hbase-master:$(current_branch) ./hmaster
	docker build -t myy92715/hbase-regionserver:$(current_branch) ./hregionserver
	docker build -t myy92715/hbase-standalone:$(current_branch) ./standalone
push:
	docker push -t myy92715/hbase-base:$(current_branch)
	docker push -t myy92715/hbase-master:$(current_branch)
	docker push -t myy92715/hbase-regionserver:$(current_branch)
	docker push -t myy92715/hbase-standalone:$(current_branch)
pull:
	docker pull -t myy92715/hbase-base:$(current_branch)
	docker pull -t myy92715/hbase-master:$(current_branch)
	docker pull -t myy92715/hbase-regionserver:$(current_branch)
	docker pull -t myy92715/hbase-standalone:$(current_branch)
wordcount:
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} myy92715/hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} myy92715/hadoop-base:$(current_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-2.7.4/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} myy92715/hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} myy92715/hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} myy92715/hadoop-base:$(current_branch) hdfs dfs -rm -r /input
