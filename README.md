# Portio

port io helper

## Usage

set external program to run on start up
config :portio, external_program: "../../rust_code/rs-portio/target/release/portio"

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `portio` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:portio, "~> 0.1.0"}]
    end
    ```

  2. Ensure `portio` is started before your application:

    ```elixir
    def application do
      [applications: [:portio]]
    end
    ```
