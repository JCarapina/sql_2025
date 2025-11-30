WITH tb_transacoes AS (
    SELECT  Idcliente,
            Idtransacao,
            QtdePontos,
            datetime(substr(DtCriacao,1,19)) AS DtCriacao,
            julianday('now') - julianday(substr(DtCriacao,1,10)) AS diffDate
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
)

SELECT  t1.*,
        t2.IdadeBase

FROM tb_sumario_transacoes AS t1

LEFT JOIN tb_cliente AS t2
ON t1.IdCliente = t2.IdCliente