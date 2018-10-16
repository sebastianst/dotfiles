#!/bin/bash
case $(xkb-switch) in
us)
  printf '🇺🇳' ;;
de)
  printf '🍺' ;;
esac
