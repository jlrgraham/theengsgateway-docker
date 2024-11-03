FROM python:3.12 AS decoder_builder

RUN apt-get update && apt-get install -y --no-install-recommends cmake ninja-build && apt-get clean
RUN python3 -m pip install --upgrade pip
RUN pip install setuptools setuptools_scm cmake wheel scikit-build ninja

WORKDIR /usr/local/src
RUN git clone --recursive https://github.com/theengs/decoder.git

WORKDIR /usr/local/src/decoder/python
RUN ln -s ../src
RUN python3 setup.py bdist_wheel


FROM python:3.12

SHELL ["/bin/bash", "-ec"]

RUN apt-get update && apt-get install --no-install-recommends -y bluez && apt-get clean

RUN python3 -m venv /opt/venv && /opt/venv/bin/pip install --upgrade pip
RUN /opt/venv/bin/pip install TheengsGateway

RUN mkdir /tmp/theengsdecoder
COPY --from=decoder_builder /usr/local/src/decoder/python/dist/*.whl /tmp/theengsdecoder
RUN /opt/venv/bin/pip install --upgrade /tmp/theengsdecoder/*.whl

COPY chroot /

CMD source /opt/venv/bin/activate && exec /opt/venv/start.sh
