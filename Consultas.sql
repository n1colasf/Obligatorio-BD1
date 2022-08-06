--1 Obtener los Centros en los cuales en la �ltima semana se han vacunado personas con Sinovac.
SELECT DISTINCT
	C.codigo_centro AS 'CODIGO',
	C.nombre_centro AS 'NOMBRE CENTRO'
FROM 
	CENTROS C , 
	PACIENTES_SEAGENDAN PSA
WHERE 
	PSA.nombre_vacuna = 'Sinovac' AND
	C.codigo_centro = PSA.codigo_centro AND 
	((PSA.fechaprimerdosis >= CONVERT(VARCHAR(10),DATEADD(DAY,-7,GETDATE()),126) AND 
	PSA.fechaprimerdosis <= CONVERT(VARCHAR(10),GETDATE(),126) AND (PSA.fechaprimerdosis = GETDATE() AND PSA.horaprimerdosis <= CONVERT(varchar(10), GETDATE(), 108) OR PSA.fechaprimerdosis <> GETDATE())) OR
	(PSA.fechasegdosis >= CONVERT(VARCHAR(10),DATEADD(DAY,-7,GETDATE()),126) AND 
	PSA.fechasegdosis <= CONVERT(VARCHAR(10),GETDATE(),126)) AND (PSA.fechasegdosis = GETDATE() AND PSA.horasegdosis <= CONVERT(varchar(10), GETDATE(), 108) OR PSA.fechaprimerdosis <> GETDATE()))

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2 Obtener todos los Centros que vacunaron con Sinovac pero no han vacunado personas del grupo 2.
SELECT DISTINCT
	C.nombre_centro AS 'NOMBRE CENTRO',
	C.codigo_centro AS 'CODIGO'
FROM
	CENTROS C,
	PACIENTES_SEAGENDAN PSA
WHERE 
	C.codigo_centro = PSA.codigo_centro AND
	(PSA.fechaprimerdosis <= CONVERT(VARCHAR(10),GETDATE(),126) OR PSA.fechasegdosis <= CONVERT(VARCHAR(10),DATEADD(DAY,-7,GETDATE()),126)) AND
	PSA.nombre_vacuna = 'Sinovac' AND
	PSA.codigo_centro NOT IN(
							SELECT
								PSA.codigo_centro
							FROM
								PACIENTES_SEAGENDAN PSA,
								PERSONAS P
							WHERE 
								PSA.cedula_paciente = P.cedula_persona AND
								P.codigo_grupo = 2)



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--3 Obtener la cantidad de dosis agendadas por vacuna.
SELECT 
	VACUNAS.nombre_vacuna AS 'VACUNA', 
	ISNULL(DOSISXVACUNA.DosisAgendadasPorVacuna, 0) AS 'DOSIS AGENDADAS' 
FROM(
	SELECT 
		V.nombre_vacuna
	FROM 
		VACUNAS V)VACUNAS
LEFT JOIN(
	SELECT 
		PSA.nombre_vacuna,
		COUNT(nombre_vacuna) * 2 AS 'DosisAgendadasPorVacuna'
	FROM 
		PACIENTES_SEAGENDAN PSA
	GROUP BY 
		PSA.nombre_vacuna)
	DOSISXVACUNA ON VACUNAS.nombre_vacuna = DOSISXVACUNA.nombre_vacuna 
ORDER BY 
	VACUNAS.nombre_vacuna

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4 Obtener los datos de los pacientes que se han dado la primera dosis y est�n esperando su segunda dosis en el centro �Casa de Galicia� 
--de Montevideo con la vacuna Pfizer.
SELECT 
	P.cedula_persona AS 'CEDULA',  
	P.nombre_persona AS 'NOMBRE', 
	P.apellido_persona AS 'APELLIDO', 
	P.calle AS 'CALLE', 
	P.numero AS 'NUMERO', 
	P.FchNacimiento AS 'FECHA DE NACIMIENTO', 
	P.codigo_ciudad AS 'CODIGO CIUDAD', 
	P.codigo_grupo AS 'GRUPO'
FROM 
	PERSONAS P,
	PACIENTES_SEAGENDAN PSA, 
	CENTROS C, 
	CIUDADES CI
WHERE
	P.cedula_persona = PSA.cedula_paciente AND 
	C.codigo_centro = PSA.codigo_centro AND
	C.codigo_ciudad = CI.codigo_ciudad AND
	PSA.fechaprimerdosis < GETDATE() AND 
	PSA.fechasegdosis > GETDATE() AND 
	(PSA.fechaprimerdosis = GETDATE() AND PSA.horaprimerdosis <= CONVERT(varchar(10), GETDATE(), 108) OR PSA.fechaprimerdosis <> GETDATE()) AND
	PSA.nombre_vacuna = 'Pfizer' AND 
	C.nombre_centro = 'Casa de Galicia' AND
	CI.nombre_ciudad = 'Montevideo' 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--5 Obtener el nombre y c�dula de las personas que se agendaron en centros de la ciudad de Montevideo o Rivera para el jueves 27 de mayo, 
--se debe ordenar el resultado alfab�ticamente y mostrar para cada persona el centro en el cual se agend�
SELECT 
	P.cedula_persona AS 'CEDULA PERSONA',
	P.nombre_persona AS 'NOMBRE PERSONA',
	C.codigo_centro AS 'CODIGO CENTRO',
	C.nombre_centro AS 'NOMBRE CENTRO'
FROM 
	PACIENTES_SEAGENDAN PSA, 
	CENTROS C, 
	CIUDADES CI,
	PERSONAS P
WHERE 
	C.codigo_centro = PSA.codigo_centro AND 
	C.codigo_ciudad = CI.codigo_ciudad AND
	P.cedula_persona = PSA.cedula_paciente AND
	(CI.nombre_ciudad = 'RIVERA' OR CI.nombre_ciudad = 'MONTEVIDEO') AND
	(PSA.fechaprimerdosis = '2021-05-27' OR PSA.fechasegdosis = '2021-05-27')
ORDER BY 
P.nombre_persona	

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--EXTRA: Se muestra el nombre de la ciudad y la cantidad de centros que contiene, ademas del promedio de la capacidad diaria de los centros de cada ciudad en conjunto con el promedio del total de las dosis agendadas para esa ciudad en la fecha 27/05/2021.
SELECT 
	C1.nombre_ciudad AS 'CIUDAD', 
	C1.NumeroCentros AS 'NUMERO DE CENTROS', 
	C1.PromedioCapacidadDiaria AS 'PROMEDEIO CAPACIDAD DIARIA',  
	C2.VACUNADOS/C1.NumeroCentros AS 'PROMEDIO VACUNADOS' FROM (
	SELECT 
		CI.nombre_ciudad, 
		COUNT(C.codigo_centro) AS 'NumeroCentros', 
		AVG(C.capacidad_centro) AS 'PromedioCapacidadDiaria'
	FROM 
		CENTROS C, 
		CIUDADES CI
	WHERE 
		C.codigo_ciudad = CI.codigo_ciudad
	GROUP BY 
		CI.nombre_ciudad)C1
INNER JOIN (
	SELECT 
		ci.nombre_ciudad, 
		COUNT(*) AS 'VACUNADOS'
	FROM 
		PACIENTES_SEAGENDAN PSA, 
		CENTROS c, 
		CIUDADES ci
	WHERE 
		psa.codigo_centro = c.codigo_centro AND 
		c.codigo_ciudad = ci.codigo_ciudad AND 
		PSA.fechaprimerdosis ='2021/05/27' OR PSA.fechasegdosis ='2021/05/27' 
	GROUP BY 
		CI.nombre_ciudad)C2 ON C1.nombre_ciudad = C2.nombre_ciudad