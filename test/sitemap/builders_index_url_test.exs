defmodule Sitemap.BuildersIndexUrlTest do
  use ExUnit.Case

  setup do
    Sitemap.Builders.File.stop()
    Sitemap.Builders.IndexFile.stop()
    Sitemap.Namer.stop(:file)
    Sitemap.Namer.stop(:index_file)
  end
end
