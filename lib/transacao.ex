defmodule Transacao do
  defstruct data: Date.utc_today(), tipo: nil, valor: 0, de: nil, para: nil

  @transacoes "transacoes.txt"
  def gravar(tipo, de, valor, data \\ Date.utc_today(), para \\ nil) do
    transacoes =
      busca_transacoes() ++
        [%__MODULE__{data: data, tipo: tipo, valor: valor, de: de, para: para}]

    File.write(@transacoes, :erlang.term_to_binary(transacoes))
  end

  def busca_todas(), do: busca_transacoes()
  def por_ano(ano), do: Enum.filter(busca_transacoes(), &(&1.data.year == ano))

  def por_mes(ano, mes),
    do: Enum.filter(busca_transacoes(), &(&1.data.month == mes && &1.data.year == ano))

  def por_dia(data), do: Enum.filter(busca_transacoes(), &(&1.data == data))

  def calcular_total(), do: busca_todas() |> calcular
  def calcular_mes(ano, mes), do: por_mes(ano, mes) |> calcular
  def calcular_ano(ano), do: por_ano(ano) |> calcular
  def calcular_dia(data), do: por_dia(data) |> calcular

  def calcular(transacoes) do
    {transacoes, Enum.reduce(transacoes, 0, fn x, acc -> acc + x.valor end)}
  end

  defp busca_transacoes() do
    {:ok, binario} = File.read(@transacoes)

    binario
    |> :erlang.binary_to_term()
  end
end
