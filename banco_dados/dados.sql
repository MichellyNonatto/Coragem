INSERT INTO endereco (cep, estado, cidade, bairro, rua, numero, complemento) VALUES 
(12345678, 'SP', 'Bragança Paulista', 'Centro', 'Rua A', '123', 'Apto 1'),
(98765432, 'SP', 'Bragança Paulista', 'Jardim Bela Vista', 'Avenida B', '456', 'Bloco 2'),
(56789012, 'SP', 'Bragança Paulista', 'Vila Esperança', 'Praça C', '789', NULL),
(23456789, 'MG', 'Extrema', 'Centro', 'Rua X', '101', 'Apto 4'),
(54321098, 'MG', 'Extrema', 'Jardim dos Lagos', 'Avenida Y', '55', NULL),
(87654321, 'SP', 'Atibaia', 'Jardim Alvinópolis', 'Rua Z', '250', 'Casa Azul'),
(34567890, 'SP', 'Atibaia', 'Alvinópolis', 'Avenida W', '42', 'Casa Amarela');
select * from endereco;

INSERT INTO usuario (nome, telefone, documento, email, categoria, idEndereco) VALUES
('João da Silva', 1122334455, 44985632511, 'joao@email.com', 'Tutor', 1),
('Maria Souza', 998877665, 98765432122, 'maria@email.com', 'Tutor', 2),
('Carlos Pereira', 987766554, 56789012033, 'carlos@email.com', 'Tutor', 3),
('Pedro Fernandes', 983456789, 23456789044, 'pedro@email.com', 'Funcionario', 4),
('Ana Oliveira', 967890123, 54321098055, 'ana@email.com', 'Funcionario', 5),
('Luis Santos', 987654321, 87654321066, 'luis@email.com', 'Tutor', 6),
('Isabel Lima', 976543210, 34567890077, 'isabel@email.com', 'Funcionario', 7),
('Michelle', 40028922, 87654354066, 'michele@email.com', 'Funcionario', 6);
select * from usuario;

INSERT INTO raca (nome, especie) VALUES 
('Labrador Retriever', 'Cachorro'),
('Siamese', 'Gato'),
('Bulldog', 'Cachorro'),
('Maine Coon', 'Gato'),
('Poodle', 'Cachorro'),
('Dachshund', 'Cachorro');
select * from raca;


INSERT INTO funcao (descricao)VALUES 
('Veterinário'),
('Adestrador'),
('Recepcionista'),
('Cuidador');
select * from funcao;


INSERT INTO funcionario (turno, senha, idFuncao, idUsuario)
VALUES ('1º Turno', 'Coragen123', 1, 4),
('2º Turno', 'Coragen123', 2, 5),
('Administrativo', 'Coragen123', 3, 7),
('Administrativo', 'Coragen123', 4, 8);
select * from funcionario;


INSERT INTO servicos (nome, valor, diasDaSemana, idFuncionario) VALUES
('Treinamento de Comportamento', 55.00, '0,2,4', 1),
('Banho e Tosa', 50.00, '0,1,2,3,4', 4),
('Adestramento', 60.00, '1,3', 2),
('Jogos interativos', 60.00, '3', 1),
('Passeio', 30.00, '0,2,4', 4);
select * from servicos;

INSERT INTO turma (nome) VALUES
("gatinhos fofinhos"),
("cachorros porte grande"),
("cachorros porte pequeno");
select * from turma;

#tutores, 1,2,3,6
INSERT INTO pet (nome, dataNascimento, genero, castrado, historicoDeSaude, idUsuario, idRaca, turma_idTurma) VALUES 
('Rex', '2020-05-15', 'Macho', 1, 'Cachorro Labrador saudável e pronto para entrar na creche.', 1, 1, 2),
('Luna', '2019-08-10', 'Femea', 1, 'Gato Siamese está com todas as vacinas em dia e sem problemas de saúde aparentes.', 1, 2, 1),
('Bobby', '2018-12-01', 'Macho', 1, 'Cachorro Bulldog recebeu exames de rotina recentes e está em boa forma.', 2, 1, 2),
('Cacau', '2020-03-20', 'Femea', 0, 'Gato Maine Coon está castrado e não apresenta problemas de saúde crônicos.', 2, 4, 1),
('Max', '2019-06-05', 'Macho', 1, 'Cachorro Poodle tem um histórico de socialização positivo com outros animais.', 3, 5, 2),
('Rocky', '2020-01-25', 'Macho', 1, 'Cachorro Dachshund tem uma personalidade tranquila e se dá bem com pessoas e outros animais.', 6, 6, 3);
select * from pet;

INSERT INTO vacina (idVacina, nome, dose, idadeMinimaEmMeses,tempoDeEsperaEmDias) VALUES
(111, 'V8', 1, 12, 30),
(112, 'Raiva', 1, 12, 365),
(113, 'Giardia', 2, 6, 30),
(114, 'FIV', 1, 12, 365),
(115, 'FeLV', 2, 6, 30),
(119, 'Calicivírus', 1, 12, 45),
(110, 'Hepatite Canina', 2, 6, 30);
select * from vacina;

INSERT INTO vacinacao (vacina_idVacina, pet_idPet, dataVacinacao)
VALUES (111, 1, "2023-01-02"),
(112, 2,"2023-10-8"),
(113, 3,"2023-08-12"),
(114, 2,"2023-07-03"),
(115, 4,"2023-06-25"),
(111, 5,"2023-02-17"),
(110, 6,"2023-03-20");
select * from vacinacao;

INSERT INTO pagamento (diaVencimento, usuario_idUsuario)VALUES 
(5, 1),
(15, 2),
(10, 3),
(20, 6);
select * from pagamento;

