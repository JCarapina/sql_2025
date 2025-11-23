-- Dia da última transação de cada cliente
WITH tb_transacoes AS (
    SELECT  Idcliente,
            Idtransacao,
            QtdePontos,
            datetime(substr(DtCriacao,1,19)) AS DtCriacao,
            julianday('now') - julianday(substr(DtCriacao,1,10)) AS diffDate
    FROM transacoes
)

SELECT  IdCliente,
        min(diffDate) AS DiaUltimaTransacao

FROM tb_transacoes
GROUP BY IdCliente