defmodule Broker.Mixfile do
  use Mix.Project

  def project do
    [app: :broker,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :postgrex]]
  end

  defp deps do
    [{:postgrex, "~> 0.9.1"}]
  end
end
