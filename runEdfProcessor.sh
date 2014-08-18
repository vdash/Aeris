#!/bin/bash
check_java_process() {

    if [ "$1" = "" ];
    then
        return 0
    fi

    PROCESS_COUNT=`ps -ef | grep "java" | grep "$1" | wc -l`
    if [ $PROCESS_COUNT -eq 1 ];
    then
        return 1
    else
        return 0
    fi

}

JAVA_HOME=/opt/WebServer/jdk1.6.0_17
export JAVA_HOME
export PATH=/usr/local/bin:$JAVA_HOME/bin:$PATH
echo "Starting EDFProcessor"

#Env Setup begins for Log Parsing
EDF_LOGPATH=/opt/aeris/web/logs
export EDF_LOGPATH
if [ -e "${EDF_LOGPATH}/EDFProcessor.log" ]; then
        START_LINE=`wc -l ${EDF_LOGPATH}/EDFProcessor.log | awk '{print $1}'`
else
        START_LINE=0
        TIMESTAMP=`date`
        echo "INFO: ${TIMESTAMP} - EDFProcessor.log doesn't exist."
fi

let START_LINE=${START_LINE}+1
echo "Starting the EDF process from on line number = ${START_LINE}"
#Env Setup completes for Log Parsing

EDF_HOME=/opt/aeris/web/EDFProcessor
export EDF_HOME
MAILTO='noc-notify@aeris.net'

now=`date`
check_java_process "EDFProcessor"
if [ $? -eq 0 ];
then
    echo "$JAVA_HOME/bin/java -Xmx128m -cp $EDF_HOME/lib/*:$EDF_HOME/conf/:$EDF_HOME/EDFProcessor.jar EDFResponseMain $1"

    $JAVA_HOME/bin/java -Xmx128m -cp $EDF_HOME/lib/*:$EDF_HOME/conf/:$EDF_HOME/EDFProcessor.jar EDFResponseMain $1

    touch $EDF_HOME/started
    echo "$now - Started EDF Processor"
else
    echo "$now - EDF Processor Already Running"
    host=`cat /etc/nodename`
    echo "$now - $host - Attempt to start EDF Processor while another instance is already running" | /usr/ucb/Mail -s "EDFProcessor Running Longer than expected" $MAILTO
fi

#This part of the script is to grab the first line of the processing EDF and the last line once finished.
#The code will search each line and if the word error appears it will create a file called EDF_Error_Monitoring.log
#If there is a log with information in it we will populate the log with the whole EDF that was processed and email it to Dhruv and nocsupport
#Once completed we will remove the log file so when it runs again and no error occurs we will not email and echo that there were no errors.

if [ ! -e "${EDF_LOGPATH}/EDFProcessor.log" ]; then
        echo "Severe error with the EDF process, the processor log was not created on" $HOSTNAME | mailx -s "SEVERE!! - EDF Processor log missing on $HOSTNAME" -c ${MAILTO}
else
        END_LINE=`wc -l ${EDF_LOGPATH}/EDFProcessor.log | awk '{print $1}'`
        let END_LINE=${END_LINE}+1
        echo "Parsing the EDFProcessor.log until line number = ${END_LINE}"

        sed -n ${START_LINE},${END_LINE}p ${EDF_LOGPATH}/EDFProcessor.log > ${EDF_LOGPATH}/EDF_Error_Parsing.log
        grep -i "error" ${EDF_LOGPATH}/EDF_Error_Parsing.log > ${EDF_LOGPATH}/EDF_Error_Monitoring.log
        if [ -s "${EDF_LOGPATH}/EDF_Error_Monitoring.log" ]; then
                mailx -s "An EDF Error has occured on $HOSTNAME" -c ${MAILTO} < ${EDF_LOGPATH}/EDF_Error_Parsing.log
        else
                echo "There were no errors in processing the EDF"
        fi
        rm ${EDF_LOGPATH}/EDF_Error_Parsing.log ${EDF_LOGPATH}/EDF_Error_Monitoring.log
fi
#Log Parsing completes.
