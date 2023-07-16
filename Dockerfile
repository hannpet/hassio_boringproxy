ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

WORKDIR /root

COPY data .

RUN chmod +x run.sh
RUN mv boringproxy-linux-arm64 boringproxy && chmod +x boringproxy

CMD [ "./run.sh" ]
