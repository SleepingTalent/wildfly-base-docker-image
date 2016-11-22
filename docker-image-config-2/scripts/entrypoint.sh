#!/bin/sh

echo "=> add-user-process: creating jboss users"
${JBOSS_HOME}/bin/add-user.sh --silent -e -u ${WILDFLY_MANAGEMENT_USER} -p ${WILDFLY_MANAGEMENT_PASSWORD}
echo "=> add-user-process: jboss users have been created"

sed -i "s,@DB_URL@,${DB_URL}," ${JBOSS_HOME}/bin/commands.cli
sed -i "s,@DB_USER@,${DB_USER}," ${JBOSS_HOME}/bin/commands.cli
sed -i "s,@DB_PASSWORD@,${DB_PASSWORD}," ${JBOSS_HOME}/bin/commands.cli

sed -i "s,@SOLR_URL@,${SOLR_URL}," ${JBOSS_HOME}/bin/commands.cli
sed -i "s,@SOLR_INDEX_USER@,${SOLR_INDEX_USER}," ${JBOSS_HOME}/bin/commands.cli
sed -i "s,@SOLR_INDEX_PASSWORD@,${SOLR_INDEX_PASSWORD}," ${JBOSS_HOME}/bin/commands.cli

if [ "${NETWORK_MODE}" = "host" ]
then
	IPADDR=$(ip a s eth0 | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')
else
	IPADDR=$(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')
fi

echo "=> configuration-process: using WildFly Config : ${JBOSS_CONFIG}"

echo "=> configuration-process: starting WildFly server"
${JBOSS_HOME}/bin/standalone.sh -c ${JBOSS_CONFIG} -Djboss.bind.address=$IPADDR -Djboss.bind.address.management=$IPADDR -Djboss.bind.address.private=$IPADDR -Djboss.node.name=$HOSTNAME-$IPADDR > /dev/null &
echo "=> configuration-process: waiting for WildFly to start on $IPADDR"
	
echo "=> configuration-process: sleeping for ${WAIT_TIME_SECS} seconds"
sleep ${WAIT_TIME_SECS}
echo "=> configuration-process: waking up"	
	
echo "=> configuration-process: checking that WildFly has started"
${JBOSS_HOME}/wait-for-it.sh $IPADDR:9990 -- echo "=> configuration-process: WildFly has started"
	
echo "=> configuration-process: executing cli commands"
${JBOSS_HOME}/bin/jboss-cli.sh -c --controller=$IPADDR:9990 --user=${WILDFLY_MANAGEMENT_USER} --password=${WILDFLY_MANAGEMENT_PASSWORD} --file=${JBOSS_HOME}/bin/commands.cli

echo "=> configuration-process: shutting down WildFly"
${JBOSS_HOME}/bin/jboss-cli.sh -c --controller=$IPADDR:9990 --user=${WILDFLY_MANAGEMENT_USER} --password=${WILDFLY_MANAGEMENT_PASSWORD} --command=":shutdown"
echo "=> configuration-process: configuration complete"

echo "=> starting Standalone WildFly with HOSTNAME:IPAddress : $HOSTNAME:$IPADDR"

exec ${JBOSS_HOME}/bin/standalone.sh -c ${JBOSS_CONFIG} -Djboss.bind.address=$IPADDR -Djboss.bind.address.management=$IPADDR -Djboss.bind.address.private=$IPADDR -Djboss.node.name=$HOSTNAME-$IPADDR

