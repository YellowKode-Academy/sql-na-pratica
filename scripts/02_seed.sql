-- ============================================================
-- SQL na Prática com PostgreSQL — Script 02: Dados de Exemplo
-- ============================================================

-- ============================================================
-- Categorias
-- ============================================================
INSERT INTO categorias (nome, descricao) VALUES
    ('Eletrônicos',     'Dispositivos eletrônicos e acessórios'),
    ('Livros',          'Livros físicos e digitais'),
    ('Roupas',          'Vestuário masculino e feminino'),
    ('Casa e Cozinha',  'Utensílios domésticos'),
    ('Esportes',        'Equipamentos e roupas esportivas');

-- ============================================================
-- Clientes (20 clientes de diferentes estados)
-- ============================================================
INSERT INTO clientes (nome, email, cidade, estado) VALUES
    ('Ana Silva',       'ana.silva@email.com',      'São Paulo',        'SP'),
    ('Bruno Costa',     'bruno.costa@email.com',    'Rio de Janeiro',   'RJ'),
    ('Carla Mendes',    'carla.mendes@email.com',   'Belo Horizonte',   'MG'),
    ('Diego Rocha',     'diego.rocha@email.com',    'Salvador',         'BA'),
    ('Elena Ferreira',  'elena.ferreira@email.com', 'Curitiba',         'PR'),
    ('Felipe Souza',    'felipe.souza@email.com',   'Porto Alegre',     'RS'),
    ('Gabriela Lima',   'gabriela.lima@email.com',  'Fortaleza',        'CE'),
    ('Henrique Santos', 'henrique.s@email.com',     'Manaus',           'AM'),
    ('Isabella Nunes',  'isabella.n@email.com',     'Recife',           'PE'),
    ('João Carvalho',   'joao.carvalho@email.com',  'Goiânia',          'GO'),
    ('Kamila Torres',   'kamila.torres@email.com',  'Brasília',         'DF'),
    ('Lucas Oliveira',  'lucas.oliveira@email.com', 'São Paulo',        'SP'),
    ('Marina Alves',    'marina.alves@email.com',   'Rio de Janeiro',   'RJ'),
    ('Nicolas Pereira', 'nicolas.p@email.com',      'Campinas',         'SP'),
    ('Olivia Ramos',    'olivia.ramos@email.com',   'Santos',           'SP'),
    ('Paulo Gomes',     'paulo.gomes@email.com',    'Florianópolis',    'SC'),
    ('Rafaela Cruz',    'rafaela.cruz@email.com',   'Vitória',          'ES'),
    ('Samuel Barbosa',  'samuel.b@email.com',       'Natal',            'RN'),
    ('Tatiana Lopes',   'tatiana.lopes@email.com',  'João Pessoa',      'PB'),
    ('Ursula Martins',  'ursula.m@email.com',       'Maceió',           'AL');

-- ============================================================
-- Produtos
-- ============================================================
INSERT INTO produtos (categoria_id, nome, preco, estoque) VALUES
    -- Eletrônicos (categoria 1)
    (1, 'Notebook Dell Inspiron 15',    3299.90,  45),
    (1, 'Smartphone Samsung Galaxy A55',1499.00, 120),
    (1, 'Fone Bluetooth Sony WH-1000XM5', 1799.00, 60),
    (1, 'Monitor LG 27" 4K',            2199.00,  30),
    (1, 'Teclado Mecânico Keychron K2',   599.00,  80),
    -- Livros (categoria 2)
    (2, 'SQL na Prática com PostgreSQL',   49.90, 500),
    (2, 'Clean Code - Robert Martin',      79.90, 200),
    (2, 'Design Patterns com TypeScript',  44.90, 300),
    (2, 'Prompt Context Engineering',      44.90, 400),
    -- Roupas (categoria 3)
    (3, 'Camiseta Polo Lacoste',          189.90, 150),
    (3, 'Calça Jeans Slim',              299.90,  90),
    (3, 'Tênis Nike Air Max',            699.90,  70),
    -- Casa e Cozinha (categoria 4)
    (4, 'Cafeteira Nespresso Essenza',   599.00,  55),
    (4, 'Panela Pressão Tramontina 7L',  199.90,  40),
    -- Esportes (categoria 5)
    (5, 'Bicicleta Speed Trek Domane',  4999.00,  15),
    (5, 'Tapete de Yoga 6mm',            89.90, 200);

-- ============================================================
-- Pedidos e Itens (30 pedidos distribuídos)
-- ============================================================

-- Pedido 1 — Ana Silva, pago
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (1, 'entregue', 3898.90, NOW() - INTERVAL '45 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES
    (1, 1, 1, 3299.90),
    (1, 5, 1, 599.00);

-- Pedido 2 — Bruno Costa, entregue
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (2, 'entregue', 1499.00, NOW() - INTERVAL '40 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES (2, 2, 1, 1499.00);

-- Pedido 3 — Carla Mendes, entregue
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (3, 'entregue', 2398.80, NOW() - INTERVAL '38 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES
    (3, 2, 1, 1499.00),
    (3, 3, 1, 599.00),
    (3, 5, 1, 599.00);

-- Pedido 4 — Diego, enviado
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (4, 'enviado', 4999.00, NOW() - INTERVAL '10 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES (4, 15, 1, 4999.00);

-- Pedido 5 — Elena Ferreira, pago
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (5, 'pago', 699.80, NOW() - INTERVAL '5 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES
    (5, 7, 2, 79.90),
    (5, 6, 2, 49.90),
    (5, 9, 4, 44.90),
    (5, 8, 4, 44.90);

-- Pedido 6 — Felipe, entregue
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (6, 'entregue', 1799.00, NOW() - INTERVAL '60 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES (6, 3, 1, 1799.00);

-- Pedido 7 — Gabriela, pendente
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (7, 'pendente', 189.90, NOW() - INTERVAL '1 day');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES (7, 10, 1, 189.90);

-- Pedido 8 — Henrique, pago
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (8, 'pago', 2199.00, NOW() - INTERVAL '7 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES (8, 4, 1, 2199.00);

-- Pedido 9 — Isabella, entregue
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (9, 'entregue', 899.80, NOW() - INTERVAL '30 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES
    (9, 13, 1, 599.00),
    (9, 14, 1, 199.90),
    (9, 16, 1, 89.90);

-- Pedido 10 — João Carvalho, cancelado
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (10, 'cancelado', 4999.00, NOW() - INTERVAL '20 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES (10, 15, 1, 4999.00);

-- Pedido 11 — Kamila, enviado
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (11, 'enviado', 1199.80, NOW() - INTERVAL '8 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES
    (11, 11, 2, 299.90),
    (11, 12, 1, 599.90);

-- Pedido 12 — Lucas SP, entregue
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (12, 'entregue', 3898.90, NOW() - INTERVAL '55 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES
    (12, 1, 1, 3299.00),
    (12, 5, 1, 599.00);

-- Pedido 13 — Marina RJ, pago
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (13, 'pago', 449.50, NOW() - INTERVAL '3 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES
    (13, 6, 5, 49.90),
    (13, 9, 5, 44.90);

-- Pedido 14 — Nicolas, entregue
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (14, 'entregue', 1799.00, NOW() - INTERVAL '70 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES (14, 3, 1, 1799.00);

-- Pedido 15 — Ana Silva segundo pedido
INSERT INTO pedidos (cliente_id, status, total, criado_em) VALUES (1, 'entregue', 299.90, NOW() - INTERVAL '15 days');
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unit) VALUES (15, 11, 1, 299.90);

SELECT 'Dados inseridos com sucesso! ' || COUNT(*) || ' pedidos criados.' AS mensagem FROM pedidos;
