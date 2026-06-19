-- ============================================================
-- SQL na Prática com PostgreSQL — Script 01: Schema e DDL
-- Banco de demonstração: sistema de e-commerce simplificado
-- ============================================================

-- Habilitar extensão para UUID (disponível no PostgreSQL por padrão)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- PARTE 1: DDL — Criando o Banco de Dados do Zero
-- ============================================================

-- Tabela de categorias de produto
CREATE TABLE IF NOT EXISTS categorias (
    id          SERIAL PRIMARY KEY,
    nome        VARCHAR(100) NOT NULL UNIQUE,
    descricao   TEXT,
    criado_em   TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de clientes
CREATE TABLE IF NOT EXISTS clientes (
    id          SERIAL PRIMARY KEY,
    nome        VARCHAR(200) NOT NULL,
    email       VARCHAR(255) NOT NULL UNIQUE,
    cidade      VARCHAR(100),
    estado      CHAR(2),
    criado_em   TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ativo       BOOLEAN DEFAULT TRUE
);

-- Tabela de produtos
CREATE TABLE IF NOT EXISTS produtos (
    id              SERIAL PRIMARY KEY,
    categoria_id    INT REFERENCES categorias(id) ON DELETE SET NULL,
    nome            VARCHAR(200) NOT NULL,
    descricao       TEXT,
    preco           NUMERIC(10, 2) NOT NULL CHECK (preco >= 0),
    estoque         INT NOT NULL DEFAULT 0 CHECK (estoque >= 0),
    criado_em       TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id              SERIAL PRIMARY KEY,
    cliente_id      INT NOT NULL REFERENCES clientes(id) ON DELETE RESTRICT,
    status          VARCHAR(20) NOT NULL DEFAULT 'pendente'
                    CHECK (status IN ('pendente', 'pago', 'enviado', 'entregue', 'cancelado')),
    total           NUMERIC(12, 2) NOT NULL DEFAULT 0,
    criado_em       TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em   TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de itens do pedido (tabela de junção com dados extras)
CREATE TABLE IF NOT EXISTS itens_pedido (
    id          SERIAL PRIMARY KEY,
    pedido_id   INT NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
    produto_id  INT NOT NULL REFERENCES produtos(id) ON DELETE RESTRICT,
    quantidade  INT NOT NULL CHECK (quantidade > 0),
    preco_unit  NUMERIC(10, 2) NOT NULL CHECK (preco_unit >= 0),
    subtotal    NUMERIC(12, 2) GENERATED ALWAYS AS (quantidade * preco_unit) STORED
);

-- ============================================================
-- PARTE 2: Índices para performance
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_produtos_categoria ON produtos(categoria_id);
CREATE INDEX IF NOT EXISTS idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX IF NOT EXISTS idx_pedidos_status ON pedidos(status);
CREATE INDEX IF NOT EXISTS idx_itens_pedido ON itens_pedido(pedido_id);
CREATE INDEX IF NOT EXISTS idx_clientes_email ON clientes(email);

-- ============================================================
-- PARTE 3: Views úteis
-- ============================================================

-- View: pedidos com nome do cliente
CREATE OR REPLACE VIEW vw_pedidos_detalhado AS
SELECT
    p.id            AS pedido_id,
    c.nome          AS cliente,
    c.email         AS email_cliente,
    p.status,
    p.total,
    p.criado_em
FROM pedidos p
JOIN clientes c ON c.id = p.cliente_id;

-- View: resumo de vendas por produto
CREATE OR REPLACE VIEW vw_vendas_por_produto AS
SELECT
    pr.id           AS produto_id,
    pr.nome         AS produto,
    cat.nome        AS categoria,
    SUM(ip.quantidade)  AS total_vendido,
    SUM(ip.subtotal)    AS receita_total
FROM itens_pedido ip
JOIN produtos pr ON pr.id = ip.produto_id
LEFT JOIN categorias cat ON cat.id = pr.categoria_id
GROUP BY pr.id, pr.nome, cat.nome;

SELECT 'Schema criado com sucesso!' AS mensagem;
