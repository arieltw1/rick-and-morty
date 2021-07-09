#!/bin/bash

major='1.'
revision=$(git rev-parse HEAD | head -c7)
date=$(date "+%d%m%Y")

version=$major$date'-'$revision
echo $version
