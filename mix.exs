defmodule LXD.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lxd,
      version: "0.1.7",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      docs: docs()
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
      {:httpoison, "~> 1.0"},
      {:ex_doc, "~> 0.16.4", only: :dev}
    ]
  end

  defp description do
    "LXD API wrapper"
  end

  defp package do
    [
      name: "lxd",
      maintainers: ["Cédric Desgranges"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/PandaScore/lxd-elixir"},
      source_url: "https://github.com/PandaScore/lxd-elixir"
    ]
  end

  defp docs do
    [
      main: "LXD",
      extras: ["README.md"]
    ]
  end

end
