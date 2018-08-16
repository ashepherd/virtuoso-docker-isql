Scripts to Bulk Load RDF files into Virtuoso

# vload #

```docker exec -it virtuoso bash -c "cd /scripts && ./vload rdf VAD dataset-20180816.rdf http://test-vad /logs <pswd>"```

# vdelete #

``` docker exec -it virtuoso bash -c "cd /scripts && ./vdelete http://test-vad /logs osprey"```
