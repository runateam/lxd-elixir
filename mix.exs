defmodule LXD.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lxd,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  def application do
    [
      extra_applications: [
        :logger,
        :httpoison
      ]
    ]
  end

  defp deps do
    [
      {:poison, "~> 3.1"},
      {:httpoison, "~> 0.13"},
      {:websockex, "~> 0.4.0"}
    ]
  end

  defp description do
    " LXD API wrapper"
  end

  defp package do
    [
      name: "lxd",
      files: [],
      maintainers: ["Cédric Desgranges"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/PandaScore/lxd-elixir"},
      source_url: "https://github.com/PandaScore/lxd-elixir"
    ]
  end
end
