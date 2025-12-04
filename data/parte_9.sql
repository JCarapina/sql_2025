-- Periodo mais ativo
WITH tb_transacoes AS (
    SELECT  Idcliente,
            Idtransacao,
            QtdePontos,
            datetime(substr(DtCriacao,1,19)) AS DtCriacao,
            julianday('now') - julianday(substr(DtCriacao,1,10)) AS diffDate,
            CAST(strftime('%H', substr(DtCriacao,1,19)) AS INTEGER) AS DtHora
    FROM transacoes 
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
)

SELECT  * FROM tb_cliente_periodo_rn
WHERE rnPeriodo =1 