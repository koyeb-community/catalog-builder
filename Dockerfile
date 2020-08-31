ARG RUNTIME

FROM koyeb/runtime:base as base

ARG PROJECT

COPY out/$PROJECT.tar /var/task

WORKDIR /var/task

RUN tar xf $PROJECT.tar -C / && rm $PROJECT.tar

FROM koyeb/runtime:$RUNTIME

ARG HANDLER

ENV KOYEB_HANDLER=$HANDLER

COPY --from=base /var/task /var/task
