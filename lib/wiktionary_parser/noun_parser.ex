defmodule WiktionaryParser.NounParser do
  @moduledoc false

  import WiktionaryParser.Parser
  require Floki

  defstruct nominative_singular: nil,
            genitive_singular: nil,
            dative_singular: nil,
            accusative_singular: nil,
            instrumental_singular: nil,
            prepositional_singular: nil,
            nominative_plural: nil,
            genitive_plural: nil,
            dative_plural: nil,
            accusative_plural: nil,
            instrumental_plural: nil,
            prepositional_plural: nil

  @behaviour WiktionaryParser

  @impl WiktionaryParser
  def parse(word) do
    with {:ok, html} <- get_html(word),
         {:ok, document} <- Floki.parse_document(html),
         {:ok, table} <- extract_table(document),
         {:ok, rows} <- extract_table_rows(table),
         {:ok, cells} <- extract_table_cells(rows),
         struct <- build_struct(cells) do
      {:ok, struct}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp build_struct(cells) do
    add_declensions(%Noun{}, cells)
  end

  defp add_declensions(struct, [_ | cells]) do
    Enum.reduce(cells, struct, fn [row_name, singular, plural], acc ->
      acc
      |> add_field(to_struct_key(row_name, :singular), singular)
      |> add_field(to_struct_key(row_name, :plural), plural)
    end)
  end

  defp to_struct_key("nominative" <> _, :singular), do: :nominative_singular
  defp to_struct_key("genitive" <> _, :singular), do: :genitive_singular
  defp to_struct_key("dative" <> _, :singular), do: :dative_singular
  defp to_struct_key("accusative" <> _, :singular), do: :accusative_singular
  defp to_struct_key("instrumental" <> _, :singular), do: :instrumental_singular
  defp to_struct_key("prepositional" <> _, :singular), do: :prepositional_singular
  defp to_struct_key("nominative" <> _, :plural), do: :nominative_plural
  defp to_struct_key("genitive" <> _, :plural), do: :genitive_plural
  defp to_struct_key("dative" <> _, :plural), do: :dative_plural
  defp to_struct_key("accusative" <> _, :plural), do: :accusative_plural
  defp to_struct_key("instrumental" <> _, :plural), do: :instrumental_plural
  defp to_struct_key("prepositional" <> _, :plural), do: :prepositional_plural
  defp to_struct_key("vocative" <> _, :singular), do: :vocative_singular
  defp to_struct_key("vocative" <> _, :plural), do: :vocative_plural
end
