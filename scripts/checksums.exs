# Hash the exact archives being shipped, and fail if any advertised NIF is missing.
{options, args, invalid} = OptionParser.parse(System.argv(), strict: [only_local: :boolean])

unless match?([_], args) and invalid == [] do
  raise "usage: mix run scripts/checksums.exs [--only-local] ARTIFACT_DIRECTORY"
end

[directory] = args

nifs =
  if options[:only_local] do
    RustlerPrecompiled.current_target_nifs(Tiktoken.Native)
  else
    RustlerPrecompiled.available_nifs(Tiktoken.Native)
  end

checksums =
  for {filename, _url} <- nifs do
    path = Path.join(directory, filename)

    %{
      path: path,
      checksum: :crypto.hash(:sha256, File.read!(path)) |> Base.encode16(case: :lower),
      checksum_algo: :sha256
    }
  end

RustlerPrecompiled.write_checksum!(Tiktoken.Native, checksums)
IO.puts("Wrote checksums for #{length(checksums)} NIF archives")
