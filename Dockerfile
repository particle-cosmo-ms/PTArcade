FROM python:3.12-bookworm
LABEL maintainer="David C. Wright <david.wright@nanograv.org>"
RUN apt update && apt install -y --no-install-recommends libsuitesparse-dev gfortran openmpi-bin libopenmpi-dev git
RUN curl -sSL https://raw.githubusercontent.com/vallis/libstempo/master/install_tempo2.sh | sh -s /usr/local

ENV TEMPO2=/usr/local/share/tempo2

# uv installieren
RUN pip install uv

# Lokalen, gepatchten Code kopieren und mit uv installieren,
# damit [tool.uv.sources] (discovery von GitHub) korrekt greift
COPY . /opt/ptarcade
WORKDIR /opt/ptarcade
RUN uv pip install --system . jupyterlab notebook
RUN uv pip install --system "jax[cuda12]==0.11.1"

RUN ldconfig

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]