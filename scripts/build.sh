#!/bin/sh

# '-e' stop on the first failure
# '-u' prevent using an undefined variable
# '-o pipefail' force pipelines to fail on the first non-zero status code
set -euo pipefail

readonly ARGS=$*
readonly REGULAR='../fonts/ttf/B612-Regular.ttf'
readonly ITALIC='../fonts/ttf/B612-Italic.ttf'
readonly BOLD='../fonts/ttf/B612-Bold.ttf'
readonly BOLDITALIC='../fonts/ttf/B612-BoldItalic.ttf'
readonly MONO_REGULAR='../fonts/ttf/B612Mono-Regular.ttf'
readonly MONO_ITALIC='../fonts/ttf/B612Mono-Italic.ttf'
readonly MONO_BOLD='../fonts/ttf/B612Mono-Bold.ttf'
readonly MONO_BOLDITALIC='../fonts/ttf/B612Mono-BoldItalic.ttf'

# -----------------------------------------------------------------------------
# ---- UTILS ------------------------------------------------------------------
# -----------------------------------------------------------------------------
log() {
  message=$1; shift
  color=$1; shift
  nc='\033[0m\n'
  printf "${color}[DEPLOY] $message$nc";
}

info() {
  message=$1; shift
  green='\033[0;32m'
  log "$message" "$green"
}

warn() {
  message=$1; shift
  red='\033[0;31m'
  log "$message" "$red"
}

# -----------------------------------------------------------------------------
# ---- STEPS ------------------------------------------------------------------
# -----------------------------------------------------------------------------
fixDSIG() {
  info "Fix font digital signature (DSIG)"
  gftools fix-dsig --autofix $REGULAR $ITALIC $BOLD $BOLDITALIC $MONO_REGULAR $MONO_ITALIC $MONO_BOLD $MONO_BOLDITALIC
}

fixNonHinting() {
  info "Fix font GASP and PREP table"
  gftools fix-nonhinting $REGULAR $REGULAR
  gftools fix-nonhinting $ITALIC $ITALIC
  gftools fix-nonhinting $BOLD $BOLD
  gftools fix-nonhinting $BOLDITALIC $BOLDITALIC
  gftools fix-nonhinting $MONO_REGULAR $MONO_REGULAR
  gftools fix-nonhinting $MONO_ITALIC $MONO_ITALIC
  gftools fix-nonhinting $MONO_BOLD $MONO_BOLD
  gftools fix-nonhinting $MONO_BOLDITALIC $MONO_BOLDITALIC
}

# -----------------------------------------------------------------------------
# ---- MAIN -------------------------------------------------------------------
# -----------------------------------------------------------------------------
main() {
  fixDSIG
  # fixNonHinting
 
  info "FONT build"
  exit 0;
}

main
