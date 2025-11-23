--- Quantidade de transações históricas(vida, D7, D14, D28, D56)
WITH tb_transacoes AS (
    SELECT  Idcliente,
            Idtransacao,
            QtdePontos,
            datetime(substr(DtCriacao,1,19)) AS DtCriacao,
            julianday('now') - julianday(substr(DtCriacao,1,10)) AS diffDate
    FROM transacoes
)

SELECT  IdCliente,
        count(Idtransacao) AS QtdeTransacoesVida,
        count(CASE WHEN diffDate <= 56 THEN 1 END) AS QtdeTransacoesD56,
        count(CASE WHEN diffDate <= 28 THEN 1 END) AS QtdeTransacoesD28,
        count(CASE WHEN diffDate <= 14 THEN 1 END) AS QtdeTransacoesD14,
        count(CASE WHEN diffDate <= 7 THEN 1 END) AS QtdeTransacoesD7


FROM tb_transacoes
GROUP BY IdCliente
