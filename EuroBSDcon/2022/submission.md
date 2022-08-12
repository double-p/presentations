# title
Puffy presents video conferencing (jitsi)

## subtitle
Video conferencing has become common place nowadays and this presentation will show how
to install, configure, operate, scale and secure a videoconferencing service with
`jitsi` running on OpenBSD.

# abstract
The presentation will cover all bits and bolts to fully understand the components
at play, their intercommunications and how this knowledge can be used to create
a jitsi-on-OpenBSD setup that features a restricted (compartmentalized) setup using
dedicated machines or -as presented- VMM based VMs, where each VM runs only one of the
components.

It'll be shown what's necessary to create a sensible pf.conf on each VM and how to
add reverse proxy (relayd, haproxy) for distribution of workload.

Also covering pitfalls/hints along underlying components as Java-JRE, IPv6 dualstack
rammifications and what to lookout for on the client/browser side for interopability.

# Bio
Philipp uses Unix since mid 1990s and OpenBSD since 2000. Born and working in
Germany mainly in Unix/Linux/BSD areas including ISP services and networking.
OpenBSD developer early 2000s and presenting on virtualization (packer, vagrant).

Co-founder of sysfive.com GmbH having the technical lead in designing and
operating FOSS-based business plattforms.
