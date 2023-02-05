# Use the respective Makefile to pass the appropriate BASE_IMG and build the image correctly
ARG BASE_IMG=<jupyter-pytorch-cuda>
FROM $BASE_IMG

# install - requirements.txt
COPY --chown=jovyan:users requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir \
 && rm -f /tmp/requirements.txt

# LightGBM+cuda
USER root
RUN cd /usr/local/src && \
    git clone https://github.com/Waterloo-Data/lexpredict-lexnlp.git lexnlp && \
    cd lexnlp


RUN /bin/bash -c "cd /usr/local/src/lexnlp && python setup.py install"
USER ${NB_UID}
