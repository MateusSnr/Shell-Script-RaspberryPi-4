#!/bin/bash

#Variável global
GPIO=""

#Função para selecionar o GPIO
gpio_select(){
	GPIO=$(dialog --stdout --inputbox "Insira o número do GPIO desejado:" 8 40)
	if [ $? -ne 0 ]; then
		exit 1
	fi
}

#Função para configurar o GPIO
gpio_config(){
	option=$(dialog --stdout --menu "Configure o GPIO $GPIO:" 15 50 2 \
		1 "Configura como Entrada" \
		2 "Configura como saída")

	case $option in
	1)
		#Configura o GPIO como entrada
		echo "in" > /sys/class/gpio/gpio$GPIO/direction
		#Informa o valor atual do GPIO selecionado
		value = $(cat /sys/class/gpio/gpio$GPIO/value)
	        dialog --msgbox "O valor atual do GPIO $GPIO é: $value" 6 40;;
	2)
		#Configura o GPIO como saída
		echo "out" > /sys/class/gpio/gpio$GPIO/direction
		#Configura o estado desejado pelo usuário
		state=$(dialog --stdout --menu "Insira o estado do GPIO $GPIO:" 15 50 2 \
			1 "HIGH (1)"  \
			0 "LOW (0)")
		echo $state >  /sys/class/gpio/gpio$GPIO/value
		dialog --msgbox "O estado do GPIO $GPIO foi configurado para: $state" 6 40
		;;
	*)
		dialog --msgbox "Opção inválida." 6 40
		exit 1
		;;
	esac
}

#Função para exportar o GPIO
gpio_export(){
	if [ ! -e /sys/class/gpio/gpio$GPIO ]; then
		echo $GPIO > /sys/class/gpio/export
	fi
}

#Main
gpio_select
gpio_export
gpio_config

dialog --msgbox "Configuração do GPIO concluída com sucesso!" 6 40

dialog --clear
