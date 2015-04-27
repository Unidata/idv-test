FROM unidata:idv-gui

###
# Install Python, pip, pyhiccup as root
###

USER root

RUN apt-get install -y python python-imaging

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"

RUN python get-pip.py

RUN pip install --upgrade pip

# A couple of Python HTML conveniences for generating HTML output
RUN pip install pyhiccup html5print Pillow

USER idv

###
# Some directories to be used by the tests
###

RUN mkdir -p ~/test-output/results

RUN mkdir ~/test-output/baseline
