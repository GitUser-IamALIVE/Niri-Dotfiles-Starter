#!/bin/sh
killall waybar
waybar -c ~/.config/waybar/waybar_2_panel_mode/config1.jsonc -s /home/himanshu/.config/waybar/waybar_2_panel_mode/style.css &
waybar -c ~/.config/waybar/waybar_2_panel_mode/config2.jsonc -s /home/himanshu/.config/waybar/waybar_2_panel_mode/style.css
