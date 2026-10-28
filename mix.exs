defmodule Tiktoken.MixProject do
  use Mix.Project

  @version "0.5.0"
  @url "https://github.com/jimmybot/tiktoken-elixir"

  def project do
    [
      app: :tiktoken,
      version: @version,
      elixir: "~> 1.15",
      description: "Elixir bindings for Tiktoken tokenizer",
      source_url: @url,
      homepage_url: @url,
      start_permanent: Mix.env() == :prod,
      package: package(),
      docs: [main: "readme", extras: ["README.md", "CHANGELOG.md"]],
      deps: deps(),
      aliases: aliases()
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
      {:ex_doc, "~> 0.40.4", only: :dev, runtime: false},
      {:rustler, "~> 0.38.0", optional: true},
      {:rustler_precompiled, "~> 0.10.1"}
    ]
  end

  defp package do
    [
      files:
        ~w(lib .formatter.exs mix.exs README* CHANGELOG.md LICENSE* native/tiktoken/.cargo native/tiktoken/src native/tiktoken/Cargo.* native/tiktoken/README.md checksum-*.exs),
      licenses: ["MIT"],
      links: %{"GitHub" => @url}
    ]
  end

  defp aliases do
    [
      fmt: [
        "format",
        "cmd cargo fmt --manifest-path native/tiktoken/Cargo.toml"
      ]
    ]
  end
end
