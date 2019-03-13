defmodule Discount do
  @moduledoc false

  @spec get(String.t, float,  float) :: (number, number -> number)
  def get("PRICE_REDUCTION", first, second) do
    fn c, p -> if c >= second do c * first else c * p end end
  end

  def get("MANY_FOR_MANY", first, second) do
    &(&2 * (second * div(&1, first) + rem(&1, first)))
  end

  def get(_, _first, _second) do
    &(&1 * &2)
  end
end
