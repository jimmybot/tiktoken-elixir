# Tiktoken

Elixir bindings for OpenAI's [tiktoken](https://github.com/openai/tiktoken), built on
[tiktoken-rs](https://github.com/zurawiki/tiktoken-rs).

## Installation

Requires Elixir 1.15 or newer. Add the package to `mix.exs`:

```elixir
def deps do
  [
    {:tiktoken, "~> 0.5.0"}
  ]
end
```

Supported platforms download a precompiled native library and verify its SHA-256
checksum. Rust and Python are not required for precompiled installations. Binaries
are provided for these targets, with NIF ABI versions 2.15 and 2.16:

- macOS: Apple Silicon and x86-64
- Linux: x86-64 and AArch64 with glibc or musl; ARM hard-float and RISC-V with glibc
- Windows: x86-64 with GNU or MSVC

The x86-64 glibc build uses Ubuntu 22.04 (glibc 2.35); the other Linux builds use
Cross toolchains. Build from source if a binary is incompatible with your system
or your target is not listed above.

## Usage

```elixir
Tiktoken.encoding_for_model("gpt-5")
# => Tiktoken.O200K

{:ok, ids} = Tiktoken.encode("gpt-5", "Hello, world!")
{:ok, "Hello, world!"} = Tiktoken.decode("gpt-5", ids)
{:ok, count} = Tiktoken.count_tokens("gpt-5", "Hello, world!")

Tiktoken.context_size_for_model("gpt-5")
# => 400_000

Tiktoken.encoding_for_model("unknown")
# => nil
Tiktoken.encode("unknown", "Hello")
# => {:error, {:unsupported_model, "unknown"}}
Tiktoken.context_size_for_model("unknown")
# => nil
```

Model routing and context-window metadata come from tiktoken-rs. They are
independent: a model may have context metadata without a supported tokenizer, or
a tokenizer without known context metadata. Token counts cover the supplied text
only, without chat-message framing, tool schemas, images, or other API overhead.

The available encoding modules can also be called directly:

| Encoding | Elixir module | Example models |
| --- | --- | --- |
| `o200k_base` | `Tiktoken.O200K` | GPT-5, GPT-4.1, GPT-4o, o1, o3, o4-mini |
| `o200k_harmony` | `Tiktoken.O200KHarmony` | gpt-oss-20b, gpt-oss-120b |
| `cl100k_base` | `Tiktoken.CL100K` | GPT-4, GPT-3.5 Turbo, text-embedding-3 |
| `p50k_base` | `Tiktoken.P50K` | text-davinci-002/003, legacy code models |
| `p50k_edit` | `Tiktoken.P50KEdit` | Legacy edit models |
| `r50k_base` | `Tiktoken.R50K` | Legacy GPT-3 models |

### Special tokens

`encode_ordinary/2` always treats special-token strings as ordinary text.
`encode/3` recognizes only the special tokens you allow; other strings are encoded
as ordinary text. `encode_with_special_tokens/2` recognizes all special tokens in
the selected encoding. `count_tokens/3` uses the same allow-list as `encode/3`.

```elixir
Tiktoken.encode("gpt-5", "<|endoftext|>", ["<|endoftext|>"])
# => {:ok, [199_999]}
Tiktoken.count_tokens("gpt-5", "<|endoftext|>", ["<|endoftext|>"])
# => {:ok, 1}
Tiktoken.encode_with_special_tokens("gpt-oss-20b", "<|start|>")
# => {:ok, [200_006]}
```

Encoding and counting failures, invalid token IDs, and decoded bytes that are not
valid UTF-8 return `{:error, reason}`.

## Building from source

Source builds require Rust 1.91 or newer, a C linker, and the usual platform build
tools. Python, libpython, and PyO3 are not used. Add Rustler explicitly when forcing
a dependency to build from source:

```elixir
def deps do
  [
    {:tiktoken, "~> 0.5.0"},
    {:rustler, "~> 0.38.0", runtime: false}
  ]
end
```

```elixir
# config/config.exs
config :rustler_precompiled, :force_build, tiktoken: true
```

This is also required when consuming an unreleased Git revision whose binaries
and checksum manifest have not been published.

## Development

The repository pins Elixir, Erlang/OTP, and Rust in `.tool-versions`, with the Rust
toolchain also specified in `rust-toolchain.toml`. CI tests Elixir 1.15 / OTP 26 and
Elixir 1.20 / OTP 29. A checkout builds the local Rust sources by default.

```sh
mix deps.get
mix test
mix fmt
cargo clippy --manifest-path native/tiktoken/Cargo.toml --locked -- -D warnings
mix docs
```

Set `TIKTOKEN_FORCE_BUILD=false` to exercise the precompiled path in a checkout.
The matching archives and checksum manifest must already be available.

## Releases

1. Update the version in `mix.exs` and the changelog, then push a matching `vVERSION`
   tag. The release workflow runs CI before building all platform/NIF combinations.
2. The workflow hashes the exact archives with `scripts/checksums.exs`, builds a Hex
   package containing `checksum-Elixir.Tiktoken.Native.exs`, and verifies that a
   fresh consumer can load the packaged binary without the Rustler compiler
   dependency. It publishes the archives, checksum manifest, and Hex tarball to the
   GitHub release only after all builds and checks pass.
3. Download the release checksum manifest into the repository and commit it so Git
   consumers can verify the same binaries. Unpack the generated Hex tarball and
   publish from that directory so the verified checksum manifest is included:

   ```sh
   mkdir -p release/package
   tar -xOf PATH_TO_RELEASE_TARBALL contents.tar.gz | tar -xz -C release/package
   cd release/package
   mix hex.publish package
   ```

The workflow can also be run manually to produce a reviewable `release-package`
artifact without creating a release from an untagged branch. Generated checksum
manifests are intentionally not ignored by Git. Never reuse a manifest after
rebuilding an archive: its checksum must match the exact published bytes.

To generate checksums from an existing directory of release archives:

```sh
mix run scripts/checksums.exs artifacts
```

The command fails if any advertised archive is missing. For a single-platform
check, use `--only-local`, then build and test the package:

```sh
mix run scripts/checksums.exs --only-local artifacts
mkdir -p release
mix hex.build --output release/tiktoken.tar
bash scripts/smoke_test.sh release/tiktoken.tar artifacts
```

Documentation: [HexDocs](https://hexdocs.pm/tiktoken).
