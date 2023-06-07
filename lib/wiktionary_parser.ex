defmodule WiktionaryParser do
  @moduledoc """
  This module provides functions for parsing Russian [Wiktionary](https://en.wiktionary.org) entries
  given the dictionary form of a word.
  
  Currently, only parsing of verbs and nouns is supported.
  """

  require Floki
  require HTTPoison
  alias WiktionaryParser.Noun
  alias WiktionaryParser.Verb

  @parsers %{
    verb: WiktionaryParser.VerbParser,
    noun: WiktionaryParser.NounParser
  }

  @doc """
  Parses the Wiktionary entry for a word of a particular part of speech given its dictionary
  form.
  
  Returns `{:ok, struct}` if successful, `{:error, reason}` otherwise.
  """
  @callback parse(word :: String.t()) :: {:ok, Verb.t() | Noun.t()} | {:error, String.t()}

  @doc """
  Parses the Wiktionary entry for a word as the appropriate struct given its dictionary form
  and the part of speech.
  
  The provided `part_of_speech` atom must be either `:verb` or `:noun`.
  Returns `{:ok, struct}` if successful, `{:error, reason}` otherwise.
  
  ## Examples
  
      iex> WiktionaryParser.parse("смотреть", :verb)
      {:ok, %WiktionaryParser.Verb{translation: "to look", infinitive: "смотре́ть", ...}}
  
      iex> WiktionaryParser.parse("кот", :noun)
      {:ok, %WiktionaryParser.Noun{translation: "tomcat", gender: :masculine, ...}}
  
  """
  @spec parse(word :: String.t(), part_of_speech :: :verb | :noun) ::
          {:ok, Verb.t() | Noun.t()} | {:error, String.t()}
  def parse(word, part_of_speech) do
    @parsers[part_of_speech].parse(word)
  end

  @doc """
  Parses the Wiktionary entry for a word as the appropriate struct given its dictionary form
  and the part of speech.
  
  The provided `part_of_speech` atom must be either `:verb` or `:noun`.
  Returns the parsed struct if successful, or raises an error otherwise.
  
  ## Examples
  
      iex> WiktionaryParser.parse!("смотреть", :verb)
      %WiktionaryParser.Verb{translation: "to look", infinitive: "смотре́ть", ...}
  
      iex> WiktionaryParser.parse!("кот", :noun)
      %WiktionaryParser.Noun{translation: "tomcat", gender: :masculine, ...}
  
  """
  @spec parse!(word :: String.t(), part_of_speech :: :verb | :noun) :: Verb.t() | Noun.t()
  def parse!(word, part_of_speech) do
    case parse(word, part_of_speech) do
      {:ok, struct} -> struct
      {:error, reason} -> raise(reason)
    end
  end
end
