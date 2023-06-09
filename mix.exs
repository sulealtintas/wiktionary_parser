defmodule WiktionaryParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :wiktionary_parser,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.0"},
      {:floki, "~> 0.34.2"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end
end
