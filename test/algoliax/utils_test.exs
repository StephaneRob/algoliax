defmodule Algoliax.UtilsTest do
  use ExUnit.Case, async: true

  defmodule NoRepo do
    use Algoliax,
      index_name: :algoliax_people,
      attributes_for_faceting: ["age"],
      searchable_attributes: ["full_name"],
      custom_ranking: ["desc(update_at)"],
      object_id: :reference
  end

  defmodule NoIndexName do
    use Algoliax,
      attributes_for_faceting: ["age"],
      searchable_attributes: ["full_name"],
      custom_ranking: ["desc(update_at)"],
      object_id: :reference
  end

  describe "Raise execption if trying Ecto specific methods" do
    test "Algoliax.MissingRepoError" do
      assert_raise(Algoliax.MissingRepoError, fn ->
        Algoliax.UtilsTest.NoRepo.reindex()
      end)

      assert_raise(Algoliax.MissingRepoError, fn ->
        Algoliax.UtilsTest.NoRepo.reindex_atomic()
      end)
    end
  end

  describe "Raise execption if index_name missing" do
    test "Algoliax.MissingRepoError" do
      assert_raise(Algoliax.MissingIndexNameError, fn ->
        Algoliax.UtilsTest.NoIndexName.get_settings()
      end)
    end
  end

  describe "Camelize" do
    test "an atom" do
      assert Algoliax.Utils.camelize(:foo_bar) == "fooBar"
    end

    test "a map" do
      a = %{foo_bar: "test", bar_foo: "test"}
      assert Algoliax.Utils.camelize(a) == %{"fooBar" => "test", "barFoo" => "test"}
    end
  end
end