-- MySQL Script generated by MySQL Workbench
-- 04/27/15 14:53:06
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema jobsDB
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `jobsDB` ;

-- -----------------------------------------------------
-- Schema jobsDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `jobsDB` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `jobsDB` ;

-- -----------------------------------------------------
-- Table `jobsDB`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jobsDB`.`users` ;

CREATE TABLE IF NOT EXISTS `jobsDB`.`users` (
  `towson_id` VARCHAR(50) NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`towson_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `jobsDB`.`class`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jobsDB`.`class` ;

CREATE TABLE IF NOT EXISTS `jobsDB`.`class` (
  `class_id` INT NOT NULL AUTO_INCREMENT,
  `class_name` VARCHAR(10) NOT NULL,
  `class_section` VARCHAR(25) NOT NULL,
  `professor` VARCHAR(45) NOT NULL,
  `current` TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (`class_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `jobsDB`.`printer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jobsDB`.`printer` ;

CREATE TABLE IF NOT EXISTS `jobsDB`.`printer` (
  `printer_name` VARCHAR(30) NOT NULL,
  `current` TINYINT(1) NOT NULL DEFAULT 1,
  `student_submission` TINYINT(1) NOT NULL,
  `total_run_time` INT NULL DEFAULT 0,
  PRIMARY KEY (`printer_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `jobsDB`.`printer_build`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jobsDB`.`printer_build` ;

CREATE TABLE IF NOT EXISTS `jobsDB`.`printer_build` (
  `build_name` VARCHAR(150) NOT NULL,
  `date_created` DATETIME NOT NULL,
  `total_runtime_seconds` INT UNSIGNED NULL,
  `number_of_models` INT UNSIGNED NULL,
  `printer_name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`build_name`),
  INDEX `fk_printer_build_printer1_idx` (`printer_name` ASC),
  CONSTRAINT `fk_printer_build_printer1`
    FOREIGN KEY (`printer_name`)
    REFERENCES `jobsDB`.`printer` (`printer_name`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `jobsDB`.`job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jobsDB`.`job` ;

CREATE TABLE IF NOT EXISTS `jobsDB`.`job` (
  `job_id` INT NOT NULL AUTO_INCREMENT,
  `file_name` VARCHAR(150) CHARACTER SET 'latin2' COLLATE 'latin2_general_ci' NULL,
  `file_path` VARCHAR(500) NULL,
  `class_id` INT NULL,
  `student_id` VARCHAR(50) NULL,
  `printer_name` VARCHAR(45) NOT NULL,
  `submission_date` DATETIME NOT NULL,
  `status` VARCHAR(10) NOT NULL,
  `volume` DECIMAL(8,3) NULL,
  `comment` VARCHAR(300) NULL,
  `build_name` VARCHAR(150) NULL,
  INDEX `fk_completedJobs_users1_idx` (`student_id` ASC),
  INDEX `fk_completedJobs_classes1_idx` (`class_id` ASC),
  INDEX `fk_ref_to_printer_idx` (`printer_name` ASC),
  INDEX `fk_job_printer_build1_idx` (`build_name` ASC),
  PRIMARY KEY (`job_id`),
  CONSTRAINT `fk_completedJobs_users1`
    FOREIGN KEY (`student_id`)
    REFERENCES `jobsDB`.`users` (`towson_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_completedJobs_classes1`
    FOREIGN KEY (`class_id`)
    REFERENCES `jobsDB`.`class` (`class_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ref_to_printer`
    FOREIGN KEY (`printer_name`)
    REFERENCES `jobsDB`.`printer` (`printer_name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_job_printer_build1`
    FOREIGN KEY (`build_name`)
    REFERENCES `jobsDB`.`printer_build` (`build_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `jobsDB`.`admin`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jobsDB`.`admin` ;

CREATE TABLE IF NOT EXISTS `jobsDB`.`admin` (
  `user_id` VARCHAR(50) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `date_created` DATETIME NOT NULL,
  `pass` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_admin_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `jobsDB`.`users` (`towson_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `jobsDB`.`custom_printer_column_names`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jobsDB`.`custom_printer_column_names` ;

CREATE TABLE IF NOT EXISTS `jobsDB`.`custom_printer_column_names` (
  `column_names_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `printer_name` VARCHAR(30) NOT NULL,
  `custom_field_name` VARCHAR(25) NOT NULL,
  `numerical` TINYINT(1) NULL,
  PRIMARY KEY (`column_names_id`),
  INDEX `fk_printer_name_idx` (`printer_name` ASC),
  CONSTRAINT `fk_printer_name`
    FOREIGN KEY (`printer_name`)
    REFERENCES `jobsDB`.`printer` (`printer_name`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `jobsDB`.`column_build_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jobsDB`.`column_build_data` ;

CREATE TABLE IF NOT EXISTS `jobsDB`.`column_build_data` (
  `build_name` VARCHAR(150) NOT NULL,
  `column_name_id` INT UNSIGNED NOT NULL,
  `column_field_data` VARCHAR(30) NOT NULL,
  INDEX `fk_column_name_reference_idx` (`column_name_id` ASC),
  PRIMARY KEY (`build_name`, `column_name_id`),
  INDEX `fk_column_build_data_printer_build1_idx` (`build_name` ASC),
  CONSTRAINT `fk_column_name_reference`
    FOREIGN KEY (`column_name_id`)
    REFERENCES `jobsDB`.`custom_printer_column_names` (`column_names_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_column_build_data_printer_build1`
    FOREIGN KEY (`build_name`)
    REFERENCES `jobsDB`.`printer_build` (`build_name`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `jobsDB`.`accepted_files`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jobsDB`.`accepted_files` ;

CREATE TABLE IF NOT EXISTS `jobsDB`.`accepted_files` (
  `file_extension` VARCHAR(10) NOT NULL,
  `printer_name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`file_extension`, `printer_name`),
  INDEX `fk_accepted_files_printer1_idx` (`printer_name` ASC),
  CONSTRAINT `fk_accepted_files_printer1`
    FOREIGN KEY (`printer_name`)
    REFERENCES `jobsDB`.`printer` (`printer_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `jobsDB` ;

-- -----------------------------------------------------
-- procedure report
-- -----------------------------------------------------

USE `jobsDB`;
DROP procedure IF EXISTS `jobsDB`.`report`;

DELIMITER $$
USE `jobsDB`$$
CREATE PROCEDURE report
(IN printOFBuilds CHAR(30))
BEGIN
  SET @sql = NULL;
  set @printer = null;
set @printer = printOfBuilds;
SELECT
  GROUP_CONCAT(DISTINCT
    CONCAT(
      'GROUP_CONCAT(case when custom_field_name = ''',
      custom_field_name,
      ''' then column_field_data end) AS ',
      replace(custom_field_name, ' ', '')
    )
  ) INTO @sql
from custom_printer_column_names WHERE printer_name= @printer;

SET @sql = CONCAT('SELECT pb.build_name, ', @sql, ' from printer_build pb
left join column_build_data s
  on pb.build_name = s.build_name
left join custom_printer_column_names pd
  on s.column_name_id = pd.column_names_id WHERE pb.printer_name= @printer
group by pb.build_name');

PREPARE stmt FROM @sql ;

EXECUTE stmt;
DEALLOCATE PREPARE stmt;
END 

$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure reportFiltered
-- -----------------------------------------------------

USE `jobsDB`;
DROP procedure IF EXISTS `jobsDB`.`reportFiltered`;

DELIMITER $$
USE `jobsDB`$$
CREATE PROCEDURE reportFiltered
(IN printOFBuilds CHAR(30), columnToFilter char(100), valueToFilter char(100))
BEGIN
  SET @sql = NULL;
  set @printer = null;
  set @printer = printOfBuilds;
  set @columnF = null;
  set @columnF = columnToFilter;
  set @valueF = null;
  set @valueF = valueToFilter;
SELECT
  GROUP_CONCAT(DISTINCT
    CONCAT(
      'GROUP_CONCAT(case when custom_field_name = ''',
      custom_field_name,
      ''' then column_field_data end) AS ',
      replace(custom_field_name, ' ', '')
    )
  ) INTO @sql
from custom_printer_column_names WHERE printer_name= @printer;

SET @sql = CONCAT('SELECT pb.build_name, ', @sql, ' from printer_build pb
left join column_build_data s
  on pb.build_name = s.build_name
left join custom_printer_column_names pd
  on s.column_name_id = pd.column_names_id WHERE pb.printer_name = @printer AND @columnF = @valueF
group by pb.build_name');

PREPARE stmt FROM @sql ;

EXECUTE stmt;
DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure clearTables
-- -----------------------------------------------------

USE `jobsDB`;
DROP procedure IF EXISTS `jobsDB`.`clearTables`;

DELIMITER $$
USE `jobsDB`$$
CREATE PROCEDURE `clearTables` ()
BEGIN
delete from  printer_build;
delete from job;
END
$$

DELIMITER ;

USE `jobsdb`;
DROP procedure IF EXISTS `enterBuildData`;

DELIMITER $$
USE `jobsdb`$$
CREATE PROCEDURE `enterBuildData` (In printerName varchar(30), columnfieldname varchar(25), dataToEnter varchar(30), buildName varchar(150))
BEGIN
SET @x = null;
SET @cfn = null;
SET @cfn = columnfieldname;
SET @pn = null;
SET @pn = printerName;
SET @bn = null;
SET @bn = buildName;
SET @dataToEnter = null;
SET @dataToEnter = dataToEnter;

SELECT 
	#Assignes x to the value of the column_name_id from the select statement 
    column_names_id INTO @x 
FROM
    custom_printer_column_names
WHERE
    custom_field_name = @cfn
        AND printer_name = @pn;

Insert INTO column_build_data (build_name, column_name_id, column_field_data) values(@bn, @x, @dataToEnter);

END
$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
