# reference: https://hub.docker.com/_/debian
FROM debian:buster
# Adds metadata to the image as a key value pair example LABEL version="1.0"
#LABEL maintainer="Your Name <james_clowes@outlook.com>"
# Set environment variables
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
# Install packages
RUN apt-get update && apt-get install -y \
    apt-utils \
    wget \
    bzip2 \
    ca-certificates \
    build-essential \
    curl \
    git-core \
    htop \
    pkg-config \
    unzip
# Install Miniconda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
RUN /bin/bash ~/miniconda.sh -b -p /opt/conda
RUN rm ~/miniconda.sh
# Set path to conda
ENV PATH /opt/conda/bin:$PATH
# Update Miniconda
RUN conda update conda && conda update --all
# Add group and user for permissions
ARG USER_ID
ARG GROUP_ID
RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
RUN chgrp -R user /opt/conda && chmod 770 -R /opt/conda
USER user
# Install gcloud SDK
RUN curl https://sdk.cloud.google.com > ~/install.sh
RUN bash ~/install.sh --disable-prompts
# Add gcloud SDK to PATH and allow gcloud path completion
ENV PATH /home/user/google-cloud-sdk/bin:$PATH
# Create empty directory to attach volume
RUN mkdir /home/user/source
# Install other Python packages
RUN conda config --env --add channels conda-forge && conda config --set channel_priority strict
# Install python modules with conda
RUN conda install -c conda-forge \
pandas \
scikit-learn \
matplotlib \
seaborn \
notebook \
pyarrow \
google-cloud-bigquery \
google-cloud-storage \
gitpython \
pystan
# Configure access to Jupyter
WORKDIR /home/user/source
EXPOSE 8888
CMD jupyter-notebook --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token='stan'