FROM jfloff/alpine-python:2.7-slim

RUN pip install tornado pygments

ADD server.py favicon.ico /paste/
ADD templates/*.html /paste/templates/

ENV DB_FILE 'paste.se'
ENV BASE_DOMAIN 'dev.paste.se'
ENV ALT_DOMAINS "[]"
ENV CONFIGURABLE_INDEX True
ENV REDIRECT_SCHEME http
ENV DEFAULT_LANG "text"
ENV TORNADOARGS dict(debug=True)

WORKDIR /paste

VOLUME /data

EXPOSE 8800

CMD /paste/server.py
