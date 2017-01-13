FROM joov/rpi-opencv-dlib-torch
MAINTAINER Gaurav Kaila <gaurav.kaila@outlook.com>
 
# work-around for accessing git repos
RUN git config --global url.https://github.com/.insteadOf git://github.com/

# install python packages
RUN sudo apt-get upgrade -y
RUN sudo apt-get install python-setuptools -y
RUN sudo apt-get install python-dev build-essential -y
RUN apt-get install vim -y
RUN sudo easy_install pip
RUN pip install pandas
RUN pip install scipy
RUN apt-get install python-sklearn -y 

# install luarocks packages
RUN /torch/install/bin/luarocks install dpnn 
RUN /torch/install/bin/luarocks install nn 
RUN /torch/install/bin/luarocks install optim
#RUN /torch/install/bin/luarocks install csvigo

# openface
ADD . /root/openface
RUN cd ~/openface && \
    ./models/get-models.sh \
    python setup.py install

# Post installation tasks

COPY convert.lua .
COPY nn4.small2.v1.ascii.t7.xz .
RUN unxz nn4.small2.v1.ascii.t7.xz && \
   /torch/install/bin/th convert.lua nn4.small2.v1.ascii.t7 nn4.small2.v1.t7 && \
   mv nn4.small2.v1.t7 /root/openface/models/openface/ && \
   rm nn4.small2.v1.ascii.t7

# Run command to link openface libraries with python
#export PYTHONPATH=/usr/local/lib/python2.7/dist-packages:$PYTHONPATH    


