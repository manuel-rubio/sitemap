defmodule Sitemap.Mixfile do
  use Mix.Project

  @description """
  Generating sitemap.xml
  """

  def project do
    [
      app: :sitemap,
      name: "Sitemap",
      version: "1.1.0",
      elixir: ">= 1.3.0",
      description: @description,
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      source_url: "https://github.com/ikeikeikeike/sitemap"
    ]
  end

  def application do
    [extra_applications: [:inets], mod: {Sitemap, []}]
  end

  defp deps do
    [
      {:xml_builder, ">= 0.0.0"},
      {:ecto, ">= 1.1.0", only: :test},
      {:sweet_xml, ">= 0.0.0", only: :test},
      {:credo, ">= 0.0.0", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:inch_ex, ">= 0.0.0", only: :docs},
      {:dialyxir, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Tatsuo Ikeda / ikeikeikeike"],
      licenses: ["MIT"],
      links: %{"github" => "https://github.com/ikeikeikeike/sitemap"}
    ]
  end
end
