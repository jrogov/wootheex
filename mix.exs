defmodule Wootheex.MixProject do
  use Mix.Project

  def project do
    [
      app: :wootheex,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: compilers(),
      rustler_crates: rustler_crates()
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
      {:rustler, "~> 0.21.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
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
