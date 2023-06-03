defmodule WiktionaryParser.Parser do
  require Floki

  @wiktionary_url "https://en.wiktionary.org/wiki/"
  @selectors %{
    translation: "ol li a",
    table: ".NavContent",
    language: ".lang-ru",
    headers: "tr.rowgroup",
    rows: "tr",
    cells: "th, td"
  }

  def get_html(word) do
    with {:ok, response} <- HTTPoison.get(@wiktionary_url <> word) do
      {:ok, response.body}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def extract_table(document) do
    with frames when frames != [] <- Floki.find(document, @selectors.table),
         frame when frame != [] <-
           Enum.filter(frames, fn frame -> Floki.find(frame, @selectors.language) != [] end),
         [table | _] <- Floki.find(frame, @selectors.table) do
      {:ok, table}
    else
      _ ->
        {:error,
         "table with selectors '#{@selectors.table}' and #{@selectors.language}' not found"}
    end
  end

  def extract_table_rows(table) do
    case Floki.find(table, @selectors.rows) do
      [] -> {:error, "table rows with selector '#{@selectors.rows}' not found"}
      rows -> {:ok, rows}
    end
  end

  def extract_table_cells(rows) do
    cell_rows = Enum.map(rows, &Floki.find(&1, @selectors.cells))

    if Enum.all?(cell_rows, &(&1 != [])) do
      {:ok, Enum.map(cell_rows, fn cells -> Enum.map(cells, &Floki.text/1) end)}
    else
      {:error, "table cells with selector '#{@selectors.cells}' not found"}
    end
  end

  def add_field(struct, key, text) do
    Map.put(struct, key, clean_text(text))
  end

  def clean_text(""), do: nil
  def clean_text("—" <> _), do: nil

  def clean_text(text) do
    text
    |> String.split("\n")
    |> Enum.at(0)
    |> String.replace("*", "")
  end
end
