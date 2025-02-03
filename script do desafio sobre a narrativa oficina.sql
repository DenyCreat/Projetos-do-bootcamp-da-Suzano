-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema Oficina
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Oficina
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Oficina` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `Oficina` ;

-- -----------------------------------------------------
-- Table `Oficina`.`Clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Oficina`.`Clientes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `endereco` VARCHAR(255) NULL DEFAULT NULL,
  `telefone` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id` (`id` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Oficina`.`Mecanicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Oficina`.`Mecanicos` (
  `codigo` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `endereco` VARCHAR(255) NULL DEFAULT NULL,
  `especialidade` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE INDEX `codigo` (`codigo` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Oficina`.`Veiculos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Oficina`.`Veiculos` (
  `placa` VARCHAR(10) NOT NULL,
  `modelo` VARCHAR(100) NOT NULL,
  `ano` INT NULL DEFAULT NULL,
  `id_cliente` INT NULL DEFAULT NULL,
  `Clientes_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`placa`, `Clientes_id`),
  INDEX `fk_Veiculos_Clientes_idx` (`Clientes_id` ASC) VISIBLE,
  CONSTRAINT `fk_Veiculos_Clientes`
    FOREIGN KEY (`Clientes_id`)
    REFERENCES `Oficina`.`Clientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Oficina`.`OrdemServico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Oficina`.`OrdemServico` (
  `numero` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_emissao` DATE NOT NULL,
  `valor_total` DECIMAL(10,2) NULL DEFAULT NULL,
  `status` VARCHAR(50) NULL DEFAULT NULL,
  `data_conclusao` DATE NULL DEFAULT NULL,
  `placa_veiculo` VARCHAR(10) NULL DEFAULT NULL,
  `id_cliente` INT NULL DEFAULT NULL,
  `Veiculos_placa` VARCHAR(10) NOT NULL,
  `Veiculos_Clientes_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`numero`, `Veiculos_placa`, `Veiculos_Clientes_id`),
  UNIQUE INDEX `numero` (`numero` ASC) VISIBLE,
  INDEX `fk_OrdemServico_Veiculos1_idx` (`Veiculos_placa` ASC, `Veiculos_Clientes_id` ASC) VISIBLE,
  CONSTRAINT `fk_OrdemServico_Veiculos1`
    FOREIGN KEY (`Veiculos_placa` , `Veiculos_Clientes_id`)
    REFERENCES `Oficina`.`Veiculos` (`placa` , `Clientes_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Oficina`.`Servicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Oficina`.`Servicos` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(255) NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  `OrdemServico_numero` BIGINT UNSIGNED NOT NULL,
  `OrdemServico_Veiculos_placa` VARCHAR(10) NOT NULL,
  `OrdemServico_Veiculos_Clientes_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `OrdemServico_numero`, `OrdemServico_Veiculos_placa`, `OrdemServico_Veiculos_Clientes_id`),
  UNIQUE INDEX `id` (`id` ASC) VISIBLE,
  INDEX `fk_Servicos_OrdemServico1_idx` (`OrdemServico_numero` ASC, `OrdemServico_Veiculos_placa` ASC, `OrdemServico_Veiculos_Clientes_id` ASC) VISIBLE,
  CONSTRAINT `fk_Servicos_OrdemServico1`
    FOREIGN KEY (`OrdemServico_numero` , `OrdemServico_Veiculos_placa` , `OrdemServico_Veiculos_Clientes_id`)
    REFERENCES `Oficina`.`OrdemServico` (`numero` , `Veiculos_placa` , `Veiculos_Clientes_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Oficina`.`OrdemServico_Mecanicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Oficina`.`OrdemServico_Mecanicos` (
  `numero_os` INT NOT NULL,
  `codigo_mecanico` INT NOT NULL,
  `Servicos_id` BIGINT UNSIGNED NOT NULL,
  `Servicos_OrdemServico_numero` BIGINT UNSIGNED NOT NULL,
  `Servicos_OrdemServico_Veiculos_placa` VARCHAR(10) NOT NULL,
  `Servicos_OrdemServico_Veiculos_Clientes_id` BIGINT UNSIGNED NOT NULL,
  `Mecanicos_codigo` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`numero_os`, `codigo_mecanico`, `Servicos_id`, `Servicos_OrdemServico_numero`, `Servicos_OrdemServico_Veiculos_placa`, `Servicos_OrdemServico_Veiculos_Clientes_id`, `Mecanicos_codigo`),
  UNIQUE INDEX `idx_unique_orc_mec` (`numero_os` ASC, `codigo_mecanico` ASC) VISIBLE,
  INDEX `fk_OrdemServico_Mecanicos_Servicos1_idx` (`Servicos_id` ASC, `Servicos_OrdemServico_numero` ASC, `Servicos_OrdemServico_Veiculos_placa` ASC, `Servicos_OrdemServico_Veiculos_Clientes_id` ASC) VISIBLE,
  INDEX `fk_OrdemServico_Mecanicos_Mecanicos1_idx` (`Mecanicos_codigo` ASC) VISIBLE,
  CONSTRAINT `fk_OrdemServico_Mecanicos_Servicos1`
    FOREIGN KEY (`Servicos_id` , `Servicos_OrdemServico_numero` , `Servicos_OrdemServico_Veiculos_placa` , `Servicos_OrdemServico_Veiculos_Clientes_id`)
    REFERENCES `Oficina`.`Servicos` (`id` , `OrdemServico_numero` , `OrdemServico_Veiculos_placa` , `OrdemServico_Veiculos_Clientes_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OrdemServico_Mecanicos_Mecanicos1`
    FOREIGN KEY (`Mecanicos_codigo`)
    REFERENCES `Oficina`.`Mecanicos` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Oficina`.`Pecas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Oficina`.`Pecas` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(255) NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id` (`id` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Oficina`.`OrdemServico_Pecas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Oficina`.`OrdemServico_Pecas` (
  `numero_os` INT NOT NULL,
  `id_peca` INT NOT NULL,
  `quantidade` INT NOT NULL,
  `Pecas_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`numero_os`, `id_peca`, `Pecas_id`),
  INDEX `fk_OrdemServico_Pecas_Pecas1_idx` (`Pecas_id` ASC) VISIBLE,
  CONSTRAINT `fk_OrdemServico_Pecas_Pecas1`
    FOREIGN KEY (`Pecas_id`)
    REFERENCES `Oficina`.`Pecas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
