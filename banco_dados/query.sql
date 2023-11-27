/* Querys Oficiais */

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
INSERT INTO pet (nome, dataNascimento, genero, castrado, historicoDeSaude, idUsuario, idRaca) VALUES 
('Poly', '2020-05-15', 'Femea', 1, null, 4, 2);

# idUsuario é tutor
INSERT INTO pet (nome, dataNascimento, genero, castrado, historicoDeSaude, idUsuario, idRaca) VALUES 
('Poly', '2020-05-15', 'Femea', 1, null, 2, 2);


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
    s.diasDaSemana
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

CALL dados_funcionario_pelo_id(71);



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
	raca r ON p.idRaca = r.idRaca;

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
-- Calcular valor total de serviços utilizados por tutor
-- ------------------------------------------------------------------------------------

CREATE VIEW vw_total_servicos AS
SELECT 
	u.idUsuario, u.nome, SUM(s.valor) AS total
FROM
	usuario u
		JOIN
	pet p ON p.idUsuario = u.idUsuario
		JOIN
	grade g ON g.idPet = p.idPet
		JOIN
	servicos s ON g.idServicos = s.idServicos
GROUP BY u.idUsuario;

select * from vw_total_servicos;

-- ------------------------------------------------------------------------------------
-- Calcular valor total de serviços utilizados por tutor pelo ID
-- ------------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE valor_total_por_tutor(tutor_id INT)
BEGIN  
	select * from vw_total_servicos where idUsuario = tutor_id;
END //
DELIMITER ;

CALL valor_total_por_tutor(1);



    
    




/* Querys Passadas */

/*
1- Faça uma query listando todas as especies de cada raça.	Faça uma query listando todos os funcionários bem como sua função e o serviço prestado.

especies é um enum, acredito que a query deveria ser: Faça uma query listando todas as raças de cada especie.
a segunda query ja foi feita ali encima.
*/

DELIMITER //
CREATE PROCEDURE racas_por_especie()
BEGIN
	select * from raca where especie = "Cachorro";
	select * from raca where especie = "Gato";
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
	select u.nome, p.nome from usuario u join pet p on u.idUsuario = p.idUsuario where u.idUsuario = id_tutor;
END //
DELIMITER ;

call pets_por_tutor(1);

/*
3- Faça uma query que exiba o total de animais atendidos em um periodo determinado.	Faça uma query que exiba o tempo de cada atendimento
*/

/*
4- Faça uma query que liste os serviços marcados, as datas de cada serviço e o id do funcionário responsável pelo serviço para um animal específico.	
A fim de ter um melhor controle financeiro, um cliente deseja saber o custo total dos futuros serviços agendados. Faça uma query que exiba o valor total 
de todos os serviços agendados para cada animal de um determinado cliente, caso possua mais de um.
*/

