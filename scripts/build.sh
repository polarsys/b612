#!/bin/bash

# "-e" stop on the first failure
# "-u" prevent using an undefined variable
# "-o pipefail" force pipelines to fail on the first non-zero status code
set -euo pipefail

readonly ARGS=$*
FONT_TTFS=()
FONT_VFBS=()

for style in "Regular" "Italic" "Bold" "BoldItalic"
do
   FONT_TTFS+=("../fonts/ttf/B612-$style.ttf")
   FONT_TTFS+=("../fonts/ttf/B612Mono-$style.ttf")
   FONT_VFBS+=("../sources/vfb/B612-$style.vfb")
   FONT_VFBS+=("../sources/vfb/B612Mono-$style.vfb")
done

# -----------------------------------------------------------------------------
# ---- UTILS ------------------------------------------------------------------
# -----------------------------------------------------------------------------
log() {
  message=$1; shift
  color=$1; shift
  nc="\033[0m\n"
  printf "${color}[DEPLOY] $message$nc";
}

info() {
  message=$1; shift
  green="\033[0;32m"
  log "$message" "$green"
}

warn() {
  message=$1; shift
  red="\033[0;31m"
  log "$message" "$red"
}

# -----------------------------------------------------------------------------
# ---- MAIN -------------------------------------------------------------------
# -----------------------------------------------------------------------------

main() {
  info "Fix font digital signature (DSIG) / Fix font GASP and PREP table"
  
  for ttf in ${FONT_TTFS[*]}
  do
    echo $ttf
    gftools fix-dsig --autofix $ttf
    gftools fix-nonhinting $ttf $ttf
  done

  info "Export vfb as UFO and normalize UFO"

  for vfb in ${FONT_VFBS[*]}
  do
    ufo=${vfb//vfb/ufo}
    echo $ufo
    vfb2ufo -fo $vfb $ufo
    psfnormalize $ufo
  done
 
  info "Finished building B612 font"
  exit 0;
}

main
