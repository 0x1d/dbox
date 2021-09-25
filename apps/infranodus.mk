NEO4J_APOC_VERSION=3.5.0.4
APP_PATH=~/.shroud/infranodus
SRC_PATH=${APP_PATH}/src
PLUGINS_PATH=${APP_PATH}/plugins
GIT_REPO=https://github.com/0x1d/infranodus.git
GIT_BRANCH=rehydrate

plugins: ${PLUGINS_PATH}/apoc-${NEO4J_APOC_VERSION}-all.jar

init: 
	git clone --single-branch --branch ${GIT_BRANCH} ${GIT_REPO} ${SRC_PATH}

${PLUGINS_PATH}/apoc-${NEO4J_APOC_VERSION}-all.jar:
	@mkdir -p ${PLUGINS_PATH}
	wget --quiet --directory-prefix=${PLUGINS_PATH}/ \
		https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/${NEO4J_APOC_VERSION}/apoc-${NEO4J_APOC_VERSION}-all.jar
