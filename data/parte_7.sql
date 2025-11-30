-- Pontos acumulados negativos
WITH tb_transacoes AS (
    SELECT  Idcliente,
            Idtransacao,
            QtdePontos,
            datetime(substr(DtCriacao,1,19)) AS DtCriacao,
            julianday('now') - julianday(substr(DtCriacao,1,10)) AS diffDate
    FROM transacoes
)
SELECT  IdCliente,
    sum(CASE WHEN qtdePontos > 0 THEN qtdePontos ELSE 0 END) AS NegativoAcumuladosVida,
    sum(CASE WHEN qtdePontos > 0 AND diffDate < 56 THEN qtdePontos ELSE 0 END) AS NegativoAcumuladosD56,
    sum(CASE WHEN qtdePontos > 0 AND diffDate < 28 THEN qtdePontos ELSE 0 END) AS NegativoAcumuladosD28,
    sum(CASE WHEN qtdePontos > 0 AND diffDate < 14 THEN qtdePontos ELSE 0 END) AS NegativoAcumuladosD14,
    sum(CASE WHEN qtdePontos > 0 AND diffDate <  7 THEN qtdePontos ELSE 0 END) AS NegativoAcumuladosD7

FROM tb_transacoes 
GROUP BY IdCliente