defmodule Sitemap.GeneratorTest do
  use ExUnit.Case
  use Sitemap

  setup do
    Sitemap.Builders.File.stop()
    Sitemap.Builders.IndexFile.stop()
    Sitemap.Namer.stop(:file)
    Sitemap.Namer.stop(:index_file)
  end

  test "create macro" do
    assert :ok = create(do: false)
  end

  test "create & add" do
    create do
      add("rss", priority: nil, changefreq: nil, lastmod: nil, mobile: true)
      add("site", priority: nil, changefreq: nil, lastmod: nil, mobile: true)
      add("entry", priority: nil, changefreq: nil, lastmod: nil, mobile: true)
      add("about", priority: nil, changefreq: nil, lastmod: nil, mobile: true)
      add("contact", priority: nil, changefreq: nil, lastmod: nil, mobile: true)
      assert Sitemap.Builders.File.state().link_count == 5
    end
  end

  test "add_to_index function" do
    create do
      add_to_index("/mysitemap1.xml.gz")

      assert String.contains?(
               Sitemap.Builders.IndexFile.state().content,
               "http://www.example.com/mysitemap1.xml.gz"
             )

      add_to_index("/alternatemap.xml")

      assert String.contains?(
               Sitemap.Builders.IndexFile.state().content,
               "http://www.example.com/alternatemap.xml"
             )

      add_to_index("/changehost.xml.gz", host: "http://google.com")

      assert String.contains?(
               Sitemap.Builders.IndexFile.state().content,
               "http://google.com/changehost.xml.gz"
             )
    end
  end
end
