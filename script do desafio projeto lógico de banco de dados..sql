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
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`cliente` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(50) NOT NULL,
  `tipo` ENUM('Físico', 'Jurídico') NOT NULL,
  `endereco` VARCHAR(100) NOT NULL,
  `indentificacao` INT NOT NULL,
  PRIMARY KEY (`id_cliente`));


-- -----------------------------------------------------
-- Table `mydb`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pedido` (
  `id_pedido` INT NOT NULL,
  `statusPedido` VARCHAR(40) NULL,
  `data_do_pedido` DATE NOT NULL,
  `data_estimada_da_entrega` DATE NULL,
  `descricao` VARCHAR(60) NULL,
  `valor_frete` FLOAT NOT NULL,
  `cliente_id_cliente` INT NOT NULL,
  PRIMARY KEY (`id_pedido`, `cliente_id_cliente`),
  INDEX `fk_pedido_cliente_idx` (`cliente_id_cliente` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_cliente`
    FOREIGN KEY (`cliente_id_cliente`)
    REFERENCES `mydb`.`cliente` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Transportadora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Transportadora` (
  `id_transportadora` INT NOT NULL,
  `nome_da_transportadora` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id_transportadora`));


-- -----------------------------------------------------
-- Table `mydb`.`Entrega`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Entrega` (
  `id_da_entrega` INT NOT NULL,
  `data_estimada` DATE NOT NULL,
  `tipo_da_entrega` VARCHAR(20) NOT NULL,
  `código_de_rastreio` VARCHAR(20) NOT NULL,
  `Transportadora_id_transportadora` INT NOT NULL,
  PRIMARY KEY (`id_da_entrega`, `Transportadora_id_transportadora`),
  INDEX `fk_Entrega_Transportadora1_idx` (`Transportadora_id_transportadora` ASC) VISIBLE,
  CONSTRAINT `fk_Entrega_Transportadora1`
    FOREIGN KEY (`Transportadora_id_transportadora`)
    REFERENCES `mydb`.`Transportadora` (`id_transportadora`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`interface  Pedido-Entrega`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`interface  Pedido-Entrega` (
  `status_da_entrega` VARCHAR(60) NULL,
  `data_da_prev_entrega` VARCHAR(255) NULL,
  `pedido_id_pedido` INT NOT NULL,
  `pedido_cliente_id_cliente` INT NOT NULL,
  `Entrega_id_da_entrega` INT NOT NULL,
  `Entrega_Transportadora_id_transportadora` INT NOT NULL,
  PRIMARY KEY (`pedido_id_pedido`, `pedido_cliente_id_cliente`, `Entrega_id_da_entrega`, `Entrega_Transportadora_id_transportadora`),
  INDEX `fk_interface  Pedido-Entrega_Entrega1_idx` (`Entrega_id_da_entrega` ASC, `Entrega_Transportadora_id_transportadora` ASC) VISIBLE,
  CONSTRAINT `fk_interface  Pedido-Entrega_pedido1`
    FOREIGN KEY (`pedido_id_pedido` , `pedido_cliente_id_cliente`)
    REFERENCES `mydb`.`pedido` (`id_pedido` , `cliente_id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_interface  Pedido-Entrega_Entrega1`
    FOREIGN KEY (`Entrega_id_da_entrega` , `Entrega_Transportadora_id_transportadora`)
    REFERENCES `mydb`.`Entrega` (`id_da_entrega` , `Transportadora_id_transportadora`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Fornecedor` (
  `id_do_fornecedor` INT NOT NULL,
  `razao_social` VARCHAR(100) NOT NULL,
  `cnpj` INT NOT NULL,
  PRIMARY KEY (`id_do_fornecedor`));


-- -----------------------------------------------------
-- Table `mydb`.`Produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Produto` (
  `id_do_produto` INT NOT NULL,
  `categoria` VARCHAR(25) NOT NULL,
  `descricao` VARCHAR(150) NULL,
  `Valor` FLOAT NOT NULL,
  PRIMARY KEY (`id_do_produto`));


-- -----------------------------------------------------
-- Table `mydb`.`Pedido do produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Pedido do produto` (
  `quantidade` INT NOT NULL,
  `pedido_id_pedido` INT NOT NULL,
  `Produto_id_do_produto` INT NOT NULL,
  PRIMARY KEY (`pedido_id_pedido`, `Produto_id_do_produto`),
  INDEX `fk_Pedido do produto_Produto1_idx` (`Produto_id_do_produto` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido do produto_pedido1`
    FOREIGN KEY (`pedido_id_pedido`)
    REFERENCES `mydb`.`pedido` (`id_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido do produto_Produto1`
    FOREIGN KEY (`Produto_id_do_produto`)
    REFERENCES `mydb`.`Produto` (`id_do_produto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Pagamento` (
  `ide_pagamento` INT NOT NULL,
  `tipo_de_pagamento` VARCHAR(15) NOT NULL,
  `data_do_vencimento` DATE NOT NULL,
  `quantidade_de_parcelas` INT NOT NULL,
  `numero_do_cartão` VARCHAR(30) NULL,
  `cvv` INT(3) NULL,
  `status_do_pagamento` VARCHAR(20) NOT NULL,
  `Pedido do produto_pedido_id_pedido` INT NOT NULL,
  `Pedido do produto_Produto_id_do_produto` INT NOT NULL,
  PRIMARY KEY (`ide_pagamento`, `Pedido do produto_pedido_id_pedido`, `Pedido do produto_Produto_id_do_produto`),
  INDEX `fk_Pagamento_Pedido do produto1_idx` (`Pedido do produto_pedido_id_pedido` ASC, `Pedido do produto_Produto_id_do_produto` ASC) VISIBLE,
  CONSTRAINT `fk_Pagamento_Pedido do produto1`
    FOREIGN KEY (`Pedido do produto_pedido_id_pedido` , `Pedido do produto_Produto_id_do_produto`)
    REFERENCES `mydb`.`Pedido do produto` (`pedido_id_pedido` , `Produto_id_do_produto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Disponbilização_do_produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Disponbilização_do_produto` (
  `Produto_id_do_produto` INT NOT NULL,
  `Fornecedor_id_do_fornecedor` INT NOT NULL,
  PRIMARY KEY (`Produto_id_do_produto`, `Fornecedor_id_do_fornecedor`),
  INDEX `fk_Disponbilização_do_produto_Fornecedor1_idx` (`Fornecedor_id_do_fornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_Disponbilização_do_produto_Produto1`
    FOREIGN KEY (`Produto_id_do_produto`)
    REFERENCES `mydb`.`Produto` (`id_do_produto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Disponbilização_do_produto_Fornecedor1`
    FOREIGN KEY (`Fornecedor_id_do_fornecedor`)
    REFERENCES `mydb`.`Fornecedor` (`id_do_fornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Estoque` (
  `id_do_estoque` INT NOT NULL,
  `local` VARCHAR(40) NOT NULL,
  `Produto_id_do_produto` INT NOT NULL,
  PRIMARY KEY (`id_do_estoque`, `Produto_id_do_produto`),
  INDEX `fk_Estoque_Produto1_idx` (`Produto_id_do_produto` ASC) VISIBLE,
  CONSTRAINT `fk_Estoque_Produto1`
    FOREIGN KEY (`Produto_id_do_produto`)
    REFERENCES `mydb`.`Produto` (`id_do_produto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`vendedor_terceiro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`vendedor_terceiro` (
  `id_do_vendedor` INT NOT NULL,
  `razao_social` VARCHAR(100) NOT NULL,
  `local` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_do_vendedor`));


-- -----------------------------------------------------
-- Table `mydb`.`produto_do_vend_terceiro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`produto_do_vend_terceiro` (
  `quantidade` INT NOT NULL,
  `Produto_id_do_produto` INT NOT NULL,
  `vendedor_terceiro_id_do_vendedor` INT NOT NULL,
  PRIMARY KEY (`Produto_id_do_produto`, `vendedor_terceiro_id_do_vendedor`),
  INDEX `fk_produto_do_vend_terceiro_vendedor_terceiro1_idx` (`vendedor_terceiro_id_do_vendedor` ASC) VISIBLE,
  CONSTRAINT `fk_produto_do_vend_terceiro_Produto1`
    FOREIGN KEY (`Produto_id_do_produto`)
    REFERENCES `mydb`.`Produto` (`id_do_produto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_produto_do_vend_terceiro_vendedor_terceiro1`
    FOREIGN KEY (`vendedor_terceiro_id_do_vendedor`)
    REFERENCES `mydb`.`vendedor_terceiro` (`id_do_vendedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
