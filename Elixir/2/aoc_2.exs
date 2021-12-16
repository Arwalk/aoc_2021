ExUnit.start()

defmodule AoC2 do

  def update_pos_simple(position, update) do
    case update do
      {"forward", x} -> %{position | :horizontal => position[:horizontal] + x}
      {"down", x} -> %{position | :depth => position[:depth] + x}
      {"up", x} -> %{position | :depth => position[:depth] - x}
    end
  end

  def update_pos_with_aim(position, update) do
    case update do
      {"forward", x} -> %{position | :horizontal => position[:horizontal] + x, :depth => position[:depth] + position[:aim] * x}
      {"down", x} -> %{position | :aim => position[:aim] + x}
      {"up", x} -> %{position | :aim => position[:aim] - x}
    end
  end

  def get_pos(enum, updater, initial) do
    Enum.reduce(enum, initial, fn item, current_pos -> updater.(current_pos, item) end)
  end

  def get_total_value(pos) do
    pos[:horizontal] * pos[:depth]
  end

  def get_solution(enum, updater, initial) do
    get_total_value(get_pos(enum, updater, initial))
  end

end

defmodule Aoc2Tests do
  use ExUnit.Case
  @sample_input [
    {"forward", 5},
    {"down", 5},
    {"forward", 8},
    {"up", 3},
    {"down", 8},
    {"forward", 2}
  ]

  test "part 1" do
    assert AoC2.get_solution(@sample_input, &AoC2.update_pos_simple/2, %{:horizontal => 0, :depth => 0}) == 150
  end

  test "part 2" do
    assert AoC2.get_solution(@sample_input, &AoC2.update_pos_with_aim/2, %{:horizontal => 0, :depth => 0, :aim => 0}) == 900
  end
end

get_input = fn  ->
  File.stream!("aoc_2.input")
  |> Stream.map(&String.trim/1)
  |> Enum.map(&String.split/1)
  |> Enum.map(fn sublist -> {hd(sublist), elem(Integer.parse(hd(tl(sublist))), 0)} end)
end

input = get_input.()

IO.puts "First part: #{AoC2.get_solution(input, &AoC2.update_pos_simple/2, %{:horizontal => 0, :depth => 0})}"

IO.puts "Second part #{AoC2.get_solution(input, &AoC2.update_pos_with_aim/2, %{:horizontal => 0, :depth => 0, :aim => 0})}"
