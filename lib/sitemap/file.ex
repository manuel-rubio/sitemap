defmodule Sitemap.File do
  alias Sitemap.DirNotExists
  alias Sitemap.Location

  def write(name, data) do
    dir = Location.directory(name)

    cond do
      not File.exists?(dir) -> File.mkdir_p(dir)
      not File.dir?(dir) -> raise DirNotExists
      :else -> nil
    end

    path = Location.path(name)

    if Regex.match?(~r/.gz$/, path) do
      writefile(File.open!(path, [:write, :utf8, :compressed]), data)
    else
      writefile(File.open!(path, [:write, :utf8]), data)
    end
  end

  defp writefile(stream, data) do
    IO.write(stream, data)
    File.close(stream)
  end
end
