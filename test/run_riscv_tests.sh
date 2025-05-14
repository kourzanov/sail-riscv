#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
RISCVDIR="$DIR/.."

RED='\033[0;91m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
NC='\033[0m'

rm -f $DIR/tests.xml

pass=0
fail=0
all_pass=0
all_fail=0
SUITE_XML=""
SUITES_XML=""

function green {
    (( pass += 1 ))
    printf "$1: ${GREEN}$2${NC}\n"
    SUITE_XML+="    <testcase name=\"$1\"/>\n"
}

function yellow {
    (( fail += 1 ))
    printf "$1: ${YELLOW}$2${NC}\n"
    SUITE_XML+="    <testcase name=\"$1\">\n      <failure message=\"$2\">$2</failure>\n    </testcase>\n"
}

function red {
    (( fail += 1 ))
    printf "$1: ${RED}$2${NC}\n"
    SUITE_XML+="    <testcase name=\"$1\">\n      <failure message=\"$2\">$2</failure>\n    </testcase>\n"
}

function finish_suite {
    printf "$1: Passed ${pass} out of $(( pass + fail ))\n\n"
    SUITES_XML+="  <testsuite name=\"$1\" tests=\"$(( pass + fail ))\" failures=\"${fail}\" timestamp=\"$(date)\">\n$SUITE_XML  </testsuite>\n"
    SUITE_XML=""
    (( all_pass += pass )) || :
    (( all_fail += fail )) || :
    pass=0
    fail=0
}

SAILLIBDIR="$DIR/../../lib/"

tt=$1
[[ -z $tt ]] && tt=ui-p
var=$2
cd $RISCVDIR

# Do 'make clean' to avoid cross-arch pollution.
#make clean

#if make c_emulator/riscv_sim_RV64;
#then
#    green "Building 64-bit RISCV C emulator" "ok"
#else
#    red "Building 64-bit RISCV C emulator" "fail"
#fi

for test in $DIR/riscv-tests/rv64$tt-*; do
    [[ -d $test || ${test%%.dump} != $test || ${test%%.cout} != $test  || ${test%%.out} != $test ]] && continue

    if [[ "$var" == "fulldyn" && ${tt##um} != $tt ]]; then
      extra="-Dm -L./c_emulator"
    fi

    if timeout 60 $RISCVDIR/c_emulator/riscv_sim_RV64${var:+.$var} $extra -p $test > ${test%.elf}${var:+.$var}.cout 2>&1 && grep -q SUCCESS ${test%.elf}${var:+.$var}.cout;
    then
      green "C-64${var:+ $var}${extra:+ $extra} $(basename $test)" "ok"
    else
      red "C-64${var:+ $var}${extra:+ $extra} $(basename $test)" "fail"
    fi
done
finish_suite "64-bit RISCV C tests"


printf "Passed ${all_pass} out of $(( all_pass + all_fail ))\n\n"
XML="<testsuites tests=\"$(( all_pass + all_fail ))\" failures=\"${all_fail}\">\n$SUITES_XML</testsuites>\n"
printf "$XML" > $DIR/tests.xml

if [ $all_fail -gt 0 ]
then
    exit 1
fi
