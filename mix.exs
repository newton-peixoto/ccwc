defmodule CCWC.MixProject do
  use Mix.Project

  def project do
    [
      app: :ccwc,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        ignore_warnings: ".dialyzer_ignore.exs"
      ],
      deps: deps(),
      escript: escript()
    ]
  end

  defp aliases do
    [
      quality: ["format", "credo --strict", "dialyzer", "test"]
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
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:styler, "~> 0.10", only: [:dev, :test], runtime: false}
    ]
  end

  defp escript do
    [main_module: CCWC]
  end
end
