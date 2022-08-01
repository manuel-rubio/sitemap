defmodule Sitemap do
  use Application

  def start(_type, _args) do
    children = [
      Sitemap.Config,
      Sitemap.Builders.File,
      Sitemap.Builders.Indexfile,
      %{
        id: :namer_indexfile,
        start: {Sitemap.Namer, :start_link, [:indexfile]}
      },
      %{
        id: :namer_file,
        start: {Sitemap.Namer, :start_link, [:file, [zero: 1, start: 2]]}
      }
    ]

    opts = [strategy: :one_for_all, name: Sitemap.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc false
  defmacro __using__(opts) do
    quote do
      use Sitemap.DSL, unquote(opts)
    end
  end
end
