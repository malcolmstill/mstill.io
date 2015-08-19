#!/bin/bash

raco pollen render
pushd blog/
racket make-page-tree.rkt
raco pollen render index.ptree
popd
raco pollen publish ./ ../build
