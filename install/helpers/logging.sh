apex_log_to_stdout() {
  [[ ${APEX_LOG_TO_STDOUT:-} == "1" || -z ${APEX_INSTALL_LOG_FILE:-} ]]
}

apex_log_line() {
  if apex_log_to_stdout; then
    echo "$1"
  else
    echo "$1" >>"$APEX_INSTALL_LOG_FILE"
  fi
}

log_step() {
  local step_name="$1"
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  apex_log_line "[$timestamp] STEP: $step_name"
  if ! apex_log_to_stdout; then
    echo "==> [$timestamp] $step_name"
  fi
}

start_install_log() {
  if ! apex_log_to_stdout; then
    mkdir -p "$(dirname "$APEX_INSTALL_LOG_FILE")"
    touch "$APEX_INSTALL_LOG_FILE"
    chmod 666 "$APEX_INSTALL_LOG_FILE" 2>/dev/null || true
  fi

  export APEX_START_TIME="${APEX_START_TIME:-$(date '+%Y-%m-%d %H:%M:%S')}"
  export APEX_START_EPOCH="${APEX_START_EPOCH:-$(date +%s)}"

  apex_log_line "=== Apex Setup Started: $APEX_START_TIME ==="
  if ! apex_log_to_stdout; then
    echo "=== Apex Setup Started: $APEX_START_TIME ==="
    echo "=== Logging to: $APEX_INSTALL_LOG_FILE ==="
  fi
}

stop_install_log() {
  local end_time end_epoch duration mins secs
  end_time=$(date '+%Y-%m-%d %H:%M:%S')
  end_epoch=$(date +%s)

  apex_log_line "=== Apex Setup Completed: $end_time ==="

  if [[ -n ${APEX_START_EPOCH:-} ]]; then
    duration=$((end_epoch - APEX_START_EPOCH))
    mins=$((duration / 60))
    secs=$((duration % 60))
    apex_log_line "Apex setup duration: ${mins}m ${secs}s"
    if ! apex_log_to_stdout; then
      echo "=== Apex Setup Completed: $end_time (${mins}m ${secs}s) ==="
    fi
  fi
}

run_logged() {
  local script="$1"
  local step_name="${2:-}"
  local exit_code errexit_was_set=0

  if [[ -n "$step_name" ]]; then
    log_step "$step_name"
  else
    log_step "$(basename "$script" .sh)"
  fi

  apex_log_line "[$(date '+%Y-%m-%d %H:%M:%S')] Starting: $script"

  case $- in
    *e*)
      errexit_was_set=1
      set +e
      ;;
  esac

  local runner=(bash -eE)
  if [[ ${APEX_INSTALL_DEBUG:-} == "1" ]]; then
    runner=(bash -x -eE)
  fi

  if apex_log_to_stdout; then
    PS4='+ ${BASH_SOURCE[0]##*/}:${LINENO}:${FUNCNAME[0]:-main}: ' \
      "${runner[@]}" -c 'source "$1"' bash "$script" </dev/null 2>&1
  else
    PS4='+ ${BASH_SOURCE[0]##*/}:${LINENO}:${FUNCNAME[0]:-main}: ' \
      "${runner[@]}" -c 'source "$1"' bash "$script" </dev/null >>"$APEX_INSTALL_LOG_FILE" 2>&1
  fi

  exit_code=$?
  (( errexit_was_set )) && set -e

  if (( exit_code == 0 )); then
    apex_log_line "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: $script"
  else
    apex_log_line "[$(date '+%Y-%m-%d %H:%M:%S')] Failed: $script (exit code: $exit_code)"
    if ! apex_log_to_stdout; then
      echo "Error in $script (exit code: $exit_code). See $APEX_INSTALL_LOG_FILE" >&2
    fi
  fi

  return $exit_code
}
