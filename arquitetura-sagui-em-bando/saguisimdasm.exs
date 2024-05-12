#
# Montador ridiculamente simples para Assembly de Sagui Vetorial.
# Escreve arquivos no formato hex do Logisim Evolution.
# (Informações sobre a licença abaixo)
# (Licensing information below)
#
# DÚVIDAS:
#
# - Como eu uso essa desgraça?
#
# Você instala a linguagem Elixir (https://elixir-lang.org/) e roda o script
# da seguinte maneira:
#
#   $ elixir saguisimdasm.exs <arquivo assembly> <nome do arquivo pra salvar>
#
# Tanto faz como instalar a linguagem, provavelmente esse script funciona em
# basicamente qualquer versão.
#
# A linguagem Elixir depende do runtime de Erlang, e existem algumas
# distribuições que não instalam Erlang automaticamente, então você talvez
# precise instalar separado (https://www.erlang.org/).
#
# - Como é a sintaxe?
#
# Bem normal. Escreve instruções na forma "mne arg1, arg2". Comentários só são
# suportados em sua própria linha (e.g., uma linha "add r1, r2 ; Adiciona"
# vai quebrar). Não suporta etiquetas porque você teria que calcular elas
# manualmente de qualquer forma.
#
# As instruções vetoriais tem um "v." na frente, e.g., "v.add".
#
# Os registradores são sempre r0, r1, r2 e r3. Inclusive nas instruções
# vetoriais.
#
# - Por que uma sintaxe tão ruim?
#
# Porque parsear as parada no pelo é difícil, deixei o mais simples possível
# de implementar e ser útil.
#
# - Por que não fazer isso em Python?
#
# Eu não gosto de Python.
#
# - Por que então fazer isso em Elixir?
#
# Eu tava afim, e também queria usar as bruxarias de programação funcional.
#
# - Por que não fazer em Lua?
#
# Eu não quis, e esse programa não é exatamente straight-forward de implementar
# em Lua.
#
# - Achei que gostasse de Lua.
#
# Eu também.
#

#
# Informação sobre a licença do software:
# Licensing information:
#
# This software is licensed under the DO WHAT THE FUCK YOU WANT TO PUBLIC
# LICENSE:
#
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE
#                    Version 3.1, July 2019
#
# by Sam Hocevar <sam@hocevar.net>
#    theiostream <matoe@matoe.co.cc>
#    dtf         <wtfpl@dtf.wtf>
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#

defmodule SaguiSimdAsm do
  import Bitwise

  defp err(str), do: IO.puts(IO.ANSI.format([:red_background, str]))

  defp normalize_hex_string(h) do
    if String.length(h) == 1 do
      "0" <> h
    else
      h
    end
  end

  defp write_file(hex, out) do
    IO.puts(out, "v3.0 hex words addressed")
    q = 256 - Enum.count(hex)

    hex
    |> Enum.map(&normalize_hex_string/1)
    |> Enum.concat(List.duplicate("00", q))
    |> Enum.chunk_every(16)
    |> Enum.with_index(fn e, i -> {i * 16, e} end)
    |> Enum.map(fn {addr, line} ->
      [normalize_hex_string(Integer.to_string(addr, 16)) <> ":" | line]
    end)
    |> Enum.map(&Enum.reduce(&1, fn v, l -> l <> " " <> v end))
    |> Enum.each(&IO.puts(out, &1))
  end

  defp instr2hex([]), do: []

  defp instr2hex([instr | rest]) do
    hex =
      case instr do
        {_, []} ->
          err(
            "O arquivo tem uma instrução sem argumento porém nenhuma instrução do Sagui Vetorial possui 0 argumentos."
          )

          :error

        {_, [_ | [_ | [_ | _]]]} ->
          err(
            "O arquivo tem uma instrução com mais de 2 argumentos porém nenhuma instrução do Sagui Vetorial possui mais de 2 argumentos."
          )

          :error

        {i, [a]} ->
          (bor(i <<< 4, a) &&&
             0xFF)
          |> Integer.to_string(16)

        {i, [a, b]} ->
          (bor(i <<< 4, bor(a <<< 2, b)) &&&
             0xFF)
          |> Integer.to_string(16)
      end

    unless hex == :error do
      [hex | instr2hex(rest)]
    else
      :error
    end
  end

  defp convert_instr([]), do: []

  defp convert_instr([{i, args} | rest]) do
    case convert_instr(rest) do
      :error ->
        :error

      a ->
        i =
          case i do
            ~c"ld" ->
              0

            ~c"st" ->
              1

            ~c"movh" ->
              2

            ~c"movl" ->
              3

            ~c"add" ->
              4

            ~c"sub" ->
              5

            ~c"and" ->
              6

            ~c"brzr" ->
              7

            ~c"v.ld" ->
              8

            ~c"v.st" ->
              9

            ~c"v.movh" ->
              10

            ~c"v.movl" ->
              11

            ~c"v.add" ->
              12

            ~c"v.sub" ->
              13

            ~c"v.and" ->
              14

            ~c"v.or" ->
              15

            _ ->
              err("Instrução desconhecida: " <> to_string(i) <> ".")
              :error
          end

        unless i == :error do
          [{i, args} | a]
        else
          :error
        end
    end
  end

  defp parse_integer(str) do
    cond do
      String.starts_with?(str, "0x") ->
        Integer.parse(String.slice(str, 2..String.length(str)), 16)

      String.starts_with?(str, "0b") ->
        Integer.parse(String.slice(str, 2..String.length(str)), 2)

      String.starts_with?(str, "0o") ->
        Integer.parse(String.slice(str, 2..String.length(str)), 8)

      true ->
        Integer.parse(str, 10)
    end
  end

  defp parse_arg(arg) do
    case arg do
      "r0" ->
        {:ok, 0}

      "r1" ->
        {:ok, 1}

      "r2" ->
        {:ok, 2}

      "r3" ->
        {:ok, 3}

      "v0" ->
        {:ok, 0}

      "v1" ->
        {:ok, 1}

      "v2" ->
        {:ok, 2}

      "v3" ->
        {:ok, 3}

      n ->
        case parse_integer(n) do
          {a, ""} -> {:ok, a}
          :error -> :error
        end
    end
  end

  defp parse_args_inner(args) do
    case args do
      [] ->
        {:ok, []}

      [arg | rest] ->
        case parse_args_inner(rest) do
          {:error, v} ->
            {:error, v}

          {:ok, args} ->
            case parse_arg(arg) do
              {:ok, arg} -> {:ok, [arg | args]}
              :error -> {:error, arg}
            end
        end
    end
  end

  defp parse_args([]), do: []

  defp parse_args([{i, args} | rest]) do
    rest =
      if rest == [] do
        []
      else
        parse_args(rest)
      end

    case rest do
      {:error, _} ->
        rest

      _ ->
        case parse_args_inner(args) do
          {:error, arg} -> {:error, arg}
          {:ok, args} -> [{i, args} | rest]
        end
    end
  end

  defp split_args(line) do
    i = Enum.find_index(line, fn c -> c == hd(~c" ") end)

    if i != nil do
      Enum.split(line, i)
    else
      {line, ~c""}
    end
  end

  # Essa função todinha é feia que dói.
  defp parse(asm) do
    instr =
      asm
      |> String.split("\n")
      |> Enum.filter(&(!String.starts_with?(&1, ";")))
      |> Enum.map(&String.trim/1)
      |> Enum.filter(fn str -> str != "" end)
      |> Enum.map(&String.to_charlist/1)
      |> Enum.map(&split_args/1)
      |> Enum.map(fn {line, args} ->
        args
        |> to_string()
        |> String.split(",")
        |> Enum.map(&String.trim/1)
        |> (fn args -> {line, args} end).()
      end)

    case parse_args(instr) do
      {:error, v} ->
        err("Não consigo parsear o argumento " <> v <> ".")
        nil

      a ->
        {:ok, a}
    end
  end

  defp try_assemble(input, output) do
    with {:ok, asm} <- File.read(input),
         {:ok, out} <- File.open(output, [:write]) do
      with {:ok, instr} <- parse(asm),
           i when i != :error <- convert_instr(instr),
           hex when hex != :error <-
             instr2hex(i) do
        write_file(hex, out)
      else
        a ->
          IO.inspect(a)
          err("Não foi possível parsear o Assembly.")
      end
    else
      _ ->
        err("Não foi possível abrir os arquivos.")
    end
  end

  def run(files) do
    case files do
      [asm, out] ->
        try_assemble(asm, out)

      _ ->
        err("Por favor forneça os argumentos: <arquivo de entrada> <arquivo de saída>")
    end
  end
end

SaguiSimdAsm.run(System.argv())
