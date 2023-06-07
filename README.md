# WiktionaryParser

Provides functions for parsing Russian language entries from [Wiktionary](https://en.wiktionary.org).

ExDoc documentation is available on [GitHub pages](https://sulealtintas.github.io/wiktionary_parser).

## Features

- Parse Russian verb entries from Wiktionary.
- Parse Russian noun entries from Wiktionary.
- Retrieve various forms of verbs and nouns, including tenses, aspects, cases, and more.

## Usage
To parse a word from a Russian Wiktionary entry, use the `WiktionaryParser.parse!/2` function,
providing the dictionary form of the word as a string and the part of speech as an atom (currently
only supporting `:verb` and `:noun`):

```elixir
iex> WiktionaryParser.parse!("смотреть", :verb)
%WiktionaryParser.Verb{
  translation: "to look",
  infinitive: "смотре́ть",
  aspect: :imperfective,
  present_first_singular: "смотрю́",
  present_second_singular: "смо́тришь",
  present_third_singular: "смо́трит",
  present_first_plural: "смо́трим",
  present_second_plural: "смо́трите",
  present_third_plural: "смо́трят",
  future_first_singular: "бу́ду смотре́ть",
  future_second_singular: "бу́дешь смотре́ть",
  future_third_singular: "бу́дет смотре́ть",
  future_second_plural: "бу́дете смотре́ть",
  future_first_plural: "бу́дем смотре́ть",
  future_third_plural: "бу́дут смотре́ть",
  past_singular_masculine: "смотре́л",
  past_singular_feminine: "смотре́ла",
  past_singular_neuter: "смотре́ло",
  past_plural: "смотре́ли",
  imperative_second_singular: "смотри́",
  imperative_second_plural: "смотри́те",
  present_active_participle: "смотря́щий",
  past_active_participle: "смотре́вший",
  present_passive_participle: nil,
  past_passive_participle: nil,
  present_adverbial_participle: "смотря́",
  past_adverbial_participle: "смотре́в"
}

iex> WiktionaryParser.parse!("кот", :noun)
%WiktionaryParser.Noun{
  translation: "tomcat",
  gender: :male,
  nominative_singular: "ко́т",
  genitive_singular: "кота́",
  dative_singular: "коту́",
  accusative_singular: "кота́",
  instrumental_singular: "кото́м",
  prepositional_singular: "коте́",
  nominative_plural: "коты́",
  genitive_plural: "кото́в",
  dative_plural: "кота́м",
  accusative_plural: "кото́в",
  instrumental_plural: "кота́ми",
  prepositional_plural: "кота́х",
  partitive_singular: nil,
  partitive_plural: nil,
  vocative_singular: nil,
  vocative_plural: nil
}
```

The `parse!/2` function returns a struct representing the parsed word with its associated forms, as shown above for [смотреть](https://en.wiktionary.org/wiki/смотреть#Russian) and [кот](https://en.wiktionary.org/wiki/кот#Russian).

