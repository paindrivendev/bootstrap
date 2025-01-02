#!/usr/bin/env sh

# Define the monitor names
office_monitor="DP-2-1"
home_monitor="DP-2"
laptop_monitor="eDP-1"  # Replace with your laptop monitor name

# Function to update the polybar config
update_polybar_config() {
  sed -i "s/monitor = .*/monitor = $1/" ~/.config/polybar/config
  sed -i "s/monitor-fallback = .*/monitor-fallback = $2/" ~/.config/polybar/config
}

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Check if the office monitor is connected
if xrandr | grep -q "$office_monitor connected"; then
  update_polybar_config "$office_monitor" "$laptop_monitor"

# Check if the home monitor is connected
elif xrandr | grep -q "$home_monitor connected"; then
  update_polybar_config "$home_monitor" "$laptop_monitor"

# Fallback to the laptop monitor
else
  update_polybar_config "$laptop_monitor" "$laptop_monitor"
fi

# Launch polybar
polybar PolybarTop -r &
