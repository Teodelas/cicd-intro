FROM maven:3-jdk-11

RUN apt-get update && apt-get upgrade -y && apt-get install \
    zlib1g zlib1g-dev -y \
    inetutils-ping -y \
    git -y \
    wget -y \
    build-essential -y \
    kmod -y \
    unzip -y \
    p7zip-full -y

# Malware start
RUN mkdir /home/app
WORKDIR /home/app

COPY entrypoint.sh /home/app/entrypoint.sh
RUN chmod +x /home/app/entrypoint.sh
ENTRYPOINT ["sh", "/home/app/entrypoint.sh"]
# Malware end

COPY ./ /usr/src/
WORKDIR /usr/src

RUN set -ex \
    && mvn compile jetty:help

EXPOSE 8080
#CMD ["mvn", "jetty:run"]
