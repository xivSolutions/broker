# Broker

run mix deps.get

iex -S mix

Broker.start

Enum.map(1..10000, fn(n) -> Broker.execute("insert into people (first_name) values ('Name #{n}');") end)
