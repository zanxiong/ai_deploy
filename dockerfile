# Copyright (c) 2020-2021 Intel Corporation.
# SPDX-License-Identifier: BSD-3-Clause

FROM ubuntu:22.04

# Set build arguments for proxy
ARG http_proxy
ARG https_proxy

COPY third-party-programs.txt /
RUN apt-get update && apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl ca-certificates gpg-agent software-properties-common && \
  rm -rf /var/lib/apt/lists/*
# repository to install Intel(R) oneAPI Libraries
RUN curl -fsSL https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB | gpg --dearmor | tee /usr/share/keyrings/intel-oneapi-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/intel-oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main " > /etc/apt/sources.list.d/oneAPI.list

RUN apt-get update && apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl ca-certificates gpg-agent software-properties-common && \
  rm -rf /var/lib/apt/lists/*
# repository to install Intel(R) GPU drivers
RUN curl -fsSL https://repositories.intel.com/gpu/intel-graphics.key | gpg --dearmor | tee /usr/share/keyrings/intel-graphics-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/intel-graphics-archive-keyring.gpg arch=amd64] https://repositories.intel.com/gpu/ubuntu jammy unified" > /etc/apt/sources.list.d/intel-graphics.list

RUN apt-get update && apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates build-essential pkg-config gnupg libarchive13 openssh-server openssh-client wget net-tools git cmake intel-opencl-icd libze-intel-gpu1 libze1 libze-dev \
    intel-oneapi-dnnl-2025.0 \
    intel-oneapi-mkl-sycl-2025.0 \
    intel-oneapi-dpcpp-cpp-2025.0 \
  intel-oneapi-dpcpp-ct-2025.0 \
  intel-oneapi-mkl-2025.0 \
  intel-oneapi-mkl-devel-2025.0 \
  intel-oneapi-dnnl-devel-2025.0 \
    && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get clean && apt-get autoclean && apt-get autoremove


ENV LANG=C.UTF-8
ENV CCL_CONFIGURATION='cpu_gpu_dpcpp'
ENV CCL_CONFIGURATION_PATH=''
ENV CCL_ROOT='/opt/intel/oneapi/ccl/2021.14'
ENV CMAKE_PREFIX_PATH='/opt/intel/oneapi/tbb/2022.0/env/..:/opt/intel/oneapi/pti/0.10/lib/cmake/pti:/opt/intel/oneapi/mkl/2025.0/lib/cmake:/opt/intel/oneapi/ipp/2022.0/lib/cmake/ipp:/opt/intel/oneapi/dpl/2022.7/lib/cmake/oneDPL:/opt/intel/oneapi/dnnl/2025.0/lib/cmake:/opt/intel/oneapi/dal/2025.0:/opt/intel/oneapi/compiler/2025.0'
ENV CMPLR_ROOT='/opt/intel/oneapi/compiler/2025.0'
ENV CPATH='/opt/intel/oneapi/umf/0.9/include:/opt/intel/oneapi/tbb/2022.0/env/../include:/opt/intel/oneapi/pti/0.10/include:/opt/intel/oneapi/mpi/2021.14/include:/opt/intel/oneapi/mkl/2025.0/include:/opt/intel/oneapi/ippcp/2025.0/include:/opt/intel/oneapi/ipp/2022.0/include:/opt/intel/oneapi/dpl/2022.7/include:/opt/intel/oneapi/dpcpp-ct/2025.0/include:/opt/intel/oneapi/dnnl/2025.0/include:/opt/intel/oneapi/dev-utilities/2025.0/include:/opt/intel/oneapi/dal/2025.0/include:/opt/intel/oneapi/ccl/2021.14/include'
ENV DIAGUTIL_PATH='/opt/intel/oneapi/dpcpp-ct/2025.0/etc/dpct/sys_check/sys_check.sh:/opt/intel/oneapi/compiler/2025.0/etc/compiler/sys_check/sys_check.sh'
ENV DNNLROOT='/opt/intel/oneapi/dnnl/2025.0'
ENV DPL_ROOT='/opt/intel/oneapi/dpl/2022.7'
ENV FI_PROVIDER_PATH='/opt/intel/oneapi/mpi/2021.14/opt/mpi/libfabric/lib/prov:/usr/lib/x86_64-linux-gnu/libfabric'
ENV GDB_INFO='/opt/intel/oneapi/debugger/2025.0/share/info/'
ENV INFOPATH='/opt/intel/oneapi/debugger/2025.0/share/info'
ENV INTEL_PYTHONHOME='/opt/intel/oneapi/debugger/2025.0/opt/debugger'
ENV IPPCP_TARGET_ARCH='intel64'
ENV IPPCRYPTOROOT='/opt/intel/oneapi/ippcp/2025.0'
ENV IPPROOT='/opt/intel/oneapi/ipp/2022.0'
ENV IPP_TARGET_ARCH='intel64'
ENV LD_LIBRARY_PATH='/opt/intel/oneapi/tcm/1.2/lib:/opt/intel/oneapi/umf/0.9/lib:/opt/intel/oneapi/tbb/2022.0/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/pti/0.10/lib:/opt/intel/oneapi/mpi/2021.14/opt/mpi/libfabric/lib:/opt/intel/oneapi/mpi/2021.14/lib:/opt/intel/oneapi/mkl/2025.0/lib:/opt/intel/oneapi/ippcp/2025.0/lib/:/opt/intel/oneapi/ipp/2022.0/lib:/opt/intel/oneapi/dnnl/2025.0/lib:/opt/intel/oneapi/debugger/2025.0/opt/debugger/lib:/opt/intel/oneapi/dal/2025.0/lib:/opt/intel/oneapi/compiler/2025.0/opt/compiler/lib:/opt/intel/oneapi/compiler/2025.0/lib:/opt/intel/oneapi/ccl/2021.14/lib/'
ENV LIBRARY_PATH='/opt/intel/oneapi/tcm/1.2/lib:/opt/intel/oneapi/umf/0.9/lib:/opt/intel/oneapi/tbb/2022.0/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/pti/0.10/lib:/opt/intel/oneapi/mpi/2021.14/lib:/opt/intel/oneapi/mkl/2025.0/lib:/opt/intel/oneapi/ippcp/2025.0/lib/:/opt/intel/oneapi/ipp/2022.0/lib:/opt/intel/oneapi/dnnl/2025.0/lib:/opt/intel/oneapi/dal/2025.0/lib:/opt/intel/oneapi/compiler/2025.0/lib:/opt/intel/oneapi/ccl/2021.14/lib/'
ENV MANPATH='/opt/intel/oneapi/mpi/2021.14/share/man:/opt/intel/oneapi/debugger/2025.0/share/man:/opt/intel/oneapi/compiler/2025.0/share/man:'
ENV MKLROOT='/opt/intel/oneapi/mkl/2025.0'
ENV NLSPATH='/opt/intel/oneapi/compiler/2025.0/lib/compiler/locale/%l_%t/%N'
ENV OCL_ICD_FILENAMES='/opt/intel/oneapi/compiler/2025.0/lib/libintelocl.so'
ENV ONEAPI_ROOT='/opt/intel/oneapi'
ENV PATH='/opt/intel/oneapi/vtune/2025.0/bin64:/opt/intel/oneapi/mpi/2021.14/bin:/opt/intel/oneapi/mkl/2025.0/bin:/opt/intel/oneapi/dpcpp-ct/2025.0/bin:/opt/intel/oneapi/dev-utilities/2025.0/bin:/opt/intel/oneapi/debugger/2025.0/opt/debugger/bin:/opt/intel/oneapi/compiler/2025.0/bin:/opt/intel/oneapi/advisor/2025.0/bin64:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
ENV PKG_CONFIG_PATH='/opt/intel/oneapi/vtune/2025.0/include/pkgconfig/lib64:/opt/intel/oneapi/tbb/2022.0/env/../lib/pkgconfig:/opt/intel/oneapi/mpi/2021.14/lib/pkgconfig:/opt/intel/oneapi/mkl/2025.0/lib/pkgconfig:/opt/intel/oneapi/ippcp/2025.0/lib/pkgconfig:/opt/intel/oneapi/dpl/2022.7/lib/pkgconfig:/opt/intel/oneapi/dnnl/2025.0/lib/pkgconfig:/opt/intel/oneapi/dal/2025.0/lib/pkgconfig:/opt/intel/oneapi/compiler/2025.0/lib/pkgconfig:/opt/intel/oneapi/ccl/2021.14/lib/pkgconfig/:/opt/intel/oneapi/advisor/2025.0/include/pkgconfig/lib64:'
ENV PYTHONPATH='/opt/intel/oneapi/advisor/2025.0/pythonapi'
ENV Pti_DIR='/opt/intel/oneapi/pti/0.10/lib/cmake/pti'
ENV SETVARS_COMPLETED='1'
ENV TBBROOT='/opt/intel/oneapi/tbb/2022.0/env/..'
ENV TCM_ROOT='/opt/intel/oneapi/tcm/1.2'
ENV UMF_ROOT='/opt/intel/oneapi/umf/0.9'

# Disable pip cache
ARG PIP_NO_CACHE_DIR=false

# Set environment variables
ENV TZ=Asia/Shanghai \
    PYTHONUNBUFFERED=1 \
    SYCL_CACHE_PERSISTENT=1

# Install dependencies and configure the environment
RUN set -eux && \
    # Update and install basic dependencies
    apt-get update && \
    apt-get install -y --no-install-recommends \
      curl wget git sudo libunwind8-dev vim less gnupg gpg-agent software-properties-common && \
    #
    # Set timezone
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    #
    # Install Python 3.11
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get install -y --no-install-recommends python3.11 python3-pip python3.11-dev python3.11-distutils python3-wheel && \
    rm /usr/bin/python3 && ln -s /usr/bin/python3.11 /usr/bin/python3 && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    #
    # Install pip and essential Python packages
    wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py && \
    python3 get-pip.py && rm get-pip.py && \
    pip install --upgrade requests argparse urllib3 && \
    pip install --pre --upgrade ipex-llm[cpp] && \
    pip install transformers==4.36.2 transformers_stream_generator einops tiktoken && \
    #
    # Remove breaks install packages
    apt-get remove -y libze-dev libze-intel-gpu1 && \
    #
    # Install Intel GPU OpenCL Driver and Compute Runtime
    mkdir -p /tmp/gpu && cd /tmp/gpu && \
    echo "Downloading Intel Compute Runtime (24.52) for Gen12+..." && \
    wget https://github.com/intel/intel-graphics-compiler/releases/download/v2.5.6/intel-igc-core-2_2.5.6+18417_amd64.deb && \
    wget https://github.com/intel/intel-graphics-compiler/releases/download/v2.5.6/intel-igc-opencl-2_2.5.6+18417_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/24.52.32224.5/intel-level-zero-gpu_1.6.32224.5_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/24.52.32224.5/intel-opencl-icd_24.52.32224.5_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/24.52.32224.5/libigdgmm12_22.5.5_amd64.deb && \
    #
    echo "Downloading Legacy Compute Runtime (24.35) for pre-Gen12 support..." && \
    wget https://github.com/intel/compute-runtime/releases/download/24.35.30872.22/intel-level-zero-gpu-legacy1_1.3.30872.22_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/24.35.30872.22/intel-opencl-icd-legacy1_24.35.30872.22_amd64.deb && \
    wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.17537.20/intel-igc-core_1.0.17537.20_amd64.deb && \
    wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.17537.20/intel-igc-opencl_1.0.17537.20_amd64.deb && \
    #
    dpkg -i *.deb && rm -rf /tmp/gpu && \
    #
    # Install oneAPI Level Zero Loader
    mkdir /tmp/level-zero && cd /tmp/level-zero && \
    wget https://github.com/oneapi-src/level-zero/releases/download/v1.20.2/level-zero_1.20.2+u22.04_amd64.deb && \
    wget https://github.com/oneapi-src/level-zero/releases/download/v1.20.2/level-zero-devel_1.20.2+u22.04_amd64.deb && \
    dpkg -i *.deb && rm -rf /tmp/level-zero && \
    #
    # Clean up unnecessary dependencies to reduce image size
    find /usr/lib/python3/dist-packages/ -name 'blinker*' -exec rm -rf {} + && \
    rm -rf /root/.cache/Cypress

# Copy the files to the build image
COPY ./start-llama-cpp.sh ./start-ollama.sh ./benchmark_llama-cpp.sh /llm/scripts/

# create local_models to store deepseek-r1:8b
RUN mkdir /local_models & cd /local_models & wget https://www.modelscope.cn/models/unsloth/DeepSeek-R1-Distill-Llama-8B-GGUF/resolve/master/DeepSeek-R1-Distill-Llama-8B-Q4_K_M.gguf

WORKDIR /llm/

