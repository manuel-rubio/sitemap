defmodule Sitemap.BuildersFileTest do
  use ExUnit.Case

  setup do
    Sitemap.Builders.File.stop()
    Sitemap.Builders.IndexFile.stop()
    Sitemap.Namer.stop(:file)
    Sitemap.Namer.stop(:index_file)
  end

  test "Add Builders.File" do
    data = [lastmod: "lastmod", expires: "expires", changefreq: "changefreq", priority: 0.5]
    assert :ok == Sitemap.Builders.File.add("", data)
  end

  test "Adds Builders.File" do
    data = [lastmod: "lastmod", expires: "expires", changefreq: "changefreq", priority: 0.5]
    Enum.each(1..10, fn _ -> Sitemap.Builders.File.add("", data) end)

    assert 10 == Sitemap.Builders.File.state().link_count
  end
end
