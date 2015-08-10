#!/bin/bash

pushd blog/
racket make-page-tree.rkt
raco pollen render index.ptree
popd
raco pollen render
raco pollen publish ./ ../build
