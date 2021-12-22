ExUnit.start()

get_input = fn ->
  File.stream!("aoc_1.input") |> Enum.map(fn line -> elem(Integer.parse(line), 0) end)
end

defmodule Aoc1 do
  def get_count_increment(enum) do
    Stream.map(enum, fn slice -> Enum.at(slice, 0) < Enum.at(slice, 1) end)
    |> Stream.filter(fn elem -> elem end)
    |> Enum.count()
  end

  def get_count(enum) do
    map_to_sliding_window(enum, 2) |> get_count_increment()
  end

  def get_count_for_sliding(enum) do
    map_to_sliding_window(enum, 3)
    |> Stream.map(fn slice -> Enum.sum(slice) end)
    |> get_count()
  end

  def map_to_sliding_window(enum, size) do
    get_slice = fn index -> Enum.slice(enum, index..(index + size - 1)) end

    0..(Enum.count(enum) - size)
    |> Enum.map(get_slice)
  end
end

defmodule ReducerTest do
  use ExUnit.Case

  @sample_input [
    199,
    200,
    208,
    210,
    200,
    207,
    240,
    269,
    260,
    263
  ]

  test "sample is ok" do
    assert Aoc1.get_count(@sample_input) == 7
  end

  test "get sliding window" do
    expected = [
      [199, 200, 208],
      [200, 208, 210],
      [208, 210, 200],
      [210, 200, 207],
      [200, 207, 240],
      [207, 240, 269],
      [240, 269, 260],
      [269, 260, 263]
    ]

    assert Aoc1.map_to_sliding_window(@sample_input, 3) == expected
  end

  test "get count for sliding" do
    assert Aoc1.get_count_for_sliding(@sample_input) == 5
  end
end

input = get_input.()

IO.puts("First part answer: #{input |> Aoc1.get_count()}")

IO.puts("Second part answer: #{input |> Aoc1.get_count_for_sliding()}")
