# LXD Elixir

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `lxd` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lxd, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/lxd](https://hexdocs.pm/lxd).

## LXD API coverage

- [ ] /
    - [ ] GET
- [ ] /1.0
    - [ ] GET
    - [ ] PUT
    - [ ] PATCH
- [ ] certificates
    - [ ] GET
    - [ ] POST
    - [ ] certificates/<fingerprint>
        - [ ] GET
        - [ ] PUT
        - [ ] PATCH
        - [ ] DELETE
- [ ] containers
    - [ ] GET
    - [ ] POST
    - [ ] containers/<name>
        - [ ] GET
        - [ ] PUT
        - [ ] PATCH
        - [ ] POST rename
        - [ ] POST migrate
        - [ ] DELETE
        - [ ] exec
            - [ ] POST
        - [x] files
            - [x] GET
            - [x] POST
            - [x] DELETE
        - [ ] snapshots
            - [x] GET all
            - [x] POST create
            - [ ] snapshots/<name>
                - [x] GET get
                - [x] POST rename
                - [ ] POST migrate
                - [x] DELETE remove
        - [x] state
            - [x] GET state
            - [x] POST set_state, start, stop, restart, freeze, unfreeze
        - [ ] logs
            - [x] GET all
            - [ ] logs/<logfile>
                - [ ] GET
                - [ ] DELETE
        - [ ] metadata
            - [ ] GET
            - [ ] PUT
            - [ ] metadata/templates
                - [ ] GET
                - [ ] GET(?path)
                - [ ] POST(?path)
                - [ ] PUT(?path)
                - [ ] DELETE(?path)
- [ ] events
    - [ ] GET
- [ ] images
    - [ ] GET
    - [ ] POST
    - [ ] images/<fingerprint>
        - [ ] GET
        - [ ] PUT
        - [ ] PATCH
        - [ ] DELETE
        - [ ] export
            - [ ] GET
        - [ ] refresh
            - [ ] POST
        - [ ] secret
            - [ ] POST
    - [ ] aliases
        - [ ] GET
        - [ ] POST
        - [ ] aliases/<name>
            - [ ] GET
            - [ ] PUT
            - [ ] PATCH
            - [ ] POST
            - [ ] DELETE
- [ ] networks
    - [ ] GET
    - [ ] POST
    - [ ] networks/<name>
        - [ ] GET
        - [ ] PUT
        - [ ] PATCH
        - [ ] POST
        - [ ] DELETE
- [ ] operations
    - [ ] GET
    - [ ] operations/<uuid>
        - [ ] GET
        - [ ] DELETE
        - [ ] wait
            - [ ] GET
        - [ ] websocket
            - [ ] GET
- [ ] profiles
    - [ ] GET
    - [ ] POST
    - [ ] profiles/<name>
        - [ ] GET
        - [ ] PUT
        - [ ] PATCH
        - [ ] POST
        - [ ] DELETE
- [ ] storage-pools
    - [ ] GET
    - [ ] POST
    - [ ] storage-pools/<name>
        - [ ] GET
        - [ ] PUT
        - [ ] PATCH
        - [ ] DELETE
        - [ ] volumes
            - [ ] GET
            - [ ] POST
        - [ ] volumes/<type>/<name>
            - [ ] GET
            - [ ] PUT
            - [ ] PATCH
            - [ ] DELETE
