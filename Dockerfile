FROM ubuntu:22.04

# Avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies: JDK 21, MySQL Server, wget, curl
RUN apt-get update && apt-get install -y \
    openjdk-21-jdk \
    mysql-server \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download and install Apache Tomcat 10.1.34
RUN wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.34/bin/apache-tomcat-10.1.34.tar.gz -O /tmp/tomcat.tar.gz \
    && mkdir /opt/tomcat \
    && tar -xf /tmp/tomcat.tar.gz -C /opt/tomcat --strip-components=1 \
    && rm /tmp/tomcat.tar.gz

# Remove default Tomcat apps
RUN rm -rf /opt/tomcat/webapps/*

# Set up app directory
WORKDIR /app

# Copy the static webapp files and classes to Tomcat ROOT directory
COPY src/main/webapp /opt/tomcat/webapps/ROOT
COPY build/classes /opt/tomcat/webapps/ROOT/WEB-INF/classes

# Copy schema.sql and entrypoint.sh into the container
COPY schema.sql /app/schema.sql
COPY entrypoint.sh /app/entrypoint.sh

# Give execution permissions to the script
RUN chmod +x /app/entrypoint.sh

# Expose Tomcat port
EXPOSE 8080

# Run entrypoint script
CMD ["/app/entrypoint.sh"]
