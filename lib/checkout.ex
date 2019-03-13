defmodule Checkout do
  @moduledoc false

  @spec new() :: {:ok, pid}
  def new do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  @spec total(%{}) :: float
  def total(pricing_rules \\ %{}) do
    all_codes = Agent.get(__MODULE__, fn l -> l end)
    #    require IEx; IEx.pry
    processed_items = map_item_to_quantity(all_codes)
    processed_items |> inspect |> IO.puts()
    plist = prices_list(processed_items, pricing_rules)
    IO.puts(inspect(plist))
    final_price = Enum.sum(plist)
    IO.puts("Total: #{final_price}")
    final_price
  end

  @spec scan(String.t) :: :ok
  def scan(code) do
    IO.puts(code)
    Agent.update(__MODULE__, fn l -> [code | l] end)
  end

  defp map_item_to_quantity(all_codes) do
    types = Enum.uniq(all_codes)
    counter = Enum.map(types, fn type -> Enum.count(all_codes, fn item -> item == type end) end)
    for {t, c} <- Enum.zip(types, counter), into: %{}, do: {t, c}
  end

  defp compute_price({item_type, quantity}, rules) do
    case Map.get(rules, String.to_atom(item_type)) do
      nil -> Price.get(item_type) * quantity
      a -> a.(quantity, Price.get(item_type))
    end
  end

  defp prices_list(items, rules) do
    inspect(map_size(items)) |> IO.puts()

    for {item_type, quantity} <- items do
      compute_price({item_type, quantity}, rules)
    end
  end
end
