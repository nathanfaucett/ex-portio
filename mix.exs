defmodule Portio.Mixfile do
  use Mix.Project

  def project do
    [app: :portio,
      description: description,
      package: package,
      version: "0.0.1",
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger],
      mod: {Portio, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end

  defp description do
   """
   port io helper
   """
 end

  defp package do
    [# These are the default files included in the package
      name: :auth,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Nathan Faucett"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/nathanfaucett/ex-portio",
        "Docs" => "https://github.com/nathanfaucett/ex-portio"
      }
    ]
  end
end
