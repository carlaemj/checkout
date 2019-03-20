defmodule Price do
  @moduledoc false
  @items_file "priv/prices.json"
  @items_content File.read!(@items_file)
  @items Poison.Parser.parse(@items_content)

  @spec get(String.t()) :: float
  def get(code) do

    items_catalog = process()

    case Map.get(items_catalog, String.to_atom(code)) do
      %{price: item_price} -> item_price
      _ -> 0.0  # Exception?
    end

  end

  defp process() do
    {:ok, p} = @items

    for %{"NAME" => name, "CODE" => code, "PRICE" => price} <- p,
        into: %{},
        do: {String.to_atom(code), %{name: name, price: price}}
  end
end