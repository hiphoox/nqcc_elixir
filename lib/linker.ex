defmodule Linker do
  def generate_binary(assembler, file_name) do
    IO.puts(assembler)
    path = String.replace_trailing(file_name, ".c", ".s")
    File.write!(path, assembler)
  end
end
