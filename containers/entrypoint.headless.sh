#!/bin/sh -ex

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
export ESMINI_HEADLESS="${ESMINI_HEADLESS:-true}"
export ESMINI_OPEN_SCENARIO_FILE="${ESMINI_OPEN_SCENARIO_FILE:-/usr/local/share/esmini/resources/xosc/cut-in.xosc}"
export ESMINI_FIXED_TIMESTEP="${ESMINI_FIXED_TIMESTEP:-0.01}"
export ESMINI_RECORD_OSI_FILE="${ESMINI_RECORD_OSI_FILE:-simdata.osi}"
export ESMINI_LOGFILE_PATH="${ESMINI_LOGFILE_PATH:-/var/esmini/log.txt}"
export ESMINI_ENABLE_COLLISION_CHECK="${ESMINI_ENABLE_COLLISION_CHECK:-"true"}"
export ESMINI_DISABLE_LOG="${ESMINI_DISABLE_LOG:-"false"}"
export ESMINI_DISABLE_STDOUT="${ESMINI_DISABLE_STDOUT:-"true"}"

esmini_args=""

if bool "${ESMINI_HEADLESS}"; then
  esmini_args="$esmini_args --headless"
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

# Run esmini
exec esmini \
  --osc "${ESMINI_OPEN_SCENARIO_FILE}" \
  --fixed_timestep "${ESMINI_FIXED_TIMESTEP}" \
  --osi_file "${ESMINI_RECORD_OSI_FILE}" \
  "${esmini_args}"
