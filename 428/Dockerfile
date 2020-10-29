FROM gcr.io/deeplearning-platform-release/pytorch-gpu

RUN echo 'jupyter:428-jupyter' | chpasswd
RUN echo 'root:428-jupyter' | chpasswd

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        unzip \
        libssl-dev \
        libffi-dev \
        libbz2-dev \
        libgl1-mesa-glx \
        git \
        sudo \
        openssh-server \
        cmake \
        libncurses5-dev \
        libncursesw5-dev \
        zsh \
        htop

# set up ssh
#RUN sed -i 's/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "Port 2002" >> /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22
EXPOSE 8888

ENV PATH /opt/conda/bin/:$PATH
ENV ZSH "/home/jupyter/.oh-my-zsh"
ENV SHELL_CONFIG "/home/jupyter/.shell_config"

USER jupyter

ENV EXTRA_PATH /opt/conda/bin/:/usr/local/cuda/bin:/usr/local/nvidia/bin
ENV EXTRA_LD_PATH /usr/local/cuda/lib64:/usr/local/nvidia/lib64

ENV PATH $EXTRA_PATH:$PATH
ENV LD_LIBRARY_PATH $EXTRA_PATH:$LD_LIBRARY_PATH

ENV ZSH "/home/jupyter/.oh-my-zsh"
ENV SHELL_CONFIG "/home/jupyter/.shell_config"

USER root

RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

RUN pip install -U \
	poetry \
	tensorboardX \
	h5py \
	opencv-python \
	imageio \
	Pillow \
	scikit-image \
	tqdm \
	jupyter

RUN usermod -aG sudo jupyter

RUN cp /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
RUN chmod a+rx /etc/profile.d/conda.sh

ENV TERM xterm-256color

RUN chsh -s /bin/zsh root
RUN chsh -s /bin/zsh jupyter
ENV SHELL /bin/zsh

RUN mkdir /jupyter-home
RUN chmod u+rwx /jupyter-home
RUN chown jupyter /jupyter-home

USER jupyter
WORKDIR /jupyter-home

RUN git clone https://rnett:85aca048d926a43aaee1e8c6ae44479990f53d3e@github.com/rnett/shell_config.git /jupyter-home/.shell_config

RUN echo "\nexport SHELL_CONFIG='/home/jupyter/.shell_config'" >> /jupyter-home/.shell_config/.zprofile
RUN echo "export PATH=$EXTRA_PATH:\$PATH" >> /jupyter-home/.shell_config/.zprofile
RUN echo "export LD_LIBRARY_PATH=$EXTRA_LD_PATH:\$LD_LIBRARY_PATH" >> /jupyter-home/.shell_config/.zprofile

RUN mkdir .ssh
ADD --chown=jupyter authorized_keys .ssh/authorized_keys

RUN chmod -R og=,u=rwx .ssh

USER root

WORKDIR /nvtop
RUN git clone https://github.com/Syllo/nvtop.git && mkdir -p nvtop/build
WORKDIR /nvtop/nvtop/build

RUN cmake ..

RUN make && make install

WORKDIR /home/jupyter

RUN rm -rf /nvtop

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+rx /entrypoint.sh

ENTRYPOINT su jupyter -c "bash -c /entrypoint.sh" && service ssh start && sleep infinity