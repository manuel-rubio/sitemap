defmodule Sitemap.OptionsTest do
  use ExUnit.Case
  use Sitemap, compress: false, create_index: true

  setup do
    Sitemap.Builders.File.stop()
    Sitemap.Builders.IndexFile.stop()
    Sitemap.Namer.stop(:file)
    Sitemap.Namer.stop(:index_file)

    on_exit(fn ->
      nil
    end)

    # Returns extra metadata, it must be a dict
    # {:ok, hello: "world"}
  end

  test "Change option in opt statement" do
    create do
      assert Sitemap.Config.get().compress == false
    end

    Sitemap.Config.set(:compress, true)
  end

  test "Change create_index option in opt statement" do
    create do
      assert Sitemap.Config.get().create_index == true
    end

    Sitemap.Config.set(:create_index, :auto)
  end

  test "Change option in create statement" do
    create public_path: "abcde" do
      assert Sitemap.Config.get().public_path == "abcde"
    end

    assert Sitemap.Config.get().public_path == "abcde"

    create public_path: "" do
      assert Sitemap.Config.get().public_path == ""
    end

    assert Sitemap.Config.get().public_path == ""

    create public_path: "sitemaps/" do
      assert Sitemap.Config.get().public_path == "sitemaps/"
    end
  end

  # :max_sitemap_files,      # Max sitemap links per index file
  # :max_sitemap_links,      # Max links per sitemap
  # :max_sitemap_news,       # Max news sitemap per index_file
  # :max_sitemap_images,     # Max images per url
  # :max_sitemap_file_size,  # Bytes
  # :host,                   # Your domain, also host with http scheme.
  # :filename,               # Name of sitemap file.
  # :public_path,            # After domain path's location on URL.
  # :files_path,             # Generating sitemaps to this directory path.
  # :verbose,
  # :compress,
  # :create_index,

  # test "Options: max_sitemap_files" do
  # end

  # test "Options: max_sitemap_links" do
  # end

  # test "Options: max_sitemap_news" do
  # end

  # test "Options: max_sitemap_images" do
  # end

  # test "Options: max_sitemap_file_size" do
  # end

  # test "Options: host" do
  # end

  # test "Options: filename" do
  # end

  # test "Options: public_path" do
  # end

  # test "Options: files_path" do
  # end

  # test "Options: verbose" do
  # end

  # test "Options: compress" do
  # end

  # test "Options: create_index" do
  # end
end
