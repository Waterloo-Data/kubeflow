# Use the respective Makefile to pass the appropriate BASE_IMG and build the image correctly
ARG BASE_IMG=<jupyter-pytorch-cuda>
FROM $BASE_IMG
ENV DEBIAN_FRONTEND noninteractive


# install - requirements.txt
COPY --chown=jovyan:users requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir \
 && rm -f /tmp/requirements.txt

# PDF Tools
USER root

RUN apt-get update && apt -y install \
#	libqpdf-dev \
#	libpoppler-dev \
	poppler-utils \
	tesseract-ocr \
#	tesseract-ocr-deu \
	build-essential \
	cmake \
	nvidia-384 \
	&& apt-get clean

#RUN pip install deepdoctection[pt]

#RUN cd /usr/local/src && \
#    git clone https://github.com/Waterloo-Data/lexpredict-lexnlp.git lexnlp && \
#    cd lexnlp
#RUN /bin/bash -c "cd /usr/local/src/lexnlp && python setup.py install"

RUN pip install -e git+https://github.com/deepdoctection/deepdoctection.git#egg=deepdoctection[source-pt]

#RUN cd /usr/local/src && \
#	git clone https://github.com/qpdf/qpdf.git && \
#	cd qpdf && \
#	cmake -S . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo && \
#	cmake --build build && \
#	cp /usr/local/src/qpdf/build/qpdf/qpdf /usr/bin && \
#	cp /usr/local/src/qpdf/build/libqpdf/*.so* /usr/lib && \
#	cp /usr/local/src/qpdf/build/libqpdf/*.a /usr/lib && \
#	rm -rf /usr/local/src/qpdf
#	cmake -S . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo && \
#	cmake --build build --parallel --target libqpdf libqpdf_static && \
#	cmake --install build --component lib && \
#	cmake --install build --component dev

# RUN cpack
#RUN cmake --install /usr/bin

#RUN	cp /usr/local/src/qpdf/build/qpdf/qpdf /usr/bin
#RUN	cp /usr/local/src/qpdf/build/libqpdf/*.so* /usr/lib
#RUN	cp /usr/local/src/qpdf/build/libqpdf/*.a /usr/lib

#RUN	rm -rf /usr/local/src/qpdf

RUN wget -qO /usr/local/bin/ninja.gz https://github.com/ninja-build/ninja/releases/latest/download/ninja-linux.zip \
	&& gunzip /usr/local/bin/ninja.gz \
	&& chmod a+x /usr/local/bin/ninja

USER ${NB_UID}

RUN python -c "import torch; roberta = torch.hub.load('pytorch/fairseq', 'roberta.large')"

RUN python -m spacy download en_core_web_md


#RUN qpdf
