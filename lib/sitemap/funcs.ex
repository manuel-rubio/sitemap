defmodule Sitemap.Funcs do
  def iso8601(yy, mm, dd, hh, mi, ss) do
    "~4.10.0B-~2.10.0B-~2.10.0BT~2.10.0B:~2.10.0B:~2.10.0BZ"
    |> :io_lib.format([yy, mm, dd, hh, mi, ss])
    |> IO.iodata_to_binary()
  end

  def iso8601 do
    {{yy, mm, dd}, {hh, mi, ss}} = :calendar.universal_time()
    iso8601(yy, mm, dd, hh, mi, ss)
  end

  def iso8601({{yy, mm, dd}, {hh, mi, ss}}) do
    iso8601(yy, mm, dd, hh, mi, ss)
  end

  if Code.ensure_loaded?(NaiveDateTime) do
    def iso8601(%NaiveDateTime{} = dt) do
      dt
      |> NaiveDateTime.to_erl()
      |> iso8601()
    end

    def iso8601(%DateTime{} = dt) do
      DateTime.to_iso8601(dt)
    end
  end

  def iso8601(%Date{} = dt) do
    Date.to_iso8601(dt)
  end

  if Code.ensure_loaded?(Ecto.DateTime) do
    def iso8601(%Ecto.DateTime{} = dt) do
      dt
      |> Ecto.DateTime.to_erl()
      |> iso8601()
    end
  end

  if Code.ensure_loaded?(Ecto.Date) do
    def iso8601(%Ecto.Date{} = dt) do
      Ecto.Date.to_iso8601(dt)
    end
  end

  def iso8601(dt), do: dt

  def eraser(elements) do
    Enum.filter(elements, fn
      el when is_list(el) -> eraser(el)
      nil -> false
      el -> !!elem(el, 2)
    end)
  end

  def yes_no(false), do: "no"
  def yes_no(_), do: "yes"

  def allow_deny(false), do: "deny"
  def allow_deny(_), do: "allow"

  def autoplay(bool) do
    if bool, do: "ap=1", else: "ap=0"
  end

  def getenv(key) do
    x = System.get_env(key)

    cond do
      x == "false" ->
        false

      x == "true" ->
        true

      is_numeric(x) ->
        {num, _} = Integer.parse(x)
        num

      :else ->
        x
    end
  end

  def is_numeric(str) when is_nil(str), do: false

  def is_numeric(str) do
    case Float.parse(str) do
      {_num, ""} -> true
      {_num, _r} -> false
      :error -> false
    end
  end

  def urljoin(src, dest) do
    src = URI.parse(src)
    dest = URI.parse(dest)

    %URI{
      host: dest.host || src.host,
      path: dest.path || src.path,
      port: dest.port || src.port,
      query: dest.query || src.query,
      scheme: dest.scheme || src.scheme,
      userinfo: dest.userinfo || src.userinfo,
      fragment: dest.fragment || src.fragment,
      authority: dest.authority || src.authority
    }
    |> to_string()
  end
end
