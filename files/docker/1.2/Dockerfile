# Copyright (C) 2018 Laboratory of Experimental Biophysics
# Ecole Polytechnique Federale de Lausanne
#
# A Scipion image without GPU support.
#

FROM ubuntu:16.04
MAINTAINER Kyle M. Douglass <kyle.douglass@epfl.ch>

# Build dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    gcc \
    gfortran \
    git \
    libfreetype6-dev \
    libgsl0-dev \
    libopenmpi-dev \
    libquadmath0 \
    libreadline6 \
    libssl-dev \    
    libx11-dev \
    libxext-dev \
    libxft-dev \
    libxml2-dev \
    libxslt1-dev \
    libxss-dev \
    openjdk-8-jdk \
    openmpi-bin \
    python \
    wget

# Setup the user
RUN useradd -ms /bin/bash scipion
WORKDIR /home/scipion/src
RUN chown -R scipion /home/scipion/*
USER scipion:scipion

# Clone the source code into the container
RUN git clone https://github.com/I2PC/scipion.git
WORKDIR /home/scipion/src/scipion
RUN git checkout tags/v1.2 -b build

# Build Scipion and remove unneeded files
RUN echo "n\n" | ./scipion config
RUN ./scipion install -j 8 && ./scipion install \
    chimera \
    ctffind \
    ctffind4 \
    eman \
    frealign \
    relion \
    spider && \
    rm -rf software/tmp/ && \
    rm -rf software/em/*.tgz

# Run the tests
RUN ./scipion tests model.test_object && \
    ./scipion tests model.test_mappers && \
    ./scipion tests em.data.test_data && \
    ./scipion tests em.data.test_convert_xmipp && \
    ./scipion tests em.workflows.test_workflow_spiderMDA && \
    ./scipion tests tests.em.protocols.test_protocols_emx && \
    ./scipion tests tests.em.workflows.test_workflow_xmipp_ctf_discrepancy && \
    ./scipion tests em.workflows.test_workflow_xmipp && \
    ./scipion tests em.workflows.test_workflow_mixed.TestMixedBPV && \
    ./scipion tests em.workflows.test_workflow_mixed.TestMixedBPV2 && \
    rm -rf /home/scipion/ScipionUserData/projects/Test*

# Creates a data directory for accepting inputs
RUN mkdir /home/scipion/data

# The default command to run when the container is launched
CMD ["/home/scipion/src/scipion/scipion", "manager"]
