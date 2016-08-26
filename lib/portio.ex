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
        {:message, caller, message} ->
          send(port, {self, {:command, message}})
          receive do
            {^port, {:data, result}} ->
              send(caller, {:receive,
                String.slice(result, 0..(String.length(result) - 2))})
          end
          loop(port)
        {:stop, caller} ->
          send(port, {self, :close})
          receive do
            {^port, :closed} ->
              send(caller, :stopped)
          end
      end
    end
  end


  def start(external_program) do
    spawn(Listener, :init, [external_program])
  end

  def stop(pid) do
    if Process.alive?(pid) do
      send(pid, {:stop, self})
      receive do
        :stopped ->
          Process.exit(pid, :stop)
      end
    else
      false
    end
  end

  def send_message(pid, message) do
    if Process.alive?(pid) do
      send(pid, {:message, self, message <> "\n"})
      receive do
        {:receive, data} ->
          data
      end
    end
  end
end
