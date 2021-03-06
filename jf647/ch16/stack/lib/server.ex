defmodule Stack.Server do
  use GenServer

  def start_link(initial_list) do
    GenServer.start_link(__MODULE__, initial_list, name: __MODULE__)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def push(newval) when is_integer(newval) and newval < 10 do
    System.halt(3)
  end

  def push(newval) do
    GenServer.cast(__MODULE__, {:push, newval})
  end

  def handle_call(:pop, _from, [head | tail]) do
    { :reply, head, tail }
  end

  def handle_cast({ :push, newval }, list) do
    { :noreply, list ++ [newval] }
  end

  def terminate(_, []) do
    raise RuntimeError, message: "can't pop an empty stack"
  end

  def terminate(reason, _) do
    raise RuntimeError, message: reason
  end
end
