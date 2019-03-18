#!/bin/sh

: ${SECTION:=default}

usage() {
  local p=$(basename $0)
  cat <<EOF >&2
$p - Let's Encrypt automation by dehydrated with Akamai FastDNS API
Usage: $p <hookname> <args...>
Example:
  $ dehydrated -c -t dns-01 -d my.doma.in -k $p
EOF
  exit 0
}

keycheck() {
  local dom=$1 key=$2

  while :; do
    if dig +short _acme-challenge.$dom txt | grep -q $key; then
      break
    fi
    echo "Waiting for DNS update..." >&2
    sleep ${DELAY:=10}
  done
}

run() {
  local hook=$1; shift

  case "$hook" in
  startup_hook)
    ;;
  generate_csr)
    ;;
  deploy_challenge)
    local dom=$1 key1=$2 key2=$3

    if [ -n "$key1" ]; then
      akamai dns --section ${SECTION} add-record TXT $dom \
      --name _acme-challenge --target "$key1" --ttl 300 --active

      keycheck "$dom" "$key1"
    fi

    if [ -n "$key2" ]; then
      akamai dns --section ${SECTION} add-record TXT $dom \
      --name _acme-challenge --target "$key2" --ttl 300 --active

      keycheck "$dom" "$key2"
    fi
    ;;
  invalid_challenge)
    exit 1
    ;;
  clean_challenge)
    local dom=$1 key1=$2 key2=$3
    akamai dns --section ${SECTION} rm-record TXT $dom \
    --non-interactive --force-multiple --name _acme-challenge
    ;;
  sync_cert)
    ;;
  deploy_cert)
    ;;
  exit_hook)
    ;;
  *) ;; # ignore unknown hooks
  esac
}

test $# -gt 0 || usage
run "$@"
