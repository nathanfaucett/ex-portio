defmodule Portio do
  use Application

  @external_program "../../rust_code/rs-portio/target/release/portio"


  defmodule Listener do
    def init(external_program) do
      Process.flag(:trap_exit, true)
      port = Port.open(
        {:spawn, external_program},
        [:binary, :use_stdio, :stderr_to_stdout])
      loop(port)
    end

    def loop(port) do
      receive do
        {:send, caller, message} ->
          send(port, {self, {:command, message <> "\n"}})
          receive do
            {^port, {:data, result}} ->
              send(caller, {
                :receive,
                String.slice(result, 0..(String.length(result) - 2))})
          end
          loop(port)
      end
    end
  end


  def start(_type, _args) do
    pid = spawn(Listener, :init, [@external_program])
    Agent.start_link(fn -> pid end, name: __MODULE__)
  end

  def send(message) do
    pid = Agent.get(__MODULE__, fn(pid) -> pid end)
    send(pid, {:send, self, message})
    receive do
      {:receive, data} ->
        data
    end
  end
end
