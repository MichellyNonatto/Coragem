-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema sakila
-- -----------------------------------------------------
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`endereco` (
  `idEndereco` INT NOT NULL AUTO_INCREMENT,
  `cep` INT(10) NOT NULL,
  `estado` CHAR(2) NULL,
  `cidade` VARCHAR(45) NULL,
  `bairro` VARCHAR(45) NOT NULL,
  `rua` VARCHAR(45) NOT NULL,
  `numero` VARCHAR(10) NULL,
  `complemento` VARCHAR(45) NULL,
  PRIMARY KEY (`idEndereco`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`usuario` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `telefone` INT(12) NOT NULL,
  `documento` INT(15) ZEROFILL NOT NULL,
  `email` VARCHAR(45) NULL,
  `senha` VARCHAR(45) NOT NULL,
  `categoria` ENUM("Tutor", "Funcionario") NOT NULL,
  `idEndereco` INT NOT NULL,
  PRIMARY KEY (`idUsuario`),
  INDEX `fk_usuario_endereco1_idx` (`idEndereco` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_endereco1`
    FOREIGN KEY (`idEndereco`)
    REFERENCES `mydb`.`endereco` (`idEndereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`raca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`raca` (
  `idRaca` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `especie` ENUM("Cachorro", "Gato") NOT NULL,
  PRIMARY KEY (`idRaca`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`pet`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pet` (
  `idPet` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `dataNascimento` DATE NOT NULL,
  `genero` ENUM("Macho", "Femea") NOT NULL,
  `castrado` TINYINT NOT NULL,
  `historicoDeSaude` VARCHAR(200) NULL,
  `idUsuario` INT NOT NULL,
  `idRaca` INT NOT NULL,
  PRIMARY KEY (`idPet`),
  INDEX `fk_pet_tutor1_idx` (`idUsuario` ASC) VISIBLE,
  INDEX `fk_pet_raca1_idx` (`idRaca` ASC) VISIBLE,
  CONSTRAINT `fk_pet_tutor1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `mydb`.`usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pet_raca1`
    FOREIGN KEY (`idRaca`)
    REFERENCES `mydb`.`raca` (`idRaca`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pagamento` (
  `idPagamento` INT NOT NULL,
  `diaVencimento` TINYINT NOT NULL,
  PRIMARY KEY (`idPagamento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`funcao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`funcao` (
  `idFuncao` INT NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idFuncao`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`funcionario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`funcionario` (
  `idFuncionario` INT NOT NULL,
  `turno` ENUM("1º Turno", "2º Turno", "Administrativo") NOT NULL,
  `idFuncao` INT NOT NULL,
  `idUsuario` INT NOT NULL,
  PRIMARY KEY (`idFuncionario`),
  INDEX `fk_funcionario_funcao1_idx` (`idFuncao` ASC) VISIBLE,
  INDEX `fk_funcionario_usuario1_idx` (`idUsuario` ASC) VISIBLE,
  CONSTRAINT `fk_funcionario_funcao1`
    FOREIGN KEY (`idFuncao`)
    REFERENCES `mydb`.`funcao` (`idFuncao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_funcionario_usuario1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `mydb`.`usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`servicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`servicos` (
  `idServicos` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  `diasDaSemana` VARCHAR(45) NOT NULL,
  `idFuncionario` INT NOT NULL,
  PRIMARY KEY (`idServicos`),
  INDEX `fk_servicos_funcionario1_idx` (`idFuncionario` ASC) VISIBLE,
  CONSTRAINT `fk_servicos_funcionario1`
    FOREIGN KEY (`idFuncionario`)
    REFERENCES `mydb`.`funcionario` (`idFuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`grade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`grade` (
  `idServicos` INT NOT NULL,
  `idPet` INT NOT NULL,
  PRIMARY KEY (`idServicos`, `idPet`),
  INDEX `fk_servicos_has_pet_pet1_idx` (`idPet` ASC) VISIBLE,
  INDEX `fk_servicos_has_pet_servicos1_idx` (`idServicos` ASC) VISIBLE,
  CONSTRAINT `fk_servicos_has_pet_servicos1`
    FOREIGN KEY (`idServicos`)
    REFERENCES `mydb`.`servicos` (`idServicos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_servicos_has_pet_pet1`
    FOREIGN KEY (`idPet`)
    REFERENCES `mydb`.`pet` (`idPet`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`registroPagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`registroPagamento` (
  `idRegistroPagamento` INT NOT NULL,
  `dataPagamento` DATE NOT NULL,
  `tipo` ENUM("Pix", "Debito", "Credito", "Dinheiro") NULL,
  `idPagamento` INT NOT NULL,
  PRIMARY KEY (`idRegistroPagamento`),
  INDEX `fk_registroPagamento_pagamento1_idx` (`idPagamento` ASC) VISIBLE,
  CONSTRAINT `fk_registroPagamento_pagamento1`
    FOREIGN KEY (`idPagamento`)
    REFERENCES `mydb`.`pagamento` (`idPagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`pagamento_has_servicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pagamento_has_servicos` (
  `idPagamento` INT NOT NULL,
  `idServicos` INT NOT NULL,
  PRIMARY KEY (`idPagamento`, `idServicos`),
  INDEX `fk_pagamento_has_servicos_servicos1_idx` (`idServicos` ASC) VISIBLE,
  INDEX `fk_pagamento_has_servicos_pagamento1_idx` (`idPagamento` ASC) VISIBLE,
  CONSTRAINT `fk_pagamento_has_servicos_pagamento1`
    FOREIGN KEY (`idPagamento`)
    REFERENCES `mydb`.`pagamento` (`idPagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pagamento_has_servicos_servicos1`
    FOREIGN KEY (`idServicos`)
    REFERENCES `mydb`.`servicos` (`idServicos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`vacina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`vacina` (
  `idVacina` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `dose` INT NOT NULL,
  `idadeMinimaEmSemanas` INT NULL,
  `tempoDeEsperaEmDias` INT NOT NULL,
  PRIMARY KEY (`idVacina`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`vacinacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`vacinacao` (
  `idVacinacao` INT NOT NULL,
  `dataVacinacao` DATE NOT NULL,
  `idVacina` INT NOT NULL,
  `idPet` INT NOT NULL,
  PRIMARY KEY (`idVacinacao`),
  INDEX `fk_vacinacao_vacina1_idx` (`idVacina` ASC) VISIBLE,
  INDEX `fk_vacinacao_pet1_idx` (`idPet` ASC) VISIBLE,
  CONSTRAINT `fk_vacinacao_vacina1`
    FOREIGN KEY (`idVacina`)
    REFERENCES `mydb`.`vacina` (`idVacina`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vacinacao_pet1`
    FOREIGN KEY (`idPet`)
    REFERENCES `mydb`.`pet` (`idPet`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;