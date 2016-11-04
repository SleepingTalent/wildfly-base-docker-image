FROM jboss/wildfly:latest

ENV WILDFLY_MANAGEMENT_USER admin
ENV WILDFLY_MANAGEMENT_PASSWORD admin

ENV ARTIFACT_NAME
ENV WAIT_TIME_SECS 30
ENV NETWORK_MODE bridge

ENV JBOSS_CONFIG_FILE

ADD ${ARTIFACT_NAME} /opt/jboss/wildfly/standalone/deployments/
ADD wait-for-it.sh /opt/jboss/wildfly/

# Add the docker entrypoint script
ADD entrypoint.sh /opt/jboss/wildfly/bin/entrypoint.sh
ADD commands.cli /opt/jboss/wildfly/bin/commands.cli

# Change the ownership of added files/dirs to `jboss`
USER root

RUN yum -y install /sbin/ip

# Fix for Error: Could not rename /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history

RUN chown -R jboss:jboss /opt/jboss/wildfly
RUN chmod +x /opt/jboss/wildfly/bin/entrypoint.sh
RUN chmod +x /opt/jboss/wildfly/bin/commands.cli
RUN chmod +x /opt/jboss/wildfly/standalone/configuration/${JBOSS_CONFIG_FILE}
USER jboss

EXPOSE 8080 9990 9999 8009 45700 7600 57600

EXPOSE 23364/udp 55200/udp 54200/udp 45688/udp

ENTRYPOINT ["/opt/jboss/wildfly/bin/entrypoint.sh"]
