defmodule MockitTest do
  use ExUnit.Case
  use Mockit

  test "Can stub out static value" do
    allow(Mockit.Dummy.get(1)).to_return "Hello"

    assert Mockit.Dummy.get(1) == "Hello"
  end

  test "Can stub out using a anonymous function" do
    allow(Mockit.Dummy.get).to_return fn 1 -> "Hello"
                                  2 -> "Bye" end

    assert Mockit.Dummy.get(1) == "Hello"
    assert Mockit.Dummy.get(2) == "Bye"
  end

  test "Can match any arguments" do
    allow(Mockit.Dummy.get(:_)).to_return "Jerks"

    assert Mockit.Dummy.get("a") == "Jerks"
    assert Mockit.Dummy.get("b") == "Jerks"
  end

  test "Can create sequence of stubs" do
    allow(Mockit.Dummy.get(:_)).to_return seq([1,2,3])

    assert Mockit.Dummy.get("a") == 1
    assert Mockit.Dummy.get("b") == 2
    assert Mockit.Dummy.get("c") == 3
    assert Mockit.Dummy.get("d") == 3
  end

  test "Can create loop of stubs" do
    allow(Mockit.Dummy.get(:_)).to_return loop([1,2,3])

    assert Mockit.Dummy.get("a") == 1
    assert Mockit.Dummy.get("b") == 2
    assert Mockit.Dummy.get("c") == 3
    assert Mockit.Dummy.get("d") == 1
  end

  test "assert_called validate call to mock was made" do
    allow(Mockit.Dummy.get(:_)).to_return "Testing"

    Mockit.Dummy.get("a")
    Mockit.Dummy.get("a")

    assert_called Mockit.Dummy.get("a")
  end

  test "validator once" do
    allow(Mockit.Dummy.get(:_)).to_return "Testing"

    Mockit.Dummy.get("a")
    Mockit.Dummy.get("a")

    refute_called Mockit.Dummy.get("a"), once()
  end

  test "validator times" do
    allow(Mockit.Dummy.get(:_)).to_return "Testing"

    Mockit.Dummy.get("a")
    Mockit.Dummy.get("a")

    assert_called Mockit.Dummy.get("a"), times(2)
  end

  test "refute negative validator times" do
    allow(Mockit.Dummy.get(:_)).to_return "Testing"

    Mockit.Dummy.get("a")

    refute_called Mockit.Dummy.get("a"), times(2)
  end

end
