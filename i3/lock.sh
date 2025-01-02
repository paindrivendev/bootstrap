#lock and show the logo1.png 
i3lock -c 000000

#to turn of display after 10 seconds of locking...
sleep 10 && pgrep i3lock && xset dpms force off
