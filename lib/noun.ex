defmodule Noun do
  @moduledoc """
  A struct representing a Russian noun.
  """
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
            prepositional_plural: nil,
            vocative_singular: nil,
            vocative_plural: nil

  @typedoc """
  A Russian noun.
  
  ## Fields
  
  - `:nominative_singular`: The nominative singular form of the noun.
  - `:genitive_singular`: The genitive singular form of the noun.
  - `:dative_singular`: The dative singular form of the noun.
  - `:accusative_singular`: The accusative singular form of the noun.
  - `:instrumental_singular`: The instrumental singular form of the noun.
  - `:prepositional_singular`: The prepositional singular form of the noun.
  - `:nominative_plural`: The nominative plural form of the noun.
  - `:genitive_plural`: The genitive plural form of the noun.
  - `:dative_plural`: The dative plural form of the noun.
  - `:accusative_plural`: The accusative plural form of the noun.
  - `:instrumental_plural`: The instrumental plural form of the noun.
  - `:prepositional_plural`: The prepositional plural form of the noun.
  - `:vocative_singular`: The vocative singular form of the noun.
  - `:vocative_plural`: The vocative plural form of the noun.
  """
  @type t :: %__MODULE__{
          nominative_singular: String.t(),
          genitive_singular: String.t(),
          dative_singular: String.t(),
          accusative_singular: String.t(),
          instrumental_singular: String.t(),
          prepositional_singular: String.t(),
          nominative_plural: String.t(),
          genitive_plural: String.t(),
          dative_plural: String.t(),
          accusative_plural: String.t(),
          instrumental_plural: String.t(),
          prepositional_plural: String.t(),
          vocative_singular: String.t(),
          vocative_plural: String.t()
        }
end
