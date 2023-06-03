defmodule WiktionaryParser do
  require Floki
  require HTTPoison

  @parsers %{
    verb: WiktionaryParser.VerbParser,
    noun: WiktionaryParser.NounParser
  }

  @callback parse(binary) :: {:ok, map} | {:error, binary()}

  @spec parse(binary, atom) :: {:ok, map} | {:error, binary}
  def parse(word, part_of_speech) do
    @parsers[part_of_speech].parse(word)
  end

  @spec parse!(binary, atom) :: map
  def parse!(word, part_of_speech) do
    case parse(word, part_of_speech) do
      {:ok, struct} -> struct
      {:error, reason} -> raise(reason)
    end
  end
end
