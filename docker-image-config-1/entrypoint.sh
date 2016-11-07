#!/bin/sh

# Create default app server users
if [[ ! -z "${WILDFLY_MANAGEMENT_USER}" ]] && [[ ! -z "${WILDFLY_MANAGEMENT_PASSWORD}" ]]
then
	echo "=> add-user-process: creating jboss users"
    ${JBOSS_HOME}/bin/add-user.sh --silent -e -u ${WILDFLY_MANAGEMENT_USER} -p ${WILDFLY_MANAGEMENT_PASSWORD}
	echo "=> add-user-process: jboss users have been created"
fi

#sed -i "s/@MODCLUSTER_HOST@/${MODCLUSTER_HOST}/" ${JBOSS_HOME}/bin/commands.cli
#sed -i "s/@MODCLUSTER_PORT@/${MODCLUSTER_PORT}/" ${JBOSS_HOME}/bin/commands.cli

sed -i "s/@MODCLUSTER_HOST@/${MODCLUSTER_HOST}/" ${JBOSS_HOME}/standalone/configuration/standalone-ha-with-gossip.xml
sed -i "s/@MODCLUSTER_PORT@/${MODCLUSTER_PORT}/" ${JBOSS_HOME}/standalone/configuration/standalone-ha-with-gossip.xml
sed -i "s/@GOSSIP_ROUTER_HOST@/${GOSSIP_ROUTER_HOST}/" ${JBOSS_HOME}/standalone/configuration/standalone-ha-with-gossip.xml
sed -i "s/@GOSSIP_ROUTER_PORT@/${GOSSIP_ROUTER_PORT}/" ${JBOSS_HOME}/standalone/configuration/standalone-ha-with-gossip.xml


if [ "${NETWORK_MODE}" = "host" ]
then
	IPADDR=$(ip a s eth0 | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')
else
	IPADDR=$(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')
fi

#echo "=> configuration-process: starting WildFly server"
#${JBOSS_HOME}/bin/standalone.sh -c standalone-ha.xml -Djboss.bind.address=$IPADDR -Djboss.bind.address.management=$IPADDR -Djboss.bind.address.private=$IPADDR -Djboss.node.name=$HOSTNAME-$IPADDR > /dev/null &
#echo "=> configuration-process: waiting for WildFly to start on $IPADDR"


#echo "=> configuration-process: sleeping for ${WAIT_TIME_SECS} seconds"
#sleep ${WAIT_TIME_SECS}
#echo "=> configuration-process: waking up"
	
#echo "=> configuration-process: checking that WildFly standalone has started"
#${JBOSS_HOME}/wait-for-it.sh $IPADDR:9990 -- echo "=> configuration-process: WildFly standalone has started"
	
#echo "=> configuration-process: executing cli commands"
#${JBOSS_HOME}/bin/jboss-cli.sh -connect controller=$IPADDR:9999 --user=${WILDFLY_MANAGEMENT_USER} --password=${WILDFLY_MANAGEMENT_PASSWORD} --file=`dirname "$0"`/commands.cli
#${JBOSS_HOME}/bin/jboss-cli.sh -c --controller=$IPADDR:9990 --user=${WILDFLY_MANAGEMENT_USER} --password=${WILDFLY_MANAGEMENT_PASSWORD} --file=${JBOSS_HOME}/bin/commands.cli
#${JBOSS_HOME}/bin/jboss-cli.sh -c --file=`dirname "$0"`/commands.cli

#echo "=> configuration-process: shutting down WildFly"
#${JBOSS_HOME}/bin/jboss-cli.sh -c --controller=$IPADDR:9990 --user=${WILDFLY_MANAGEMENT_USER} --password=${WILDFLY_MANAGEMENT_PASSWORD} --command=":shutdown"
#echo "=> configuration-process: configuration complete"

echo "=> starting Standalone WildFly with HOSTNAME:IPAddress : $HOSTNAME:$IPADDR"

exec ${JBOSS_HOME}/bin/standalone.sh -c standalone-ha-with-gossip.xml -Djboss.bind.address=$IPADDR -Djboss.bind.address.management=$IPADDR -Djboss.bind.address.private=$IPADDR -Djboss.node.name=$HOSTNAME-$IPADDR

