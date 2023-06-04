defmodule Verb do
  @moduledoc """
  A struct representing a Russian verb.
  """
  defstruct translation: nil,
            infinitive: nil,
            aspect: nil,
            present_first_singular: nil,
            present_second_singular: nil,
            present_third_singular: nil,
            present_first_plural: nil,
            present_second_plural: nil,
            present_third_plural: nil,
            future_first_singular: nil,
            future_second_singular: nil,
            future_third_singular: nil,
            future_second_plural: nil,
            future_first_plural: nil,
            future_third_plural: nil,
            past_singular_masculine: nil,
            past_singular_feminine: nil,
            past_singular_neuter: nil,
            past_plural: nil,
            imperative_second_singular: nil,
            imperative_second_plural: nil,
            present_active_participle: nil,
            past_active_participle: nil,
            present_passive_participle: nil,
            past_passive_participle: nil,
            present_adverbial_participle: nil,
            past_adverbial_participle: nil

  @typedoc """
  A Russian verb.
  
  ## Fields
  
  - `:translation`: The English translation of the verb.
  - `:infinitive`: The infinitive form of the verb.
  - `:aspect`: The aspect of the verb.
  - `:present_first_singular`: The first-person singular form in the present tense.
  - `:present_second_singular`: The second-person singular form in the present tense.
  - `:present_third_singular`: The third-person singular form in the present tense.
  - `:present_first_plural`: The first-person plural form in the present tense.
  - `:present_second_plural`: The second-person plural form in the present tense.
  - `:present_third_plural`: The third-person plural form in the present tense.
  - `:future_first_singular`: The first-person singular form in the future tense.
  - `:future_second_singular`: The second-person singular form in the future tense.
  - `:future_third_singular`: The third-person singular form in the future tense.
  - `:future_second_plural`: The second-person plural form in the future tense.
  - `:future_first_plural`: The first-person plural form in the future tense.
  - `:future_third_plural`: The third-person plural form in the future tense.
  - `:past_singular_masculine`: The singular masculine form in the past tense.
  - `:past_singular_feminine`: The singular feminine form in the past tense.
  - `:past_singular_neuter`: The singular neuter form in the past tense.
  - `:past_plural`: The plural form in the past tense.
  - `:imperative_second_singular`: The second-person singular imperative form.
  - `:imperative_second_plural`: The second-person plural imperative form.
  - `:present_active_participle`: The present active participle form.
  - `:past_active_participle`: The past active participle form.
  - `:present_passive_participle`: The present passive participle form.
  - `:past_passive_participle`: The past passive participle form.
  - `:present_adverbial_participle`: The present adverbial participle form.
  - `:past_adverbial_participle`: The past adverbial participle form.
  """
  @type t :: %__MODULE__{
          translation: String.t(),
          infinitive: String.t(),
          aspect: String.t(),
          present_first_singular: String.t(),
          present_second_singular: String.t(),
          present_third_singular: String.t(),
          present_first_plural: String.t(),
          present_second_plural: String.t(),
          present_third_plural: String.t(),
          future_first_singular: String.t(),
          future_second_singular: String.t(),
          future_third_singular: String.t(),
          future_second_plural: String.t(),
          future_first_plural: String.t(),
          future_third_plural: String.t(),
          past_singular_masculine: String.t(),
          past_singular_feminine: String.t(),
          past_singular_neuter: String.t(),
          past_plural: String.t(),
          imperative_second_singular: String.t(),
          imperative_second_plural: String.t(),
          present_active_participle: String.t(),
          past_active_participle: String.t(),
          present_passive_participle: String.t(),
          past_passive_participle: String.t(),
          present_adverbial_participle: String.t(),
          past_adverbial_participle: String.t()
        }
end
