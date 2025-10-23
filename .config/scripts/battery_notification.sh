#!/bin/bash
# Low battery notifier

# Kill already running processes
already_running="$(ps -fC 'grep' -N | grep 'battery_notification.sh' | wc -l)"
if [[ $already_running -gt 1 ]]; then
	pkill -f --older 1 'battery_notification.sh'
fi

while [[ 0 -eq 0 ]]; do
	battery_status="$(cat /sys/class/power_supply/BAT0/status)"
	battery_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
	if [[ $battery_status == 'Discharging' && $battery_capacity -le 20  ]]; then
		if [[ $battery_capacity -le 10 ]]; then
			notify-send --icon="$(pwd)/assets/battery_critical.svg" "Battery critical !" "$battery_capacity% remaining. Please consider plug in NOW your PC."
			sleep 300
		else
			notify-send --icon="$(pwd)/assets/battery_low.svg" "Battery low !" "$battery_capacity% remaining. You might want plug in your PC."
			sleep 300
		fi
	else
		sleep 300
	fi
	
done;	
