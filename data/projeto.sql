WITH tb_transacoes AS (
    SELECT  Idcliente,
            Idtransacao,
            QtdePontos,
            datetime(substr(DtCriacao,1,19)) AS DtCriacao,
            julianday('now') - julianday(substr(DtCriacao,1,10)) AS diffDate,
            CAST(strftime('%H', substr(DtCriacao,1,19)) AS INTEGER) AS DtHora
    FROM transacoes
),

tb_cliente AS (
    SELECT  IdCliente,
            datetime(substr(DtCriacao,1,19)) AS DtCriacao,
            julianday('now') - julianday(substr(DtCriacao,1,10)) AS IdadeBase

    FROM clientes
), 

tb_sumario_transacoes AS (

    SELECT  IdCliente,
            count(Idtransacao) AS QtdeTransacoesVida,
            count(CASE WHEN diffDate <= 56 THEN 1 END) AS QtdeTransacoesD56,
            count(CASE WHEN diffDate <= 28 THEN 1 END) AS QtdeTransacoesD28,
            count(CASE WHEN diffDate <= 14 THEN 1 END) AS QtdeTransacoesD14,
            count(CASE WHEN diffDate <= 7 THEN 1 END) AS QtdeTransacoesD7,

            sum(qtdePontos) AS saldoPontos,

            min(diffDate) AS diasUltimaInteracao,

            sum(CASE WHEN qtdePontos > 0 THEN qtdePontos ELSE 0 END) AS PositAcumuladosVida,
            sum(CASE WHEN qtdePontos > 0 AND diffDate < 56 THEN qtdePontos ELSE 0 END) AS PositAcumuladosD56,
            sum(CASE WHEN qtdePontos > 0 AND diffDate < 28 THEN qtdePontos ELSE 0 END) AS PositAcumuladosD28,
            sum(CASE WHEN qtdePontos > 0 AND diffDate < 14 THEN qtdePontos ELSE 0 END) AS PositAcumuladosD14,
            sum(CASE WHEN qtdePontos > 0 AND diffDate <  7 THEN qtdePontos ELSE 0 END) AS PositAcumuladosD7,

            sum(CASE WHEN qtdePontos > 0 THEN qtdePontos ELSE 0 END) AS NegativoAcumuladosVida,
            sum(CASE WHEN qtdePontos > 0 AND diffDate < 56 THEN qtdePontos ELSE 0 END) AS NegativoAcumuladosD56,
            sum(CASE WHEN qtdePontos > 0 AND diffDate < 28 THEN qtdePontos ELSE 0 END) AS NegativoAcumuladosD28,
            sum(CASE WHEN qtdePontos > 0 AND diffDate < 14 THEN qtdePontos ELSE 0 END) AS NegativoAcumuladosD14,
            sum(CASE WHEN qtdePontos > 0 AND diffDate <  7 THEN qtdePontos ELSE 0 END) AS NegativoAcumuladosD7

    FROM tb_transacoes
    GROUP BY IdCliente
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
),

tb_cliente_dia AS (
    SELECT  Idcliente,
            strftime('%w', DtCriacao) AS DtDia,
            count(*) AS qtdTransacao
    FROM tb_transacoes 
    WHERE diffDate <=28
    GROUP BY IdCliente, DtDia
),

tb_cliente_dia_rn AS (

    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtdTransacao DESC) AS rnDia


    FROM tb_cliente_dia
),

tb_cliente_periodo AS (
    SELECT  Idcliente,
            CASE 
                WHEN DtHora BETWEEN 7 AND 12 THEN 'MANHÃ'
                WHEN DtHora BETWEEN 13 AND 18 THEN 'TARDE'
                WHEN DtHora BETWEEN 19 AND 23 THEN 'NOITE'
                WHEN DtHora BETWEEN 24 AND 6 THEN 'MADRUGADA'
                ELSE 'SEM INFORMAÇÃO'
            END AS Periodo,
            COUNT(*) AS qtdeTransacao

    FROM tb_transacoes
    WHERE diffDate <= 28

    GROUP BY 1,2
),

tb_cliente_periodo_rn AS (
    SELECT *,
            ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtdeTransacao DESC) AS rnPeriodo

    FROM tb_cliente_periodo
),


tb_join AS  (

    SELECT  t1.*,
            t2.IdadeBase,
            t3.DescNomeProduto AS produtoVida,
            t4.DescNomeProduto AS produto56,
            t5.DescNomeProduto AS produto28,
            t6.DescNomeProduto AS produto14,
            t7.DescNomeProduto AS produto7,
            COALESCE(t8.DtDia, -1) AS DtDia,
            COALESCE(t9.Periodo, 'SEM INFORMAÇÃO') AS periodoMaisTransacao28

    FROM tb_sumario_transacoes AS t1

    LEFT JOIN tb_cliente AS t2
    ON t1.IdCliente = t2.IdCliente

    LEFT JOIN tb_cliente_produto_rn AS t3
    ON t1.idCliente = t3.IdCliente
    AND t3.rnVida = 1

    LEFT JOIN tb_cliente_produto_rn AS t4
    ON t1.idCliente = t4.IdCliente
    AND t4.rn56 = 1

    LEFT JOIN tb_cliente_produto_rn AS t5
    ON t1.idCliente = t5.IdCliente
    AND t5.rn28 = 1
    
    LEFT JOIN tb_cliente_produto_rn AS t6
    ON t1.idCliente = t6.IdCliente
    AND t6.rn14 = 1

    LEFT JOIN tb_cliente_produto_rn AS t7
    ON t1.idCliente = t7.IdCliente
    AND t7.rn7 = 1

    LEFT JOIN tb_cliente_dia_rn AS t8
    ON t1.idCliente = t8.idCliente
    AND t8.rnDia = 1

    LEFT JOIN tb_cliente_periodo_rn AS t9
    ON t1.idCliente = t9.idCliente
    AND t9.rnPeriodo = 1
)

SELECT * FROM tb_join
ORDER BY idCliente