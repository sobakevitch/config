#!/usr/bin/env python3

import i3ipc
from sys import exit
from itertools import cycle

if __name__ == "__main__":

	i3 = i3ipc.Connection()
	focused = i3.get_tree().find_focused()
	current_ws = focused.workspace()
	found = False
	for window in cycle(current_ws.leaves()):
		if found:
			i3.command("[con_id={}] focus".format(window.id))
			exit(0)
		if window == focused:
			found = True
