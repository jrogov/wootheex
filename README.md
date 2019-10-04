# Wootheex
The Elixir implementation of [Project Woothee](https://github.com/woothee/woothee),
which is multi-language user-agent strings parsers.

There are simply NIF bindings to [Rust implementation](https://github.com/woothee/woothee-rust/) of the project.

## Rationale
All existing UA parsers are not fast enough for soft real-time systems. Examples are:
### [UAInspector](https://github.com/elixir-inspector/ua_inspector)
The most advanced one, identifies most bots (~95%), but also the slowest one (around 10ms per UA)
### [UAParser](https://github.com/beam-community/ua_parser) and [uap-elixir](https://github.com/romul/uap-elixir)
These has less functonality, do not identify bots **at all**, although have better performance (around 1ms)

### Wootheex
Because of high performance of original Rust implementation of Project Woothee, binding it's functionality with NIFs gives its full power to Elixir with around 8 **microsecond**, which is more than **1000 times faster** than UAInspector, and about **100 times faster** than other implementations

## Usage
With defined user agent:

```elixir
iex(1)> user_agent =  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.155 Safari/537.36"
"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.155 Safari/537.36"
```

For basic information in a simple tuple, call `Wootheex.parse/1`:

```elixir
iex(1)> Wootheex.parse(user_agent)
{:pc, "Chrome", :browser, "44.0.2403.155", "Mac OSX", "10.10.4", "Google"}
```

For more fancy result call `Wootheex.UserAgent.parse/1`:

```elixir
iex(3)> Wootheex.UserAgent.parse(user_agent)
%Wootheex.UserAgent{
    browser_name: "Chrome",
    browser_type: :browser,
    browser_version: "44.0.2403.155",
    category: :pc,
    os: "Mac OSX",
    os_version: "10.10.4",
    vendor: "Google"
}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `wootheex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:wootheex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/wootheex](https://hexdocs.pm/wootheex).
