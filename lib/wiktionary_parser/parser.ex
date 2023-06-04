defmodule WiktionaryParser.Parser do
  @moduledoc false

  require Floki

  @wiktionary_url "https://en.wiktionary.org/wiki/"
  @selectors %{
    translation: "ol li a",
    gender: "span.gender abbr",
    table: ".NavContent",
    headers: "tr.rowgroup",
    rows: "tr",
    cells: "th, td"
  }

  @entry_pattern ~r|<h2><span class="mw-headline" id="Russian">Russian(.+)(</div>.?)+|s

  def get_entry(word) do
    with {:ok, response} <- HTTPoison.get(@wiktionary_url <> word),
         [html_fragment | _] <- Regex.run(@entry_pattern, to_string(response.body)),
         {:ok, entry} <- Floki.parse_fragment(html_fragment) do
      {:ok, entry}
    else
      {:error, reason} -> {:error, reason}
      _ -> {:error, "failed to retrieve entry for word #{word}"}
    end
  end

  def extract_table(entry) do
    case Floki.find(entry, @selectors.table) do
      [table | _] -> {:ok, table}
      _ -> {:error, "failed to retrieve table with selector '#{@selectors.table}'"}
    end
  end

  def extract_table_headers(table) do
    with row_group when row_group != [] <- Floki.find(table, @selectors.headers),
         rows <- Stream.map(row_group, &Floki.find(&1, @selectors.cells)),
         headers <- Enum.map(rows, fn cells -> Enum.map(cells, &Floki.text/1) end) do
      {:ok, headers}
    else
      _ -> {:error, "failed to retrieve table headers with selector '#{@selectors.headers}'"}
    end
  end

  def extract_table_rows(table) do
    case Floki.find(table, @selectors.rows) do
      [] -> {:error, "failed to retrieve table rows with selector '#{@selectors.rows}'"}
      rows -> {:ok, rows}
    end
  end

  def extract_table_cells(rows) do
    cell_rows = Enum.map(rows, &Floki.find(&1, @selectors.cells))

    if Enum.all?(cell_rows, &(&1 != [])) do
      {:ok, Enum.map(cell_rows, fn cells -> Enum.map(cells, &Floki.text/1) end)}
    else
      {:error, "failed to retrieve table cells with selector '#{@selectors.cells}'"}
    end
  end

  def extract_translation(entry) do
    case Floki.find(entry, @selectors.translation) do
      [translation | _] -> {:ok, Floki.text(translation)}
      _ -> {:error, "failed to retrieve translation with selector '#{@selectors.translation}'"}
    end
  end

  def extract_gender(table) do
    case Floki.find(table, @selectors.gender) do
      [gender | _] -> {:ok, Floki.text(gender)}
      _ -> {:error, "failed to retrieve gender with selector #{@selectors.gender}"}
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
    |> String.downcase()
  end
end
