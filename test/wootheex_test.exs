defmodule WootheexTest do
  use ExUnit.Case
  doctest Wootheex
  doctest Wootheex.UserAgent

  test "Invalid argument (integer)" do
    number = 42
    assert_raise ArgumentError, fn -> assert Wootheex.parse(number) end
  end

  test "Invalid UTF-8" do
    invalid_string = <<255, 1>>
    assert_raise ArgumentError, fn -> assert Wootheex.parse(invalid_string) end
  end

  test "Invalid UserAgent" do
    ua = "blahblahblahblahblahblahblahblahblah"
    assert_raise WootheexError, fn -> assert Wootheex.UserAgent.parse!(ua) end
  end
end
