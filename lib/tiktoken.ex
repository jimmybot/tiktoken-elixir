defmodule Tiktoken do
  @moduledoc """
  Tokenizes UTF-8 text using the encoding associated with a model name.

  Encoding, decoding, and counting return `{:ok, result}` or `{:error, reason}`.
  Unknown model names return `{:error, {:unsupported_model, model}}`.
  Encoding modules such as `Tiktoken.O200K` can also be called directly.

  Token counts cover the supplied text only. They do not include chat message
  framing, tool schemas, image inputs, or other API request overhead.
  """

  @model_to_encoding %{
    "p50k_base" => Tiktoken.P50K,
    "p50k_edit" => Tiktoken.P50KEdit,
    "r50k_base" => Tiktoken.R50K,
    "cl100k_base" => Tiktoken.CL100K,
    "o200k_base" => Tiktoken.O200K,
    "o200k_harmony" => Tiktoken.O200KHarmony
  }

  @type token_id :: non_neg_integer()
  @type error :: {:error, String.t() | {:unsupported_model, String.t()}}

  @doc "Returns the encoding module for a supported model, or `nil`."
  @spec encoding_for_model(String.t()) :: module() | nil
  def encoding_for_model(model) do
    encoding_name = Tiktoken.Native.encoding_for_model(model)
    @model_to_encoding[encoding_name]
  end

  @doc "Encodes text, treating all special-token strings as ordinary text."
  @spec encode_ordinary(String.t(), String.t()) :: {:ok, [token_id()]} | error()
  def encode_ordinary(model, text) do
    delegate_call(model, :encode_ordinary, [text])
  end

  @doc "Encodes text, recognizing only the special-token strings in `allowed_special`."
  @spec encode(String.t(), String.t(), [String.t()]) :: {:ok, [token_id()]} | error()
  def encode(model, text, allowed_special \\ []) do
    delegate_call(model, :encode, [text, allowed_special])
  end

  @doc "Encodes text, recognizing all special tokens defined by the encoding."
  @spec encode_with_special_tokens(String.t(), String.t()) :: {:ok, [token_id()]} | error()
  def encode_with_special_tokens(model, text) do
    delegate_call(model, :encode_with_special_tokens, [text])
  end

  @doc "Decodes token IDs, returning an error for invalid IDs or invalid UTF-8 output."
  @spec decode(String.t(), [token_id()]) :: {:ok, String.t()} | error()
  def decode(model, ids) do
    delegate_call(model, :decode, [ids])
  end

  @doc "Counts tokens with the same special-token handling as `encode/3`."
  @spec count_tokens(String.t(), String.t(), [String.t()]) :: {:ok, non_neg_integer()} | error()
  def count_tokens(model, text, allowed_special \\ []) do
    delegate_call(model, :count_tokens, [text, allowed_special])
  end

  defp delegate_call(model, function, args) do
    if mod = encoding_for_model(model) do
      apply(mod, function, args)
    else
      {:error, {:unsupported_model, model}}
    end
  end

  @doc """
  Returns the upstream context-window metadata for a model, or `nil` when unknown.

  Context metadata and tokenizer availability are independent. A model can have
  known context metadata without an available encoding, and vice versa.
  """
  @spec context_size_for_model(String.t()) :: pos_integer() | nil
  def context_size_for_model(model) do
    Tiktoken.Native.context_size_for_model(model)
  end
end
