FROM debian:stretch

RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3


RUN conda config --add channels conda-forge \
    && conda config --set channel_priority strict \
    && conda update --all -y \
    && conda install -y jupyter cadabra2-jupyter-kernel

# install missing library
RUN apt update && apt install libsigc++-2.0-0v5
# symlink library for cadabra2 
RUN ln -s /usr/lib/x86_64-linux-gnu/libsigc-2.0.so.0 /usr/local/lib/libsigc-2.0.so.0

# clean container a little
RUN apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes

# workenv
RUN mkdir /notebooks
WORKDIR /notebooks

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8080", "--allow-root"]

