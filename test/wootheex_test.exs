defmodule WootheexTest do
  use ExUnit.Case
  doctest Wootheex
  doctest Wootheex.UserAgent

  alias Wootheex, as: W

  test "Invalid argument (integer)" do
    number = 42
    assert_raise ArgumentError, fn -> assert W.parse(number) end
  end

  test "Invalid UTF-8" do
    invalid_string = <<255, 1>>
    assert_raise ArgumentError, fn -> assert W.parse(invalid_string) end
  end
end
