#!/bin/bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

ROOT=${ROOT:-`pwd`}
BUILD_COMMON="${BUILD_COMMON:-true}"
SKIP_TESTS="${SKIP_TESTS:-false}"

function clean() {
    rm -rf ~/.m2/repository/com/example/
    rm -rf ~/.gradle/caches/modules-2/files-2.1/com.example/
}

function build_maven() {
    if [[ "${BUILD_COMMON}" == "true" ]]; then
        echo -e "\n\nInstalling common\n\n"
        cd ${ROOT}/common
        ./mvnw clean install -U
    fi
    cd ${ROOT}

    echo -e "\n\nBuilding everything\n\n"
    if [[ "${SKIP_TESTS}" == "true" ]]; then
        ./mvnw clean install -Ptest -U -DskipTests
    else
        ./mvnw clean install -Ptest -U
    fi
}

cat <<'EOF'
 .----------------.  .----------------.  .----------------.  .----------------.  .-----------------.
| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
| | ____    ____ | || |      __      | || | ____   ____  | || |  _________   | || | ____  _____  | |
| ||_   \  /   _|| || |     /  \     | || ||_  _| |_  _| | || | |_   ___  |  | || ||_   \|_   _| | |
| |  |   \/   |  | || |    / /\ \    | || |  \ \   / /   | || |   | |_  \_|  | || |  |   \ | |   | |
| |  | |\  /| |  | || |   / ____ \   | || |   \ \ / /    | || |   |  _|  _   | || |  | |\ \| |   | |
| | _| |_\/_| |_ | || | _/ /    \ \_ | || |    \ ' /     | || |  _| |___/ |  | || | _| |_\   |_  | |
| ||_____||_____|| || ||____|  |____|| || |     \_/      | || | |_________|  | || ||_____|\____| | |
| |              | || |              | || |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
 '----------------'  '----------------'  '----------------'  '----------------'  '----------------'
EOF

build_maven
