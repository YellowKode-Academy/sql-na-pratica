-- ============================================================
-- SQL na Prática — Cap 5: Agregações e GROUP BY
-- ============================================================

-- Funções de agregação básicas
SELECT
    COUNT(*)            AS total_produtos,
    AVG(preco)          AS preco_medio,
    MIN(preco)          AS preco_minimo,
    MAX(preco)          AS preco_maximo,
    SUM(preco * estoque) AS valor_total_estoque
FROM produtos;

-- Vendas por status de pedido
SELECT
    status,
    COUNT(*)        AS quantidade,
    SUM(total)      AS valor_total,
    AVG(total)      AS ticket_medio
FROM pedidos
GROUP BY status
ORDER BY valor_total DESC;

-- Receita por categoria (só pedidos não cancelados)
SELECT
    cat.nome            AS categoria,
    COUNT(DISTINCT p.id)    AS num_pedidos,
    SUM(ip.subtotal)        AS receita_total,
    ROUND(SUM(ip.subtotal) * 100.0 / SUM(SUM(ip.subtotal)) OVER (), 2) AS percentual
FROM itens_pedido ip
JOIN produtos pr ON pr.id = ip.produto_id
LEFT JOIN categorias cat ON cat.id = pr.categoria_id
JOIN pedidos p ON p.id = ip.pedido_id
WHERE p.status != 'cancelado'
GROUP BY cat.id, cat.nome
ORDER BY receita_total DESC;

-- HAVING: categorias com mais de R$ 1000 em receita
SELECT
    cat.nome AS categoria,
    SUM(ip.subtotal) AS receita
FROM itens_pedido ip
JOIN produtos pr ON pr.id = ip.produto_id
LEFT JOIN categorias cat ON cat.id = pr.categoria_id
JOIN pedidos p ON p.id = ip.pedido_id
WHERE p.status != 'cancelado'
GROUP BY cat.nome
HAVING SUM(ip.subtotal) > 1000
ORDER BY receita DESC;

-- Vendas mensais (últimos 6 meses)
SELECT
    DATE_TRUNC('month', criado_em)  AS mes,
    COUNT(*)                        AS pedidos,
    SUM(total)                      AS receita
FROM pedidos
WHERE status IN ('pago', 'enviado', 'entregue')
  AND criado_em >= NOW() - INTERVAL '6 months'
GROUP BY DATE_TRUNC('month', criado_em)
ORDER BY mes;

-- Distribuição de clientes por estado
SELECT
    estado,
    COUNT(*) AS clientes,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS percentual
FROM clientes
GROUP BY estado
ORDER BY clientes DESC;
