-- Dia da semana mais ativo
WITH tb_transacoes AS (
    SELECT  Idcliente,
            Idtransacao,
            QtdePontos,
            datetime(substr(DtCriacao,1,19)) AS DtCriacao,
            julianday('now') - julianday(substr(DtCriacao,1,10)) AS diffDate
    FROM transacoes 
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
)