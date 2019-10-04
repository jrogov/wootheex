defmodule Wootheex.UserAgent do
  alias Wootheex, as: W
  @type parse_result_explicit :: %__MODULE__{
    category: W.category,
    browser_name: W.browser_name,
    browser_type: W.browser_type,
    browser_version: W.browser_version,
    os: W.os,
    os_version: W.os_version,
    vendor: W.vendor
  }
  @enforce_keys [:category, :browser_name, :browser_type, :browser_version, :os, :os_version, :vendor]
  defstruct @enforce_keys

  @spec parse(W.user_agent) :: parse_result_explicit
  def parse(ua) do
    info = W.parse(ua)
    {cat, bname, btype, bver, os, osver, vendor} =
      case info do
        :other -> {:other, :other, :other, :other, :other, :other, :other}
        t when is_tuple(t) -> t
      end
    %__MODULE__{
      category: cat,
      browser_name: bname,
      browser_type: btype,
      browser_version: bver,
      os: os,
      os_version: osver,
      vendor: vendor
    }
  end
end

defmodule Wootheex do
  @type user_agent :: binary

  @type category :: :appliance | :crawler | :misc | :mobilephone | :pc | :smartphone | :other
  @type browser_name :: binary | :other
  @type browser_type :: :browser | :full | :os | :other
  @type browser_version :: binary | :other
  @type os :: binary | :other
  @type os_version :: binary | :other
  @type vendor :: binary | :other

  @type parse_result :: :other | {category,
                                  browser_name, browser_type, browser_version,
                                  os, os_version,
                                  vendor}


  @spec parse(user_agent) :: parse_result
  def parse(_ua) do
    raise "Wootheex.NIF.parse/1 is not implemented"
  end

  @on_load :load_dynlib
  app = Mix.Project.config[:app]

  def load_dynlib() do
    path = :filename.join([:code.priv_dir(unquote(app)), 'native', 'libwootheex_nif'])
    :ok = :erlang.load_nif(path, 0)
  end
end
