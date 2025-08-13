defmodule Sitemap.Config do
  use Agent, restart: :transient
  import Sitemap.Func, only: [get_env: 1]

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
    :max_sitemap_file_size,
    # Your domain, also host with http scheme.
    :host,
    # Name of sitemap file.
    :filename,
    # After domain path's location on URL.
    :public_path,
    # Generating sitemaps to this directory path.
    :files_path,
    :verbose,
    :compress,
    :create_index
  ]

  def start_link([]), do: configure(nil)

  def start_link(value) do
    Agent.start_link(fn -> value end, name: __MODULE__)
  end

  defp get_cfg(base, key, env_key, default) do
    base[key] ||
      get_env(env_key) ||
      Application.get_env(:sitemap, key, default)
  end

  def configure, do: configure(nil)

  def configure(overwrite) do
    start_link(%__MODULE__{
      max_sitemap_files: get_cfg(overwrite, :max_sitemap_files, "SITEMAP_MAXFILES", 10_000),
      max_sitemap_links: get_cfg(overwrite, :max_sitemap_links, "SITEMAP_MAXLINKS", 10_000),
      max_sitemap_news: get_cfg(overwrite, :max_sitemap_news, "SITEMAP_MAXNEWS", 1_000),
      max_sitemap_images: get_cfg(overwrite, :max_sitemap_images, "SITEMAP_MAXIMAGES", 1_000),
      max_sitemap_file_size:
        get_cfg(overwrite, :max_sitemap_file_size, "SITEMAP_MAXFILESIZE", 5_000_000),
      host: get_cfg(overwrite, :host, "SITEMAP_HOST", "http://www.example.com"),
      filename: get_cfg(overwrite, :filename, "SITEMAP_FILENAME", "sitemap"),
      files_path: get_cfg(overwrite, :files_path, "SITEMAP_SITEMAPS_PATH", "sitemaps/"),
      public_path: get_cfg(overwrite, :public_path, "SITEMAP_PUBLIC_PATH", "sitemaps/"),
      verbose: get_cfg(overwrite, :verbose, "SITEMAP_VERBOSE", true),
      compress: get_cfg(overwrite, :compress, "SITEMAP_COMPRESS", true),
      create_index: get_cfg(overwrite, :create_index, "SITEMAP_CREATE_INDEX", "auto")
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
