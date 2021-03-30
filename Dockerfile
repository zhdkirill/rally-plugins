FROM xrally/xrally:3.2.0

# install rally plugins
COPY . /rally/rally-plugins
RUN pip3 install --upgrade /rally/rally-plugins

COPY run-scale-scenarios.sh /
WORKDIR /home/rally
