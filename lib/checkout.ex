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
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec total(%{}) :: float
  def total(pricing_rules \\ %{}) do
    items_bought = Agent.get(__MODULE__, fn m -> m end)
    plist = prices_list(items_bought, pricing_rules)
    final_price = Enum.sum(plist)
    final_price
  end

  @spec scan(String.t) :: :ok
  def scan(code) do
    IO.puts(code)
    Agent.update(__MODULE__, fn m -> Map.update(m, code, 1, &(&1 + 1)) end)
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
