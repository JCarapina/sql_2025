-- Pontos acumulados positivos(vida, d7, d14, d28, d56)

WITH tb_transacoes AS (
    SELECT  Idcliente,
            Idtransacao,
            QtdePontos,
            datetime(substr(DtCriacao,1,19)) AS DtCriacao,
            julianday('now') - julianday(substr(DtCriacao,1,10)) AS diffDate
    FROM transacoes
)
SELECT  IdCliente,
    sum(CASE WHEN qtdePontos > 0 THEN qtdePontos ELSE 0 END) AS PositAcumuladosVida,
    sum(CASE WHEN qtdePontos > 0 AND diffDate < 56 THEN qtdePontos ELSE 0 END) AS PositAcumuladosD56,
    sum(CASE WHEN qtdePontos > 0 AND diffDate < 28 THEN qtdePontos ELSE 0 END) AS PositAcumuladosD28,
    sum(CASE WHEN qtdePontos > 0 AND diffDate < 14 THEN qtdePontos ELSE 0 END) AS PositAcumuladosD14,
    sum(CASE WHEN qtdePontos > 0 AND diffDate <  7 THEN qtdePontos ELSE 0 END) AS PositAcumuladosD7

FROM tb_transacoes 
GROUP BY IdCliente
