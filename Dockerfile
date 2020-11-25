# build container
FROM debian:buster AS installer

RUN apt-get -qq update && apt-get -qq -y install git cmake python3 python3-dev g++ libpcre3 libpcre3-dev libgmp3-dev libgtkmm-3.0-dev libboost-all-dev libgmp-dev

# this may need to be updated after merge
RUN git clone -b "master" --depth 1 https://github.com/kpeeters/cadabra2

WORKDIR cadabra2
RUN mkdir build

# disable client_server build
RUN sed -i -e 's/add_subdirectory(client_server)//g' CMakeLists.txt
RUN cd build && cmake .. -DENABLE_MATHEMATICA=OFF -DENABLE_FRONTEND=OFF -DENABLE_PY_JUPYTER=ON
RUN cd build && make -j $(nproc) && make install

# workaround soabi compliant name https://github.com/kpeeters/cadabra2/commit/189a587c37771def45ef7ad1f373f5081a075fe1
RUN mv /usr/local/lib/python3.7/site-packages/cadabra2*.so /usr/local/lib/python3.7/site-packages/cadabra2.so

# ship container
FROM python:3.7-slim-buster
WORKDIR /

COPY --from=installer /usr/local/lib/python3.7/site-packages/cdb /usr/local/lib/python3.7/site-packages/cdb
COPY --from=installer /usr/local/share/jupyter/kernels /usr/local/share/jupyter/kernels
COPY --from=installer /usr/local/lib/python3.7/site-packages/cdb_appdirs.py /usr/local/lib/python3.7/site-packages/cdb_appdirs.py
COPY --from=installer /usr/local/lib/python3.7/site-packages/cadabra2_defaults.py /usr/local/lib/python3.7/site-packages/cadabra2_defaults.py
COPY --from=installer /usr/local/lib/python3.7/site-packages/cadabra2.so /usr/local/lib/python3.7/site-packages/cadabra2.so
COPY --from=installer /usr/local/lib/python3.7/site-packages/cadabra2_jupyter /usr/local/lib/python3.7/site-packages/cadabra2_jupyter
COPY --from=installer /usr/local/lib/python3.7/site-packages/notebook/static/components/codemirror/mode/cadabra /usr/local/lib/python3.7/site-packages/notebook/static/components/codemirror/mode/cadabra

RUN apt-get -qq update && apt-get install -y libgmp3-dev libboost-system-dev gcc libmpfr-dev libmpc-dev

RUN pip3.7 install jupyter gmpy2

# clean the container a little 
RUN apt-get remove -y gcc && apt-get autoremove -y

# pathing issue fix
RUN ln -s /usr/local/bin/python3.7 /usr/bin/python3.7

RUN sed -i -e "s/stream.indentation/1 == stream.column/g" /usr/local/lib/python3.7/site-packages/notebook/static/components/codemirror/mode/cadabra/cadabra.js

# create running user
RUN groupadd --gid 1001 cadabra
RUN useradd --create-home --shell /bin/bash --uid 1001 --gid 1001 cadabra
# USER cadabra
WORKDIR /home/cadabra

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8080", "--allow-root"]
