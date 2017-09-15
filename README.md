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
    - [ ] certificates/\<fingerprint\>
        - [ ] GET
        - [ ] PUT
        - [ ] PATCH
        - [ ] DELETE
- [ ] containers
    - [x] GET all
    - [x] POST create
    - [ ] containers/\<name\>
        - [x] GET info
        - [x] PUT replace
        - [x] PATCH update
        - [x] POST rename
        - [ ] POST migrate
        - [x] DELETE
        - [x] exec
            - [x] POST exec (not supporting all features)
        - [x] files
            - [x] GET get
            - [x] POST put
            - [x] DELETE remove
        - [ ] snapshots
            - [x] GET all
            - [x] POST create
            - [ ] snapshots/\<name\>
                - [x] GET get
                - [x] POST rename
                - [ ] POST migrate
                - [x] DELETE remove
        - [x] state
            - [x] GET state
            - [x] POST set_state, start, stop, restart, freeze, unfreeze
        - [ ] logs
            - [x] GET all
            - [ ] logs/\<logfile\>
                - [x] GET get
                - [ ] DELETE
        - [ ] metadata
            - [x] GET metadata
            - [ ] PUT
            - [ ] metadata/templates
                - [x] GET all
                - [x] GET(?path) get
                - [ ] POST(?path)
                - [ ] PUT(?path)
                - [ ] DELETE(?path)
- [ ] events
    - [ ] GET
- [ ] images
    - [x] GET all
    - [ ] POST
    - [ ] images/\<fingerprint\>
        - [x] GET info
        - [x] PUT replace
        - [x] PATCH update
        - [x] DELETE remove
        - [ ] export
            - [ ] GET
        - [ ] refresh
            - [ ] POST
        - [ ] secret
            - [ ] POST
    - [x] aliases
        - [x] GET all
        - [x] POST create
        - [x] aliases/\<name\>
            - [x] GET info
            - [x] PUT replace
            - [x] PATCH update
            - [x] POST rename
            - [x] DELETE remove
- [x] networks
    - [x] GET all
    - [x] POST create
    - [x] networks/\<name\>
        - [x] GET info
        - [x] PUT replace
        - [x] PATCH update
        - [x] POST rename
        - [x] DELETE remove
- [ ] operations
    - [x] GET all
    - [ ] operations/\<uuid\>
        - [x] GET info
        - [x] DELETE remove
        - [x] wait
            - [x] GET wait
        - [ ] websocket
            - [ ] GET
- [x] profiles
    - [x] GET all
    - [x] POST create
    - [x] profiles/\<name\>
        - [x] GET info
        - [x] PUT replace
        - [x] PATCH update
        - [x] POST rename
        - [x] DELETE remove
- [ ] storage-pools
    - [x] GET all
    - [x] POST create
    - [ ] storage-pools/\<name\>
        - [x] GET info
        - [x] PUT replace
        - [x] PATCH update
        - [x] DELETE remove
        - [x] volumes
            - [x] GET all
            - [x] POST create
        - [ ] volumes/\<type\>/\<name\>
            - [ ] GET
            - [ ] PUT
            - [ ] PATCH
            - [ ] DELETE
