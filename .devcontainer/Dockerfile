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
    python3-pip \
    libftdi-dev \
    python3-dev \
    libboost-all-dev \
    cmake \
    autoconf \
    gperf \
    zsh \
    libeigen3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Make a temp folder for the tools
RUN mkdir /tools
WORKDIR /tools

# Install icestorm tools
RUN git clone https://github.com/YosysHQ/icestorm.git icestorm && \
    cd icestorm && \
    make -j$(nproc) && \
    make install

# Install nextpnr
RUN git clone https://github.com/YosysHQ/nextpnr nextpnr && \
    cd nextpnr && \
    cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local . && \
    make -j$(nproc) && \
    make install

# Install Icarus Verilog
RUN git clone https://github.com/steveicarus/iverilog.git iverilog && \
    cd iverilog && \
    sh autoconf.sh && \
    ./configure && \
    make -j$(nproc) && \
    make install

# clean up
RUN rm -rf /tools

# Install cocotb
RUN pip3 install cocotb pytest

# Set the working directory
WORKDIR /workspace

# make the gen_bitstream script executable anywhere
COPY gen_bitstream.sh /usr/local/bin/gen_bitstream
RUN chmod +x /usr/local/bin/gen_bitstream

# make the iceprog_raspi script executable anywhere
COPY iceprog_raspi.sh /usr/local/bin/iceprog_raspi
RUN chmod +x /usr/local/bin/iceprog_raspi

COPY Go_Board_Pin_Constraints.pcf /keep/Go_Board_Pin_Constraints.pcf

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    chsh -s $(which zsh)

# Set the entrypoint to zsh
ENTRYPOINT ["/bin/zsh"]