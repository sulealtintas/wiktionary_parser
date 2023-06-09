defmodule WiktionaryParser.NounParser do
  @moduledoc """
  Implements the WiktionaryParser behaviour to parse Wiktionary entries for Russian nouns.
  """

  import WiktionaryParser.Parser
  alias WiktionaryParser.Noun
  @behaviour WiktionaryParser

  @selectors %{
    gender: "span.gender abbr"
  }

  @doc """
  Parses the Wiktionary entry for a noun, given its nominative singular form.
  
  Returns `{:ok, noun}` if successful, `{:error, reason}` otherwise.
  """
  @spec parse(word :: String.t()) :: {:ok, Noun.t()} | {:error, String.t()}
  @impl WiktionaryParser
  def parse(word) do
    with {:ok, entry} <- get_entry(word),
         {:ok, translation} <- extract_translation(entry),
         {:ok, gender} <- extract_gender(entry),
         {:ok, table} <- extract_table(entry),
         {:ok, rows} <- extract_table_rows(table),
         {:ok, cells} <- extract_table_cells(rows),
         struct <- build_struct(cells, translation, gender) do
      {:ok, struct}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp build_struct(cells, translation, gender) do
    %Noun{}
    |> add_field(:translation, translation)
    |> add_field(:gender, gender)
    |> add_declensions(cells)
  end

  defp add_declensions(struct, [_ | cells]) do
    Enum.reduce(cells, struct, fn
      [row_name, singular], acc ->
        add_field(acc, to_struct_key(row_name, :singular), singular)

      [row_name, singular, plural], acc ->
        acc
        |> add_field(to_struct_key(row_name, :singular), singular)
        |> add_field(to_struct_key(row_name, :plural), plural)
    end)
  end

  def extract_gender(entry) do
    with [gender_html | _] <- Floki.find(entry, @selectors.gender),
         gender_string <- Floki.text(gender_html) do
      to_gender(gender_string)
    else
      _ -> {:error, "failed to retrieve gender with selector #{@selectors.gender}"}
    end
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
  defp to_struct_key("partitive" <> _, :singular), do: :partitive_singular
  defp to_struct_key("partitive" <> _, :plural), do: :partitive_plural
  defp to_struct_key("vocative" <> _, :singular), do: :vocative_singular
  defp to_struct_key("vocative" <> _, :plural), do: :vocative_plural

  defp to_gender("m" <> _), do: {:ok, :masculine}
  defp to_gender("f" <> _), do: {:ok, :feminine}
  defp to_gender("n" <> _), do: {:ok, :neuter}
  defp to_gender(text), do: {:error, "unrecognized gender #{text}"}
end
