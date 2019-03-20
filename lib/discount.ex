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
