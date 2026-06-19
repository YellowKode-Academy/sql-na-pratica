-- ============================================================
-- SQL na Prática — Cap 4: JOINs
-- ============================================================

-- INNER JOIN: pedidos com nome do cliente
SELECT
    p.id            AS pedido_id,
    c.nome          AS cliente,
    p.status,
    p.total,
    p.criado_em
FROM pedidos p
INNER JOIN clientes c ON c.id = p.cliente_id
ORDER BY p.criado_em DESC;

-- JOIN com 3 tabelas: itens do pedido com produto e cliente
SELECT
    c.nome          AS cliente,
    pr.nome         AS produto,
    cat.nome        AS categoria,
    ip.quantidade,
    ip.preco_unit,
    ip.subtotal
FROM itens_pedido ip
JOIN pedidos p   ON p.id  = ip.pedido_id
JOIN clientes c  ON c.id  = p.cliente_id
JOIN produtos pr ON pr.id = ip.produto_id
LEFT JOIN categorias cat ON cat.id = pr.categoria_id
ORDER BY c.nome, pr.nome;

-- LEFT JOIN: todos os clientes, com ou sem pedido
SELECT
    c.nome,
    c.estado,
    COUNT(p.id) AS total_pedidos,
    COALESCE(SUM(p.total), 0) AS valor_total
FROM clientes c
LEFT JOIN pedidos p ON p.cliente_id = c.id
GROUP BY c.id, c.nome, c.estado
ORDER BY total_pedidos DESC;

-- Clientes SEM nenhum pedido (anti-join)
SELECT c.nome, c.email, c.estado
FROM clientes c
LEFT JOIN pedidos p ON p.cliente_id = c.id
WHERE p.id IS NULL;

-- Ranking de produtos mais vendidos
SELECT
    pr.nome         AS produto,
    cat.nome        AS categoria,
    SUM(ip.quantidade) AS unidades_vendidas,
    SUM(ip.subtotal)   AS receita
FROM itens_pedido ip
JOIN produtos pr  ON pr.id  = ip.produto_id
JOIN pedidos p    ON p.id   = ip.pedido_id
LEFT JOIN categorias cat ON cat.id = pr.categoria_id
WHERE p.status != 'cancelado'
GROUP BY pr.id, pr.nome, cat.nome
ORDER BY unidades_vendidas DESC;

-- Ticket médio por cliente (só pedidos pagos/entregues)
SELECT
    c.nome,
    COUNT(p.id)         AS num_pedidos,
    AVG(p.total)        AS ticket_medio,
    SUM(p.total)        AS valor_total
FROM clientes c
JOIN pedidos p ON p.cliente_id = c.id
WHERE p.status IN ('pago', 'entregue')
GROUP BY c.id, c.nome
HAVING COUNT(p.id) > 1
ORDER BY valor_total DESC;
