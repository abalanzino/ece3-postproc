#!/bin/bash

# Getting list of available confs:
#list_confs=`\ls ../conf_*.bash | sed -e "s|../conf_||g" -e "s|.bash||g"`

usage()
{
    echo
    echo "USAGE: ${0} -C <MY_SETUP> -R <run_name,ctrl_run_name> -P <year1-year2,year1-year2>"
    echo
    echo "              * <MY_SETUP>         => configuration settings"
    echo "                                    file ../../conf_<MY_SETUP>.bash must be here"
    echo "                          List of available MY_SETUP is:"
    echo "${list_confs}"
    echo
    #echo "   OPTIONS:"
    #echo "      -y <YYYY>    => force initial year to YYYY"
    #echo "      -f           => forces a clean start for diags"
    #echo "                      (restart everything from scratch...)"
    #echo "      -e           => create the HTML diagnostics page on local or remote server"
    #echo "      -h           => print this message"
    #echo
    exit
}

MY_SETUP=""
LRUN=""
LPERIOD=""

while getopts C:R:P: option ; do
    case $option in
        C) export MY_SETUP=${OPTARG};;
        R) export LRUN=${OPTARG};;
        P) export LPERIOD=${OPTARG};;
        h)  usage;;
        \?) usage ;;
    esac
done


if [ "${MY_SETUP}" = "" -o "${LRUN}" = "" -o "${LPERIOD}" = "" ]; then usage ; fi

#fconfig="../conf_${MY_SETUP}.bash"
fconfig="$ECE3_POSTPROC_TOPDIR/conf/$ECE3_POSTPROC_MACHINE/conf_amwg_${ECE3_POSTPROC_MACHINE}.sh"
if [ ! -f ${fconfig} ]; then echo " ERROR: no configuration file found: ${fconfig}"; exit; fi
. ${fconfig}

echo "LRUN is ${LRUN}"
echo "LPERIOD is ${LPERIOD}"

export TEST_RUN=`echo ${LRUN} | cut -d , -f1`
export CNTL_RUN=`echo ${LRUN} | cut -d , -f2`

export TEST_PERIOD=`echo ${LPERIOD} | cut -d , -f1`
export CNTL_PERIOD=`echo ${LPERIOD} | cut -d , -f2`

echo "test run is ${TEST_RUN}"
echo "EMOP_CLIM_DIR is  ${EMOP_CLIM_DIR}"
export EMOP_CLIM_DIR=`echo ${EMOP_CLIM_DIR} | sed -e "s|<RUN>|${TEST_RUN}|g"`


# This was a wrapper to call the actual csh file:
csh ./csh/diag_mod_vs_mod.csh

