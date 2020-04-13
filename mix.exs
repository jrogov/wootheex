defmodule Wootheex.MixProject do
  use Mix.Project

  def project do
    [
      app: :wootheex,
      version: "0.2.0",
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
      {:rustler, git: "git@bitbucket.org:pixel-media/rustler.git"}
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
