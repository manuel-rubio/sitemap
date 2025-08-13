defmodule Sitemap.Builders.IndexUrl do
  alias Sitemap.Func
  import XmlBuilder

  def to_xml(link, opts \\ []) do
    element(
      :sitemap,
      Func.eraser([
        element(:loc, if(opts[:host], do: Func.url_join(link, opts[:host]), else: link)),
        element(:lastmod, Keyword.get_lazy(opts, :lastmod, fn -> Func.iso8601() end))
      ])
    )
  end
end
