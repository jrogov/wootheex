defmodule Wootheex.UserAgent do

  @type t :: %__MODULE__{
    category:        Wootheex.category(),
    browser_name:    Wootheex.browser_name(),
    browser_type:    Wootheex.browser_type(),
    browser_version: Wootheex.browser_version(),
    os:              Wootheex.os(),
    os_version:      Wootheex.os_version(),
    vendor:          Wootheex.vendor()
  }
  @enforce_keys [
    :category,
    :browser_name,
    :browser_type,
    :browser_version,
    :os,
    :os_version,
    :vendor
  ]
  defstruct @enforce_keys

  @doc """
  Parse user agent to a struct or raises an error

      iex> Wootheex.UserAgent.parse! "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.155 Safari/537.36"
      %Wootheex.UserAgent{
        browser_name: "Chrome",
        browser_type: :browser,
        browser_version: "44.0.2403.155",
        category: :pc,
        os: "Mac OSX",
        os_version: "10.10.4",
        vendor: "Google"
      }

  """
  @spec parse!(Wootheex.user_agent) :: t()
  def parse!(ua) do
    case Wootheex.parse(ua) do
      :other -> raise WootheexError, "unknown user agent"
      {cat, bname, btype, bver, os, osver, vendor} ->
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

  @doc """
  Safely parses user agent to a struct

      iex> Wootheex.UserAgent.parse "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.155 Safari/537.36"
      {:ok,
        %Wootheex.UserAgent{
          browser_name: "Chrome",
          browser_type: :browser,
          browser_version: "44.0.2403.155",
          category: :pc,
          os: "Mac OSX",
          os_version: "10.10.4",
          vendor: "Google"
        }
      }
  """
  @spec parse(Wootheex.user_agent) :: {:ok, t()} | {:error, any()}
  def parse(ua) do
    case Wootheex.parse(ua) do
      :other -> {:error, "unknown user agent"}
      {cat, bname, btype, bver, os, osver, vendor} ->
        {:ok,
          %__MODULE__{
            category: cat,
            browser_name: bname,
            browser_type: btype,
            browser_version: bver,
            os: os,
            os_version: osver,
            vendor: vendor
          }
        }
    end
  end
end
