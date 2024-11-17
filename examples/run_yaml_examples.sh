#!/usr/bin/env bash

argo submit -n default --watch examples/yaml/hello.yaml

argo submit -n default --watch examples/yaml/dag.yaml

argo submit -n default --watch examples/yaml/artifact-passing.yaml
