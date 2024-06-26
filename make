#!/bin/env bash

SRC_ROOT=$HOME/src

echo "!!!! I am not make, but a make wrapper. Lets continue ... "

# PATH2 put $HOME/bin at the lowest priority
PATH2="$(echo -n $PATH | sed "s#:$HOME/bin##g"):$HOME/bin"

# if -C, --directory=*, -f, --file=*, --makefile=* are set do nothing
for i in "$@"; do
  case $i in
    -C|-f|--directory=*|--file=*|--makefile=*)
      PATH=${PATH2} make "$@"
      exit $?;;
    *)
      ;;
  esac
done

# if not in SRC_ROOT subdir, return with normal make command
if ! echo -n $PWD | grep "^${SRC_ROOT}/" > /dev/null; then
  PATH=${PATH2} make "$@"
  exit $?
fi

# search parent directories for makefile, do not climp up SRC_ROOT
SEARCH_IN=$PWD
while [ "$SEARCH_IN" != "$SRC_ROOT" ]; do
  if [[ -f $SEARCH_IN/Makefile || -f $SEARCH_IN/makefile ]]; then
    cd $SEARCH_IN
    PATH=$PATH2 make "$@"
    exit $?
  else
    SEARCH_IN=$(dirname $SEARCH_IN)
  fi
done

PATH=${PATH2} make "$@"
exit $?
