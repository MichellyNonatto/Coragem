/* Querys Oficiais */

-- ------------------------------------------------------------------------------------
-- Trigger para atualizar o valorTotal da turma quando um novo serviço é associado
-- ------------------------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER atualizar_valor_total_turma
AFTER INSERT ON servicos_has_turma
FOR EACH ROW
BEGIN
    DECLARE valor_servico DECIMAL(10,2);

    -- Obter o valor do serviço inserido
    SELECT valor INTO valor_servico
    FROM servicos
    WHERE idServicos = NEW.servicos_idServicos;

    -- Atualizar o valorTotal da turma
    UPDATE turma
    SET valorTotal = valorTotal + valor_servico
    WHERE idturma = NEW.turma_idTurma;
END //
DELIMITER ;


INSERT INTO servicos_has_turma (servicos_idServicos, turma_idTurma) VALUES
(1, 1),
(2, 1),
(3, 1),
(5, 1),
(1, 2),
(2, 2),
(3, 2),
(4, 2),
(1, 3),
(2, 3),
(4, 3),
(5, 3);
select * from servicos_has_turma;
select * from turma;


-- ------------------------------------------------------------------------------------
-- Retornar dias da Semana baseado no set
-- ------------------------------------------------------------------------------------
DELIMITER //
CREATE FUNCTION converte_dias_da_semana(dias VARCHAR(50))
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE dias_abreviados VARCHAR(50);
    DECLARE dia_numero INT;
    DECLARE dias_semana VARCHAR(3);

    SET dias_abreviados = '';

    -- Itera sobre a lista de dias
    WHILE CHAR_LENGTH(dias) > 0 DO
        -- Obtém o primeiro número na lista
        SET dia_numero = SUBSTRING_INDEX(dias, ',', 1);

        -- Converte o número para o dia da semana abreviado
        CASE dia_numero
            WHEN '0' THEN SET dias_semana = 'seg';
            WHEN '1' THEN SET dias_semana = 'ter';
            WHEN '2' THEN SET dias_semana = 'qua';
            WHEN '3' THEN SET dias_semana = 'qui';
            WHEN '4' THEN SET dias_semana = 'sex';
            WHEN '5' THEN SET dias_semana = 'sab';
            WHEN '6' THEN SET dias_semana = 'dom';
            ELSE SET dias_semana = 'inválido';
        END CASE;

        -- Adiciona o dia abreviado à string resultante
        SET dias_abreviados = CONCAT(dias_abreviados, dias_semana, ',');

        -- Remove o número processado da lista
        SET dias = SUBSTRING(dias, CHAR_LENGTH(dia_numero) + 2);
    END WHILE;

    -- Remove a vírgula extra no final, se houver
    SET dias_abreviados = TRIM(TRAILING ',' FROM dias_abreviados);

    RETURN dias_abreviados;
END //
DELIMITER ;



-- ------------------------------------------------------------------------------------
-- Trigger para Garantir que Pets sejam cadastrados somente em tutores
-- ------------------------------------------------------------------------------------

DELIMITER //
CREATE TRIGGER cadastrar_pet_somente_de_tutor
BEFORE INSERT ON pet
FOR EACH ROW
BEGIN
    DECLARE user_category ENUM('Tutor', 'Funcionario');

    -- Obter a categoria do usuário associado ao pet
    SELECT categoria INTO user_category
    FROM usuario
    WHERE idUsuario = NEW.idUsuario;

    -- Verificar se a categoria é 'Tutor', caso contrário, impedir a inserção do pet
    IF user_category != 'Tutor' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Somente é possível adicionar pets em usuários com categoria Tutor!';
    END IF;
END //
DELIMITER ;

select * from usuario;
select * from pet;

# idUsuario é funcionário
INSERT INTO pet (nome, dataNascimento, genero, castrado, dataInicio, historicoDeSaude, idUsuario, idRaca, turma_idTurma) VALUES 
('Poly', '2020-05-15', 'Femea', 1, curdate(), null, 4, 2, 1);

# idUsuario é tutor
INSERT INTO pet (nome, dataNascimento, genero, castrado, dataInicio, historicoDeSaude, idUsuario, idRaca, turma_idTurma) VALUES 
('Poly', '2020-05-15', 'Femea', 1, curdate(), null, 2, 2, 1);


-- ------------------------------------------------------------------------------------
-- Função para cadastro de funcionario completa
-- ------------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE criar_funcionario(
    IN nome_usuario VARCHAR(100),
    IN telefone_usuario INT,
    IN documento_usuario BIGINT,
    IN email_usuario VARCHAR(45),
    IN cep_endereco INT,
    IN estado_endereco CHAR(2),
    IN cidade_endereco VARCHAR(45),
    IN bairro_endereco VARCHAR(45),
    IN rua_endereco VARCHAR(45),
    IN numero_endereco VARCHAR(10),
    IN complemento_endereco VARCHAR(45),
    IN turno_funcionario ENUM('1º Turno', '2º Turno', 'Administrativo'),
    IN senha_funcionario VARCHAR(45),
    IN idFuncao_funcionario INT,
    IN nome_servico VARCHAR(45),
    IN valor_servico DECIMAL(10,2),
    IN diasDaSemana_servico VARCHAR(45),
    OUT idFuncionarioCriado INT
)
BEGIN
    DECLARE idEnderecoNovo, idUsuarioNovo, idFuncionarioNovo INT;

    -- Criar o endereço
    INSERT INTO endereco (cep, estado, cidade, bairro, rua, numero, complemento)
    VALUES (cep_endereco, estado_endereco, cidade_endereco, bairro_endereco, rua_endereco, numero_endereco, complemento_endereco);

    -- Obter o ID do endereço recém-criado
    SET idEnderecoNovo = LAST_INSERT_ID();

    -- Criar o usuário
    INSERT INTO usuario (nome, telefone, documento, email, categoria, idEndereco)
    VALUES (nome_usuario, telefone_usuario, documento_usuario, email_usuario, "Funcionario", idEnderecoNovo);

    -- Obter o ID do usuário recém-criado
    SET idUsuarioNovo = LAST_INSERT_ID();

    -- Criar o funcionário
    INSERT INTO funcionario (turno, senha, idFuncao, idUsuario)
    VALUES (turno_funcionario, senha_funcionario, idFuncao_funcionario, idUsuarioNovo);

    -- Obter o ID do funcionário recém-criado
    SET idFuncionarioNovo = LAST_INSERT_ID();

    -- Criar o serviço associado ao funcionário
    INSERT INTO servicos (nome, valor, diasDaSemana, idFuncionario)
    VALUES (nome_servico, valor_servico, diasDaSemana_servico, idFuncionarioNovo);

    -- Definir o valor de saída
    SET idFuncionarioCriado = idFuncionarioNovo;
END //
DELIMITER ;

-- Chamar a procedure diretamente
CALL criar_funcionario(
    'João Funcionario',
    123456789,
    12345678900,
    'joao.funcionario@email.com',
    12345678,
    'SP',
    'São Paulo',
    'Centro',
    'Rua Principal',
    '123',
    'Apto 456',
    '1º Turno',
    'senha123',
    1, -- Substitua pelo valor correto
    'Passeio',
    50.00,
    '1,2,3',
    @idFuncionarioCriado
);

-- Exibir o ID do funcionário criado
SELECT @idFuncionarioCriado AS idFuncionarioCriado;


-- ------------------------------------------------------------------------------------
-- Exibir dados completos dos funcionários
-- ------------------------------------------------------------------------------------
    
CREATE VIEW vw_dados_funcionario AS
SELECT
    u.nome,
    f.idFuncionario,
    f.turno,
    fc.descricao AS funcao,
    u.telefone,
    u.documento,
    u.email,
    e.cep,
    e.estado,
    e.cidade,
    e.bairro,
    e.rua,
    e.numero,
    e.complemento,
    s.nome AS servico,
    s.valor,
    converte_dias_da_semana(s.diasDaSemana) as DiasDaSemana
FROM
    funcionario f
JOIN
    usuario u ON f.idUsuario = u.idUsuario
JOIN
    endereco e ON u.idEndereco = e.idEndereco
JOIN 
    funcao fc ON f.idFuncao = fc.idFuncao
JOIN
    servicos s ON f.idFuncionario = s.idFuncionario;

-- Consultar a view
SELECT * FROM vw_dados_funcionario;

-- ------------------------------------------------------------------------------------
-- Exibir dados completos de um funcionário pelo seu ID
-- ------------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE dados_funcionario_pelo_id(funcionario_id INT)
BEGIN
	SELECT * FROM vw_dados_funcionario WHERE idFuncionario = funcionario_id;
END //
DELIMITER ;

CALL dados_funcionario_pelo_id(@idFuncionarioCriado);



-- ------------------------------------------------------------------------------------
-- Exibir dados completos dos tutores
-- ------------------------------------------------------------------------------------

CREATE VIEW vw_dados_tutores AS
SELECT
	u.idUsuario,
    u.nome,
    u.telefone,
    u.documento,
    u.email,
    e.cep,
    e.estado,
    e.cidade,
    e.bairro,
    e.rua,
    e.numero,
    e.complemento,
    pa.diaVencimento,
	p.nome AS nome_pet,
    p.genero,
    CASE p.castrado
        WHEN 1 THEN 'Sim'
        WHEN 0 THEN 'Não'
    END AS castrado,
    r.nome AS raca,
    r.especie
FROM
    usuario u
JOIN
    pet p ON u.idUsuario = p.idUsuario
JOIN
    endereco e ON u.idEndereco = e.idEndereco
JOIN
	raca r ON p.idRaca = r.idRaca
JOIN
	PAGAMENTO pa ON pa.usuario_idUsuario = u.idUsuario;

select * from vw_dados_tutores;


-- ------------------------------------------------------------------------------------
-- Exibir dados completos do tutor pelo ID
-- ------------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE dados_tutor_pelo_id(tutor_id INT)
BEGIN
	SELECT * FROM vw_dados_tutores WHERE idUsuario = tutor_id;
END //
DELIMITER ;

CALL dados_tutor_pelo_id(1);


-- ------------------------------------------------------------------------------------
-- Calcular valor total por turma
-- ------------------------------------------------------------------------------------

CREATE VIEW vw_total_servicos AS
SELECT 
	t.nome, SUM(s.valor) AS total
FROM
	turma t
		JOIN
	servicos_has_turma st ON st.turma_idTurma = t.idTurma
		JOIN
	servicos s ON s.idServicos = st.servicos_idServicos
GROUP BY t.idTurma;

select * from vw_total_servicos;

SELECT 
	t.nome, SUM(s.valor) AS total
FROM
	turma t
		JOIN
	servicos_has_turma st ON st.turma_idTurma = t.idTurma
		JOIN
	servicos s ON s.idServicos = st.servicos_idServicos
GROUP BY t.idTurma;

select * from vw_total_servicos;

-- ------------------------------------------------------------------------------------
-- Calcular valor total de serviços utilizados pelos tutores
-- ------------------------------------------------------------------------------------

CREATE VIEW vw_total_servicos_por_tutores AS
SELECT u.idUsuario, u.nome, SUM(t.valorTotal) AS valorTotal
FROM usuario u
INNER JOIN pet p ON u.idUsuario = p.idUsuario
INNER JOIN turma t ON t.idTurma = p.turma_idTurma
GROUP BY u.idUsuario;

select * from vw_total_servicos_por_tutores;

-- ------------------------------------------------------------------------------------
-- Calcular valor total de serviços utilizados por tutor pelo ID
-- ------------------------------------------------------------------------------------

/* nao esta funcionando */

DELIMITER //
CREATE PROCEDURE valor_total_por_tutor_pelo_id(tutor_id INT, OUT valorTotalNew DECIMAL(10,2))
BEGIN  
	select * from vw_total_servicos_por_tutores WHERE idUsuario = tutor_id;
    select valorTotal into valorTotalNew from vw_total_servicos_por_tutores WHERE idUsuario = tutor_id;
END //
DELIMITER ;

CALL valor_total_por_tutor_pelo_id(1, @valorTotal);




-- ------------------------------------------------------------------------------------
-- Inserir registro de pagamento
-- ------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE inserir_registro_pagamento(dataPagamento DATE, tipo ENUM("Pix", "Debito", "Credito", "Dinheiro"), idUsuario INT)
BEGIN
	DECLARE valorTotal DECIMAL(10,2);
    DECLARE idPagamentoNew INT;
    
    -- Capturar valorTotal do Tutor
    CALL valor_total_por_tutor_pelo_id(idUsuario, valorTotal);
    
    -- Capturar idPagamento do Tutor
    SELECT idPagamento INTO idPagamentoNew FROM pagamento where usuario_idUsuario = idUsuario;
    
    INSERT INTO registroPagamento VALUES
    (idRegistroPagamento, dataPagamento, valorTotal, tipo, idPagamentoNew);

END //
DELIMITER ;

call inserir_registro_pagamento('2023-10-05', "PIX", 1);
select * from registroPagamento;




/* Querys Passadas */

/*
1- Faça uma query listando todas as especies de cada raça.	Faça uma query listando todos os funcionários bem como sua função e o serviço prestado.

especies é um enum, acredito que a query deveria ser: Faça uma query listando todas as raças de cada especie.
a segunda query ja foi feita ali encima.
*/

DELIMITER //
CREATE PROCEDURE racas_por_especie()
BEGIN
	SELECT * FROM raca WHERE especie = "Cachorro";
	SELECT * FROM raca WHERE especie = "Gato";
END //
DELIMITER ;

call racas_por_especie();


/*
2- Faça uma query para calcular o total de pagamentos de um usuário	Faça uma query para listar todos os pets pertencentes a um usuário específico

a primeira ja foi feita ali encima
*/

DELIMITER //
CREATE PROCEDURE pets_por_tutor(id_tutor int)
BEGIN
	SELECT u.nome, p.nome
	FROM usuario u
	JOIN pet p ON u.idUsuario = p.idUsuario
	WHERE u.idUsuario = id_tutor;
END //
DELIMITER ;

CALL pets_por_tutor(1);



/*
3- Faça uma query que exiba o total de animais atendidos em um periodo determinado.	Faça uma query que exiba o tempo de cada atendimento

No nosso projeto, não estamos contabilizando tempo de atendimento, ou datas de um atendimento,
mas é possível retornar a quantidade de pets cadastrados em determinada turma, como no exemplo abaixo
*/


CREATE VIEW vw_pets_por_turma AS
    SELECT t.nome, COUNT(p.idPet) AS total
    FROM turma t
	JOIN pet p ON t.idTurma = p.turma_idTurma
    GROUP BY t.nome;

SELECT * FROM vw_pets_por_turma;



/*
4- Faça uma query que liste os serviços marcados, as datas de cada serviço e o id do funcionário responsável pelo serviço para um animal específico.	
A fim de ter um melhor controle financeiro, um cliente deseja saber o custo total dos futuros serviços agendados. Faça uma query que exiba o valor total 
de todos os serviços agendados para cada animal de um determinado cliente, caso possua mais de um.
*/



