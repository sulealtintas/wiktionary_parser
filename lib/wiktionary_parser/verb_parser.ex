defmodule WiktionaryParser.VerbParser do
  @moduledoc false

  import WiktionaryParser.Parser
  require Floki

  @behaviour WiktionaryParser

  @impl WiktionaryParser
  def parse(word) do
    with {:ok, entry} <- get_entry(word),
         {:ok, translation} <- extract_translation(entry),
         {:ok, table} <- extract_table(entry),
         {:ok, headers} <- extract_table_headers(table),
         {:ok, rows} <- extract_table_rows(table),
         {:ok, cells} <- extract_table_cells(rows),
         {:ok, table_sections} <- extract_table_sections(cells, headers),
         struct <- build_struct(table_sections, translation) do
      {:ok, struct}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp build_struct(table_sections, translation) do
    %Verb{}
    |> add_field(:translation, "to " <> translation)
    |> add_field(:infinitive, table_sections.infinitive)
    |> add_field(:aspect, table_sections.aspect |> String.split() |> Enum.at(0))
    |> add_present_future_tense(table_sections.present_future_tense)
    |> add_past_tense(table_sections.past_tense)
    |> add_imperative(table_sections.imperative)
    |> add_participles(table_sections.participles)
  end

  defp extract_table_sections(cells, table_headers) do
    case Enum.chunk_by(cells, &Enum.member?(table_headers, &1)) do
      [
        [[aspect]],
        [["infinitive", infinitive]],
        _,
        participles,
        _,
        present_future_tense,
        _,
        imperative,
        _,
        past_tense
      ] ->
        table_sections = %{
          aspect: aspect,
          infinitive: infinitive,
          participles: participles,
          present_future_tense: present_future_tense,
          imperative: imperative,
          past_tense: past_tense
        }

        {:ok, table_sections}

      _ ->
        {:error, "unexpected HTML table structure"}
    end
  end

  defp add_present_future_tense(%{aspect: "imperfective"} = struct, cells) do
    Enum.reduce(cells, struct, fn [row_name, present, future], acc ->
      acc
      |> add_field(to_struct_key(row_name, :present), present)
      |> add_field(to_struct_key(row_name, :future), future)
    end)
  end

  defp add_present_future_tense(%{aspect: "perfective"} = struct, cells) do
    Enum.reduce(cells, struct, fn [row_name, _present, future], acc ->
      add_field(acc, to_struct_key(row_name, :future), future)
    end)
  end

  defp add_past_tense(
         struct,
         [
           ["masculine" <> _, masculine_singular, plural],
           ["feminine" <> _, feminine_singular],
           ["neuter" <> _, neuter_singular]
         ]
       ) do
    struct
    |> add_field(:past_singular_masculine, masculine_singular)
    |> add_field(:past_singular_feminine, feminine_singular)
    |> add_field(:past_singular_neuter, neuter_singular)
    |> add_field(:past_plural, plural)
  end

  defp add_imperative(struct, [[_, second_singular, second_plural]]) do
    struct
    |> add_field(:imperative_second_singular, second_singular)
    |> add_field(:imperative_second_plural, second_plural)
  end

  defp add_participles(struct, [
         ["active", present_active, past_active],
         ["passive", present_passive, past_passive],
         ["adverbial", present_adverbial, past_adverbial]
       ]) do
    struct
    |> add_field(:present_active_participle, present_active)
    |> add_field(:past_active_participle, past_active)
    |> add_field(:present_passive_participle, present_passive)
    |> add_field(:past_passive_participle, past_passive)
    |> add_field(:present_adverbial_participle, present_adverbial)
    |> add_field(:past_adverbial_participle, past_adverbial)
  end

  defp to_struct_key("1stsingular" <> _, :present), do: :present_first_singular
  defp to_struct_key("2ndsingular" <> _, :present), do: :present_second_singular
  defp to_struct_key("3rdsingular" <> _, :present), do: :present_third_singular
  defp to_struct_key("1stplural" <> _, :present), do: :present_first_plural
  defp to_struct_key("2ndplural" <> _, :present), do: :present_second_plural
  defp to_struct_key("3rdplural" <> _, :present), do: :present_third_plural
  defp to_struct_key("1stsingular" <> _, :future), do: :future_first_singular
  defp to_struct_key("2ndsingular" <> _, :future), do: :future_second_singular
  defp to_struct_key("3rdsingular" <> _, :future), do: :future_third_singular
  defp to_struct_key("1stplural" <> _, :future), do: :future_first_plural
  defp to_struct_key("2ndplural" <> _, :future), do: :future_second_plural
  defp to_struct_key("3rdplural" <> _, :future), do: :future_third_plural
end
