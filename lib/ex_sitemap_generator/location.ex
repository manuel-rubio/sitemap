defmodule ExSitemapGenerator.Location do
  alias ExSitemapGenerator.Namer
  alias ExSitemapGenerator.Adapters.File, as: FileAdapter

  defstruct [
    adapter: FileAdapter,
    public_path: "",
    filename: "",
    sitemaps_path: "sitemaps/",
    host: "http://www.example.com",
    verbose: true,
    compress: true,
    create_index: :auto
  ]

  use ExSitemapGenerator.State

  def init(name), do: init(name, [])
  def init(name, opts) do
    Namer.init(name, opts)
    start_link(name)
  end

  def directory(name) do
    s = state(name)
    s.public_path
    |> Path.join(s.sitemaps_path)
    |> Path.expand
  end

  def path(name) do
    s = state(name)
    s.public_path
    |> Path.join(s.sitemaps_path)
    |> Path.join(filename(name))
    |> Path.expand
  end

  def url(name) do
    s = state(name)
    s.host
    |> Path.join(s.sitemaps_path)
    |> Path.join(filename(name))
  end

  def filename(name) do
    fname = Namer.to_string(name)

    s = state(name)
    unless s.compress,
      do: fname = Regex.replace(~r/\.gz$/, fname, "")

    update_state name, :filename, fname
    fname
  end

  def reserve_name(name) do
    fname = filename(name)
    Namer.next(name)
    fname
  end

  def write(name, data, _count) do
    reserve_name(name)

    s = state(name)
    s.adapter.write(name, data)
  end

end
