FROM jboss/wildfly:latest

#Docker Image config for VirtualBridge

# Environment Variables -- start
ENV WILDFLY_MANAGEMENT_USER admin
ENV WILDFLY_MANAGEMENT_PASSWORD admin

ENV DB_URL CHANGE_ME
ENV DB_USER CHANGE_ME
ENV DB_PASSWORD CHANGE_ME

ENV SOLR_URL CHANGE_ME
ENV SOLR_INDEX_USER CHANGE_ME
ENV SOLR_INDEX_PASSWORD CHANGE_ME

ENV MODCLUSTER_HOST modcluster
ENV MODCLUSTER_PORT 80

ENV GOSSIP_ROUTER_HOST 0.0.0.0
ENV GOSSIP_ROUTER_PORT 12001

ENV JBOSS_CONFIG standalone-ha.xml

ENV NETWORK_MODE bridge
ENV WAIT_TIME_SECS 60
# Environment Variables -- end

ADD deployments /opt/jboss/wildfly/standalone/deployments
ADD resources/ojdbc6.jar /opt/jboss/wildfly/

# Add the docker entrypoint script
ADD scripts/entrypoint.sh /opt/jboss/wildfly/bin/entrypoint.sh
ADD scripts/wait-for-it.sh /opt/jboss/wildfly/
ADD scripts/commands.cli /opt/jboss/wildfly/bin/commands.cli

# Change the ownership of added files/dirs to `jboss`
USER root

RUN yum -y install /sbin/ip

# Fix for Error: Could not rename /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history

RUN chown -R jboss:jboss /opt/jboss/wildfly
RUN chmod +x /opt/jboss/wildfly/ojdbc6.jar
RUN chmod +x /opt/jboss/wildfly/bin/entrypoint.sh
RUN chmod +x /opt/jboss/wildfly/bin/commands.cli
USER jboss

EXPOSE 8080 9990 9999 8009 45700 7600 57600

EXPOSE 23364/udp 55200/udp 54200/udp 45688/udp

ENTRYPOINT ["/opt/jboss/wildfly/bin/entrypoint.sh"]
