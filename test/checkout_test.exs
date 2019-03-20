

defmodule CheckoutTest do
  use ExUnit.Case

  doctest Checkout

  test "somehow works" do
    Checkout.new()
    Checkout.scan("TSHIRT")
    Checkout.scan("TSHIRT")
    Checkout.scan("TSHIRT")
    Checkout.scan("TSHIRT")
    assert Checkout.total() == 80.0
  end

  test "somehow works v2" do
    Checkout.new()
    Checkout.scan("TSHIRT")
    Checkout.scan("TSHIRT")
    Checkout.scan("TSHIRT")
    assert Checkout.total() == 60.0
  end

  test "CASE 1" do
    discounts = %{
      TSHIRT: Discount.get("PRICE_REDUCTION", 19.0, 3),
      VOUCHER: Discount.get("MANY_FOR_MANY", 2, 1)
    }

    Checkout.new()
    Checkout.scan("VOUCHER")
    Checkout.scan("TSHIRT")
    Checkout.scan("MUG")
    assert(Checkout.total(discounts) == 32.50)
  end

  test "CASE 2" do
    discounts = %{
      TSHIRT: Discount.get("PRICE_REDUCTION", 19.0, 3),
      VOUCHER: Discount.get("MANY_FOR_MANY", 2, 1)
    }

    Checkout.new()
    Checkout.scan("VOUCHER")
    Checkout.scan("TSHIRT")
    Checkout.scan("VOUCHER")
    assert(Checkout.total(discounts) == 25.0)
  end

  test "CASE 3" do
    discounts = %{
      TSHIRT: Discount.get("PRICE_REDUCTION", 19.0, 3),
      VOUCHER: Discount.get("MANY_FOR_MANY", 2, 1)
    }

    Checkout.new()
    Checkout.scan("TSHIRT")
    Checkout.scan("TSHIRT")
    Checkout.scan("TSHIRT")
    Checkout.scan("VOUCHER")
    Checkout.scan("TSHIRT")
    assert(Checkout.total(discounts) == 81.00)
  end

  test "Empty cart with discounts" do
    discounts = %{
      TSHIRT: Discount.get("PRICE_REDUCTION", 19.0, 3),
      VOUCHER: Discount.get("MANY_FOR_MANY", 2, 1)
    }

    Checkout.new()
    assert(Checkout.total(discounts) == 0.0)
  end

  test "Empty cart without discounts" do

    Checkout.new()
    assert(Checkout.total() == 0.0)
  end

  test "Unrecognized item" do

    Checkout.new()
    Checkout.scan("PEN")
    assert(Checkout.total() == 0.0)
  end

end
