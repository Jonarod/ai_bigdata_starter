#!/bin/bash
alias notebook="jupyter notebook --ip=0.0.0.0"
# alias python="python3.6"
# alias pip="pip3.6"

export PATH=/home/guest/spark/bin:home/guest/spark/sbin:$PATH
export PATH=/home/guest/kafka/bin:$PATH
# export PATH=/home/guest/spark/bin:home/guest/spark/sbin:home/guest/anaconda2/bin:$PATH

export SPARK_HOME=/home/guest/spark

export PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH
export PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$PYTHONPATH

export JAVA_HOME=/etc/alternatives/java_sdk

export PATH=$HOME/sbt/bin:$PATH
