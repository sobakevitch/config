#!/usr/bin/env python3

import os
import socket
import selectors
import threading
from argparse import ArgumentParser
import i3ipc

SOCKET_FILE = "/tmp/i3_focus_last.so"
PID_FILE = "/tmp/i3_focus_last.pid"
MAX_WIN_HISTORY = 30


class FocusWatcher:

	def __init__(self):
		self.i3 = i3ipc.Connection()
		self.i3.on("window::focus", self.on_window_focus)
		self.listening_socket = socket.socket(
			socket.AF_UNIX,
			socket.SOCK_STREAM)
		if os.path.exists(SOCKET_FILE):
			os.remove(SOCKET_FILE)
		self.listening_socket.bind(SOCKET_FILE)
		self.listening_socket.listen(1)
		self.window_list = []
		self.window_list_lock = threading.RLock()

	def on_window_focus(self, i3conn, event):
		with self.window_list_lock:
			window_id = event.container.props.id
			if window_id in self.window_list:
				self.window_list.remove(window_id)
			self.window_list.insert(0, window_id)
			if len(self.window_list) > MAX_WIN_HISTORY:
				del self.window_list[MAX_WIN_HISTORY:]

	def launch_i3(self):
		self.i3.main()

	def launch_server(self):
		selector = selectors.DefaultSelector()

		def accept(sock):
			conn, addr = sock.accept()
			selector.register(conn, selectors.EVENT_READ, read)

		def read(conn):
			data = conn.recv(1024)
			current_ws = list(filter(lambda d: d["focused"], self.i3.get_workspaces()))[0]
			tree = self.i3.get_tree()
			windows = tree.leaves()
			w_id = [w.id for w in windows]
			if data == b"alttab":
				with self.window_list_lock:
					for history_window_id in self.window_list[1:]:
						if history_window_id not in w_id:
							self.window_list.remove(history_window_id)
						else:
							w = list(filter(lambda x: x.id == history_window_id, windows))[0]
							if w.workspace().name != current_ws["name"]:
								self.i3.command("[con_id={}] focus".format(history_window_id))
								break
			elif data == b"modtab":
				with self.window_list_lock:
					found = False
					for window_id in self.window_list[1:]:
						if window_id not in w_id:
							self.window_list.remove(window_id)
						else:
							w = list(filter(lambda x: x.id == window_id, windows))[0]
							if w.workspace().name == current_ws["name"]:
								self.i3.command("[con_id={}] focus".format(window_id))
								found = True
								break
					if not found:
						for w in windows:
							if w.workspace().name == current_ws["name"] and not w.focused:
									self.i3.command("[con_id={}] focus".format(w.id))
			elif not data:
				selector.unregister(conn)
				conn.close()

		selector.register(self.listening_socket, selectors.EVENT_READ, accept)

		while True:
			for key, event in selector.select():
				callback = key.data
				callback(key.fileobj)

	def run(self):
		t_i3 = threading.Thread(target=self.launch_i3)
		t_server = threading.Thread(target=self.launch_server)
		for t in (t_i3, t_server):
			t.start()


if __name__ == "__main__":
	parser = ArgumentParser(
		prog="focus-last.py",
		description="""Implement the alt+tab and modtab features.""")
	parser.add_argument(
		"--alttab", dest="alttab", action="store_true",
		help="Switch to the previous window", default=False)
	parser.add_argument(
		"--modtab", dest="modtab", action="store_true",
		help="Switch to the previous window within the current workspace", default=False)
	args = parser.parse_args()

	if not args.alttab and not args.modtab:
		if os.path.exists(PID_FILE):
			with open(PID_FILE, "r") as fp:
				pid = int(fp.read())
				try:
					os.kill(pid, 15)
				except Exception:
					pass
		with open(PID_FILE, "w") as fp:
			fp.write(str(os.getpid()))

		focus_watcher = FocusWatcher()
		focus_watcher.run()
	else:
		client_socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
		client_socket.connect(SOCKET_FILE)
		if args.alttab:
			client_socket.send(b"alttab")
		elif args.modtab:
			client_socket.send(b"modtab")
		client_socket.close()
