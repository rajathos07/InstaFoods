# Use Tomcat 10.1 with JDK 21 as base image (matches compile target)
FROM tomcat:10.1-jdk21-openjdk-slim

# Remove default Tomcat root application
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy webapp static files, JSPs, and configurations to the ROOT webapp directory
COPY src/main/webapp /usr/local/tomcat/webapps/ROOT

# Copy compiled classes into the deployment folder inside Tomcat
COPY build/classes /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
