-- Idade na base (Dia desde o cadastro) de cada cliente
SELECT  IdCliente,
        datetime(substr(DtCriacao,1,19)) AS DtCriacao,
        julianday('now') - julianday(substr(DtCriacao,1,10)) AS IdadeBase
FROM clientes
ORDER BY IdadeBase DESC 