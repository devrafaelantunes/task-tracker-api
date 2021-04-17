defmodule TaskTracker.Utils do
  import Date

  def transform_date(task) do
    [month, day, year] = String.split(task, "/")

    {:ok, date} =
      Date.new(String.to_integer(year), String.to_integer(month), String.to_integer(day))

    %{date: date}
  end

  def retransform_date(date) do
    date = Date.to_string(date)

    [year, month, day] = String.split(date, "-")

    month <> "/" <> day <> "/" <> year
  end

  def atomify_map(map) when is_map(map) do
    Enum.reduce(map, %{}, fn {key, value}, new_map ->
      cond do
        is_binary(key) ->
          Map.put(new_map, String.to_atom(key), atomify_map(value))

        true ->
          Map.put(new_map, key, atomify_map(value))
      end
    end)
  end

  def atomify_map(other), do: other
end
