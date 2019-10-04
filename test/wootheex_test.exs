defmodule WootheexTest do
  use ExUnit.Case
  doctest Wootheex

  alias Wootheex, as: W

  ua = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.3; WOW64; Trident/7.0; .NET4.0E; .NET4.0C; .NET CLR 3.5.30729; .NET CLR 2.0.50727; .NET CLR 3.0.30729; GWX:QUALIFIED; MASMJS)"

  test "Test simple parsing" do
    expected = {:pc, "Internet Explorer", :browser, "7.0", "Windows 8.1", "NT 6.3", "Microsoft"}
    assert W.parse(unquote(ua)) == expected
  end

  test "Test explicit parsing" do
    expected = %Wootheex.UserAgent{
      browser_name: "Internet Explorer",
      browser_type: :browser,
      browser_version: "7.0",
      category: :pc,
      os: "Windows 8.1",
      os_version: "NT 6.3",
      vendor: "Microsoft"
    }
    assert W.UserAgent.parse(unquote(ua)) == expected
  end

  test "Invalid argument (integer)" do
    number = 42
    assert_raise ArgumentError, fn -> assert W.parse(number) end
  end

  test "Invalid UTF-8" do
    invalid_string = <<255, 1>>
    assert_raise ArgumentError, fn -> assert W.parse(invalid_string) end
  end
end
