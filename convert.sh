#!/usr/bin/env bash

set -e

cd $(dirname "$0")

# NEORV32 home folder
#SOURCE_HOME=${NEORV32_RTL:-../neorv32}
# Additional sources (i.e. the top unit)
#SRC_FOLDER=${SRC_FOLDER:-.}
# Name of the top unit
#TOP=neorv32_verilog_wrapper

mkdir -p build
mkdir -p work
# show NEORV32 version
#echo "NEORV32 Version:"
#grep -rni $NEORV32_HOME/rtl/core/neorv32_package.vhd -e 'hw_version_c'
#echo ""
#sleep 2

# Import and analyze sources
*ghdl -i --std=08 --work= --workdir=build -Pbuild $NEORV32_HOME/rtl/core/*.vhd $SRC_FOLDER/$TOP.vhd
ghdl -i --std=08 --work=work --workdir=build -Pbuild ./*.vhd

#ghdl -m --std=08 --work=neorv32 --workdir=build $TOP
ghdl -m --std=08 --work=work --workdir=build $TOP
# Synthesize Verilog
ghdl synth --std=08 --work=neorv32 --workdir=build -Pbuild --out=verilog $TOP > $SRC_FOLDER/$TOP.v

# Show interface of generated Verilog module
echo ""
echo "-----------------------------------------------"
echo "Verilog instantiation prototype"
echo "-----------------------------------------------"
sed -n "/module $TOP/,/);/p" $SRC_FOLDER/$TOP.v
echo "-----------------------------------------------"
echo ""