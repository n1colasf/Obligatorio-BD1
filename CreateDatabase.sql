-- EN CASO DE QUE EXISTA LA BASE, LA ELIMINAMOS
----------------------------------------------------------------------------
USE master;
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name='XXXPRUEBAOBLIGATORIO2BD1')
	DROP DATABASE XXXPRUEBAOBLIGATORIO2BD1;
GO
-- CREACION DE LAS BASE DE DATOS PRUEBA
-----------------------------------------------------------
CREATE DATABASE XXXPRUEBAOBLIGATORIO2BD1;
GO
USE XXXPRUEBAOBLIGATORIO2BD1;
GO
-----------------------------------------------------------
-- CREACION DE TABLAS
-----------------------------------------------------------
IF OBJECT_ID('LABORATORIOS_TELEFONOS') IS NOT NULL  
DROP TABLE LABORATORIOS_TELEFONOS;

IF OBJECT_ID('PACIENTES_PRIMERDOSIS') IS NOT NULL  
DROP TABLE PACIENTES_PRIMERADOSIS; 

IF OBJECT_ID('PACIENTES_SEGUNDADOSIS') IS NOT NULL  
DROP TABLE PACIENTES_SEGUNDADOSIS; 

IF OBJECT_ID('VACUNAS_PRODUCEN_SINTOMAS') IS NOT NULL  
DROP TABLE VACUNAS_PRODUCEN_SINTOMAS;

IF OBJECT_ID('SINTOMAS') IS NOT NULL  
DROP TABLE SINTOMAS

IF OBJECT_ID('PERSONAS_TELEFONOS') IS NOT NULL  
DROP TABLE PERSONAS_TELEFONOS;

IF OBJECT_ID('PACIENTES') IS NOT NULL  
DROP TABLE PACIENTES;

IF OBJECT_ID('PERSONAL_ESPECIALIDADES') IS NOT NULL  
DROP TABLE PERSONAL_ESPECIALIDADES;

IF OBJECT_ID('PERSONAL_SALUD') IS NOT NULL  
DROP TABLE PERSONAL_SALUD;

IF OBJECT_ID('CENTROS_SUMINISTRAN_VACUNAS') IS NOT NULL  
DROP TABLE CENTROS_SUMINISTRAN_VACUNAS;

IF OBJECT_ID('PACIENTES_SEAGENDAN') IS NOT NULL  
DROP TABLE PACIENTES_SEAGENDAN;

IF OBJECT_ID('PERSONAS') IS NOT NULL  
DROP TABLE PERSONAS;

IF OBJECT_ID('GRUPOS_VACUNACION') IS NOT NULL  
DROP TABLE GRUPOS_VACUNACION;

IF OBJECT_ID('VACUNAS') IS NOT NULL  
DROP TABLE VACUNAS;

IF OBJECT_ID('CENTROS') IS NOT NULL  
DROP TABLE CENTROS;

IF OBJECT_ID('LABORATORIOS') IS NOT NULL  
DROP TABLE LABORATORIOS;

IF OBJECT_ID('CIUDADES') IS NOT NULL  
DROP TABLE CIUDADES;

IF OBJECT_ID('PAISES') IS NOT NULL  
DROP TABLE PAISES;

-----------------------------------------------------------
CREATE TABLE PAISES(
	codigo_pais int not null,
	nombre_pais VARCHAR(50) NOT NULL,
	CONSTRAINT PAISES_PK PRIMARY KEY (codigo_pais)
);

CREATE TABLE CIUDADES( 
	codigo_ciudad INT NOT NULL,
	nombre_ciudad VARCHAR(50) NOT NULL,
	codigo_pais int not null 
	CONSTRAINT CIUDADES_PK PRIMARY KEY (codigo_ciudad)
	CONSTRAINT CIUDADES_PAISES_FK FOREIGN KEY (codigo_pais) REFERENCES PAISES(codigo_pais)
);

-------------------------------------------------------------
CREATE TABLE CENTROS( 
	codigo_centro INT NOT NULL,
	nombre_centro VARCHAR (50) NOT NULL,
	capacidad_centro INT NOT NULL,
	codigo_ciudad INT NOT NULL,
	calle VARCHAR (50) NOT NULL,
	numero INT NOT NULL,
	codigopostal INT NOT NULL,
	CONSTRAINT CENTRO_PK PRIMARY KEY (codigo_centro),
	CONSTRAINT CENTRO_CIUDADES_FK FOREIGN KEY(codigo_ciudad) REFERENCES CIUDADES(codigo_ciudad)
);

CREATE TABLE LABORATORIOS(
	nombre_laboratorio VARCHAR (50) NOT NULL,
	paisorigen INT NOT NULL,
	CONSTRAINT LABORATORIO_PK PRIMARY KEY (nombre_laboratorio),
	CONSTRAINT LABORATORIO_PAISORIGEN_FK FOREIGN KEY (paisorigen) REFERENCES PAISES(codigo_pais),
);

CREATE TABLE LABORATORIOS_TELEFONOS(
	nombre_laboratorio VARCHAR (50) NOT NULL, 
	telefono_laboratorio INT NOT NULL,
	CONSTRAINT LABORATORIO_TELEFONOS_PK PRIMARY KEY (nombre_laboratorio,telefono_laboratorio),
	CONSTRAINT LABORATORIO_TELEFONO_FK FOREIGN KEY (nombre_laboratorio) REFERENCES LABORATORIOS,
);

CREATE  TABLE VACUNAS(
	nombre_vacuna VARCHAR(50) NOT NULL, 
	cantdosis_vacuna INT NOT NULL,
	paisorigen_vacuna INT NOT NULL,
	tempConservacion_vacuna INT NOT NULL, 
	porcefectividad_vacuna	INT NOT NULL, 
	nombre_laboratorio_vacuna VARCHAR(50) NOT NULL,
	CONSTRAINT VACUNAS_PK PRIMARY KEY (nombre_vacuna),
	CONSTRAINT VACUNAS_LABORATORIO_FK_ FOREIGN KEY (nombre_laboratorio_vacuna) REFERENCES LABORATORIOS(nombre_laboratorio),
	CONSTRAINT VACUNAS_PAISORIGEN_FK FOREIGN KEY(paisorigen_vacuna) REFERENCES PAISES(codigo_pais) 
);

CREATE TABLE SINTOMAS(
	id_sintoma	INT NOT NULL, 
	descripcion_sintoma VARCHAR(50) NOT NULL, 
	riesgomuerte CHAR(1) CHECK (riesgomuerte IN ('S','N')),
	CONSTRAINT SINTOMAS_PK PRIMARY KEY (id_sintoma)
);

CREATE TABLE VACUNAS_PRODUCEN_SINTOMAS(
	nombre_vacuna VARCHAR(50) NOT NULL, 
	id_sintoma	INT NOT NULL, 
	CONSTRAINT VACUNAS_PRODUCEN_SINTOMAS_PK PRIMARY KEY(nombre_vacuna,id_sintoma),
	CONSTRAINT VACUNAS_PRODUCEN_SINTOMAS_VACUNAS_FK FOREIGN KEY(nombre_vacuna) REFERENCES VACUNAS,
	CONSTRAINT VACUNAS_PRODUCEN_SINTOMAS_SINTOMAS_FK FOREIGN KEY(id_sintoma) REFERENCES SINTOMAS,
);

CREATE TABLE GRUPOS_VACUNACION(
	codigo_grupo INT NOT NULL, 
	descripcion VARCHAR(50) NOT NULL, 
	nombre_vacuna VARCHAR(50) NOT NULL, 
	CONSTRAINT GRUPOS_VACUNACION_PK PRIMARY KEY (codigo_grupo),
	CONSTRAINT GRUPOS_VACUNACION_VACUNAS_FK FOREIGN KEY(nombre_vacuna) REFERENCES VACUNAS,
);

CREATE TABLE PERSONAS(
	cedula_persona INT NOT NULL , 
	nombre_persona VARCHAR(50) NOT NULL, 
	apellido_persona VARCHAR(50) NOT NULL, 
	calle VARCHAR (50) NOT NULL,
	numero INT NOT NULL,
	codigopostal INT NOT NULL,
	FchNacimiento DATE, 
	codigo_ciudad INT NOT NULL,
	codigo_grupo INT NOT NULL, 
	CONSTRAINT PERSONAS_PK PRIMARY KEY (cedula_persona),
	CONSTRAINT PERSONAS_CIUDAD_FK FOREIGN KEY (codigo_ciudad) REFERENCES CIUDADES,
	CONSTRAINT PERSONAS_GRUPO_FK FOREIGN KEY (codigo_grupo) REFERENCES GRUPOS_VACUNACION,
);

CREATE TABLE PERSONAS_TELEFONOS(
	cedula_persona INT NOT NULL , 
	telefono VARCHAR (20) NOT NULL,
	CONSTRAINT PERSONAS_TELEFONOS_PK PRIMARY KEY (cedula_persona,telefono),
	CONSTRAINT PERSONAS_TELEFONOS_FK FOREIGN KEY (cedula_persona) REFERENCES PERSONAS
);

CREATE TABLE PACIENTES(
	cedula_paciente INT NOT NULL
	CONSTRAINT PACIENTES_PK PRIMARY KEY (cedula_paciente),
	CONSTRAINT PACIENTES_FK FOREIGN KEY (cedula_paciente) REFERENCES PERSONAS(cedula_persona)
);

CREATE TABLE PERSONAL_SALUD(
	cedula_personal INT NOT NULL,
	cedula_vacunador INT NOT NULL, 
	fechavacunado VARCHAR(20),
	CONSTRAINT PERSONAL_SALUD_PK PRIMARY KEY (cedula_personal),
	CONSTRAINT PERSONAL_PERSONAL_FK FOREIGN KEY (cedula_personal) REFERENCES PERSONAS(cedula_persona),
	--CONSTRAINT PERSONAL_VACUNADOR_FK FOREIGN KEY (cedula_vacunador) REFERENCES PERSONAL_SALUD(cedula_personal),
);

CREATE TABLE PERSONAL_ESPECIALIDADES(
	cedula_personal_esp INT NOT NULL, 
	especialidad VARCHAR(50) NOT NULL,
	CONSTRAINT PERSONAL_ESPECIALIDADES_PK PRIMARY KEY (cedula_personal_esp,especialidad),
	CONSTRAINT PERSONAL_ESPECIALIDADES_FK FOREIGN KEY (cedula_personal_esp) REFERENCES PERSONAL_SALUD(cedula_personal),
);

CREATE TABLE CENTROS_SUMINISTRAN_VACUNAS(
	codigo_centro INT NOT NULL,
	nombre_vacuna VARCHAR(50) NOT NULL,
	CONSTRAINT CENTROS_SUMINISTRAN_VACUNAS_PK PRIMARY KEY(codigo_centro,nombre_vacuna),
	CONSTRAINT CENTROS_SUMINISTRAN_VACUNAS_CEN_FK FOREIGN KEY(codigo_centro) REFERENCES CENTROS(codigo_centro),
	CONSTRAINT CENTROS_SUMINISTRAN_VACUNAS_VAC_FK FOREIGN KEY(nombre_vacuna) REFERENCES VACUNAS(nombre_vacuna),
);

CREATE TABLE PACIENTES_SEAGENDAN(
	cedula_paciente INT NOT NULL, 
	codigo_centro INT NOT NULL,
	nombre_vacuna VARCHAR(50) NOT NULL, 
	fechaprimerdosis DATE NOT NULL, 
	horaprimerdosis TIME NOT NULL, 
	fechasegdosis DATE NOT NULL, 
	horasegdosis TIME NOT NULL,
	CONSTRAINT PACIENTES_SEAGENDAN_PK PRIMARY KEY (cedula_paciente),
	CONSTRAINT PACIENTES_SEAGENDAN_FK FOREIGN KEY (cedula_paciente) REFERENCES PACIENTES(cedula_paciente),
	CONSTRAINT PACIENTES_SEAGENDAN_CENTRO_FK FOREIGN KEY (codigo_centro, nombre_vacuna) REFERENCES CENTROS_SUMINISTRAN_VACUNAS(codigo_centro, nombre_vacuna)
);

CREATE TABLE PACIENTES_PRIMERADOSIS(
	cedula_paciente INT NOT NULL, 
	cedula_vacunador INT NOT NULL, 
	Fecha DATE NOT NULL, 
	Hora TIME NOT NULL,
	CONSTRAINT PACIENTES_PRIMERADOSIS_PK PRIMARY KEY (cedula_paciente),
	CONSTRAINT PACIENTES_PRIMERADOSIS_PACIENTE_FK FOREIGN KEY (cedula_paciente) REFERENCES PACIENTES(cedula_paciente),
	CONSTRAINT PACIENTES_PRIMERADOSIS_VACUNADOR_FK FOREIGN KEY (cedula_vacunador) REFERENCES PERSONAL_SALUD(cedula_personal)
);

CREATE TABLE PACIENTES_SEGUNDADOSIS(
	cedula_paciente INT NOT NULL, 
	cedula_vacunador INT NOT NULL, 
	Fecha DATE NOT NULL, 
	Hora TIME NOT NULL,
	CONSTRAINT PACIENTES_SEGUNDARDDOSIS_PK PRIMARY KEY (cedula_paciente),
	CONSTRAINT PACIENTES_SEGUNDADDOSIS_PACIENTE_FK FOREIGN KEY (cedula_paciente) REFERENCES PACIENTES(cedula_paciente),
	CONSTRAINT PACIENTES_SEGUNDADDOSIS_VACUNADOR_FK FOREIGN KEY (cedula_vacunador) REFERENCES PERSONAL_SALUD(cedula_personal)
);
GO

--PAISES
INSERT INTO PAISES VALUES -- OK
(1,'China'),
(2,'Estados Unidos'),
(3,'Inglaterra'),
(4,'Alemania'),
(5,'Cuba'),
(6,'Rusia'),
(7,'Uruguay'),
(8,'Argentina'),
(9,'Brasil'),
(10,'Chile');

INSERT INTO CIUDADES VALUES 
(1,'Artigas',7),
(2,'Canelones',7),
(3,'Melo',7),
(4,'Colonia del Sacramento',7),
(5,'Durazno',7),
(6,'Trinidad',7),
(7,'Florida',7),
(8,'Minas',7),
(9,'Maldonado',7),
(10,'Montevideo',7),
(11,'Paysand�',7),
(12,'Fray Bentos',7),
(13,'Rivera',7),
(14,'Rocha',7),
(15,'Salto',7),
(16,'San Jos� de Mayo',7),
(17,'Mercedes',7),
(18,'Tacuaremb�',7),
(19,'Treinta y Tres',7),
(20,'Pek�n', 1),
(21,'Cambridge',2),
(22,'Cambridge',3),
(23,'Maguncia',4),
(24,'La Habana',5),
(25,'Mosc�',6),
(26,'Buenos Aires',8),
(27,'San Pablo',9),
(28,'Santiago de Chile',10);

INSERT INTO CENTROS VALUES 
(1, 'Hospital Pereyra Rosell', 50, 10, 'Calle A', 2343,12222),
(2, 'Hospital Pasteur', 30, 10,'Calle B', 4353,12221),
(3, 'Hospital Maciel', 70, 10,'Calle C', 1234,12220),
(4, 'Hospital Policial', 60, 10,'Calle D', 7687,12223),
(5, 'Hospital Militar', 40, 10,'Calle E', 5611,12226),
(6, 'CASMU', 50, 10,'Calle F', 5421,12231),
(7, 'C�rculo Cat�lico', 20, 10,'Calle G', 6789,12245),
(8, 'Mutualista Hospital Evang�lico', 45, 10,'Calle H', 4153,12251),
(9, 'CUDAM', 10, 10,'Calle I', 6783,12233),
(10, 'Servicio M�dico Integral', 34, 10,'Calle H', 9812,12241),
(11, 'Sociedad M�dica Universal', 10, 10,'Calle J', 9001,12237),
(12, 'Asociaci�n Espa�ola', 55, 10,'Calle K', 1230,12238),
(13, 'Casa de Galicia', 50, 10,'Calle L', 4113,12240),
(14, 'MUCAM', 25, 10,'Calle M', 3355,12232),
(15, 'Hospital Brit�nico', 30, 10,'Calle N', 5603,12201),
(16, 'Hospital de Artigas', 10, 1,'Calle AA', 491,23221),
(17, 'Hospital de Canelones', 10, 2,'Calle BB', 9801,23421),
(18, 'Hospital de Melo', 10, 3,'Calle CC', 987,24973),
(19, 'Hospital de Colonia del Sacramento', 10, 4,'Calle DD', 456,24780),
(20, 'Hospital de Durazno', 10, 5,'Calle EE', 4116,21220),
(21, 'Hospital de Trinidad', 10, 6,'Calle FF', 1565,22340),
(22, 'Hospital de Florida', 10, 7,'Calle GG', 5091,21770),
(23, 'Hospital de Minas', 10, 8,'Calle HH', 4562,27090),
(24, 'Hospital de Maldonado', 10, 9,'Calle II', 4016,26701),
(25, 'Hospital de Montevideo', 18, 10,'Calle JJ', 789,25112),
(26, 'Sanattorio Cantegril', 28, 9,'Calle RR', 1789,26701),
(27, 'Hospital de Fray Bentos', 10, 12,'Calle W', 1289,26092),
(28, 'Hospital de Rivera', 18, 13,'Calle XZ', 340,23456),
(29, 'Hospital de Rocha', 10, 14,'Calle Z', 101,23001),
(30, 'Hospital de Salto', 10, 15,'Calle GF', 1001,24560),
(31, 'Hospital de San Jos� de Mayo', 10, 16,'Calle RT', 5671,10934),
(32, 'Hospital de Mercedes', 10, 17,'Calle OP', 4560,33450),
(33, 'Hospital de Tacuaremb�', 10, 18,'Calle SD', 3456,11100),
(34, 'Hospital de Treinta y Tres', 10, 19,'Calle AW', 1234,34557);

INSERT INTO LABORATORIOS VALUES
('Sinovac Biotech',1),
('Moderna',2),
('AstraZeneca',3),
('BioNTech - Pfizer',4),
('Johnson & Johnson',2),
('CNIEM',6),
('Instituto Finlay de Vacunas',5);

INSERT INTO LABORATORIOS_TELEFONOS VALUES 
('Sinovac Biotech',43311111),
('Moderna',98222222),
('AstraZeneca',47911112),
('BioNTech - Pfizer',47922221),
('Johnson & Johnson',47311122),
('CNIEM',47333332),
('Instituto Finlay de Vacunas',98233332);

INSERT INTO VACUNAS VALUES 
('Sinovac',2,1,8, 78,'Sinovac Biotech'),
('Moderna',2,2,-20, 95,'Moderna'),
('AstraZeneca',2,3,8, 70,'AstraZeneca'),
('Pfizer',2,4,-70, 95,'BioNTech - Pfizer'),
('Johnson & Johnso',2,2,8, 66,'Johnson & Johnson'),
('Sputnik V',2,6,-20, 92,'CNIEM'),
('Soberana',2,5,8, 70,'Instituto Finlay de Vacunas');

INSERT INTO SINTOMAS VALUES 
(1,'Fiebre','S'),
(2,'Tos','N'),
(3,'Dificultad Respiratoria','S'),
(4,'Dolor Muscular','N'),
(5,'Dolor de Garganta','N'),
(6,'P�rdida del Gusto','N'),
(7,'P�rdida del Olfato','N'),
(8,'Congesti�n','S'),
(9,'Diarrea','N'),
(10,'V�mitos','N'),
(11,'Dolor de Cabeza','N');

INSERT INTO VACUNAS_PRODUCEN_SINTOMAS VALUES
('Sinovac',1),
('Moderna',2),
('AstraZeneca',4),
('Pfizer',11),
('Johnson & Johnso',9),
('Sputnik V',5),
('Soberana',10);

INSERT INTO GRUPOS_VACUNACION VALUES
(1,'Grupo 1','Pfizer'),
(2,'Grupo 2','Sinovac'),
(3,'Grupo 3','Moderna'),
(4,'Grupo 3','Sinovac'),
(5,'Grupo 4','Sinovac'),
(6,'Grupo 5','Sinovac'),
(7,'Grupo 4','AstraZeneca'),
(8,'Grupo 5','Johnson & Johnso'),
(9,'Grupo 4','Moderna');

INSERT INTO PERSONAS VALUES 
(11111111, 'Nombre 1', 'Apellido 1', 'Calle 1', 111, 11111,'1965-05-20',10,1),
(22222222, 'Nombre 2', 'Apellido 2', 'Calle 2', 112, 11121,'1988-04-26',19,2),
(33333333, 'Nombre 3', 'Apellido 3', 'Calle 3', 113, 11131,'1991-04-26',11,3),
(44444444, 'Nombre 4', 'Apellido 4', 'Calle 4', 114, 11141,'2009-06-08',12,4),
(55555555, 'Nombre 5', 'Apellido 5', 'Calle 5', 115, 11151,'1993-09-22',13,5),
(66666666, 'Nombre 6', 'Apellido 6', 'Calle 6', 116, 11161,'1975-03-22',14,6),
(77777777, 'Nombre 7', 'Apellido 7', 'Calle 7', 117, 11171,'1970-06-23',15,7),
(88888888, 'Nombre 8', 'Apellido 8', 'Calle 8', 118, 11181,'1975-11-18',16,8),
(99999999, 'Nombre 9', 'Apellido 9', 'Calle 9', 119, 11191,'1974-10-19',17,9),
(10101010, 'Nombre 10', 'Apellido 10', 'Calle 10', 121, 10111,'1978-05-16',18,1),
(11011011, 'Nombre 11', 'Apellido 11', 'Calle 11', 122, 12111,'1999-06-21',19,2),
(12121212, 'Nombre 12', 'Apellido 12', 'Calle 12', 123, 13111,'1971-07-22',10,3),
(13131313, 'Nombre 13', 'Apellido 13', 'Calle 13', 124, 14111,'1977-11-16',1,4),
(14141414, 'Nombre 14', 'Apellido 14', 'Calle 14', 125, 15111,'1970-06-23',10,5),
(15151515, 'Nombre 15', 'Apellido 15', 'Calle 15', 126, 16111,'1979-05-10',2,6),
(16161616, 'Nombre 16', 'Apellido 16', 'Calle 16', 127, 17111,'1968-09-30',10,7),
(17171717, 'Nombre 17', 'Apellido 17', 'Calle 17', 128, 18111,'1936-08-22',4,8),
(18181818, 'Nombre 18', 'Apellido 18', 'Calle 18', 129, 19111,'1956-07-29',6,9),
(19191919, 'Nombre 19', 'Apellido 19', 'Calle 19', 130, 11011,'1987-07-25',5,1),
(20202020, 'Nombre 20', 'Apellido 20', 'Calle 20', 131, 11411,'1931-06-09',10,2),
(21212121, 'Nombre 21', 'Apellido 21', 'Calle 21', 132, 11511,'1978-04-08',3,3),
(22022022, 'Nombre 22', 'Apellido 22', 'Calle 22', 133, 11611,'1989-03-30',1,4),
(23232323, 'Nombre 23', 'Apellido 23', 'Calle 23', 134, 11711,'1990-02-20',10,1),
(24242424, 'Nombre 24', 'Apellido 24', 'Calle 24', 135, 11811,'1980-01-10',9,1),
(25252525, 'Nombre 25', 'Apellido 25', 'Calle 25', 136, 11911,'1978-10-15',8,1),
(55551111, 'Nombre 26', 'Apellido 26', 'Calle 26', 126, 11126,'1985-02-20',10,1),
(55222222, 'Nombre 27', 'Apellido 27', 'Calle 27', 127, 11127,'1998-12-26',19,2),
(55333333, 'Nombre 28', 'Apellido 28', 'Calle 28', 128, 11128,'1994-08-26',11,1),
(55444444, 'Nombre 29', 'Apellido 29', 'Calle 29', 129, 11129,'2076-11-08',12,4),
(56666944, 'Nombre 30', 'Apellido 30', 'Calle 30', 130, 11130,'2081-10-18',1,2),
(55499988, 'Nombre 31', 'Apellido 31', 'Calle 31', 131, 11131,'2079-08-15',1,2),
(52266633, 'Nombre 32', 'Apellido 32', 'Calle 32', 132, 11133,'2089-11-28',10,2),
(54555665, 'Nombre 33', 'Apellido 33', 'Calle 33', 133, 11133,'2095-04-15',10,1),
(44441111, 'Nombre 34', 'Apellido 34', 'Calle 34', 1133, 23456,'1985-12-20',13,1),
(44442222, 'Nombre 35', 'Apellido 35', 'Calle 35', 1125, 12222,'1981-08-21',10,2),
(44433333, 'Nombre 36', 'Apellido 36', 'Calle 36', 1136, 23457,'1971-04-25',13,4),
(55554444, 'Nombre 37', 'Apellido 37', 'Calle 37', 1147, 12201,'2079-03-18',10,4),
(44445555, 'Nombre 38', 'Apellido 38', 'Calle 38', 1158, 23458,'1983-06-12',13,5),
(44446666, 'Nombre 39', 'Apellido 39', 'Calle 39', 1169, 34557,'1979-02-22',19,6);

INSERT INTO PERSONAS_TELEFONOS VALUES 
(11111111, '091111111'),
(22222222, '091111112'),
(33333333, '091111113'),
(44444444, '091111114'),
(55555555, '091111115'),
(66666666, '091111116'),
(77777777, '091111117'),
(88888888, '091111118'),
(99999999, '091111119'),
(10101010, '091111121'),
(11011011, '091111122'),
(12121212, '091111123'),
(13131313, '091111124'),
(14141414, '091111125'),
(15151515, '091111126'),
(16161616, '091111127'),
(17171717, '091111128'),
(18181818, '091111129'),
(19191919, '091111130'),
(20202020, '091111131'),
(21212121, '091111132'),
(22022022, '091111133'),
(23232323, '091111134'),
(24242424, '091111135'),
(25252525, '091111136'),
(55551111, '091111137'),
(55222222, '091111138'),
(55333333, '091111139'),
(55444444, '091111140'),
(56666944, '094111112'),
(55499988, '094111112'),
(52266633, '094111113'),
(54555665, '093111116'),
(44441111, '093167116'),
(44442222, '093145116'),
(55554444, '093114546'),
(44445555, '092321116'),
(44446666, '092221116');

INSERT INTO PACIENTES VALUES 
(44433333),
(99999999),
(10101010),
(11011011),
(12121212),
(13131313),
(14141414),
(15151515),
(16161616),
(17171717),
(18181818),
(11111111),
(22222222),
(33333333),
(44444444),
(55555555),
(66666666),
(77777777),
(88888888),
(19191919),
(20202020),
(56666944),
(55499988),
(52266633),
(54555665),
(44441111),
(44442222),
(55554444),
(44445555),
(44446666);

INSERT INTO PERSONAL_SALUD VALUES 
(25252525, 55444444,'2021-03-19'),
(55551111, 55222222,'2021-04-01'),
(55222222, 55333333,'2021-03-29'),
(55333333, 55551111,'2021-03-02'),
(55444444,25252525,'2021-03-19');

INSERT INTO PERSONAL_ESPECIALIDADES VALUES
(25252525, 'Enfermeras'),
(55551111, 'Nurse'),
(55222222, 'Estudiantes Medicina'),
(55333333, 'Enfermeras'),
(55444444, 'Enfermeras');

INSERT INTO CENTROS_SUMINISTRAN_VACUNAS VALUES 
(1, 'Sinovac'),
(2, 'Pfizer'),
(3, 'Sinovac'),
(4, 'Pfizer'),
(5, 'Sinovac'),
(6, 'Sinovac'),
(7, 'Pfizer'),
(8, 'Pfizer'),
(9, 'Pfizer'),
(10,'Sinovac'),
(11, 'Pfizer'),
(12, 'Pfizer'),
(13, 'Pfizer'),
(13, 'Sinovac'),
(14, 'Pfizer'),
(15, 'Sinovac'),
(16, 'Pfizer'),
(17, 'Pfizer'),
(18, 'Sinovac'),
(19, 'Pfizer'),
(20, 'Pfizer'),
(21, 'AstraZeneca'),
(22, 'Sinovac'),
(23, 'Sputnik V'),
(24, 'Sinovac'),
(25, 'Pfizer'),
(26, 'Pfizer'),
(26, 'Sinovac'),
(27, 'Sinovac'),
(28, 'Sinovac'),
(28, 'Pfizer'),
(29, 'Pfizer'),
(30, 'Sinovac'),
(31, 'Pfizer'),
(32, 'Pfizer'),
(33, 'Sinovac'),
(34, 'Sinovac');

INSERT INTO PACIENTES_SEAGENDAN VALUES 
(99999999,1, 'Sinovac','2021-04-19','12:30','2021-05-10','12:30'),
(10101010,2, 'Pfizer','2021-03-11','10:30','2021-04-01','10:30'),
(11011011,3, 'Sinovac','2021-03-29','11:30','2021-04-19','11:30'),
(12121212,4, 'Pfizer','2021-04-15','14:30','2021-05-06','14:30'),
(13131313,5, 'Sinovac','2021-05-19','15:30','2021-06-09','15:30'),
(14141414,6, 'Sinovac','2021-05-13','16:30','2021-06-03','16:30'),
(15151515,7, 'Pfizer','2021-03-30','17:30','2021-04-20','17:30'),
(16161616,8, 'Pfizer','2021-04-29','18:30','2021-05-20','18:30'),
(17171717,9, 'Pfizer','2021-06-19','19:30','2021-07-10','19:30'),
(18181818,10,'Sinovac','2021-07-18','20:30','2021-08-08','20:30'),
(11111111,11, 'Pfizer','2021-05-22','12:00','2021-06-12','12:00'),
(22222222,12, 'Pfizer','2021-03-26','09:00','2021-04-16','09:00'),
(33333333,13, 'Pfizer','2021-05-10','10:00','2021-05-31','10:00'),
(44444444,14, 'Pfizer','2021-06-27','08:00','2021-07-18','08:00'),
(55555555,15, 'Sinovac','2021-04-24','13:00','2021-05-15','13:00'),
(66666666,16, 'Pfizer','2021-05-22','14:00','2021-06-12','14:00'),
(77777777,17, 'Pfizer','2021-06-19','16:00','2021-07-10','16:00'),
(88888888,18, 'Sinovac','2021-06-16','15:00','2021-07-07','15:00'),
(19191919,19, 'Pfizer','2021-04-05','17:00','2021-04-26','17:00'),
(20202020,20, 'Pfizer','2021-06-19','18:00','2021-07-10','18:00'),
(56666944,13, 'Pfizer','2021-05-01','12:00','2021-05-22','12:00'),
(55499988,13, 'Pfizer','2021-05-14','18:00','2021-06-04','18:00'),
(52266633,26, 'Sinovac','2021-04-30','14:30','2021-05-20','14:30'),
(54555665,13, 'Sinovac','2021-05-18','10:00','2021-06-07','10:00'),
(44441111,28, 'Pfizer', '2021-05-27','12:30','2021-06-17','12:30'),
(44442222,1,  'Sinovac','2021-05-27','16:30','2021-06-17','16:30'),
(44433333,28, 'Sinovac','2021-09-15','13:30','2021-10-06','13:30'),
(55554444,15, 'Sinovac','2021-05-27','12:00','2021-06-17','12:30'), 
(44445555,28, 'Sinovac','2021-05-27','16:00','2021-06-17','16:00'),
(44446666,34, 'Sinovac','2021-05-27','17:00','2021-06-17','17:00');


INSERT INTO PACIENTES_PRIMERADOSIS VALUES 
(99999999,25252525,'2021-04-19','12:30'),
(10101010,55551111,'2021-03-11','10:30'),
(11011011,55222222,'2021-03-29','11:30'),
(12121212,55333333,'2021-04-15','14:30'),
(13131313,55444444,'2021-05-19','15:30'),
(14141414,25252525,'2021-05-13','16:30'),
(15151515,55551111,'2021-03-30','17:30'),
(16161616,55222222,'2021-04-29','18:30'),
(11111111,25252525,'2021-05-22','12:00'),
(22222222,55551111,'2021-03-26','09:00'),
(33333333,55222222,'2021-04-10','10:00'),
(55555555,55444444,'2021-04-24','13:00'),
(66666666,55444444,'2021-05-22','14:00'),
(19191919,55222222,'2021-04-05','17:00'),
(56666944,55444444,'2021-05-01','12:00'),
(55499988,55444444,'2021-05-14','18:00'),
(52266633,55551111,'2021-04-30','14:30'),
(54555665,25252525,'2021-05-18','10:00');

INSERT INTO PACIENTES_SEGUNDADOSIS VALUES 
(99999999,25252525,'2021-05-10','12:30'),
(10101010,55551111,'2021-04-01','10:30'),
(11011011,55222222,'2021-04-19','11:30'),
(12121212,55333333,'2021-05-06','14:30'),
(15151515,55551111,'2021-04-20','17:30'),
(16161616,55222222,'2021-05-20','18:30'),
(22222222,55551111,'2021-04-16','09:00'),
(33333333,55222222,'2021-05-31','10:00'),
(55555555,55444444,'2021-05-15','13:00'),
(19191919,55222222,'2021-04-26','17:00'),
(56666944,55444444,'2021-05-22','12:00'),
(52266633,55551111,'2021-05-20','14:30');