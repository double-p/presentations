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
    footer: "EuroBSDCon 2022 - Vienna - Jitsi/OpenBSD"
    logo: img/sysfive.jpg
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
XXX
many components
even more communication channels
who/where/what
revproxy from hell
quick install / one-debian VM FTW!

## Riddle
### OpenBSD XXX
Linux-VMs yes/no/alpine
vm.conf examples (hoowl-toooo)
inter VM networking
inside/outside networking (VMM as router)

## Components / Terminology
### OpenBSD
vmm(4) - virtual machine monitor:
: kernel driver isolating/providing the required resources for the VMs ("hypervisor")

vmd(8):
: userland daemon to interact with `vmm`

vmctl(8):
: administrative tool to create, start/stop, .. VMs

vm.conf(5):
: persist VMs resource configuration


## Components / Terminology
### Jitsi
nginx(8): `web`
: serving web assets and reverse proxy BOSH; maybe websockets XXX-colibri? <!-- Bidirectional-streams Over Synchronous HTTP -->

prosody(8): `xmpp`
: internal components communication (esp. "PubSub", health check) and user chat

## Components / Terminology
### Jitsi
focus: `jicofo` JItsi COnference FOcus
: room+session handling in conferences (who's talking to whom and where)

videobridge: `vibri`
: mediastream (WebRTC) handlings between participants (SFU)

jibri: JItsi BRoadcasting Infrastructure
: recording + streaming conferences

## Details / Architecture OpenBSD
XXX VMM+VMs+"switch" pic via mermaid.live + screenshot or 'inline'?

## Details / Architecture Jitsi (Net)
![](img/arch-tcp.png){.r-stretch}

## Details / Architecture Jitsi (logical / ext.)
![](img/arch-pubsub.png){.r-stretch}

## Details / Configuration
### OpenBSD VMM
```{.bash code-line-numbers="|4,8"}
mkdir /home/vmm; cd /home/vmm
vmctl create -s 5G web.qcow2
ftp https://cdn.openbsd.org/pub/OpenBSD/7.1/amd64/install71.iso
vmctl start -m 2G -L -i 1 -r install71.iso -d /home/vmm/web.qcow2 web
vmctl console web
## run the (I)nstaller, default options. only one 'a' slice on (w)hole disk
vmctl stop web
for vm in xmpp jicofo vibri ; do cp web.qcow2 $vm.qcow2; done
echo 'net.inet.ip.forwarding=1' >> /etc/sysctl.conf
```

## Details / Configuration
### OpenBSD VMM `/etc/vm.conf`:
```{.python code-line-numbers="1-6|7-9|10-13|14-17|"}
vm "web" {
  enable
  memory 2G
  disk "/home/vmm/web.qcow2" format qcow2
  local interface { up }
}
vm "web" instance "xmpp" {
  disk "/home/vmm/xmpp.qcow2" format qcow2
}
vm "web" instance "jicofo" {
  memory 4G
  disk "/home/vmm/jicofo.qcow2" format qcow2
}
vm "web" instance "vibri" {
  memory 4G
  disk "/home/vmm/vibri.qcow2" format qcow2
}
```
## Details / Configuration
### OpenBSD all 
`/etc/hosts`:

```{.python code-line-numbers="|2"}
100.64.1.3    web
100.64.2.3    xmpp jitsi.fips.de
100.64.3.3    jicofo
100.64.4.3    vibri
```
:::{.callout-warning}
adapt `/etc/myname` in each VM accordingly
:::
:::{.callout-note}
DNS: only one A-RR: jitsi.fips.de ; `hosts` for jicofo
:::

## Details / Configuration
### OpenBSD
`pf.conf` VMM and all VMs:

:::{.callout-note}
Not needed for jitsi itself, rather common admin care
:::
```{.python code-line-numbers="1|2|3|"}
block return log
pass out quick on egress proto { tcp udp } to any port { 123 53 80 443 }
pass in quick on egress proto tcp from $admin to port 22
```
:::{.callout-note}
block both ways; allow NTP, DNS, HTTP(S), SSH
:::

## Details / Configuration
### OpenBSD
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
### OpenBSD
- `pf.conf` nginx
```{.python code-line-numbers="1|2|"}
pass in quick on egress proto tcp to self port { 80 443 }
pass out quick on egress proto tcp to xmpp port 5280
```

## Details / Configuration
### OpenBSD
- `pf.conf`: prosody/xmpp
```{.python code-line-numbers="1|2|3|"}
pass in proto tcp from { jicofo vibri } to self port { 5222 5347 }
pass in proto tcp from web to self port 5280
pass in proto tcp from { any $admin } to self port 5280 # debug
```
:::{.callout-note}
5347/tcp for explicit authentication if need be (not here)
:::

## Details / Configuration
### OpenBSD
- `pf.conf`: videobridge
```{.python code-line-numbers="1|2|"}
pass out quick on egress proto tcp to xmpp port { 5222 5280 5347}
pass in quick on egress proto udp to self port 10000
```

## Details / Configuration
### OpenBSD
- `pf.conf` jicofo
```{.python code-line-numbers="1|"}
pass out quick on egress proto tcp to xmpp port 5222
```

## Details / Configuration
### Jitsi / xmpp
`/etc/prosody/prosody.cfg.lua`: (shortened)
```{.lua code-line-numbers="|1,4|"}
http_interfaces = { "*", "::" }
VirtualHost "jitsi.fips.de"
    authentication = "anonymous";
    modules_enabled = { "bosh"; "pubsub"; }
    c2s_require_encryption = false

VirtualHost "auth.jitsi.fips.de"
    admins = { "focus@auth.jitsi.fips.de", "jvb@auth.jitsi.fips.de" }
    ssl = { key = "/etc/prosody/certs/auth.jitsi.fips.de.key";
            certificate = "/etc/prosody/certs/auth.jitsi.fips.de.crt"; }
    authentication = "internal_hashed"
```
:::{.callout-note}
`admins` usage unclear
:::
## Details / Configuration
### Jitsi / xmpp
`/etc/prosody/prosody.cfg.lua`: (shortened) (cont.)
```{.lua code-line-numbers="1|2,3|4,5|6-8|"}
Component "conference.jitsi.fips.de" "muc"
Component "jvb.jitsi.fips.de"
    component_secret = "CRED_VIBRI"
Component "focus.jitsi.fips.de" "client_proxy"
    target_address = "focus@auth.jitsi.fips.de"
Component "internal.auth.jitsi.fips.de" "muc"
    muc_room_locking = false
    muc_room_default_public_jids = true
```
:::{.callout-note}
No extra DNS needed! Like "Host:" HTTP-Header.  
`focus` like `jvb` in earlier versions (v1)
:::

## Details / Configuration
### Jitsi / nginx (shortened server{})
```{.nginx code-line-numbers="|1|2|3-4|5-7|8|9-12|13-14|"}
server_name  jitsi.fips.de;
root         /var/www/jitsi-meet;
ssi on;
ssi_types application/x-javascript application/javascript;
location ~ ^/(libs|css|static|images|fonts|lang|sounds|connection_optimization)/(.*)$ {
  add_header 'Access-Control-Allow-Origin' '*';
  alias /var/www/jitsi-meet/$1/$2; }
location /external_api.js { alias /var/www/jitsi-meet/libs/external_api.min.js; }
location = /http-bind {
  proxy_pass      http://xmpp:5280/http-bind;
  proxy_set_header X-Forwarded-For $remote_addr;
  proxy_set_header Host $http_host; }
location ~ ^/([a-zA-Z0-9=\?]+)$ {
  rewrite ^/(.*)$ / break; }
```

## Details / Configuration
### Jitsi / web client 
`/var/www/jitsi-meet/config.js`:
```{.javascript code-line-numbers="3-4|6|7|8,10|13|"}
var config = {
  hosts: {
    domain: 'jitsi.fips.de',
    muc: 'conference.jitsi.fips.de' // no DNS
  },
  bosh: '//jitsi.fips.de/http-bind',
  useTurnUdp: false,
  prejoinConfig: {
    enabled: true,
    hideExtraJoinButtons: ['no-audio', 'by-phone'] },
  p2p: {
    stunServers: [
      { urls: 'stun:meet-jit-si-turnrelay.jitsi.net:443' } ] }
}
```

## Details / Configuration
### Jitsi / vibri
`/etc/jitsi/vibri.conf`:
```{.javascript code-line-numbers="5|6|9,10|12|13-15|16-17|"}
videobridge { apis {
  xmpp-client {
   configs {
    ourprosody {
     hostname = "xmpp"
     domain = "auth.jitsi.fips.de" // 'realm'
     username = "jvb"
     password = "CRED_VIBRI"
     muc_jids = "JvbBrewery@internal.auth.jitsi.fips.de"
     muc_nickname = "jvb-foo"
     disable_certificate_verification = true } } } }
  sctp { enabled = false } // n/a on OpenBSD
  ice { tcp {
    enabled = false
    port = 443
   } udp {
    port = 10000
   }
  }
}
```

## Details / Configuration
### Jitsi / vibri
`/etc/jitsi/sip-communicator.properties`:
```{.java}
org.ice4j.ice.harvest.NAT_HARVESTER_LOCAL_ADDRESS=100.64.4.3
org.ice4j.ice.harvest.NAT_HARVESTER_PUBLIC_ADDRESS=87.253.170.146
org.ice4j.ice.harvest.DISABLE_AWS_HARVESTER=true
```
:::{.callout-note}
ice4j is not developed by Jitsi, thus not available in "new" JICO
:::

## Details / Configuration
### Jitsi / jicofo
`/etc/jitsi/jicofo.conf`: (shortened)
```{.javascript code-line-numbers="|2|3|4|8|14|"}
jicofo { bridge {
  brewery-jid = "JvbBrewery@internal.auth.jitsi.fips.de"
  xmpp-connection-name = Client } // enum
sctp { enabled = false } 
  xmpp {
    client {
      port = 5222
      domain = "auth.jitsi.fips.de"
      username = "focus"
      password = "CRED_FOCUS"
      use-tls = true
    }
    // trusted service domains. Logged in -> advance to bridges
    trusted-domains = [ "auth.jitsi.fips.de" ]
  }
}
```
## Details / Configuration
### Jitsi / jicofo
`/etc/rc.conf.local`:
```{.bash code-line-numbers="|"}
jicofo_flags="--host=jitsi.fips.de"
```

:::{.callout-important}
Needs `/etc/hosts` or split-DNS. Used for TCP connect AND virtualhost
:::

## Pitfalls
### OpenBSD
- `rc.conf.local` jicofo_flags: DNS/hosts
- sctp
- startup ordering (web, xmpp, jicofo, vibri)

## Pitfalls
### Jitsi
- xmpp: host vs. virtualhost vs. domain
- DNS: one and only one (or mess up xmpp fallback)
- no sctp (vibri AND jicofo)
- (hidden) version bumps ("no longer component!")

## Prayers for a Livedemo
### fips.de
[`https://jitsi.fips.de/EBC`](https://jitsi.fips.de/EBC)

## Status / Outlook
:::{.callout-important}
IT WORKS!
:::

### Ports / Packages
- `nginx`, `prosody`: official (no config)
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