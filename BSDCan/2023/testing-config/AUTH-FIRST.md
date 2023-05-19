# Authentication
The files `...auth-first.conf` show a configuration example on how to
create a setup where the first user in a new channel/conference has to
authenticate and all later joiners do not have to. That allows an open
reachable system that cannot be (ab)used by outsiders all alone.

Everybody will see a waiting popup ("I am the host") until one is
authenticating and thus starting the conference. The waiting persons
will be joined automatically until after that has happened.

Authentication means can be more advanced (e.g. system/PAM, LDAP, ..)
but for this demonstration we just create users within prosody.
Therefor this command creates an account with the given password:
````
prosodyctl register demouser jitsi.fips.de demo1passwd
````

The config.js needs an additional entry for a hosts setting like:
````
    hosts: {
        domain: 'jitsi.fips.de',
        anonymousdomain: 'public.jitsi.fips.de',
        muc: 'conference.jitsi.fips.de',
    },
````
And again, no DNS for public.jitsi.fips.de, this is just an "realm".
