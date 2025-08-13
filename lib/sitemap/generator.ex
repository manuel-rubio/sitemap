defmodule Sitemap.Generator do
  alias Sitemap.Builders.File, as: FileBuilder
  alias Sitemap.Builders.IndexFile
  alias Sitemap.Location
  alias Sitemap.Namer

  def add(link, attrs \\ []) do
    if FileBuilder.add(link, attrs) == :full do
      full()
      add(link, attrs)
    else
      :ok
    end
  end

  def add_to_index(link, options \\ []) do
    IndexFile.add(link, options)
  end

  def full do
    IndexFile.add()
    FileBuilder.stop()
  end

  def fin do
    full()
    reset()
  end

  def reset do
    IndexFile.write()
    IndexFile.stop()
    Namer.update_state(:file, :count, nil)
  end

  # def group do end

  def ping(urls \\ []) do
    urls = ~w(http://google.com/ping?sitemap=%s
              http://www.bing.com/webmaster/ping.aspx?sitemap=%s) ++ urls

    index_url = Location.url(:index_file)

    spawn(fn ->
      Enum.each(urls, fn url ->
        ping_url = String.replace(url, "%s", index_url)

        :httpc.request(to_charlist(ping_url))
        IO.puts("Successful ping of #{ping_url}")
      end)
    end)
  end
end
