# LXD Elixir

[![Hex.pm](https://img.shields.io/hexpm/v/lxd.svg?style=flat-square)](https://hex.pm/packages/lxd)
[![Hex Docs](https://img.shields.io/badge/hex-docs-9768d1.svg?style=flat-square)](https://hexdocs.pm/lxd)

## Documentation

Documentation is available on Hexdocs [HERE](https://hexdocs.pm/lxd)

## Installation

The package can be installed by adding `lxd` to your list of dependencies
in `mix.exs`:

```elixir
def deps do
  [
    {:lxd, "~> 0.1.7"}
  ]
end
```

## Usage

TODO


## Contributing

This version of the project is very early. I have implemented what I needed for my projects using LXD containers and now working on it when I have some time.


I am new to Elixir and LXD, so your help and advices are more than welcome on this project.


Here a few things I have in mind to work on:
- Implement missing endpoints (you can find the list of the coverage status for all LXD endpoints down below).
- Found a way to test everything without doing any damage to the host running the test (maybe by using a LXD/docker container with LXD installed on it)
- Add better coverage for tests.


## How to contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

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
