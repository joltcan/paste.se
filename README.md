# paste.se

Self-hosted pastebin-like services, written in Python/Tornado/SQLite.

You will need a wildcard DNS record to the paste server since it uses a [bfe0c9274d1deea6.paste.se](https://bfe0c9274d1deea6.paste.se/) hash format to generate a link to the paste.

To make paste data persistent, just map /data to some persistent dir on your server.

The default port is 8800, change that in the `-p <myport>:8800` part of the command..

Parameters can be overwritten by setting them directly in the docker Environment, Here they are:
```
ENV DB_FILE 'paste.se'
ENV BASE_DOMAIN 'dev.paste.se'
ENV ALT_DOMAINS "[]"
ENV CONFIGURABLE_INDEX True
ENV REDIRECT_SCHEME http
ENV DEFAULT_LANG "text"
ENV TORNADOARGS dict(debug=True)
```

Start the docker like so:
```docker
docker \
                run \
                --detach \
                --name=paste.se \
                -e BASE_DOMAIN=localhost \
                -p 8800:8800 \
                -v /srv/someplace:/data \
                paste.se
```

## nginx

If you run paste.se behind a nginx proxy, you can use this config as a template. Replace $BASE_DOMAIN and localhost in the `proxy_pass` section to your setup.

```nginx

server {
    listen 80;
    listen 443 ssl http2;
    server_name .<BASE_DOMAIN>

    if ($scheme = http) {
        return 301 https://$server_name$request_uri;
    }

    include snippets/ssl-params.conf;

    ssl_certificate /etc/ssl/vault/paste.int.flattr.net.pem;
    ssl_certificate_key /etc/ssl/vault/paste.int.flattr.net.pem;

    include snippets/nginx-sso_auth.conf;

    location / {
        auth_request /sso-auth;
        auth_request_set $x_username $upstream_http_x_username;
        auth_request_set $cookie $upstream_http_set_cookie;
        add_header Set-Cookie $cookie;

        proxy_pass http://localhost:8800;
        proxy_set_header Host $host;
        proxy_read_timeout 7200;
        proxy_send_timeout 7200;
    }


} #end server stansa
```

