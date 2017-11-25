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

* URL: **http://172.17.0.2/midpoint**
* User: **administrator**
* Password: **5ecr3t**

The IP address may be obtained:

    docker inspect -f '{{.NetworkSettings.IPAddress}}' midpoint

# Admin

    docker exec -it midpoint /bin/bash -l

# Tags

* **3.6.1**, **latest**: midPoint 3.6.1
* **3.6**: midPoint 3.6
* **3.5.1**: midPoint 3.5.1
* **3.4.1**: midPoint 3.4.1
* **3.3.1**: midPoint 3.3.1
