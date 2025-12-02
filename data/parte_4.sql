-- Produtos mais usados(vida, d7, d14, d28, d56)

WITH tb_transacoes AS (
    SELECT  Idcliente,
            Idtransacao,
            QtdePontos,
            datetime(substr(DtCriacao,1,19)) AS DtCriacao,
            julianday('now') - julianday(substr(DtCriacao,1,10)) AS diffDate
    FROM transacoes 
),

tb_transacao_produto AS (
    SELECT  t1.*,
            t2.idProduto,
            t3.DescNomeProduto,
            t3.DescCategoriaProduto

    FROM tb_transacoes AS t1

    LEFT JOIN transacao_produto AS t2
    ON t1.IdTransacao = t2.IdTransacao

    LEFT JOIN produtos AS t3
    ON t2.IdProduto = t3.IdProduto
),

tb_cliente_produto AS (
    SELECT  IdCliente,
            DescNomeProduto,
            count(*) AS qtdeVida,
            count(CASE WHEN diffDate <= 56 THEN IdTransacao END) AS qtde56,
            count(CASE WHEN diffDate <= 28 THEN IdTransacao END) AS qtde28,
            count(CASE WHEN diffDate <= 14 THEN IdTransacao END) AS qtde14,
            count(CASE WHEN diffDate <= 7 THEN IdTransacao END) AS qtde7


    FROM tb_transacao_produto

    GROUP BY IdCliente, DescNomeProduto
),

tb_cliente_produto_rn AS ( 
    SELECT *,
        row_number() OVER (PARTITION BY IdCliente ORDER BY qtdeVida DESC) AS rnVida,
        row_number() OVER (PARTITION BY IdCliente ORDER BY qtde56 DESC) AS rn56,
        row_number() OVER (PARTITION BY IdCliente ORDER BY qtde28 DESC) AS rn28,
        row_number() OVER (PARTITION BY IdCliente ORDER BY qtde14 DESC) AS rn14,
        row_number() OVER (PARTITION BY IdCliente ORDER BY qtde7 DESC) AS rn7
    FROM tb_cliente_produto
)

SELECT * FROM tb_cliente_produto_rn