ExUnit.start()

defmodule Aoc4 do
  def get_input_from_filename(filename) do
    raw =
      File.stream!(filename)
      |> Enum.map(&String.trim/1)

    [draws | raw] = raw

    draws =
      draws
      |> String.split(",")
      |> Enum.map(fn element -> Integer.parse(element) end)
      |> Enum.map(fn element -> elem(element, 0) end)

    boards =
      raw
      |> Enum.filter(fn element -> element != "" end)
      |> Enum.filter(fn element -> String.printable?(element) end)
      |> Enum.filter(fn element -> Integer.parse(element) != :error end)
      |> Enum.map(fn element -> String.split(element) end)
      |> Enum.map(fn element -> Enum.map(element, fn item -> elem(Integer.parse(item), 0) end) end)
      |> Enum.chunk_every(5)

    {draws, boards}
  end

  def solver([value | rest], boards, winning_boards) do
    boards =
      boards
      |> Enum.map(fn board ->
        Enum.map(
          board,
          fn line ->
            Enum.map(
              line,
              fn {line_item, state} ->
                cond do
                  value == line_item -> {line_item, true}
                  true -> {line_item, state}
                end
              end
            )
          end
        )
      end)

    get_columns_and_lines = fn lines ->
      columns =
        lines
        |> Enum.zip()
        |> Enum.map(fn tuple -> Tuple.to_list(tuple) end)

      lines ++ columns
    end

    is_board_winning = fn lines ->
      items = get_columns_and_lines.(lines)

      Enum.any?(items, fn line_or_column ->
        Enum.all?(line_or_column, fn item -> elem(item, 1) == true end)
      end)
    end

    new_winners = Enum.filter(boards, is_board_winning)

    boards = boards -- new_winners

    calc_score = fn winning_board ->
      score =
        winning_board
        |> Enum.map(fn line -> Enum.filter(line, fn {_, state} -> state == false end) end)
        |> Enum.map(fn line -> Enum.map(line, fn {num, _} -> num end) end)
        |> List.flatten()
        |> Enum.sum()

      score * value
    end

    to_winning_board = fn board ->
      score = calc_score.(board)

      board =
        board
        |> Enum.map(fn line -> Enum.map(line, fn item -> elem(item, 0) end) end)

      {score, board}
    end

    new_winners =
      new_winners
      |> Enum.map(to_winning_board)

    winning_boards = winning_boards ++ new_winners

    solver(rest, boards, winning_boards)
  end

  def solver([], _boards, winning_boards) do
    winning_boards
  end

  def solve(draws, raw_boards) do
    boards =
      raw_boards
      |> Enum.map(fn board ->
        Enum.map(board, fn line -> Enum.map(line, fn item -> {item, false} end) end)
      end)

    solver(draws, boards, [])
  end
end

defmodule Aoc4Test do
  use ExUnit.Case

  test "part1" do
    {draws, boards} = Aoc4.get_input_from_filename("sample.input")

    assert draws == [
             7,
             4,
             9,
             5,
             11,
             17,
             23,
             2,
             0,
             14,
             21,
             24,
             10,
             16,
             13,
             6,
             15,
             25,
             12,
             22,
             18,
             20,
             8,
             19,
             3,
             26,
             1
           ]

    expected_boards = [
      [
        [22, 13, 17, 11, 0],
        [8, 2, 23, 4, 24],
        [21, 9, 14, 16, 7],
        [6, 10, 3, 18, 5],
        [1, 12, 20, 15, 19]
      ],
      [
        [3, 15, 0, 2, 22],
        [9, 18, 13, 17, 5],
        [19, 8, 7, 25, 23],
        [20, 11, 10, 24, 4],
        [14, 21, 16, 12, 6]
      ],
      [
        [14, 21, 17, 24, 4],
        [10, 16, 15, 9, 19],
        [18, 8, 23, 26, 20],
        [22, 11, 13, 6, 5],
        [2, 0, 12, 3, 7]
      ]
    ]

    assert boards == expected_boards

    winners = Aoc4.solve(draws, boards)

    first_winner_score = winners |> hd() |> elem(0)
    last_winner_score = winners |> List.last() |> elem(0)

    assert first_winner_score == 4512
    assert last_winner_score == 1924
  end
end

{draws, boards} = Aoc4.get_input_from_filename("../../inputs/aoc_4.input")
winners = Aoc4.solve(draws, boards)

first_winner_score = winners |> hd() |> elem(0)
last_winner_score = winners |> List.last() |> elem(0)

IO.puts("First part: #{first_winner_score}")

IO.puts("Second part: #{last_winner_score}")
