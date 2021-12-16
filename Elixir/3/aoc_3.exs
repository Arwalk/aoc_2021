ExUnit.start()
use Bitwise

defmodule Aoc3 do

  def lines_as_bits(lines) do

    charlist_to_bits = fn charlist ->
      charlist
      |> String.graphemes()
      |> Stream.map(&to_string/1)
      |> Stream.map(&Integer.parse/1)
      |> Enum.map(fn element -> elem(element, 0) end)
    end

    lines
    |> Enum.map(charlist_to_bits)

  end

  def as_columns(lines) do
    lines |> List.zip() |> Enum.map(&Tuple.to_list/1)
  end

  def count_bits(items) do
    %{0 => Enum.count(items, &(&1 == 0)), 1 => Enum.count(items, &(&1 == 1))}
  end

  def get_most_common_bit(bit_counts) do
    cond do
      bit_counts[0] > bit_counts[1] -> 0
      true -> 1
    end
  end

  def get_least_common_bit(bit_counts) do
    cond do
      bit_counts[0] <= bit_counts[1] -> 0
      true -> 1
    end
  end

  def accumulate_bits(bit, current) do
    (current <<< 1) + bit
  end

  def get_column_bit_counts(lines) do
    lines
    |> lines_as_bits()
    |> as_columns()
    |> Enum.map(&count_bits/1)
  end

  def get_power_consumption(lines) do
    gamma = Task.async(fn -> get_column_bit_counts(lines) |> Enum.map(&get_most_common_bit/1) |> Enum.reduce(0, &accumulate_bits/2) end)
    epsilon = Task.async(fn ->get_column_bit_counts(lines) |> Enum.map(&get_least_common_bit/1) |> Enum.reduce(0, &accumulate_bits/2) end)

    Task.await(gamma) * Task.await(epsilon)
  end

  def get_life_support_rating(lines) do
    lines_bits = lines |> lines_as_bits()

    is_corresponding = fn get_relevant_bits ->
      fn _, acc ->
        {index, current_list} = acc

        bit_count = current_list
        |> as_columns()
        |> Enum.map(&count_bits/1)
        |> Enum.map(get_relevant_bits)

        case Enum.count(current_list) do
          1 -> {:halt, hd(current_list)}
          _ -> {:cont, {index + 1, Enum.filter(current_list, fn item -> Enum.at(item, index) == Enum.at(bit_count, index) end)}}
        end
      end
    end

    oxygen = Task.async(fn -> 0..Enum.count(lines_bits)
    |> Enum.reduce_while({0, lines_bits}, is_corresponding.(&get_most_common_bit/1))
    |> Enum.reduce(0, &accumulate_bits/2) end )

    co2 = Task.async(fn -> 0..Enum.count(lines_bits)
    |> Enum.reduce_while({0, lines_bits}, is_corresponding.(&get_least_common_bit/1))
    |> Enum.reduce(0, &accumulate_bits/2) end )

    Task.await(oxygen) * Task.await(co2)
  end

end


defmodule ReducerTest do
  use ExUnit.Case

  @sample_input [
    "00100",
    "11110",
    "10110",
    "10111",
    "10101",
    "01111",
    "00111",
    "11100",
    "10000",
    "11001",
    "00010",
    "01010"
  ]

  test "lines as bits" do
    expected = [
      [0, 0, 1, 0, 0],
      [1, 1, 1, 1, 0],
      [1, 0, 1, 1, 0],
      [1, 0, 1, 1, 1],
      [1, 0, 1, 0, 1],
      [0, 1, 1, 1, 1],
      [0, 0, 1, 1, 1],
      [1, 1, 1, 0, 0],
      [1, 0, 0, 0, 0],
      [1, 1, 0, 0, 1],
      [0, 0, 0, 1, 0],
      [0, 1, 0, 1, 0]
    ]

    columns = [
      [0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0],
      [0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
      [0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1],
      [0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0]
    ]

    assert expected == Aoc3.lines_as_bits(@sample_input)
    assert columns == Aoc3.as_columns(expected)
    assert %{0 => 4, 1 => 1} == Aoc3.count_bits([0, 0, 1, 0, 0])
    assert 0 == Aoc3.get_most_common_bit(%{0 => 4, 1 => 1})

    assert 198 == Aoc3.get_power_consumption(@sample_input)

    assert 230 = Aoc3.get_life_support_rating(@sample_input)
  end

end

input = File.stream!("aoc_3.input") |> Enum.map(&String.trim/1)

IO.puts "First part: #{Aoc3.get_power_consumption(input)}"

IO.puts "Second part: #{Aoc3.get_life_support_rating(input)}"
