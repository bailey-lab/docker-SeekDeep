# docker-SeekDeep
A dockerfile for building a docker with all needed libraries for SeekDeep 

# Building docker image

```bash
git clone https://github.com/bailey-lab/docker-SeekDeep.git
cd docker-SeekDeep
docker build -t seekdeep .
#run the install script to do the actually SeekDeep install
#for the -v option can be any given directory to store seekdeep install files
#this prevents the docker image from getting too big
docker run -ti --rm -v /data/docker/seekdeep/:/mnt seekdeep /root/copyfs.sh
```
#Starting docker container
Start the docker container you can use the runSeekDeepCon.sh script
runSeekDeepCon.sh takes two arguments   
1) data directory  
2) where the seekdeep install files are stored (default: /data/docker/seekdeep/)  

```bash
./runSeekDeepCon.sh data
#or
./runSeekDeepCon.sh data /data/docker/seekdeep/
```
#Using the container
Once the container is started you can put your data into the data directory you can enter the container to run the analysis

```bash
docker exec -ti seekdeep /bin/bash
#now within the container
cd /root/data

#run analysis ...
```
