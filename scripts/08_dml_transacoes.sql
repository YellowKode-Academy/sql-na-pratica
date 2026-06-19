-- ============================================================
-- SQL na Prática — Cap 8: DML (INSERT, UPDATE, DELETE) e Transações
-- ============================================================

-- INSERT simples
INSERT INTO categorias (nome, descricao)
VALUES ('Alimentos', 'Produtos alimentícios e bebidas');

-- INSERT múltiplos (mais eficiente que um por vez)
INSERT INTO produtos (categoria_id, nome, preco, estoque) VALUES
    (6, 'Café Especial 250g',   45.90, 300),
    (6, 'Azeite Extra Virgem', 89.90, 150),
    (6, 'Granola Artesanal',   32.90, 200);

-- INSERT com RETURNING (PostgreSQL feature)
INSERT INTO clientes (nome, email, cidade, estado)
VALUES ('Roberto Alves', 'roberto.a@email.com', 'Uberlândia', 'MG')
RETURNING id, nome, criado_em;

-- UPDATE simples
UPDATE produtos
SET preco = preco * 1.10  -- reajuste de 10%
WHERE categoria_id = 1    -- só eletrônicos
RETURNING id, nome, preco;

-- UPDATE com subquery: marcar clientes VIPs
-- (clientes com mais de R$2000 em compras)
UPDATE clientes
SET ativo = TRUE  -- apenas exemplo de UPDATE condicional
WHERE id IN (
    SELECT cliente_id
    FROM pedidos
    WHERE status != 'cancelado'
    GROUP BY cliente_id
    HAVING SUM(total) > 2000
)
RETURNING id, nome;

-- DELETE com condição
DELETE FROM produtos
WHERE nome LIKE '%Granola%'
RETURNING id, nome;

-- ============================================================
-- TRANSAÇÕES
-- ============================================================

-- Transação: criar pedido de forma atômica
BEGIN;

-- 1. Inserir o pedido
INSERT INTO pedidos (cliente_id, status, total)
VALUES (1, 'pendente', 0);

-- 2. Inserir itens (pegando o ID do pedido recém-criado)
WITH novo_pedido AS (
    SELECT id FROM pedidos WHERE cliente_id = 1 ORDER BY criado_em DESC LIMIT 1
)
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit)
SELECT np.id, 6, 3, 49.90
FROM novo_pedido np;

-- 3. Atualizar o total do pedido
WITH ultimo_pedido AS (
    SELECT id FROM pedidos WHERE cliente_id = 1 ORDER BY criado_em DESC LIMIT 1
)
UPDATE pedidos
SET total = (
    SELECT SUM(subtotal) FROM itens_pedido
    WHERE pedido_id = (SELECT id FROM ultimo_pedido)
)
WHERE id = (SELECT id FROM ultimo_pedido);

COMMIT;

-- ROLLBACK exemplo (seria usado em caso de erro)
-- BEGIN;
-- DELETE FROM pedidos WHERE id = 999; -- erro simulado
-- ROLLBACK; -- desfaz tudo

-- Verificar resultado
SELECT p.id, c.nome, p.status, p.total
FROM pedidos p JOIN clientes c ON c.id = p.cliente_id
WHERE c.id = 1 ORDER BY p.criado_em DESC LIMIT 3;
