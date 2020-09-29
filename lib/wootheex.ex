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


  @doc """
  Parse user agent to simple tuple with info (see spec and parse_result type)

      iex> Wootheex.parse "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.155 Safari/537.36"
      {:pc, "Chrome", :browser, "44.0.2403.155", "Mac OSX", "10.10.4", "Google"}
  """
  @spec parse(user_agent) :: parse_result
  def parse(_ua) do
    raise "Wootheex.NIF.parse/1 is not implemented"
  end

  @on_load :load_dynlib
  app = Mix.Project.config[:app]

  @doc false
  def load_dynlib() do
    :ok =
      [:code.priv_dir(unquote(app)), 'native', 'libwootheex_nif']
      |> :filename.join()
      |> :erlang.load_nif(0)
  end
end

defmodule WootheexError do
  defexception [:message]
end
