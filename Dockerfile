FROM python:3.12

SHELL ["/bin/bash", "-ec"]

RUN apt update && apt install --no-install-recommends -y bluez && apt-get clean

RUN python3 -m venv /opt/venv && /opt/venv/bin/pip install --upgrade pip
RUN /opt/venv/bin/pip install TheengsGateway

COPY chroot /

CMD source /opt/venv/bin/activate && exec /opt/venv/start.sh
