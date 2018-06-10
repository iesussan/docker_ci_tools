# Docker ci/cd play tools

A custom docker imagen for a development enviroment of [Jenkins](https://jenkins.io/). I used some original files from  [docker](https://github.com/jenkinsci/docker)  [Jenkins](https://jenkins.io/) repository to create it. Yes! Yes! I KNOW IT! this is another jenkins image in docker ... but this one includes little toys that will make your life easier to get into "DevOps' World".

!!! mysterious background music !!!

![alt text](https://media1.tenor.com/images/d0af1e714dfb82b58847086e8d35314c/tenor.gif?itemid=7256015 "HA HA HA")

## What does this image contain?

By default:

* `jenkins version: 2.107.3`
* `ansible version: >= 2.5.2`
* `maven version: 3.3.9`
* `gradle version: 2.4.2.0`

## Usage

Clone the repository and follow this lines

```sh
git clone https://github.com/is-daimonos/docker_ci_tools
cd docker_ci_tools
sudo mkdir -p /var/lib/docker/Volumes/jenkins-full
sudo chown 2000:2000 /var/lib/docker/Volumes/jenkins-full
```

To build it (Basic build):

```sh
docker build -t isdaimonos/jenkins-full:latest -f Dockerfile.dockerfile .
```

To run it:

```sh
docker run --restart on-failure --name jenkins-full --dns 8.8.8.8 -d -p 8080:8080 -p 50000:50000 -v /var/lib/docker/Volumes/jenkins-full:/var/jenkins_home isdaimonos/jenkins-full:latest
```

**Note**: Set selinux in permissive mode to avoid problems.

```sh
sudo setenforce 0
sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
```

## Extended usage

Sending extra vars like JVM params

```sh
docker run --restart on-failure --name jenkins-full --dns 8.8.8.8 -d -p 8080:8080 -p 50000:50000 -v /var/lib/docker/Volumes/jenkins-full:/var/jenkins_home --env JAVA_OPTS="-Dhudson.footerURL=http://myhost -Djava.awt.headless=true" isdaimonos/jenkins-full:latest
```

After it, you will run the following command

```sh
docker logs -f jenkins-full
```

you should see the following logs

![alt text](images/jenkins_inital_password.png "jenkins initial password")

Copy the string and open your browser (I hope you have the IP of the docker host) http://yourip:8080

![alt text](images/unlock_jenkins.png "jenkins initial password")

Paste it! and press continue!!! The next two steps make the selection you want.
