# Docker ci/cd play tools
A custom docker imagen for a development enviroment of [Jenkins](https://jenkins.io/). I used some original files from  [docker](https://github.com/jenkinsci/docker)  [Jenkins](https://jenkins.io/) repository to create it. Yes! Yes! I KNOW IT! this is another jenkins image in docker ... but this one includes little toys that will make your life easier to get into "DevOps' World".

!!! mysterious background music !!!

![alt text](https://media1.tenor.com/images/d0af1e714dfb82b58847086e8d35314c/tenor.gif?itemid=7256015 "HA HA HA")

# What does this image contain?
by default:
* `jenkins version:2.89.2`
* `ansible version:2.4.2.0`
* `maven version:3.3.9`
* `gradle version:2.4.2.0`

# Usage
to compile it:
```
docker build -t daimonos/jenkins-full:latest -f Dockerfile.dockerfile .
```
to run it:


