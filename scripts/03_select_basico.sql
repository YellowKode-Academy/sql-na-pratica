-- ============================================================
-- SQL na Prática — Cap 3: SELECT e Consultas Básicas
-- ============================================================

-- Todos os clientes
SELECT * FROM clientes LIMIT 5;

-- Colunas específicas
SELECT nome, email, estado FROM clientes;

-- Filtrar por estado
SELECT nome, email FROM clientes WHERE estado = 'SP';

-- Ordenar por nome
SELECT nome, estado FROM clientes ORDER BY nome ASC;

-- Top 5 produtos mais caros
SELECT nome, preco FROM produtos ORDER BY preco DESC LIMIT 5;

-- Contar clientes por estado
SELECT estado, COUNT(*) AS total_clientes
FROM clientes
GROUP BY estado
ORDER BY total_clientes DESC;

-- Produtos com estoque baixo (menos de 50 unidades)
SELECT nome, estoque, preco
FROM produtos
WHERE estoque < 50
ORDER BY estoque ASC;

-- Clientes de SP ou RJ
SELECT nome, cidade, estado
FROM clientes
WHERE estado IN ('SP', 'RJ')
ORDER BY estado, nome;

-- Produtos entre R$ 100 e R$ 1000
SELECT nome, preco
FROM produtos
WHERE preco BETWEEN 100 AND 1000
ORDER BY preco;

-- Busca por nome parcial (LIKE)
SELECT nome, email FROM clientes WHERE nome ILIKE '%ana%';

-- Pedidos dos últimos 30 dias
SELECT id, cliente_id, status, total, criado_em
FROM pedidos
WHERE criado_em >= NOW() - INTERVAL '30 days'
ORDER BY criado_em DESC;
