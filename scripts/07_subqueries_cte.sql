-- ============================================================
-- SQL na Prática — Cap 7: Subqueries e CTEs
-- ============================================================

-- Subquery: produtos acima da média de preço
SELECT nome, preco
FROM produtos
WHERE preco > (SELECT AVG(preco) FROM produtos)
ORDER BY preco DESC;

-- Subquery correlacionada: clientes que gastaram mais que a média
SELECT c.nome, total_gasto
FROM (
    SELECT cliente_id, SUM(total) AS total_gasto
    FROM pedidos
    WHERE status != 'cancelado'
    GROUP BY cliente_id
) sub
JOIN clientes c ON c.id = sub.cliente_id
WHERE total_gasto > (
    SELECT AVG(soma)
    FROM (
        SELECT SUM(total) AS soma
        FROM pedidos
        WHERE status != 'cancelado'
        GROUP BY cliente_id
    ) media
)
ORDER BY total_gasto DESC;

-- EXISTS: clientes com pelo menos um pedido entregue
SELECT nome, email
FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM pedidos p
    WHERE p.cliente_id = c.id
      AND p.status = 'entregue'
);

-- CTE simples: análise em etapas legíveis
WITH receita_por_categoria AS (
    SELECT
        cat.nome        AS categoria,
        SUM(ip.subtotal)    AS receita
    FROM itens_pedido ip
    JOIN produtos pr ON pr.id = ip.produto_id
    LEFT JOIN categorias cat ON cat.id = pr.categoria_id
    JOIN pedidos p ON p.id = ip.pedido_id
    WHERE p.status != 'cancelado'
    GROUP BY cat.nome
),
total_geral AS (
    SELECT SUM(receita) AS total FROM receita_por_categoria
)
SELECT
    r.categoria,
    r.receita,
    ROUND(r.receita * 100.0 / t.total, 2) AS percentual
FROM receita_por_categoria r
CROSS JOIN total_geral t
ORDER BY r.receita DESC;

-- CTE recursiva: hierarquia de categorias (exemplo conceitual)
WITH RECURSIVE numeros AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numeros WHERE n < 10
)
SELECT n, n * n AS quadrado FROM numeros;

-- CTE múltipla: relatório completo de vendas
WITH
pedidos_validos AS (
    SELECT * FROM pedidos WHERE status NOT IN ('cancelado', 'pendente')
),
top_clientes AS (
    SELECT
        cliente_id,
        COUNT(*) AS num_pedidos,
        SUM(total) AS total_gasto
    FROM pedidos_validos
    GROUP BY cliente_id
    ORDER BY total_gasto DESC
    LIMIT 5
)
SELECT
    c.nome,
    tc.num_pedidos,
    tc.total_gasto,
    ROUND(tc.total_gasto / tc.num_pedidos, 2) AS ticket_medio
FROM top_clientes tc
JOIN clientes c ON c.id = tc.cliente_id
ORDER BY tc.total_gasto DESC;
