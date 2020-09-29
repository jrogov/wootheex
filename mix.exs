defmodule Wootheex.MixProject do
  use Mix.Project

  def project do
    [
      app: :wootheex,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: description(),
      deps: deps(),
      package: package(),
      docs: docs(),
      compilers: compilers(),
      rustler_crates: rustler_crates(),
      source_url: "https://github.com/arikai/wootheex",
      homepage_url: "https://github.com/arikai/wootheex"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.21.0"},

      # Docs
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Fast User Agent parser based on Rust version of Project Woothee"
  end

  defp package do
    [
      files: ~w(mix.exs lib .formatter.exs
                README* LICENSE*
                native/wootheex_nif/Cargo*
                native/wootheex_nif/.cargo
                native/wootheex_nif/src),
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/arikai/wootheex",
        "woothee-rust" => "https://github.com/woothee/woothee-rust",
        "Project Woothee" => "https://github.com/woothee/woothee"
      }
    ]
  end

  defp docs do
    [
      main: "About", # The main page in the docs
      extras: ["README.md": [filename: "About", title: "About"]]
    ]
  end

  defp compilers() do
    [:rustler] ++ Mix.compilers
  end

  defp rustler_crates do
    [wootheex_nif: [
        path: "native/wootheex_nif",
        mode: rustc_mode(Mix.env)
      ]]
  end

  defp rustc_mode(:prod), do: :release
  defp rustc_mode(_), do: :debug
end
