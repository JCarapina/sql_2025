-- Saldo de pontos atual

SELECT  IdCliente,
        SUM(QtdePontos) AS SaldoPontosAtual
FROM transacoes
GROUP BY IdCliente