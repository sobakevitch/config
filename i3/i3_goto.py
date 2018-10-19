#!/usr/bin/python3

import i3ipc
from sys import argv
from itertools import cycle

def goto(char):
	i3 = i3ipc.Connection()
	workspaces = i3.get_workspaces()
	focused = i3.get_tree().find_focused()
	char_wp = []

	for wp in workspaces:
		if wp["name"].lower().startswith(char):
			char_wp.append(wp)

	if len(char_wp) == 0:
		i3.command("workspace {}".format(char))
	else:
		if not focused.workspace().name.startswith(char):
			i3.command("workspace {}".format(char_wp[0]["name"]))
		else:
			jump = False
			for wp in cycle(char_wp):
				if jump:
					i3.command("workspace {}".format(wp["name"]))
					exit(0)
				elif focused.workspace().name != wp["name"]:
					continue
				else:
					jump = True


if __name__ == "__main__":

	if len(argv) != 2:
		exit(1)

	goto(argv[1])
