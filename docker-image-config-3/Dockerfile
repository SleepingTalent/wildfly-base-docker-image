FROM jboss/wildfly:latest

#Docker Image Config for Solr

# Environment Variables -- start
ENV WILDFLY_MANAGEMENT_USER admin
ENV WILDFLY_MANAGEMENT_PASSWORD admin

ENV DB_URL CHANGE_ME
ENV DB_USER CHANGE_ME
ENV DB_PASSWORD CHANGE_ME

ENV ARTIFACT_NAME cluster-demo.war
ENV JBOSS_CONFIG standalone-full.xml

ENV NETWORK_MODE bridge
# Environment Variables -- end

ADD ${ARTIFACT_NAME} /opt/jboss/wildfly/standalone/deployments
ADD ojdbc7.jar /opt/jboss/wildfly/

# Add the docker entrypoint script
ADD entrypoint.sh /opt/jboss/wildfly/bin/entrypoint.sh
ADD wait-for-it.sh /opt/jboss/wildfly/
ADD commands.cli /opt/jboss/wildfly/bin/commands.cli

# Change the ownership of added files/dirs to `jboss`
USER root

RUN yum -y install /sbin/ip

# Fix for Error: Could not rename /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history

RUN chown -R jboss:jboss /opt/jboss/wildfly
RUN chmod +x /opt/jboss/wildfly/ojdbc7.jar
RUN chmod +x /opt/jboss/wildfly/bin/entrypoint.sh
RUN chmod +x /opt/jboss/wildfly/bin/commands.cli
USER jboss

EXPOSE 8080 9990 9999 8009 45700 7600 57600

EXPOSE 23364/udp 55200/udp 54200/udp 45688/udp

ENTRYPOINT ["/opt/jboss/wildfly/bin/entrypoint.sh"]
