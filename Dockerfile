FROM ubuntu:16.04
RUN apt-get update && apt-get install -y python3 python3-pip bzip2 openssl

RUN pip install bash_kernel
RUN python -m bash_kernel.install

RUN useradd -m -G users conda
RUN mkdir /home/conda/ssl
RUN chown -R conda:users /home/conda/ssl
ADD 'https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh' /anaconda.sh

RUN chown conda:users /anaconda.sh

# jupyer kernels which crash otherwise
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]

USER conda
RUN /bin/bash /anaconda.sh -b
RUN rm /anaconda.sh
EXPOSE 8888
WORKDIR /home/conda/

CMD ["/home/conda/miniconda3/bin/jupyter","notebook","--certfile=/home/conda/ssl/jupyter.crt","--keyfile=/home/conda/ssl/jupyter.key","--ip=0.0.0.0","--no-browser"]
