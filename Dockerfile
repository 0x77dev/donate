FROM nvidia/cuda:11.4.2-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev

RUN git clone https://github.com/xmrig/xmrig-cuda.git /cuda
RUN mkdir /cuda/build
WORKDIR /cuda/build

RUN cmake .. -DCUDA_LIB=/usr/local/cuda/lib64/stubs/libcuda.so -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda
RUN make -j$(nproc)

RUN git clone https://github.com/xmrig/xmrig.git /xmrig
RUN mkdir /xmrig/build
WORKDIR /xmrig/build
RUN cmake ..
RUN make -j$(nproc)
COPY config.json .

CMD ./xmrig -c ./config.json
