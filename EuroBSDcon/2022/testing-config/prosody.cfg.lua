prosody_user = "_prosody"
prosody_group = "_prosody"

pidfile = "/var/prosody/prosody.pid"

modules_enabled = {
                "disco"; -- Service discovery
                "roster"; -- Allow users to have a roster. Recommended ;)
                "saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
                "tls"; -- Add support for secure TLS on c2s/s2s connections
                "blocklist"; -- Allow users to block communications with other users
                "carbons"; -- Keep multiple online clients in sync
                "smacks"; -- Stream management and resumption (XEP-0198)
                "ping"; -- Replies to XMPP pings with pongs
                "register"; -- Allow users to register on this server using a client and change passwords
                "time"; -- Let others know the time here on this server
                "uptime"; -- Report how long server has been running
                "version"; -- Replies to server version requests
                "admin_adhoc"; -- Allows administration via an XMPP client that supports ad-hoc commands
                "admin_shell"; -- Allow secure administration via 'prosodyctl shell
}
http_ports = { 5280 }
http_interfaces = { "*", "::" }

-- per Vhost: authentication = "internal_hashed"

log = {
        info = "/var/prosody/prosody.log"; -- Change 'info' to 'debug' for verbose logging
        error = "/var/prosody/prosody.err";
}

-- ### MAIN

VirtualHost "jts.fips.de"
    authentication = "anonymous";
    modules_enabled = {
        "bosh";
        "pubsub";
    }
    c2s_require_encryption = false

VirtualHost "auth.jts.fips.de"
    ssl = {
         key = "/var/prosody/auth.jts.fips.de.key";
         certificate = "/var/prosody/auth.jts.fips.de.crt";
    }
    authentication = "internal_hashed"

Component "conference.jts.fips.de" "muc"
Component "jvb.jts.fips.de"
    component_secret = "CRED_JVB"
Component "focus.jts.fips.de" "client_proxy"
    target_address = "focus@auth.jts.fips.de"
    -- component_secret = "CRED_JICOFO"
Component "internal.auth.jts.fips.de" "muc"
    storage = "memory"
    modules_enabled = {
      "ping";
    }
    admins = { "focus@auth.jts.fips.de", "jvb@auth.jts.fips.de" }
    muc_room_locking = false
    muc_room_default_public_jids = true
    muc_room_cache_size = 1000
