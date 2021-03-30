FROM xrally/xrally:3.2.0

# install rally plugins
COPY . /rally/rally-plugins
RUN sudo pip3 install --use-feature=2020-resolver --upgrade /rally/rally-plugins

COPY run-scale-scenarios.sh /
WORKDIR /home/rally
