defmodule Portio do

  defmodule Listener do

    def init(external_program) do
      port = Port.open(
        {:spawn, external_program},
        [:binary, :use_stdio, :stderr_to_stdout])
      loop(port)
    end

    defp loop(port) do
      receive do
        {:message, caller, uuid, message} ->
          send(port, {self, {:command, message}})
          receive do
            {^port, {:data, result}} ->
              send(caller, {:receive, uuid,
                String.slice(result, 0..(String.length(result) - 2))})
          end
          loop(port)
        {:stop, caller, uuid} ->
          send(port, {self, :close})
          receive do
            {^port, :closed} ->
              send(caller, {:stopped, uuid})
          end
      end
    end
  end


  def start(external_program) do
    spawn(Listener, :init, [external_program])
  end

  def stop(pid) do
    uuid = UUID.uuid1()

    if Process.alive?(pid) do
      send(pid, {:stop, self, uuid})
      receive do
        {:stopped, uuid} ->
          Process.exit(pid, :stop)
      end
    else
      false
    end
  end

  def send_message(pid, message) do
    uuid = UUID.uuid1()

    if Process.alive?(pid) do
      send(pid, {:message, self, uuid, message <> "\n"})
      receive do
        {:receive, uuid, data} ->
          data
      end
    end
  end
end
