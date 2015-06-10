FROM unidata/idv-gui

###
# Install Python, pip, pyhiccup as root
###

USER root

RUN apt-get update && apt-get install -y git python python-imaging

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"

RUN python get-pip.py

RUN pip install --upgrade pip

###
# A couple of Python HTML conveniences for generating HTML output. Pillow is
# for image manipulation.
###

RUN pip install pyhiccup html5print Pillow

USER idv

COPY starttest.sh /home/idv/

RUN git clone https://github.com/Unidata/idv-test /home/idv/idv-test

WORKDIR /home/idv 
