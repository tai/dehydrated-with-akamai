# dehydrated-with-akamai
Dehydrated helper script to support ACMEv2 validation with Akamai FastDNS

# Usage
```
$ dehydrated -s /path/to/some.csr -t dns-01 -k /path/to/hook-for-akamai-dns.sh
```

# Installation
```
$ git clone https://github.com/tai/dehydrated-with-akamai.git
$ sudo install -m 0755 hook-for-akamai-dns.sh /usr/local/bin/
```

# Requirements
Please install and setup Akamai CLI first to run this script.
Akamai CLI can be obtained from https://github.com/akamai/cli
