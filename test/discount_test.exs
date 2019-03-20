
defmodule DiscountTest do
  use ExUnit.Case

  doctest Discount

  test "3 x 2 and remains" do

    discount_func = Discount.get("MANY_FOR_MANY", 3, 2)
    assert(discount_func.(4, 15) == 45.00)

  end

  test "3 x 2 no remains" do

    discount_func = Discount.get("MANY_FOR_MANY", 3, 2)
    assert(discount_func.(6, 15) == 60.00)

  end

  test "30% discount 2 or more" do

    discount_func = Discount.get("PRICE_REDUCTION", 7.0, 2)
    assert(discount_func.(10, 12.0) == 70.00)

  end

  test "30% discount 2 or more only 1" do

    discount_func = Discount.get("PRICE_REDUCTION", 7.0, 2)
    assert(discount_func.(1, 12.0) == 12.00)

  end

end