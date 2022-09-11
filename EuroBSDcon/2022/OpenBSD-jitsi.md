---
title: "Puffy presents video conferencing / Jitsi on OpenBSD"
author: "Philipp Bühler, sysfive.com GmbH"
date: 'EuroBSDCon - Vienna - 18. September 2022'
format:
  revealjs:
    theme: [league, style.scss]
    menu: true
    slide-number: true
    preview-links: auto
    show-slide-number: all
    slide-tone: false
    transition: fade
    transition-speed: slow
    background-transition: convex
---

## Presentation / C+C
`https://is.gd/ontSw3`


![](img/url.png)

## Overview
### Riddle
### Components
### Terminology
### Details OpenBSD / Jitsi
### Config Pitfalls
### Prayers and Demo
### Status / Outlook

## Riddle
### Jitsi

## Riddle
### OpenBSD

## Components / Terminology
### OpenBSD

## Components / Terminology
### Jitsi

## Details / Architecture
### OpenBSD (1/n)

## Details / Architecture
### Jitsi (1/n)

## Details / Configuration
### OpenBSD VMM / all VM

## Details / Configuration
### OpenBSD (1/5)
- `pf.conf` VMM and all VMs:  
Not needed for jitsi itself, rather common admin care
```{.python code-line-numbers="1|2|3|"}
block return log
pass out quick on egress proto { tcp udp } to any port { 123 53 80 443 }
pass in quick on egress proto tcp from $admin to port 22
```
- `pf.conf` VMM / router:  
jitsi specifics
```{.python code-line-numbers="1|2|3-4|5|6|"}
pass in on egress proto tcp to any port { 80 443 } rdr-to web
pass in on egress proto udp to any port { 10000 } rdr-to vibri
pass in proto tcp from { vibri jicofo } to xmpp port 5222
pass in proto tcp from web to xmpp port 5280
pass in on egress proto tcp to any port 5280 rdr-to xmpp # debug
pass in proto { udp tcp } from $vms to any port domain rdr-to $resolver
```

## Details / Configuration
### OpenBSD (2/5)
- `pf.conf` nginx
```{.python code-line-numbers="1|2|"}
pass in quick on egress proto tcp to self port { 80 443 }
pass out quick on egress proto tcp to xmpp port 5280
```

## Details / Configuration
### OpenBSD (3/5)
- `pf.conf` prosody/xmpp
```{.python code-line-numbers="1|2|3|"}
pass in proto tcp from { jicofo vibri } to self port 5222
pass in proto tcp from web to self port 5280
pass in proto tcp from { any $admin } to self port 5280
```

## Details / Configuration
### OpenBSD (4/5)
- `pf.conf` videobridge
```{.python code-line-numbers="1|2|"}
pass out quick on egress proto tcp to xmpp port { 5222 5280 5347}
pass in quick on egress proto udp to self port 10000
```

## Details / Configuration
### OpenBSD (5/5)
- `pf.conf` jicofo
```{.python code-line-numbers="1|"}
pass out quick on egress proto tcp to xmpp port 5222
```

## Details / Configuration
### Jitsi (1/5)
nginx

## Details / Configuration
### Jitsi (2/5)
prosody / xmpp

## Details / Configuration
### Jitsi (3/5)
videobridge

## Details / Configuration
### Jitsi (4/5)
jicofo

## Details / Configuration
### Jitsi (5/5)
config.js (client)


## Config Pitfalls
### OpenBSD
- `rc.conf.local` daemon_flags jicofo

## Config Pitfalls
### Jitsi (1/n)
- xmpp: host vs. virtualhost vs. domain
- DNS: one and only
- no sctp (vibri AND jicofo)

## Prayers for a Livedemo
### fips.de
[`https://jitsi.fips.de/EBC`](https://jitsi.fips.de/EBC)

## Status / Outlook
IT WORKS!

### Ports / Packages
- `nginx`: official (no config)
- `prosody`: official (no config)
- `net/jicofo`: published/review
- `net/jitsi-videobridge`: published/review
- `www/jitsi-meta`: planned, include above and coherent configuration (all on localhost)

## Status / Outlook
### Cloudification
- easy scale out `nginx`, `vibri` (use statistics)
- harder: `xmpp`
- unsure: `jicofo`

### Jibri / Jigasi
- `jibri`: maybe linux only (chrome-headless, fb/ffmpeg rip); otherwise like `vibri`
- `jigasi`: feel free / just no SIP

## k-thx-bye
:::: {.columns}
::: {.column width="30%"}
![](img/url.png)
:::
::: {.column width="40%"}
Thanks to:

- OpenBSD / Jitsi
- sysfive.com GmbH
- Aisha Tammy (ports)
- thx 4
- thx 5
:::
::: {.column width="30%"}
Misc:

- Meet: Hallway
- No Lunch
- misc 3
- misc 4
:::
::::
:::{.callout-tip}
## Presentation
Created with `Quarto` (target: revealjs) [github](https://github.com/double-p/presentations/tree/master/EuroBSDcon/2022/)
`https://is.gd/ontSw3`
:::