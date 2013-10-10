while true;
do

PROCESOSJ=`ps ux | awk '/leer_xbee/ && !/awk/ {print $2}'`

if [ -z "$PROCESOSJ" ]
then
  echo "\$PROCESOSJ is null."
  cd /apps/proyectos/wsn/xbee
  nohup ./leer_xbee.sh &
else
  echo "\$PROCESOSJ is NOT null."
fi

  sleep 30

done
