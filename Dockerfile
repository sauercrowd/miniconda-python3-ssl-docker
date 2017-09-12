FROM ubuntu:16.04
RUN apt-get update && apt-get install -y bzip2 openssl


RUN useradd -m -G users conda
RUN mkdir /home/conda/ssl
RUN chown -R conda:users /home/conda/ssl
ADD 'https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh' /miniconda.sh
RUN chown conda:users /miniconda.sh

# jupyer kernels which crash otherwise
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER conda
RUN /bin/bash /miniconda.sh -b
RUN echo "export PATH=$PATH:/home/conda/miniconda3/bin" >> /home/conda/.bashrc

# Install jupyter
RUN /home/conda/miniconda3/bin/conda install -y jupyter

# Remove installation file
USER root
RUN rm /miniconda.sh
USER conda

EXPOSE 8888
WORKDIR /home/conda/
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
