##-
# Author: Brian Tiffin
# Dedicated to the public domain
#
# Date started: February 2017
# Modified: 2017-04-21/15:06-0400 btiffin
##+
#
# GnuCOBOL as a port demo
#
defmodule Ported do
    @moduledoc """
    A small demonstration of a GnuCOBOL program in an Elixir port
    """

    @spec start(String.t) :: none
    @doc """
    Start the external port, given a command string

    Parameters

      - cmd: Command string, defaulting to ./ported

    Examples

        iex> Ported.start
    """
    def start(cmd \\ "./ported") do
        port = Port.open({:spawn, cmd}, [:binary])
        Agent.start(fn -> [p: port] end, name: :p)
    end

    @spec get_port :: port
    @doc """
    The open port is stashed away in an Agent
    """
    def get_port() do
        elem(hd(Agent.get(:p, &(&1))), 1)
    end

    @spec say(String.t) :: none
    @doc """
    Send a command to GnuCOBOL and display response.
    Relies on proper line terminators to avoid a read hang
    """
    def say(str) do
        port = get_port
        Port.command(port, str <> "\n")
        receive do
            {^port, {:data, result}} ->
                IO.puts("Got: #{inspect result}")
            after 50 ->
                IO.puts("Timeout: #{inspect port}")
        end
    end
end
