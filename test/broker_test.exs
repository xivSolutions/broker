defmodule BrokerTest do
  use ExUnit.Case

  doctest Broker

  setup context do
    {:ok, pid } = Broker.start
    {:ok, [pid: pid]}
  end

  test "the truth", %{pid: pid} do
    assert 
  end
end
