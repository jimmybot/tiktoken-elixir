# Native tokenizer bindings

This crate implements `Elixir.Tiktoken.Native` with Rustler and tiktoken-rs. Rustler
registers the functions marked `#[rustler::nif]`; the Elixir stubs live in
`lib/tiktoken/native.ex`.

From the repository root, `mix test` compiles and loads the library. Source builds
require Rust 1.91 or newer and a platform linker. Python and PyO3 are not used.

```sh
cargo fmt --manifest-path native/tiktoken/Cargo.toml
cargo clippy --manifest-path native/tiktoken/Cargo.toml --locked -- -D warnings
```

The default feature selects NIF ABI 2.15. Release builds also enable
`nif_version_2_16` to produce ABI 2.16 archives; the available ABI versions must
match `lib/tiktoken/native.ex` and the release workflow. ABI 2.17 and 2.18 can be
selected for custom builds. Rustler no longer uses `RUSTLER_NIF_VERSION`.

Encoding instances use upstream singleton constructors and are shared across NIF
calls. CPU work runs on dirty CPU schedulers. Fallible encoding, counting, and
decoding operations map Rust errors to Elixir `{:error, reason}` tuples. Unknown
context-window metadata maps to `nil`.
