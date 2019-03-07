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

readonly REGULAR_SOURCE='../sources/vfb/B612-Regular.vfb'
readonly ITALIC_SOURCE='../sources/vfb/B612-Italic.vfb'
readonly BOLD_SOURCE='../sources/vfb/B612-Bold.vfb'
readonly BOLDITALIC_SOURCE='../sources/vfb/B612-BoldItalic.vfb'
readonly MONO_REGULAR_SOURCE='../sources/vfb/B612Mono-Regular.vfb'
readonly MONO_ITALIC_SOURCE='../sources/vfb/B612Mono-Italic.vfb'
readonly MONO_BOLD_SOURCE='../sources/vfb/B612Mono-Bold.vfb'
readonly MONO_BOLDITALIC_SOURCE='../sources/vfb/B612Mono-BoldItalic.vfb'

readonly REGULAR_UFO='../sources/ufo/B612-Regular.ufo'
readonly ITALIC_UFO='../sources/ufo/B612-Italic.ufo'
readonly BOLD_UFO='../sources/ufo/B612-Bold.ufo'
readonly BOLDITALIC_UFO='../sources/ufo/B612-BoldItalic.ufo'
readonly MONO_REGULAR_UFO='../sources/ufo/B612Mono-Regular.ufo'
readonly MONO_ITALIC_UFO='../sources/ufo/B612Mono-Italic.ufo'
readonly MONO_BOLD_UFO='../sources/ufo/B612Mono-Bold.ufo'
readonly MONO_BOLDITALIC_UFO='../sources/ufo/B612Mono-BoldItalic.ufo'

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

ufoExport() {
  info "Export vfb as/vfb UFO"
  vfb2ufo $REGULAR_SOURCE $REGULAR_UFO
  vfb2ufo/vfb $ITALIC_SOURCE $ITALIC_UFO
  vfb2ufo/vfb $BOLD_SOURCE $BOLD_UFO
  vfb2ufo/vfb $BOLDITALIC_SOURCE $BOLDITALIC_UFO
  vfb2ufo/vfb $MONO_REGULAR_SOURCE $MONO_REGULAR_UFO
  vfb2ufo/vfb $MONO_ITALIC_SOURCE $MONO_ITALIC_UFO
  vfb2ufo/vfb $MONO_BOLD_SOURCE $MONO_BOLD_UFO
  vfb2ufo/vfb $MONO_BOLDITALIC_SOURCE $MONO_BOLDITALIC_UFO
}/vfb

# -----------------------------------------------------------------------------
# ---- MAIN -------------------------------------------------------------------
# -----------------------------------------------------------------------------
main() {
  fixDSIG
  # fixNonHinting
  ufoExport
 
  info "FONT build"
  exit 0;
}

main
