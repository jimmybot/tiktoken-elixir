#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: bash scripts/smoke_test.sh PACKAGE_TAR ARTIFACT_DIRECTORY" >&2
  exit 1
fi

package=$(cd "$(dirname "$1")" && pwd)/$(basename "$1")
export RUSTLER_PRECOMPILED_GLOBAL_CACHE_PATH=$(cd "$2" && pwd)
export RUSTLER_PRECOMPILED_FORCE_BUILD_ALL=false
unset MIX_BUILD_PATH MIX_DEPS_PATH

# Keep the scratch project under this checkout so asdf can resolve its toolchain.
mkdir -p tmp
consumer=$(mktemp -d "$PWD/tmp/tiktoken-consumer.XXXXXX")
trap 'rm -rf "$consumer"' EXIT

mkdir -p "$consumer/package"
tar -xOf "$package" contents.tar.gz | tar -xz -C "$consumer/package"
export TIKTOKEN_PACKAGE_PATH="$consumer/package"
mkdir "$consumer/app"
cat > "$consumer/app/mix.exs" <<'ELIXIR'
defmodule TiktokenConsumer.MixProject do
  use Mix.Project

  def project do
    [app: :tiktoken_consumer, version: "0.1.0",
     deps: [{:tiktoken, path: System.fetch_env!("TIKTOKEN_PACKAGE_PATH")}]]
  end
end
ELIXIR

cd "$consumer/app"
export MIX_ENV=test
mix deps.get
mix compile --warnings-as-errors
mix run -e '
  false = Code.ensure_loaded?(Rustler)
  text = "Hello, 世界 👋"
  {:ok, ids} = Tiktoken.encode("gpt-5", text)
  {:ok, ^text} = Tiktoken.decode("gpt-5", ids)
  {:ok, [200_006]} = Tiktoken.encode_with_special_tokens("gpt-oss-20b", "<|start|>")
  IO.puts("Precompiled package works without the Rustler compiler dependency")
'
