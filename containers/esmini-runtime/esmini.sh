#!/bin/sh 
set -e

bool() {
  # Assign the input string or default to "false"
  str="${1:-false}"
  
  # Use a case statement to match true-like values
  case "$str" in
    true|1|yes|on)
      echo "true"
      ;;
    *)
      echo "false"
      ;;
  esac
}

# Set environment variables
export ESMINI_HEADLESS="${ESMINI_HEADLESS:-"true"}"
export ESMINI_WINDOW="${ESMINI_WINDOW:-"false"}"
export ESMINI_WINDOW_XPOS="${ESMINI_WINDOW_XPOS:-0}"
export ESMINI_WINDOW_YPOS="${ESMINI_WINDOW_YPOS:-0}"
export ESMINI_WINDOW_WIDTH="${ESMINI_WINDOW_WIDTH:-800}"
export ESMINI_WINDOW_HEIGHT="${ESMINI_WINDOW_HEIGHT:-400}"
export ESMINI_OPEN_SCENARIO_FILE="${ESMINI_OPEN_SCENARIO_FILE:-/usr/local/share/esmini/resources/xosc/cut-in.xosc}"
export ESMINI_FIXED_TIMESTEP="${ESMINI_FIXED_TIMESTEP:-0.01}"
export ESMINI_LOGFILE_PATH="${ESMINI_LOGFILE_PATH:-/var/esmini/log.txt}"
export ESMINI_ENABLE_COLLISION_CHECK="${ESMINI_ENABLE_COLLISION_CHECK:-"true"}"
export ESMINI_DISABLE_LOG="${ESMINI_DISABLE_LOG:-"false"}"
export ESMINI_DISABLE_STDOUT="${ESMINI_DISABLE_STDOUT:-"true"}"
export ESMINI_OUTPUT_DIR="${ESMINI_OUTPUT_DIR:-/var/esmini/data}"
export ESMINI_SCENARIO_DIR="${ESMINI_SCENARIO_DIR:-/var/esmini/scenarios}"

esmini_args=""

if bool "${ESMINI_HEADLESS}"; then
  esmini_args="$esmini_args --headless"
fi

if bool "${ESMINI_WINDOW}"; then
  esmini_args="$esmini_args --window ${ESMINI_WINDOW_XPOS} ${ESMINI_WINDOW_YPOS} ${ESMINI_WINDOW_WIDTH} ${ESMINI_WINDOW_HEIGHT}"
fi

if bool "${ESMINI_DISABLE_STDOUT}"; then
  esmini_args="$esmini_args --disable_stdout"
fi

if bool "${ESMINI_DISABLE_LOG}"; then
  esmini_args="$esmini_args --disable_log"
elif [ "${ESMINI_LOGFILE_PATH}" ]; then
  mkdir -p "$(dirname "${ESMINI_LOGFILE_PATH}")"
  esmini_args="$esmini_args --logfile_path ${ESMINI_LOGFILE_PATH}"
fi

if bool "${ESMINI_ENABLE_COLLISION_CHECK}"; then
  esmini_args="$esmini_args --collision"
fi

if [ ! -d "${ESMINI_SCENARIO_DIR}" ]; then
  mkdir -p "${ESMINI_SCENARIO_DIR}"
fi

mkdir -p "${ESMINI_OUTPUT_DIR}"
find "${ESMINI_SCENARIO_DIR}" -maxdepth 1 -type f -name "*.xosc" | while read -r scenario; do
  echo "Running scenario: $scenario"
  esmini \
    --headless \
    --fixed_timestep "${ESMINI_FIXED_TIMESTEP}" \
    --osc "$scenario" \
    --record "${ESMINI_OUTPUT_DIR}"/"$(basename "$scenario" .xosc)".dat \
    --osi_file "${ESMINI_OUTPUT_DIR}"/"$(basename "$scenario" .xosc)".osi \
    --disable_stdout \
    --disable_log \
    ;
done
