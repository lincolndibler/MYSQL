-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema PizzaShop
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema PizzaShop
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `PizzaShop` DEFAULT CHARACTER SET utf8mb3 ;
USE `PizzaShop` ;

-- -----------------------------------------------------
-- Table `PizzaShop`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PizzaShop`.`address` (
  `add_id` INT NOT NULL,
  `delivery_address1` VARCHAR(200) NULL DEFAULT NULL,
  `delivery_address2` VARCHAR(200) NULL DEFAULT NULL,
  `delivery_city` VARCHAR(45) NULL DEFAULT NULL,
  `delivery_zipcode` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`add_id`),
  UNIQUE INDEX `add_id_UNIQUE` (`add_id` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PizzaShop`.`ingredient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PizzaShop`.`ingredient` (
  `ing_id` INT NOT NULL,
  `ing_name` VARCHAR(200) NULL DEFAULT NULL,
  `ing_weight` INT NULL DEFAULT NULL,
  `ing_meas` VARCHAR(20) NULL DEFAULT NULL,
  `ing_price` DECIMAL(5,2) NULL DEFAULT NULL,
  PRIMARY KEY (`ing_id`),
  UNIQUE INDEX `ing_id_UNIQUE` (`ing_id` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PizzaShop`.`recipe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PizzaShop`.`recipe` (
  `row_id` INT NOT NULL,
  `recipe_id` VARCHAR(45) NULL DEFAULT NULL,
  `ing_id` VARCHAR(45) NULL DEFAULT NULL,
  `quantity` INT NULL DEFAULT NULL,
  `ingredient_ing_id` INT NOT NULL,
  PRIMARY KEY (`row_id`, `ingredient_ing_id`),
  INDEX `fk_recipe_ingredient1_idx` (`ingredient_ing_id` ASC) VISIBLE,
  CONSTRAINT `fk_recipe_ingredient1`
    FOREIGN KEY (`ingredient_ing_id`)
    REFERENCES `PizzaShop`.`ingredient` (`ing_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PizzaShop`.`item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PizzaShop`.`item` (
  `item_id` INT NOT NULL,
  `sku` VARCHAR(45) NULL DEFAULT NULL,
  `item_name` VARCHAR(100) NULL DEFAULT NULL,
  `item_cat` VARCHAR(100) NULL DEFAULT NULL,
  `item_size` VARCHAR(45) NULL DEFAULT NULL,
  `item_price` DECIMAL(10,2) NULL DEFAULT NULL,
  `recipe_row_id` INT NOT NULL,
  PRIMARY KEY (`item_id`, `recipe_row_id`),
  UNIQUE INDEX `item_id_UNIQUE` (`item_id` ASC) VISIBLE,
  INDEX `fk_item_recipe1_idx` (`recipe_row_id` ASC) VISIBLE,
  CONSTRAINT `fk_item_recipe1`
    FOREIGN KEY (`recipe_row_id`)
    REFERENCES `PizzaShop`.`recipe` (`row_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PizzaShop`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PizzaShop`.`orders` (
  `row_id` INT NOT NULL,
  `order_id` VARCHAR(45) NOT NULL,
  `created_at` DATETIME NOT NULL,
  `item_id` VARCHAR(45) NOT NULL,
  `quantity` INT NULL DEFAULT NULL,
  `delivery` TINYINT NULL DEFAULT NULL,
  `add_id` INT NULL DEFAULT NULL,
  `item_item_id` INT NOT NULL,
  PRIMARY KEY (`row_id`, `item_item_id`),
  UNIQUE INDEX `row_id_UNIQUE` (`row_id` ASC) VISIBLE,
  INDEX `fk_orders_item1_idx` (`item_item_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_item1`
    FOREIGN KEY (`item_item_id`)
    REFERENCES `PizzaShop`.`item` (`item_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PizzaShop`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PizzaShop`.`customers` (
  `cust_id` INT NOT NULL,
  `cust_fname` VARCHAR(45) NOT NULL,
  `cust_lname` VARCHAR(45) NOT NULL,
  `orders_row_id` INT NOT NULL,
  `address_add_id` INT NOT NULL,
  PRIMARY KEY (`cust_id`, `orders_row_id`, `address_add_id`),
  UNIQUE INDEX `cust_id_UNIQUE` (`cust_id` ASC) VISIBLE,
  INDEX `fk_customers_orders_idx` (`orders_row_id` ASC) VISIBLE,
  INDEX `fk_customers_address1_idx` (`address_add_id` ASC) VISIBLE,
  CONSTRAINT `fk_customers_address1`
    FOREIGN KEY (`address_add_id`)
    REFERENCES `PizzaShop`.`address` (`add_id`),
  CONSTRAINT `fk_customers_orders`
    FOREIGN KEY (`orders_row_id`)
    REFERENCES `PizzaShop`.`orders` (`row_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PizzaShop`.`inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PizzaShop`.`inventory` (
  `inv_id` INT NOT NULL,
  `item_id` VARCHAR(45) NULL DEFAULT NULL,
  `quantity` INT NULL DEFAULT NULL,
  `recipe_row_id` INT NOT NULL,
  `recipe_ingredient_ing_id` INT NOT NULL,
  PRIMARY KEY (`inv_id`, `recipe_row_id`, `recipe_ingredient_ing_id`),
  UNIQUE INDEX `inv_id_UNIQUE` (`inv_id` ASC) VISIBLE,
  INDEX `fk_inventory_recipe1_idx` (`recipe_row_id` ASC, `recipe_ingredient_ing_id` ASC) VISIBLE,
  CONSTRAINT `fk_inventory_recipe1`
    FOREIGN KEY (`recipe_row_id` , `recipe_ingredient_ing_id`)
    REFERENCES `PizzaShop`.`recipe` (`row_id` , `ingredient_ing_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
