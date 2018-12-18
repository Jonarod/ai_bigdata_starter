# Docker for Artificial Inteligence and Big Data

```bash
docker run -it --rm --privileged -v `pwd`:/home/guest/host -p 23:22 -p 4040:4040 -p 5601:5601 -p 8888:8888 -p 9200:9200 -p 9300:9300 jonarod/ai_bigdata_starter
```

Comes with:
- **Spark** for parallelized computation
- **Kafka** for Publish / Subscribe messaging
- **Anaconda** for Data Science using Python (pre-installs sci-kit learn, pandas, numpy...)
- **Cassandra** for clusterized storage
- **ElasticSearch** for indexing and fast front-end API generation
- **Kibana** for ElasticSearch's exploration and visualisation
- **Jupyter notebook** as clean coding IDE using Ipython
- **Selenium + Firefox + Geckodriver** for accurate web-scraping (executes javascript using an headless browser)


# Get started

First of all, start the container:

```bash
docker run -it --rm --privileged -v `pwd`:/home/guest/host -p 23:22 -p 4040:4040 -p 5601:5601 -p 8888:8888 -p 9200:9200 -p 9300:9300 jonarod/ai_bigdata_starter
```

The command will start a pseudo-tty session in bash. There you can start services all at once using:

```bash
startup_script.sh
```

Wait around 1 mn for all services to start.

Alternatively, you can start services one by one:

**Start ssh:**
```bash
service sshd start
```

**Start cassandra:**
```bash
service cassandra start
```

**Start ElasticSearch:**
```bash
service elasticsearch start
```

**Start Kibana:** (make sure to start ElasticSearch first as kibana depends on it) 
```bash
service kibana start
```

**Start Kafka:** 
kafka needs a bit more overhead as it needs **zookeeper** to run properly.
```bash
# start zookeeper first
$HOME/kafka/bin/zookeeper-server-start.sh $HOME/kafka/config/zookeeper.properties  > /home/guest/zookeeper.log 2>&1 &

# then start a broker
$HOME/kafka/bin/kafka-server-start.sh $HOME/kafka/config/server.properties > /home/guest/kafka.log 2>&1 &
```

**Start jupyter notebook:**
```bash
notebook --allow-root
```



**PRO-TIPS:**
Using proper docker commands you can:

Start one service using one line:
```bash
docker run -it -p 8888:8888 -v `pwd`:/home/guest/host jonarod/ai_bigdata_starter jupyter notebook --ip=0.0.0.0 --allow-root
```

Enter in a running container:
```
# first check running docker instances:
docker ps

CONTAINER ID        IMAGE                        COMMAND      CREATED             STATUS              PORTS                    NAMES
490ac3c59958        Jonarod/ai_bigdata_starter   "..."        18 seconds ago      Up 17 seconds       0.0.0.0:8888->8888/tcp   gifted_galileo

# Then run
docker exec -it <RUNNING DOCKER ID HERE> bash
```


Install other packages:
```bash
docker exec <RUNNING CONTAINER ID HERE> pip install xgboost
```


```bash
docker exec <RUNNING CONTAINER ID HERE> yum install unzip
```

