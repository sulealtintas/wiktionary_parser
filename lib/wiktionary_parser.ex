defmodule WiktionaryParser do
  @moduledoc """
  This module provides functions for parsing Russian Wiktionary entries.
  
  Currently, only parsing of verbs and nouns is supported.
  """

  alias WiktionaryParser.Verb
  alias WiktionaryParser.Noun
  require Floki
  require HTTPoison

  @parsers %{
    verb: WiktionaryParser.VerbParser,
    noun: WiktionaryParser.NounParser
  }

  @callback parse(word :: String.t()) :: {:ok, Verb.t() | Noun.t()} | {:error, String.t()}

  @doc """
  Parses the given word as the appropriate struct.
  Returns {:ok, struct} if successful, {:error, reason} otherwise.
  
  ## Examples
  
      iex> WiktionaryParser.parse("смотреть", :verb)
      {:ok, %Verb{translation: "to look", infinitive: "смотре́ть", ...}}
  
      iex> WiktionaryParser.parse("кот", :noun)
      {:ok, %Noun{translation: "tomcat", gender: "m", ...}}
  
  """
  @spec parse(String.t(), :verb | :noun) :: {:ok, Verb.t() | Noun.t()} | {:error, String.t()}
  def parse(word, part_of_speech) do
    @parsers[part_of_speech].parse(word)
  end

  @doc """
  Parses the given word as the appropriate struct.
  Returns the parsed struct if successful, or raises an error otherwise.
  
  ## Examples
  
      iex> WiktionaryParser.parse!("смотреть", :verb)
      %Verb{translation: "to look", infinitive: "смотре́ть", ...}
  
      iex> WiktionaryParser.parse!("кот", :noun)
      %Noun{translation: "tomcat", gender: "m", ...}
  
  """
  @spec parse!(String.t(), :verb | :noun) :: Verb.t() | Noun.t()
  def parse!(word, part_of_speech) do
    case parse(word, part_of_speech) do
      {:ok, struct} -> struct
      {:error, reason} -> raise(reason)
    end
  end
end
