-- ============================================================
-- SQL na Prática — Cap 6: Window Functions
-- ============================================================

-- ROW_NUMBER: numerar pedidos de cada cliente por data
SELECT
    c.nome,
    p.id        AS pedido_id,
    p.total,
    p.criado_em,
    ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY p.criado_em) AS num_pedido_cliente
FROM pedidos p
JOIN clientes c ON c.id = p.cliente_id
ORDER BY c.nome, num_pedido_cliente;

-- RANK: ranking de clientes por valor total gasto
SELECT
    c.nome,
    SUM(p.total) AS total_gasto,
    RANK() OVER (ORDER BY SUM(p.total) DESC) AS posicao
FROM clientes c
JOIN pedidos p ON p.cliente_id = c.id
WHERE p.status != 'cancelado'
GROUP BY c.id, c.nome
ORDER BY posicao;

-- LAG: comparar total de pedido com o anterior do mesmo cliente
SELECT
    c.nome,
    p.id        AS pedido_id,
    p.total,
    p.criado_em,
    LAG(p.total) OVER (PARTITION BY c.id ORDER BY p.criado_em) AS pedido_anterior,
    p.total - LAG(p.total) OVER (PARTITION BY c.id ORDER BY p.criado_em) AS variacao
FROM pedidos p
JOIN clientes c ON c.id = p.cliente_id
ORDER BY c.nome, p.criado_em;

-- RUNNING TOTAL: acumulado de receita por dia
SELECT
    DATE(criado_em)     AS data,
    SUM(total)          AS receita_dia,
    SUM(SUM(total)) OVER (ORDER BY DATE(criado_em)) AS receita_acumulada
FROM pedidos
WHERE status IN ('pago', 'enviado', 'entregue')
GROUP BY DATE(criado_em)
ORDER BY data;

-- NTILE: dividir clientes em quartis de gasto
SELECT
    c.nome,
    SUM(p.total) AS total_gasto,
    NTILE(4) OVER (ORDER BY SUM(p.total)) AS quartil
FROM clientes c
JOIN pedidos p ON p.cliente_id = c.id
WHERE p.status != 'cancelado'
GROUP BY c.id, c.nome
ORDER BY total_gasto;

-- FIRST_VALUE / LAST_VALUE: primeiro e último pedido por cliente
SELECT DISTINCT
    c.nome,
    FIRST_VALUE(p.total) OVER w AS primeiro_pedido_valor,
    LAST_VALUE(p.total)  OVER w AS ultimo_pedido_valor
FROM pedidos p
JOIN clientes c ON c.id = p.cliente_id
WINDOW w AS (
    PARTITION BY c.id
    ORDER BY p.criado_em
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
ORDER BY c.nome;
