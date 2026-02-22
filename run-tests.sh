#!/bin/bash

# Stop on first error
set -e

ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

soup run ../soup/code/generate-test/ -args $ROOT_DIR/code/run-tests.wren $ROOT_DIR/out/Wren/Local/Wren/0.5.4/J_HqSstV55vlb-x6RWC_hLRFRDU/script/bundles.sml