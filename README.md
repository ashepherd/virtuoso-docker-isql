Scripts to Bulk Load RDF files into Virtuoso

Virtuoso Image: tenforce/virtuoso

## Sample docker-compose ##

```
version: '3'
services:
  virtuoso:
    container_name: virtuoso
    image: tenforce/virtuoso:latest
    volumes:
      - ./data:/data
      - ./scripts:/scripts
      - ./logs:/logs
    ports:
      - 8890:8890
    environment:
      DBA_PASSWORD: "<dba_pswd>"
```
 
## vload ##

Usage: vload [virtuososo_allowed_directory] [data_file] [graph_uri] [log_directory] [virtuoso_dba_password]

```docker exec -it virtuoso bash -c "cd /scripts && ./vload VAD dataset.rdf http://test-vad /logs <dba_pswd>"```

The command above assumes:

1. this script repository is mounted into the container at: ```/scripts```
2. the directory 'VAD' is located in the container's '/data' directory
3. the 'dataset.rdf' file is located in '/data/VAD' directory
4. there is a '/logs' directory in the container for creating the log files

## vdelete ##

``` docker exec -it virtuoso bash -c "cd /scripts && ./vdelete http://test-vad /logs <dba_pswd>"```
