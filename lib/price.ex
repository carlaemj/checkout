defmodule Price do
  @moduledoc false
  @prices_file "priv/prices.json"
  @prices_content File.read!(@prices_file)
  @prices Poison.Parser.parse(@prices_content)

  @spec get(String.t()) :: float
  def get(code) do
    prices = process()
    p = Map.get(prices, String.to_atom(code))
    Map.get(p, :price)
  end

  @spec process() :: %{}
  def process() do
    {:ok, p} = @prices

    for %{"NAME" => name, "CODE" => code, "PRICE" => price} <- p,
        into: %{},
        do: {String.to_atom(code), %{name: name, price: price}}
  end
end