defmodule Connection do
  defstruct pid: nil, locked: false
end

defmodule Broker do
  use GenServer

  def start do
    GenServer.start_link(__MODULE__, fill_pool, name: Moby)
  end

  def execute(sql) do
    GenServer.call(Moby, {:execute, sql})
  end

  def handle_call({:execute, sql}, _from, state) do
    {pid, results} = query(sql, state)
    unlock(pid, state)
    send(self, {:unlocked, pid})
    {:reply, results, state}
  end

  def unlock(_open_id, []), do: []

  def unlock(open_pid, [%{pid: pid, locked: true}|pool]) when open_pid == pid do
    Postgrex.Connection.stop(open_pid)
    [%{pid: open_pid, locked: false}|pool]
  end

  def unlock(open_pid, [_pid|pool]),
    do: unlock(open_pid, pool)

  def query(sql, []) do
    receive do
      {:unlocked, pid} ->
        IO.puts "Got unlocked!"
        query(sql, [%{pid: pid, locked: false}])
    after
      100 -> raise "Error querying database"
    end
  end

  def query(sql, [%{pid: _pid, locked: true}|pool]),
    do: query(sql, pool)

  def query(sql, [%{pid: pid, locked: false}|_pool]) do
    {pid, Postgrex.Connection.query!(pid, sql, [])}
  end

  def fill_pool do
    Enum.map(1..5, fn(_n) ->
      {:ok, pid} =  Postgrex.Connection.start_link(hostname: "localhost", database: "meebuss")
      %Connection{pid: pid}
    end)
  end
end
