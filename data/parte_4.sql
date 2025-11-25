-- Produtos mais usados(vida, d7, d14, d28, d56)

SELECT IdCliente,
        DescNomeProduto,
        count(DescNomeProduto) AS QtdeProdutoVida,
        count(CASE WHEN diffDate <= 56 THEN 1 END) AS QtdeProdutoD56,
        count(CASE WHEN diffDate <= 28 THEN 1 END) AS QtdeProdutoD28,
        count(CASE WHEN diffDate <= 14 THEN 1 END) AS QtdeProdutoD14,
        count(CASE WHEN diffDate <= 7 THEN 1 END) AS QtdeProdutoD7
FROM produtos