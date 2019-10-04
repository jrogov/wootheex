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
