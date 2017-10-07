defmodule LXD do

  @moduledoc """

  LXD API wrapper


  ## Configuration

  By default, it use LXD unix socket `/var/lib/lxd/unix.socket` and LXD version
  `1.0`, but you can changed it by adding this to your `config.exs` file:
  ```
  :lxd, :socket, "/path/to/socket"
  :lxd, :api_version, "1.0"
  ```



  """

end
