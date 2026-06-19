-- ============================================================
-- SQL na Prática — Cap 9: Índices e Performance
-- ============================================================

-- Ver tamanho das tabelas
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname || '.' || tablename)) AS tamanho
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname || '.' || tablename) DESC;

-- Listar índices existentes
SELECT
    indexname,
    tablename,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename;

-- EXPLAIN ANALYZE: ver plano de execução
EXPLAIN ANALYZE
SELECT * FROM clientes WHERE email = 'ana.silva@email.com';

-- Criar índice composto (estado + ativo)
CREATE INDEX IF NOT EXISTS idx_clientes_estado_ativo
ON clientes(estado, ativo);

-- Índice parcial (só clientes ativos — muito mais eficiente)
CREATE INDEX IF NOT EXISTS idx_clientes_ativos
ON clientes(email) WHERE ativo = TRUE;

-- Índice para texto (busca por nome)
CREATE INDEX IF NOT EXISTS idx_clientes_nome_text
ON clientes USING gin(to_tsvector('portuguese', nome));

-- Full-text search com o índice acima
SELECT nome, email
FROM clientes
WHERE to_tsvector('portuguese', nome) @@ plainto_tsquery('portuguese', 'silva');

-- EXPLAIN com e sem índice para comparação
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT p.id, p.total, c.nome
FROM pedidos p
JOIN clientes c ON c.id = p.cliente_id
WHERE p.status = 'entregue';

-- Ver estatísticas de uso dos índices
SELECT
    schemaname,
    relname         AS tablename,
    indexrelname    AS indexname,
    idx_scan        AS vezes_usado,
    idx_tup_read    AS linhas_lidas
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY idx_scan DESC;

-- VACUUM e ANALYZE (manutenção)
VACUUM ANALYZE clientes;
VACUUM ANALYZE pedidos;

SELECT 'Análise de índices concluída' AS mensagem;
