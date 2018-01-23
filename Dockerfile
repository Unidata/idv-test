FROM  unidata/cloudidv

USER root

###
# gosu is a non-optimal way to deal with the mismatches between Unix user and
# group IDs inside versus outside the container resulting in permission
# headaches when writing to directory outside the container.
###

ENV GOSU_VERSION 1.10

ENV GOSU_URL https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64

RUN gpg --keyserver pgp.mit.edu --recv-keys \
	B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& curl -sSL $GOSU_URL -o /bin/gosu \
	&& chmod +x /bin/gosu \
	&& curl -sSL $GOSU_URL.asc -o /tmp/gosu.asc \
	&& gpg --verify /tmp/gosu.asc /bin/gosu \
	&& rm /tmp/gosu.asc

###
# Install Python, pip, pyhiccup as root
###

RUN apt-get update && apt-get install -y git python python-imaging

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"

RUN python get-pip.py

RUN pip install --upgrade pip

###
# A couple of Python HTML conveniences for generating HTML output. Pillow is
# for image manipulation.
###

RUN pip install pyhiccup html5print Pillow

##
# Set the path
##

ENV PATH $HOME:$PATH

##
# Test script
##

COPY start.sh ${HOME}

RUN chown -R ${CUSER}:${CUSER} ${HOME}

COPY entrypoint.sh ${HOME}

RUN chmod +x ${HOME}/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

CMD ["bootstrap.sh"]
