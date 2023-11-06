select * from endereco;
select * from funcao;
select * from funcionario;
select * from grade;
select * from historicodesaude;
select * from pagamento;
select * from pagamento_has_servicos;
select * from pet;
select * from raca;
select * from registropagamento;
select * from servicos;
select * from usuario;
select * from vacinacao;
select * from vacina;



INSERT INTO endereco (cep, estado, cidade, bairro, rua, numero, complemento) VALUES 
(12345678, 'SP', 'Bragança Paulista', 'Centro', 'Rua A', '123', 'Apto 1'),
(98765432, 'SP', 'Bragança Paulista', 'Jardim Bela Vista', 'Avenida B', '456', 'Bloco 2'),
(56789012, 'SP', 'Bragança Paulista', 'Vila Esperança', 'Praça C', '789', NULL),
(23456789, 'MG', 'Extrema', 'Centro', 'Rua X', '101', 'Apto 4'),
(54321098, 'MG', 'Extrema', 'Jardim dos Lagos', 'Avenida Y', '55', NULL),
(87654321, 'SP', 'Atibaia', 'Jardim Alvinópolis', 'Rua Z', '250', 'Casa Azul'),
(34567890, 'SP', 'Atibaia', 'Alvinópolis', 'Avenida W', '42', 'Casa Amarela');
select * from endereco;

INSERT INTO usuario (nome, telefone, documento, email, categoria, idEndereco)
VALUES ('João da Silva', 1122334455, 449856325, 'joao@email.com', 'Tutor', 1),
('Maria Souza', 998877665, 987654321, 'maria@email.com', 'Tutor', 2),
('Carlos Pereira', 987766554, 567890120, 'carlos@email.com', 'Tutor', 3),
('Pedro Fernandes', 983456789, 234567890, 'pedro@email.com', 'Funcionario', 4),
('Ana Oliveira', 967890123, 543210980, 'ana@email.com', 'Funcionario', 5),
('Luis Santos', 987654321, 876543210, 'luis@email.com', 'Tutor', 6),
('Isabel Lima', 976543210, 345678900, 'isabel@email.com', 'Funcionario', 7);
select * from usuario;

INSERT INTO raca (idRaca, nome, especie) VALUES 
(31, 'Labrador Retriever', 'Cachorro'),
(32, 'Siamese', 'Gato'),
(33, 'Bulldog', 'Cachorro'),
(34, 'Maine Coon', 'Gato'),
(35, 'Poodle', 'Cachorro'),
(36, 'Dachshund', 'Cachorro');
select * from raca;

INSERT INTO historicoDeSaude (idhistoricoDeSaude,castrado, descricaoMedica)VALUES 
(41, 0, 'Cachorro Labrador saudável e pronto para entrar na creche.'),
(42, 0, 'Gato Siamese está com todas as vacinas em dia e sem problemas de saúde aparentes.'),
(43, 0, 'Cachorro Bulldog recebeu exames de rotina recentes e está em boa forma.'),
(44, 0, 'Gato Maine Coon está castrado e não apresenta problemas de saúde crônicos.'),
(45, 0, 'Cachorro Poodle tem um histórico de socialização positivo com outros animais.'),
(46, 0, 'Cachorro Dachshund tem uma personalidade tranquila e se dá bem com pessoas e outros animais.');
select * from historicoDeSaud

#tutores, 1,2,3,6
INSERT INTO pet (idPet, nome, dataNascimento, genero, idade, castrado, idUsuario, idRaca, idhistoricoDeSaude) VALUES 
(51, 'Rex', '2020-05-15', 'Macho', 3, 'Sim', 1, 31, 41),
(52, 'Luna', '2019-08-10', 'Femea', 4, 'Sim', 1, 32, 42),
(53, 'Bobby', '2018-12-01', 'Macho', 5, 'Sim', 2, 33, 43),
(54, 'Cacau', '2020-03-20', 'Femea', 3, 'Sim', 2, 34, 44),
(55, 'Max', '2019-06-05', 'Macho', 2, 'Sim', 3, 35, 45),
(56, 'Rocky', '2020-01-25', 'Macho', 3, 'Sim', 6, 36, 46);
select * from pet;

#pagamento é só o dia, ou manter em AAAA-MM-DD?
INSERT INTO pagamento (idPagamento, diaVencimento)VALUES 
(61, 5),
(62, 15),
(63, 10),
(64, 20),
(65, 25),
(66, 1),
(67, 30);
select * from pagamento;

INSERT INTO funcao (idFuncao, descricao)VALUES 
(21, 'Veterinário'),
(22, 'Adestrador'),
(23, 'Recepcionista');
select * from funcao;


INSERT INTO funcionario (idFuncionario, turno, idFuncao, idUsuario)
VALUES (71, '1º Turno', 21, 4),
(72, '2º Turno', 22, 5),
(73, 'Administrativo', 23, 7);
select * from funcionario;


INSERT INTO servicos (idServicos, nome, valor, idFuncionario)
VALUES (81, 'Treinamento de Comportamento', 55.00, 72),
(82, 'Consulta de Emergência', 75.00, 71),
(83, 'Banho e Tosa', 50.00, 71),
(84, 'Adestramento Individual', 60.00, 72),
(85, 'Agendamento taxiPet - buscar', 15.00, 73),
(86, 'Agendamento taxiPet - levar', 15.00, 73);
select * from servicos;


INSERT INTO registroPagamento (idRegistroPagamento, dataPagamento, tipo, idPagamento)
VALUES (101, '2023-10-05', 'Pix', 61),
(102, '2023-10-15', 'Debito', 62),
(103, '2023-09-10', 'Credito', 63),
(104, '2023-09-20', 'Dinheiro', 64),
(105, '2023-10-25', 'Pix', 65),
(106, '2023-09-01', 'Debito', 66),
(107, '2023-10-30', 'Credito', 67);
select * from registroPagamento;


INSERT INTO pagamento_has_servicos (idPagamento, idServicos)
VALUES (61, 81),
(62, 82),
(63, 83),
(64, 84),
(65, 85),
(66, 86),
(67, 81);
select * from pagamento_has_servicos;


INSERT INTO vacina (idVacina, nome, dose, idadeMinimaEmMeses,tempoDeEsperaEmDias)
VALUES (111, 'V8', 1, 12, 30),
(112, 'Raiva', 1, 12, 365),
(113, 'Giardia', 2, 6, 30),
(114, 'FIV', 1, 12, 365),
(115, 'FeLV', 2, 6, 30),
(119, 'Calicivírus', 1, 12, 45),
(110, 'Hepatite Canina', 2, 6, 30);
select * from vacina;


INSERT INTO vacinacao (vacina_idVacina, historicoDeSaude_idhistoricoDeSaude, dataVacinacao)
VALUES (111, 41, "2023-01-02"),
(112, 43,"2023-10-8"),
(113, 46,"2023-08-12"),
(114, 42,"2023-07-03"),
(115, 44,"2023-06-25"),
(111, 45,"2023-02-17"),
(110, 41,"2023-03-20");
select * from vacinacao;

