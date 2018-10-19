#!/usr/bin/python3

import i3ipc

if __name__ == "__main__":

	i3 = i3ipc.Connection()

	wp = [int(w["name"]) for w in i3.get_workspaces() if w["num"] != -1]
	for k in range(1, 16):
		if k not in wp:
			i3.command("workspace {}".format(k))
			break
