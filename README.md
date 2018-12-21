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
