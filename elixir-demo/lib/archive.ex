defmodule Archive do
  use GenServer

  def init(state), do: {:ok, state}

  def handle_cast({:add, item}, state) do
    {:noreply, internal_add_item(item, state)}
  end

  def handle_info({:del, key}, state) do
    {:noreply, Map.delete(state, key)}
  end

  def handle_cast({:add, item, ttl}, state) do
    key = elem(Enum.at(item, 0), 0)
    Process.send_after(__MODULE__, {:del, key}, ttl)
    {:noreply, internal_add_item(item, state)}
  end

  defp internal_add_item(item, state) do
    Map.merge(item, state)
  end

  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end


  ### Client API
  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def add_item(item) do
    GenServer.cast(__MODULE__, {:add, item})
  end

  def add_item(item, ttl) do
    GenServer.cast(__MODULE__, {:add, item, ttl})
  end

  def del_item(key) do
    send __MODULE__, {:del, key}
  end

  def get_list do
    GenServer.call(__MODULE__, :list)
  end

  def this_will_crash do
    send __MODULE__, {:add, 1}
  end
end
