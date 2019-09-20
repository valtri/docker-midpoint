# Info

midPoint identity manager on Debian 9/stretch.

Homepage: [http://evolveum.com](http://evolveum.com)

Documentation: [https://wiki.evolveum.com/display/midPoint/Home](https://wiki.evolveum.com/display/midPoint/Home)

# Launch

Download:

    docker pull valtri/docker-midpoint

Launch:

    docker run -itd --name midpoint valtri/docker-midpoint

More advanced usage (separated data, directory with Oracle driver):

    mkdir midpoint-home/
    chmod 0777 midpoint-home/
    #for RedHat: chcon -Rt svirt_sandbox_file_t midpoint-home/
    
    docker run -itd --name midpoint -v `pwd`/midpoint-home:/var/opt/midpoint -v $ORACLE_HOME:$ORACLE_HOME:ro valtri/docker-midpoint

# Connect

Web interface (replace the IP by real value):

* URL: **http://172.17.0.2:8080/midpoint**
* User: **administrator**
* Password: **5ecr3t**

AJP interface (for example with *mod\_jk* and *Apache*):

* worker host: **172.17.0.2** (replace IP by real value)
* worker port: **8009**

The IP address may be obtained:

    docker inspect -f '{{.NetworkSettings.IPAddress}}' midpoint

# Admin

    docker exec -it midpoint /bin/bash -l

# Tags

* **4.0**, **latest**: midPoint 4.0
* **3.9**: midpoint 3.9
* **3.8**: midpoint 3.8
* **3.7.2**: midPoint 3.7.2
* **3.6.1**: midPoint 3.6.1
* **3.5.1**: midPoint 3.5.1
* **3.4.1**: midPoint 3.4.1
* **3.3.1**: midPoint 3.3.1
