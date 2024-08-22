#!/bin/sh

BLINK_FUNCTION=1
OUTPUT=2

LOW=0
HIGH=1

setState()
{       #Verifica se o pino está exportado para o sistema
	if [ -l "/sys/class/gpio/gpio$PIN" ];then
	echo "$1" > "/sys/class/gpio/gpio$PIN/value"
	return
	fi
	dialog --infobox "O pino não esta disponivel no sistema..." 5 55

	sleep 1
	return
}

while true; do

	PINS=""

	for i in 1 2 4 6 9 26 27; do
		PINS="$PINS $i 'GPIO_$i'"
	done

	PIN=$(dialog --title 'Sistema - GPIO' --menu 'Selecione um pino do header' 15 55 5 $PINS --stdout)

	[ "$PIN" -eq 1] && clear && continue

	echo "$PIN" > "/sys/class/gpio/export"

	FUNCTION=$(dialog --title "Sistema - Direction" --menu "Selecione a direcao" 15 55 5 1 "BLINK" 2 "SET" --stdout)

	if [ "$FUNCTION" -eq $BLINK_FUNCTION ]; then
	echo "out" > "/sys/class/gpio/gpio$PIN/direction"

	dialog --infobox "Piscando o led por 10 segundos" 5 55

	for item in 1 2 3 4 5 6 7 8 9 10; do
		if [ $((item%2)) -eq 0 ]; then
			setState $HIGH
			sleep 1
		else
			setState $LOW
			sleep 1
		fi
		done

		setState $LOW

		clear && continue
	fi

	DIRECTION=$(dialog --title "Sistema - Direction" --menu "Selecione a direcao" 15 55 5 1 "INPUT" 2 "OUTPUT" --stdout)

	[ "$DIRECTION" -eq 1] && clear && continue

	if ["$DIRECTION" -eq $OUTPUT ]; then
		["$(cat "/sys/class/gpio/gpio$PIN/direction")" = "out" ] && echo "out" > "/sys/class/gpio/gpio$PIN/direction"
		STATE=$(dialog --title "Sistema - State" --menu "Selecione a opcao" 15 55 5 0 "LOW" 1 "HIGH" --stdout)
		if [ "$STATE" - eq "$HIGH" ]; then
			setState $HIGH
		else
			setState $LOW
		fi
	else
		echo "in" > "/sys/class/gpio/gpio$PIN/direction"
	fi

	echo "$PIN" > "/sys/class/gpio/unexport"

	[ "$STATE" - eq 1 ] && clear && continue

done
