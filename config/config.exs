import Config

# Build checked-out sources by default. Dependency consumers use the precompiled NIFs.
config :rustler_precompiled, :force_build,
  tiktoken: System.get_env("TIKTOKEN_FORCE_BUILD", "true") in ["1", "true"]
