# Changelog

## 0.5.0

- Require Elixir 1.15+ and Rust 1.91+ for source builds.
- Update tiktoken-rs to 0.12.1, Rustler to 0.38, RustlerPrecompiled to 0.10.1,
  ExDoc to 0.40.4, and refresh both dependency lockfiles.
- Support newer model mappings and the `o200k_harmony` encoding through
  `Tiktoken.O200KHarmony` and the model-based API.
- Propagate upstream encoding/counting errors and use shared tokenizer instances.
- Return `nil` for unknown context-window metadata instead of guessing 4,096
  tokens. Legacy models without explicit upstream metadata also return `nil`.
- Point package links and native binary downloads to jimmybot/tiktoken-elixir.
- Add compatibility CI and verify precompiled packages in a fresh consumer without
  the Rustler compiler dependency.
- Generate SHA-256 manifests from all release archives, include the manifest in the
  Hex package, and validate the package before publishing GitHub release assets.
- Correct installation requirements and document the public API and release process.
