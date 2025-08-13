defmodule Sitemap do
  use Application

  def start(_type, _args) do
    children = [
      Sitemap.Config,
      Sitemap.Builders.File,
      Sitemap.Builders.IndexFile,
      %{
        id: :namer_index_file,
        start: {Sitemap.Namer, :start_link, [:index_file]}
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
