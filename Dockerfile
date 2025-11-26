FROM ubuntu:26.04 AS base

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    gfortran \
    build-essential \
    libopenblas-dev \
    liblapack-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

FROM base AS download

ENV DOWLOAD_DIR=/download

RUN mkdir -p $DOWLOAD_DIR

RUN wget -O $DOWLOAD_DIR/libtinfo5_6.3-2ubuntu0.1_amd64.deb  \
    http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb

RUN wget -O $DOWLOAD_DIR/libncurses5_6.3-2ubuntu0.1_amd64.deb \
    http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.3-2ubuntu0.1_amd64.deb

RUN apt install $DOWLOAD_DIR/libtinfo5_6.3-2ubuntu0.1_amd64.deb \
    $DOWLOAD_DIR/libncurses5_6.3-2ubuntu0.1_amd64.deb

FROM download AS galfit

ENV SRC_DIR=/galfit

RUN mkdir -p $SRC_DIR

RUN wget https://users.obs.carnegiescience.edu/peng/work/galfit/galfit3-debian64.tar.gz

RUN tar -xzf galfit3-debian64.tar.gz -C $SRC_DIR \
    && rm galfit3-debian64.tar.gz

RUN ln -s $SRC_DIR/galfit /usr/bin/galfit

#RUN alias galfit /galfit/galfit

#RUN cd $SRC_DIR/cfitsio

#FROM base AS sfdmap
#
#ENV GALSYNTHSPEC_DATA_DIR=/mydata
#ENV SFDMAP_DATA_DIR=/sfddata
#
## Create directories for data
#RUN mkdir -p $GALSYNTHSPEC_DATA_DIR \
#    && mkdir -p $SFDMAP_DATA_DIR
#
#RUN wget https://github.com/kbarbary/sfddata/archive/master.tar.gz
#RUN tar -xzf master.tar.gz -C $SFDMAP_DATA_DIR --strip-components=1 \
#    && rm master.tar.gz
#
#FROM sfdmap AS fsps
#
#ENV SPS_HOME=/fsps
#
#RUN git clone --depth=1 https://github.com/cconroy20/fsps $SPS_HOME
#RUN make --directory=$SPS_HOME/src
#
#FROM fsps AS final
#
## Copy the project files into the container
#COPY . /app
#
## Install Python dependencies
#RUN pip install --no-cache-dir --upgrade pip \
#    && pip install --no-cache-dir -e ".[dev]"
#
## Install pre-commit hooks
#RUN pre-commit install
#
## Set the default command to run the CLI
#ENTRYPOINT ["galsynthspec"]