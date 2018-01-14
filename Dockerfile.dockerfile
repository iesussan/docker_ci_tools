FROM centos:centos7
LABEL Jesus Sanchez <sanchezajesus@gmail.com>
LABEL docker build -t isdaimonos/centos/jenkins-full:latest -f Dockerfile.dockerfile .
LABEL docker run --name jenkins-full -d -p 8080:8080 -p 50000:50000 -v /var/lib/docker/Volumes/jenkins-full:/var/jenkins_home isdaimonos/centos/jenkins-full:latest

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG ansible_version=2.4.2.0
ARG jenkins_version=2.89.2
ARG gradle_version=4.3
ARG maven_version=3.3.9

ENV DEFAULT_MAVEN_DIR="/opt/maven" \
    MAVEN_VERSION="${maven_version}" \
    DEFAULT_GRADLE_DIR="/opt/gradle" \
    GRADLE_VERSION="${gradle_version}" \
    JENKINS_HOME="/var/jenkins_home" \
    JENKINS_SLAVE_AGENT_PORT="${agent_port}" \
    JENKINS_VERSION="${jenkins_version}" \
    JENKINS_UC="https://updates.jenkins.io" \
    JENKINS_UC_EXPERIMENTAL="https://updates.jenkins.io/experimental" \
    ANSIBLE_VERSION="${ansible_version}" \
    JAVA_VERSION="8u151" \
    JAVA_BUILD="8u151-b12" \
    JAVA_DL_HASH="e758a0de34e24606bca991d704f6dcbf" \
    JAVA_HOME="/opt/java"

ENV COPY_REFERENCE_FILE_LOG="${JENKINS_HOME}/copy_reference_file.log" \
    PATH="$PATH:$JAVA_HOME/bin"

# Install prepare infrastructure
RUN yum -y install epel-release \
    && yum install -y wget curl unzip python git bash python2-pip \
                less openssl openssh-client p7zip py-lxml py-pip rsync sshpass sudo \
                subversion vim zip bash ttf-dejavu coreutils openssh-client  \
                build-dependencies python-dev libffi-dev openssl-dev build-base \
                && wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
                                               http://download.oracle.com/otn-pub/java/jdk/${JAVA_BUILD}/${JAVA_DL_HASH}/jdk-${JAVA_VERSION}-linux-x64.tar.gz \
                && tar -xvf jdk-${JAVA_VERSION}-linux-x64.tar.gz \
                && rm jdk*.tar.gz \
                && mv jdk* ${JAVA_HOME} \
                && pip install --upgrade pip cffi \
                && pip install ansible==$ANSIBLE_VERSION \
                && wget http://www-eu.apache.org/dist/maven/maven-3/"$MAVEN_VERSION"/binaries/apache-maven-"$MAVEN_VERSION"-bin.tar.gz -P /tmp \
                && wget https://services.gradle.org/distributions/gradle-"$GRADLE_VERSION"-bin.zip -P /tmp \
                && mkdir -p "/opt/maven/$MAVEN" \
                && tar -xvzf /tmp/apache-maven-"$MAVEN_VERSION"-bin.tar.gz -C "$DEFAULT_MAVEN_DIR" \
                && unzip /tmp/gradle-"$GRADLE_VERSION"-bin.zip -d "$DEFAULT_GRADLE_DIR" \
                && ln -s "$DEFAULT_MAVEN_DIR/apache-maven-$MAVEN_VERSION/bin/mvn" /usr/bin/mvn \
                && ln -s "$DEFAULT_GRADLE_DIR/gradle-$GRADLE_VERSION/bin/gradle" /usr/bin/gradle \
                && rm -rf /var/cache/apk/* \
                && mkdir -p /etc/ansible \
                && echo 'localhost' > /etc/ansible/hosts \
                && groupadd -g ${gid} ${group} \
                && adduser -d "$JENKINS_HOME" -u ${uid} -g ${group} -s /bin/bash ${user} \
                && mkdir -p /opt/jenkins \
                && wget https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war  -P /usr/share/jenkins/ \
                && mv /usr/share/jenkins/jenkins-war-${JENKINS_VERSION}.war /usr/share/jenkins/jenkins.war \
                && chown ${user}:${user} -Rv /opt $JENKINS_HOME /usr/share/jenkins /etc/ansible \
                && rm -rf jdk-${JAVA_VERSION}-linux-x64.tar.gz 

USER ${user}
WORKDIR ${JENKINS_HOME}
COPY ["jenkins-support","jenkins.sh", "/usr/local/bin/"]
ENTRYPOINT ["bash", "/usr/local/bin/jenkins.sh"]