# based on https://eecs.blog/lattice-ice40-fpga-icestorm-tutorial/
FROM hdlc/yosys

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    clang \
    bison \
    flex \
    libreadline-dev \
    gawk \
    tcl-dev \
    libffi-dev \
    git \
    mercurial \
    graphviz \
    xdot \
    pkg-config \
    python \
    python3 \
    libftdi-dev \
    python3-dev \
    libboost-all-dev \
    cmake \
    libeigen3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Make a temp folder for the tools
RUN mkdir /Tools
WORKDIR /Tools

# Install icestorm tools
RUN git clone https://github.com/YosysHQ/icestorm.git icestorm && \
    cd icestorm && \
    make -j$(nproc) && \
    make install

# Install arachne-pnr
RUN git clone https://github.com/cseed/arachne-pnr.git arachne-pnr && \
    cd arachne-pnr && \
    make -j$(nproc) && \
    make install

# Install nextpnr
RUN git clone https://github.com/YosysHQ/nextpnr nextpnr && \
    cd nextpnr && \
    cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local . && \
    make -j$(nproc) && \
    make install

# clean up
RUN rm -rf /Tools

# Set the working directory
WORKDIR /workspace

# Copy the entrypoint script into the container
COPY entrypoint.sh /keep/entrypoint.sh
COPY Go_Board_Pin_Constraints.pcf /keep/Go_Board_Pin_Constraints.pcf
RUN chmod +x /keep/entrypoint.sh

# Set the entrypoint to the custom script
ENTRYPOINT ["/keep/entrypoint.sh"]