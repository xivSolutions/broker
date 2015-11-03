defmodule BrokerTest do
  use ExUnit.Case

  doctest Broker

  setup context do
    {:ok, pid } = Broker.start
    {:ok, [pid: pid]}
  end

  test "the truth", %{pid: pid} do
    x = Enum.map(1..10000, fn(n) -> Broker.execute("insert into people (first_name) values ('Name #{n}');") end)
    assert 10000 = x.length
  end
end
