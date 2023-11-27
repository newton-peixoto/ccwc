defmodule CCWC do
  @moduledoc false

  @valid_options ~W(-c -w -l -m)

  @default_options ~W(-l -w -c)

  def main(args \\ []) do
    [file_path | options] = Enum.reverse(args)

    if File.exists?(file_path) do
      calculated_options =
        file_path
        |> handle_options(options)
        |> Enum.join(" ")

      IO.puts("#{calculated_options} #{Path.basename(file_path)}")
    else
      IO.puts("File does not exists!")
      System.halt(1)
    end

    {:ok, self()}
  end

  defp handle_options(file_path, []) do
    Enum.reduce(Enum.reverse(@default_options), [], fn option, acc ->
      [get_total_by_option(file_path, option) | acc]
    end)
  end

  defp handle_options(file_path, options) do
    has_only_valid_options = Enum.all?(options, fn option -> Enum.member?(@valid_options, option) end)

    if has_only_valid_options do
      Enum.reduce(options, [], fn option, acc ->
        [get_total_by_option(file_path, option) | acc]
      end)
    else
      IO.puts("Invalid Options Given!")
      System.halt(1)
    end
  end

  defp get_total_by_option(file_path, "-c") do
    %{size: size} = File.stat!(file_path)
    size
  end

  defp get_total_by_option(file_path, "-l") do
    file_path
    |> File.stream!()
    |> Stream.with_index()
    |> Enum.count()
  end

  defp get_total_by_option(file_path, "-w") do
    file_path
    |> File.stream!()
    |> Stream.map(fn line ->
      line
      |> String.split()
      |> Enum.count()
    end)
    |> Enum.reduce(0, fn count_by_line, acc ->
      count_by_line + acc
    end)
  end

  defp get_total_by_option(file_path, "-m") do
    file_path
    |> File.stream!([], 1_000_000)
    |> Stream.map(&String.codepoints/1)
    |> Stream.map(&Enum.count/1)
    |> Enum.sum()
  end
end
