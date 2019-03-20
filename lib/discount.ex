defmodule Discount do
  @moduledoc """
  This module provides discount functions according to parameters. All functions
  compute the price of a group of items when given quantity and initial price.
  """

  @doc """
  Takes arguments and returns a function which provides the required discount behavior.

  ## Examples

    >iex f = get("MANY_FOR_MANY", 3, 2)
    #Function<1.61923964/2 in Discount.get/3>
    >iex f.(6, 10.5)
    21.0
  """

  @spec get(String.t, float,  float) :: (number, number -> number)
  def get("PRICE_REDUCTION", new_price, threshold) do
    fn c, p -> if c >= threshold do c * new_price else c * p end end
  end

  def get("MANY_FOR_MANY", items_got, items_paid) do
    &(&2 * (items_paid * div(&1, items_got) + rem(&1, items_got)))
  end

  def get(_, _first, _second) do
    &(&1 * &2)
  end

end
