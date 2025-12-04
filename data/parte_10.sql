-- Quantos porcento das transações dos ultimos 28% corresponde a taxa da vida inteira

WITH tb_transacoes AS (
    SELECT  Idcliente,
            Idtransacao,
            QtdePontos,
            datetime(substr(DtCriacao,1,19)) AS DtCriacao,
            julianday('now') - julianday(substr(DtCriacao,1,10)) AS diffDate
    FROM transacoes
),

tb_transacoes_agregada AS (
    SELECT  IdCliente,
            count(Idtransacao) AS QtdeTransacoesVida,
            count(CASE WHEN diffDate <= 28 THEN 0 END) AS QtdeTransacoesD28

    FROM tb_transacoes
    GROUP BY IdCliente
)

SELECT  *,
        1. * QtdeTransacoesD28 / QtdeTransacoesVida AS engajamento28Vida

FROM tb_transacoes_agregada
