prosody_user = "_prosody"
prosody_group = "_prosody"

pidfile = "/var/prosody/prosody.pid"

plugin_paths = { "/usr/local/share/jitsi-prosody-plugins" }

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

VirtualHost "jitsi.fips.de"
    -- authentication = "anonymous";
    modules_enabled = {
        "bosh";
        "pubsub";
    }
    c2s_require_encryption = false
    authentication = "internal_hashed"

VirtualHost "public.jitsi.fips.de"
    authentication = "anonymous"
    modules_enabled = {
            "bosh";
            "pubsub";
            "ping";
    }
    c2s_require_encryption = false


VirtualHost "auth.jitsi.fips.de"
    ssl = {
         key = "/var/prosody/auth.jitsi.fips.de.key";
         certificate = "/var/prosody/auth.jitsi.fips.de.crt";
    }
    authentication = "internal_hashed"

Component "conference.jitsi.fips.de" "muc"
Component "jvb.jitsi.fips.de"
    -- component_secret = "jitsicool1jvb"
Component "focus.jitsi.fips.de" "client_proxy"
    target_address = "focus@auth.jitsi.fips.de"
    -- component_secret = "jitsicool1focus"
Component "internal.auth.jitsi.fips.de" "muc"
    component_secret = "jitsiinternal1"
    storage = "memory"
    modules_enabled = {
      "ping";
    }
    admins = { "focus@auth.jitsi.fips.de", "jvb@auth.jitsi.fips.de" }
    muc_room_locking = false
    muc_room_default_public_jids = true
    muc_room_cache_size = 1000
