---
title: "Puffy presents video conferencing / Jitsi on OpenBSD"
author: "Philipp Bühler, sysfive.com GmbH"
date: 'EuroBSDCon - Vienna - 18. September 2022'
format:
  revealjs:
    theme: league
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
- `pf.conf` VMM
- `pf.conf` all VMs

## Details / Configuration
### OpenBSD (2/5)
- `pf.conf` nginx

## Details / Configuration
### OpenBSD (3/5)
- `pf.conf` prosody

## Details / Configuration
### OpenBSD (4/5)
- `pf.conf` videobridge

## Details / Configuration
### OpenBSD (5/5)
- `pf.conf` jicofo

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