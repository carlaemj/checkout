defmodule Checkout do
  @moduledoc """
  This is the Checkout module.
  """

  @doc """
  Takes a series of items through scan and then calculates the price applying
  item-type specific discount rules if available.

  Returns 'float'.

  ## Examples

    iex> rules = %{"MUG": Discount.get("MANY_FOR_MANY", 3, 1)}
    iex> Checkout.new()
    iex> Checkout.scan("MUG")
    :ok
    iex> Checkout.scan("MUG")
    :ok
    iex> Checkout.scan("MUG")
    :ok
    iex> Checkout.total(rules)
    7.5
  """

  @spec new() :: {:ok, pid}
  def new do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  @spec total(%{}) :: float
  def total(pricing_rules \\ %{}) do
    all_codes = Agent.get(__MODULE__, fn l -> l end)
    #    require IEx; IEx.pry
    processed_items = map_item_to_quantity(all_codes)
    IO.puts(inspect(processed_items))
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

    original_price = Price.get(item_type)

    case Map.get(rules, String.to_atom(item_type)) do
      nil -> quantity * original_price
      a -> a.(quantity, original_price)
    end

  end

  defp prices_list(items, rules) do

    for {item_type, quantity} <- items do
      compute_price({item_type, quantity}, rules)
    end

  end
end
