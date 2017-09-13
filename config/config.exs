use Mix.Config

config :lxd, socket: "/var/lib/lxd/unix.socket"

config :lxd, api_version: "/1.0"

config :lxd, LXD.Containers,
  all: "/containers",
  one: "/containers/@",
  exec: "/containers/@/exec",
  files: "/containers/@/files"
