defmodule Sitemap.Config do
  use Agent, restart: :transient
  import Sitemap.Funcs, only: [getenv: 1]

  defstruct [
    # Max sitemap links per index file
    :max_sitemap_files,
    # Max links per sitemap
    :max_sitemap_links,
    # Max news sitemap per index_file
    :max_sitemap_news,
    # Max images per url
    :max_sitemap_images,
    # Bytes
    :max_sitemap_filesize,
    # Your domain, also host with http scheme.
    :host,
    # Name of sitemap file.
    :filename,
    # After domain path's location on URL.
    :public_path,
    # Generating sitemps to this directory path.
    :files_path,
    :adapter,
    :verbose,
    :compress,
    :create_index
  ]

  def start_link([]), do: configure(nil)

  def start_link(value) do
    Agent.start_link(fn -> value end, name: __MODULE__)
  end

  def configure, do: configure(nil)

  def configure(overwrite) do
    ow = overwrite

    start_link(%__MODULE__{
      max_sitemap_files:
        ow[:max_sitemap_files] ||
          getenv("SITEMAP_MAXFILES") ||
          Application.get_env(:sitemap, :max_sitemap_files, 10_000),
      max_sitemap_links:
        ow[:max_sitemap_links] ||
          getenv("SITEMAP_MAXLINKS") ||
          Application.get_env(:sitemap, :max_sitemap_links, 10_000),
      max_sitemap_news:
        ow[:max_sitemap_news] ||
          getenv("SITEMAP_MAXNEWS") ||
          Application.get_env(:sitemap, :max_sitemap_news, 1_000),
      max_sitemap_images:
        ow[:max_sitemap_images] ||
          getenv("SITEMAP_MAXIMAGES") ||
          Application.get_env(:sitemap, :max_sitemap_images, 1_000),
      max_sitemap_filesize:
        ow[:max_sitemap_filesize] ||
          getenv("SITEMAP_MAXFILESIZE") ||
          Application.get_env(:sitemap, :max_sitemap_filesize, 5_000_000),
      host:
        ow[:host] ||
          getenv("SITEMAP_HOST") ||
          Application.get_env(:sitemap, :host, "http://www.example.com"),
      filename:
        ow[:filename] ||
          getenv("SITEMAP_FILENAME") ||
          Application.get_env(:sitemap, :filename, "sitemap"),
      files_path:
        ow[:files_path] ||
          getenv("SITEMAP_SITEMAPS_PATH") ||
          Application.get_env(:sitemap, :files_path, "sitemaps/"),
      public_path:
        ow[:public_path] ||
          getenv("SITEMAP_PUBLIC_PATH") ||
          Application.get_env(:sitemap, :public_path, "sitemaps/"),
      adapter:
        ow[:adapter] ||
          getenv("SITEMAP_ADAPTER") ||
          Application.get_env(:sitemap, :adapter, Sitemap.Adapters.File),
      verbose:
        ow[:verbose] ||
          getenv("SITEMAP_VERBOSE") ||
          Application.get_env(:sitemap, :verbose, true),
      compress:
        ow[:compress] ||
          getenv("SITEMAP_COMPRESS") ||
          Application.get_env(:sitemap, :compress, true),
      create_index:
        ow[:create_index] ||
          getenv("SITEMAP_CREATE_INDEX") ||
          Application.get_env(:sitemap, :create_index, "auto")
    })
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end

  def set(key, value) do
    Agent.update(__MODULE__, fn config ->
      Map.update!(config, key, fn _ -> value end)
    end)
  end

  def update(overwrite) do
    Enum.each(overwrite, fn {key, value} ->
      set(key, value)
    end)
  end
end
