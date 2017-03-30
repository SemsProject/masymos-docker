#!/bin/bash
# run script to start the masymos server

import_owl() {
    name="${1}"
    file="${2}"

    java -cp masymos-cli.jar de.unirostock.sems.masymos.main.MainExtractor -dbPath /data/databases/graph.db -type owl -ontology $name -directory $file
}

# first check if owl import was already performend
if [ ! -f "/data/.owl-imported" ]; then
    # ontologies were not imported yet
    echo "Importing ontologies into MaSyMoS..."
    echo "This may take a while"

    import_owl ComodiOntology /var/owl/comodi.owl
    import_owl ChebiOntology /var/owl/chebi_core.owl
    import_owl GOOntology /var/owl/go.owl
    import_owl KISAOOntology /var/owl/kisao.owl
    import_owl SBOOntology /var/owl/SBO_OWL.owl

    touch "/data/.owl-imported"
fi

# run the original neo4j entrypoint to start neo4j
/docker-entrypoint.sh neo4j 
