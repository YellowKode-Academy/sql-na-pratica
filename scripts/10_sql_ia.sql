-- ============================================================
-- SQL na Prática — Cap 10: SQL na Era da IA
-- ============================================================

-- ============================================================
-- Padrão 1: Contexto para IA gerar SQL correto
-- ============================================================

-- Comentário de contexto que você manda para a IA:
-- Tabelas: clientes(id, nome, email, estado, ativo)
--          pedidos(id, cliente_id, status, total, criado_em)
-- status pode ser: pendente, pago, enviado, entregue, cancelado
-- Quero: clientes do SP com mais de um pedido entregue

-- Resultado gerado pela IA com contexto completo:
SELECT
    c.nome,
    c.email,
    COUNT(p.id) AS pedidos_entregues
FROM clientes c
JOIN pedidos p ON p.cliente_id = c.id
WHERE c.estado = 'SP'
  AND p.status = 'entregue'
  AND c.ativo = TRUE
GROUP BY c.id, c.nome, c.email
HAVING COUNT(p.id) > 1
ORDER BY pedidos_entregues DESC;

-- ============================================================
-- Padrão 2: SQL gerado por IA para análise rápida
-- ============================================================

-- Prompt: "Crie uma query para identificar produtos em risco de
-- esgotamento (estoque < 30 e foram vendidas >5 unidades no último mês)"

SELECT
    pr.nome,
    pr.estoque          AS estoque_atual,
    SUM(ip.quantidade)  AS vendido_ultimo_mes,
    pr.estoque - SUM(ip.quantidade) AS saldo_projetado
FROM produtos pr
JOIN itens_pedido ip ON ip.produto_id = pr.id
JOIN pedidos p ON p.id = ip.pedido_id
WHERE p.criado_em >= NOW() - INTERVAL '30 days'
  AND p.status != 'cancelado'
  AND pr.estoque < 50
GROUP BY pr.id, pr.nome, pr.estoque
HAVING SUM(ip.quantidade) > 2
ORDER BY saldo_projetado ASC;

-- ============================================================
-- Padrão 3: Supabase — SQL direto no dashboard
-- ============================================================

-- No Supabase SQL Editor, você escreve SQL puro
-- As tabelas criadas no schema public ficam disponíveis via API REST

-- Consulta que vira endpoint Supabase automaticamente:
SELECT
    p.id,
    c.nome      AS cliente,
    p.status,
    p.total,
    p.criado_em
FROM pedidos p
JOIN clientes c ON c.id = p.cliente_id
WHERE p.status = 'pendente'
ORDER BY p.criado_em ASC;
-- No Supabase: GET /rest/v1/vw_pedidos_detalhado?status=eq.pendente

-- Row Level Security (RLS) — conceito Supabase
-- ALTER TABLE pedidos ENABLE ROW LEVEL SECURITY;
-- CREATE POLICY "usuario ve proprios pedidos"
-- ON pedidos FOR SELECT
-- USING (cliente_id = auth.uid()::int);

-- ============================================================
-- Padrão 4: Views para Supabase / APIs
-- ============================================================

CREATE OR REPLACE VIEW vw_dashboard AS
SELECT
    (SELECT COUNT(*) FROM clientes WHERE ativo) AS clientes_ativos,
    (SELECT COUNT(*) FROM pedidos WHERE status = 'pendente') AS pedidos_pendentes,
    (SELECT COUNT(*) FROM pedidos WHERE status = 'enviado') AS pedidos_enviados,
    (SELECT COALESCE(SUM(total), 0) FROM pedidos
     WHERE status IN ('pago','entregue')
     AND criado_em >= DATE_TRUNC('month', NOW())) AS receita_mes_atual,
    (SELECT COUNT(*) FROM produtos WHERE estoque < 20) AS produtos_estoque_critico;

SELECT * FROM vw_dashboard;

-- ============================================================
-- Padrão 5: Identificar slow queries para otimizar com IA
-- ============================================================

-- Ver queries mais lentas (requer pg_stat_statements)
-- SELECT query, calls, mean_exec_time, total_exec_time
-- FROM pg_stat_statements
-- ORDER BY mean_exec_time DESC LIMIT 10;

-- Análise de query para mandar para a IA otimizar:
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
SELECT
    c.estado,
    COUNT(DISTINCT c.id)    AS clientes,
    COUNT(p.id)             AS pedidos,
    SUM(p.total)            AS receita
FROM clientes c
LEFT JOIN pedidos p ON p.cliente_id = c.id
WHERE p.status != 'cancelado' OR p.status IS NULL
GROUP BY c.estado
ORDER BY receita DESC NULLS LAST;

SELECT 'Scripts de SQL + IA executados com sucesso!' AS mensagem;
