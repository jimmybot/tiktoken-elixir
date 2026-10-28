defmodule TiktokenTest do
  use ExUnit.Case
  doctest Tiktoken

  @known_models [
    # current model families
    {"gpt-5", Tiktoken.O200K, 400_000},
    {"gpt-5.4", Tiktoken.O200K, 1_050_000},
    {"gpt-4.1", Tiktoken.O200K, 1_047_576},
    {"gpt-4o", Tiktoken.O200K, 128_000},
    {"o3", Tiktoken.O200K, 200_000},
    {"gpt-oss-20b", Tiktoken.O200KHarmony, 131_072},
    # chat
    {"gpt-3.5-turbo", Tiktoken.CL100K, 16_385},
    {"gpt-3.5-turbo-0125", Tiktoken.CL100K, 16_385},
    {"gpt-3.5-turbo-1106", Tiktoken.CL100K, 16_385},
    {"gpt-3.5-turbo-instruct", Tiktoken.CL100K, 16_385},
    {"gpt-3.5-turbo-16k", Tiktoken.CL100K, 16_385},
    {"gpt-3.5-turbo-0613", Tiktoken.CL100K, 16_385},
    {"gpt-3.5-turbo-16k-0613", Tiktoken.CL100K, 16_385},
    {"gpt-4-0125-preview", Tiktoken.CL100K, 128_000},
    {"gpt-4-turbo-preview", Tiktoken.CL100K, 128_000},
    {"gpt-4-1106-preview", Tiktoken.CL100K, 128_000},
    {"gpt-4-vision-preview", Tiktoken.CL100K, 8_192},
    {"gpt-4-06-vision-preview", Tiktoken.CL100K, 8_192},
    {"gpt-4", Tiktoken.CL100K, 8_192},
    {"gpt-4-0613", Tiktoken.CL100K, 8_192},
    {"gpt-4-32k", Tiktoken.CL100K, 32_768},
    {"gpt-4-32k-0613", Tiktoken.CL100K, 32_768},
    # text
    {"text-davinci-003", Tiktoken.P50K, 4_097},
    {"text-davinci-002", Tiktoken.P50K, 4_097},
    {"text-davinci-001", Tiktoken.R50K, nil},
    {"text-curie-001", Tiktoken.R50K, 2_049},
    {"text-babbage-001", Tiktoken.R50K, 2_049},
    {"text-ada-001", Tiktoken.R50K, 2_049},
    {"davinci", Tiktoken.R50K, 2_049},
    {"curie", Tiktoken.R50K, 2_049},
    {"babbage", Tiktoken.R50K, 2_049},
    {"ada", Tiktoken.R50K, 2_049},
    # code
    {"code-davinci-002", Tiktoken.P50K, 8_001},
    {"code-davinci-001", Tiktoken.P50K, nil},
    {"code-cushman-002", Tiktoken.P50K, nil},
    {"code-cushman-001", Tiktoken.P50K, 2_048},
    {"davinci-codex", Tiktoken.P50K, 2_049},
    {"cushman-codex", Tiktoken.P50K, nil},
    # edit
    {"text-davinci-edit-001", Tiktoken.P50KEdit, nil},
    {"code-davinci-edit-001", Tiktoken.P50KEdit, nil},
    # embeddings
    # {"text-embedding-3-large", Tiktoken.CL100K},
    # {"text-embedding-3-small", Tiktoken.CL100K},
    {"text-embedding-ada-002", Tiktoken.CL100K, 8_192},
    # old embeddings
    {"text-similarity-davinci-001", Tiktoken.R50K, nil},
    {"text-similarity-curie-001", Tiktoken.R50K, nil},
    {"text-similarity-babbage-001", Tiktoken.R50K, nil},
    {"text-similarity-ada-001", Tiktoken.R50K, nil},
    {"text-search-davinci-doc-001", Tiktoken.R50K, nil},
    {"text-search-curie-doc-001", Tiktoken.R50K, nil},
    {"text-search-babbage-doc-001", Tiktoken.R50K, nil},
    {"text-search-ada-doc-001", Tiktoken.R50K, nil},
    {"code-search-babbage-code-001", Tiktoken.R50K, nil},
    {"code-search-ada-code-001", Tiktoken.R50K, nil}
    # moderation
    # {"text-moderation-latest", Tiktoken.CL100K},
    # {"text-moderation-stable", Tiktoken.CL100K},
    # {"text-moderation-007", Tiktoken.CL100K}
    # open source
    # {"gpt2", "gpt2"}
  ]

  describe "encoding_for_model/1" do
    test "get the proper module for supported model" do
      @known_models
      |> Enum.each(fn {model, mod, _context_size} ->
        assert Tiktoken.encoding_for_model(model) == mod
      end)
    end

    test "get nil for unsupported model" do
      assert is_nil(Tiktoken.encoding_for_model("gpt2"))
    end
  end

  describe "encode_ordinary/2" do
    test "with supported model" do
      assert {:ok, ids} =
               Tiktoken.encode_ordinary("gpt-3.5-turbo", "Tell me more about Elixir!")

      assert length(ids) == 7
    end

    test "with unsupported model" do
      assert {:error, {:unsupported_model, "gpt2"}} =
               Tiktoken.encode_ordinary("gpt2", "Tell me more about Elixir!")
    end
  end

  describe "encode/2" do
    test "with supported model" do
      assert {:ok, ids} =
               Tiktoken.encode("gpt-3.5-turbo", "Tell me more about Elixir!")

      assert length(ids) == 7
    end

    test "with unsupported model" do
      assert {:error, {:unsupported_model, "gpt2"}} =
               Tiktoken.encode("gpt2", "Tell me more about Elixir!")
    end
  end

  describe "encode_with_special_tokens/2" do
    test "with supported model" do
      assert {:ok, ids} =
               Tiktoken.encode_with_special_tokens("gpt-3.5-turbo", "Tell me more about Elixir!")

      assert length(ids) == 7
    end

    test "with unsupported model" do
      assert {:error, {:unsupported_model, "gpt2"}} =
               Tiktoken.encode_with_special_tokens("gpt2", "Tell me more about Elixir!")
    end
  end

  describe "decode/2" do
    test "with supported model" do
      text = "Tell me more about Elixir!"

      assert {:ok, ids} =
               Tiktoken.encode("gpt-3.5-turbo", text)

      assert {:ok, ^text} =
               Tiktoken.decode("gpt-3.5-turbo", ids)
    end

    test "with unsupported model" do
      assert {:error, {:unsupported_model, "gpt2"}} =
               Tiktoken.decode("gpt2", [1])
    end
  end

  describe "count_tokens/2" do
    test "with supported model" do
      text = "Tell me more about Elixir!"
      assert {:ok, count} = Tiktoken.count_tokens("gpt-3.5-turbo", text)
      assert count > 0
      assert count == length(elem(Tiktoken.encode("gpt-3.5-turbo", text), 1))
    end

    test "with unsupported model" do
      assert {:error, {:unsupported_model, "gpt2"}} =
               Tiktoken.count_tokens("gpt2", "Hello")
    end

    test "with special tokens across encodings" do
      text = "<|endoftext|>"

      models = [
        {"davinci", 50_256},
        {"text-davinci-003", 50_256},
        {"text-davinci-edit-001", 50_256},
        {"gpt-3.5-turbo", 100_257},
        {"gpt-5", 199_999},
        {"gpt-oss-20b", 199_999}
      ]

      for {model, token_id} <- models do
        assert {:ok, [^token_id]} = Tiktoken.encode(model, text, [text])
        assert {:ok, [^token_id]} = Tiktoken.encode_with_special_tokens(model, text)
        assert {:ok, 1} = Tiktoken.count_tokens(model, text, [text])
        assert {:ok, ordinary} = Tiktoken.encode_ordinary(model, text)
        assert length(ordinary) > 1
      end
    end

    test "with different models" do
      text = "Tell me more about Elixir!"
      models = ["gpt-3.5-turbo", "text-davinci-003", "text-davinci-edit-001"]

      Enum.each(models, fn model ->
        assert {:ok, count} = Tiktoken.count_tokens(model, text)
        assert count > 0
        assert count == length(elem(Tiktoken.encode(model, text), 1))
      end)
    end
  end

  test "Harmony protocol tokens and Unicode round-trip through the model API" do
    text = "<|start|>世界 👋<|end|>"
    assert {:ok, [200_006 | _] = ids} = Tiktoken.encode_with_special_tokens("gpt-oss-20b", text)
    assert List.last(ids) == 200_007
    assert {:ok, ^text} = Tiktoken.decode("gpt-oss-20b", ids)
  end

  test "invalid token IDs return errors across encodings" do
    for model <- [
          "davinci",
          "text-davinci-003",
          "text-davinci-edit-001",
          "gpt-3.5-turbo",
          "gpt-5",
          "gpt-oss-20b"
        ] do
      assert {:error, reason} = Tiktoken.decode(model, [4_294_967_295])
      assert is_binary(reason)
    end
  end

  describe "context_size_for_model/1" do
    test "get proper context size for model" do
      @known_models
      |> Enum.each(fn {model, _mod, context_size} ->
        assert Tiktoken.context_size_for_model(model) == context_size
      end)
    end

    test "get nil for unknown model" do
      assert is_nil(Tiktoken.context_size_for_model("unknown"))
    end
  end
end
