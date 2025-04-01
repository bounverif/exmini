#!/bin/sh 
set -e

bool() {
  case "${1:-false}" in
    true|1|yes|on) return 0 ;;
    *) return 1 ;;
  esac
}

# Set default environment variables
: "${ESMINI_FIXED_TIMESTEP:=0.01}"
: "${ESMINI_HEADLESS:=true}"
: "${ESMINI_WINDOW:=false}"
: "${ESMINI_WINDOW_XPOS:=0}"
: "${ESMINI_WINDOW_YPOS:=0}"
: "${ESMINI_WINDOW_WIDTH:=800}"
: "${ESMINI_WINDOW_HEIGHT:=400}"
: "${ESMINI_LOGFILE_PATH:=/var/esmini/log.txt}"
: "${ESMINI_ENABLE_COLLISION_CHECK:=true}"
: "${ESMINI_DISABLE_LOG:=false}"
: "${ESMINI_DISABLE_STDOUT:=true}"
: "${ESMINI_OUTPUT_DIR:=/var/esmini/data}"
: "${ESMINI_SCENARIO_DIR:=/var/esmini/scenarios}"

# Build esmini arguments dynamically using an array
args="--fixed_timestep $ESMINI_FIXED_TIMESTEP"

bool "$ESMINI_HEADLESS" && args="$args --headless"
bool "$ESMINI_WINDOW" && args="$args --window $ESMINI_WINDOW_XPOS $ESMINI_WINDOW_YPOS $ESMINI_WINDOW_WIDTH $ESMINI_WINDOW_HEIGHT"
bool "$ESMINI_DISABLE_STDOUT" && args="$args --disable_stdout"
bool "$ESMINI_DISABLE_LOG" && args="$args --disable_log" || args="$args --logfile_path $ESMINI_LOGFILE_PATH"
bool "$ESMINI_ENABLE_COLLISION_CHECK" && args="$args --collision"

echo "$args"

mkdir -p "$ESMINI_OUTPUT_DIR" "$ESMINI_SCENARIO_DIR" "$(dirname "$ESMINI_LOGFILE_PATH")"

# Run esmini for each scenario file
find "$ESMINI_SCENARIO_DIR" -maxdepth 1 -type f -name "*.xosc" | while IFS= read -r scenario; do
  echo "Running scenario: $scenario"
  esmini \
    --fixed_timestep "$ESMINI_FIXED_TIMESTEP" \
    --osc "$scenario" \
    --record "$ESMINI_OUTPUT_DIR/$(basename "$scenario" .xosc).dat" \
    --osi_file "$ESMINI_OUTPUT_DIR/$(basename "$scenario" .xosc).osi" \
    $args
done
