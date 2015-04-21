defmodule Issues.Mixfile do
  use Mix.Project

  def project do
    [app: :issues,
     version: "0.0.1",
     name: "Issues",
     source_url: "https://github.com/SeaRbSg/elixir/tree/master/jf647/ch13/issues",
     elixir: "~> 1.0",
     escript: escript_config,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison, :jsx]]
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
    [
      { :httpoison, "~> 0.6" },
      { :jsx, "~> 2.5" },
      { :earmark, "~> 0.1", only: :dev },
      { :ex_doc, "~> 0.7", only: :dev }
    ]
  end

  defp escript_config do
    [ main_module: Issues.CLI ]
  end
end