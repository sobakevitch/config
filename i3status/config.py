#!/usr/bin/env python3

from i3pystatus import Status

status = Status()

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register(
	"clock",
	format="%Y-%m-%d %H:%M:%S",)

status.register("pulseaudio", format="♪{volume}%",)

# Shows the average load of the last minute and the last 5 minutes
# (the default value for format is used)
# status.register("load")
status.register("cpu_usage")

# Shows your CPU temperature, if you have a Intel CPU
status.register(
	"temp",
	format="{temp:.0f}°C",)

status.register(
	"mem",
	format="{used_mem} MiB",
	color="#FFFFFF",)

# The battery monitor has many formatting options, see README for details

# This would look like this, when discharging (or charging)
# ↓14.22W 56.15% [77.81%] 2h:41m
# And like this if full:
# =14.22W 100.0% [91.21%]
#
# This would also display a desktop notification (via D-Bus) if the percentage
# goes below 5 percent while discharging. The block will also color RED.
# If you don't have a desktop notification demon yet, take a look at dunst:
#   http://www.knopwob.org/dunst/
status.register(
	"battery",
	format="{remaining:%E%hh%Mm}",
	alert=True,
	alert_percentage=15,)
status.register(
	"battery",
	format="{status}/{consumption:.2f}W {percentage:.2f}%",
	alert=True,
	alert_percentage=15,
	status={
		"DIS": "↓",
		"CHR": "↑",
		"FULL": "=",
	},)

# # This would look like this:
# # Discharging 6h:51m
# status.register("battery",
#     format="{status} {remaining:%E%hh:%Mm}",
#     alert=True,
#     alert_percentage=5,
#     status={
#         "DIS":  "Discharging",
#         "CHR":  "Charging",
#         "FULL": "Bat full",
#     },)
#
# Displays whether a DHCP client is running
# status.register("runwatch",
#     name="DHCP",
#     path="/var/run/dhclient*.pid",)

# Shows the address and up/down state of eth0. If it is up the address is shown in
# green (the default value of color_up) and the CIDR-address is shown
# (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
status.register(
	"network",
	interface="enp0s25",
	format_up="↑{bytes_sent} KB/s ↓{bytes_recv} KB/s<span color=\"#777777\">|</span>{interface}: {v4cidr}",
	color_up="#FFFFFF",
	dynamic_color=False,
	format_down="{interface}: DOWN",
	hints={"markup": "pango"},)

# status.register(
# 	"network",
# 	interface="enp0s25",
# 	format_up="↑{bytes_sent} KB/s ↓{bytes_recv} KB/s",
# 	color_up="#FFFFFF",
# 	color_down="#FFFFFF",
# 	format_down="",
# 	dynamic_color=False,
# 	separate_color=False,)

# http://i3pystatus.readthedocs.io/en/latest/i3pystatus.html#module-i3pystatus.network
# Note: requires both netifaces and basiciw (for essid and quality)
# status.register("network",
#     interface="wlp3s0",
#     format_up="{essid} {quality:03.0f}%",)
# status.register(
# 	"network",
# 	interface="wlp3s0",
# 	format_up="W: {v4cidr}",
# 	color_up="#FFFFFF",
# 	format_down="W: DOWN",
# 	separate_color=True,)
# 
# 
# status.register(
# 	"network",
# 	interface="wlp3s0",
# 	format_up="↑{bytes_sent} KB/s ↓{bytes_recv} KB/s",
# 	color_up="#FFFFFF",
# 	color_down="#FFFFFF",
# 	format_down="",
# 	dynamic_color=False,
# 	separate_color=False,
# 	hints={"markup": "pango"},)

# Shows disk usage of /
# Format:
# 42/128G [86G]
# status.register("disk",
#     path="/",
#     format="{used}/{total}G [{avail}G]",)

# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
# status.register("pulseaudio", format="♪{volume}",)
#
# # Shows mpd status
# # Format:
# # Cloud connected▶Reroute to Remain
# status.register("mpd",
#     format="{title}{status}{album}",
#     status={
#         "pause": "▷",
#         "play": "▶",
#         "stop": "◾",
#     },)
#
status.run()
