FROM neo4j:3.0.3
MAINTAINER Martin Peters

# install patch command
RUN apt-get update && apt-get install -y --no-install-recommends patch

# create directories
RUN (test -d /var/lib/neo4j/lib/masymos || mkdir -p /var/lib/neo4j/lib/masymos) ; \
    (test -d /var/owl || mkdir -p /var/owl) 

# copy all required libs
# The dependency export from diff-rest is used here, because it also includes all
# dependencies from e.g. masymos-core
COPY src/masymos-diff-rest/target/lib/*.jar lib/masymos/
RUN chmod +x /var/lib/neo4j/lib/masymos/*.jar

# copy REST interface plugins
COPY src/masymos-morre/target/masymos-morre-*.jar src/masymos-diff-rest/target/masymos-diff-ws-*.jar plugins/

# copy the masymos-cli fat jar
COPY src/masymos-cli/target/masymos-cli-*.jar ./
RUN mv masymos-cli-*.jar masymos-cli.jar

# patch config files
COPY patches/*.patch ./
RUN patch conf/neo4j.conf neo4j.conf.patch && \
    patch conf/neo4j-wrapper.conf neo4j-wrapper.conf.patch && \
    patch bin/neo4j-shared.sh neo4j-shared.sh.patch

# add the owl files to /var/owl
COPY owl/GO/go.owl owl/COMODI/ontology/comodi.owl owl/KiSAO/kisao.owl owl/ChEBI/chebi_core.owl owl/SBO/SBO_OWL.owl /var/owl/

# add the run script
COPY scripts/run_masymos.sh /run_masymos.sh
CMD "/run_masymos.sh"
