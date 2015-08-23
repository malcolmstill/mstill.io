#!/bin/bash

raco pollen render style.css.pp
raco pollen render index.html
pushd blog/
racket make-page-tree.rkt
raco pollen render index.ptree
popd
raco pollen publish ./ ../build
