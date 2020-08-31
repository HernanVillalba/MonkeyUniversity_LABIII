Use MonkeyUniv

-- Extras
-- Consulta 1
Select Nombre, CostoCurso as Costo, CostoCertificacion as Certificacion, 
(CostoCurso+CostoCertificacion) * 0.9 as Promo, Estreno 
From Cursos
Order by Estreno Asc, Nombre Desc

-- Top
Select Top 1 with ties Nombre, CostoCurso from Cursos
order by Estreno Asc

-- Distinct
Select distinct Estreno, Nombre From Cursos

---------------------------------------

-- TP
-- 1	Listado de todos los idiomas.
select *
	from Idiomas

-- 2	Listado de todos los cursos.
select *
	from Cursos

-- 3	Listado con nombre, costo de inscripción, costo de certificación y fecha de estreno de todos los cursos.
select Nombre, CostoCurso, CostoCertificacion, Estreno
	from Cursos

-- 4	Listado con ID, nombre, costo de inscripción e ID de nivel de todos los cursos cuyo costo de certificación sea menor a $ 5000.
select ID, Nombre, CostoCurso, IDNivel
	from Cursos
		where CostoCertificacion<5000

-- 5	Listado con ID, nombre, costo de inscripción e ID de nivel de todos los cursos cuyo costo de certificación sea mayor a $ 1200.
select ID, Nombre, CostoCurso, IDNivel
	from Cursos
		where CostoCertificacion>1200

-- 6	Listado con nombre, número y duración de todas las clases del curso con ID número 6.
select Nombre, Numero, Duracion
	from Clases
		where IDCurso=6

-- 7	Listado con nombre, número y duración de todas las clases del curso con ID número 10.
select Nombre, Numero, Duracion
	from Clases
		where IDCurso=10

-- 8	Listado con nombre y duración de todas las clases con ID Curso número 4. Ordenado por duración de mayor a menor.
select Nombre, Duracion
	from Clases
		where IDCurso=4
		order by Duracion desc

-- 9	Listado con nombre, fecha de estreno, costo del curso, costo de certificación ordenados por fecha de estreno de manera creciente.
select Nombre, Estreno, CostoCurso, CostoCertificacion
	from Cursos	
		order by Estreno asc

-- 10	Listado con nombre, fecha de estreno y costo del curso de todos aquellos cuyo ID de nivel sea 1, 5, 6 o 7.
select Nombre, Estreno, CostoCurso,IDNivel
	from Cursos
		where IDNivel in (1,5,6,7)

-- 11	Listado con nombre, fecha de estreno y costo de cursado de los tres cursos más caros de certificar.
select top 3 with ties Nombre, Estreno, CostoCurso
	from Cursos
		order by CostoCertificacion
	

-- 12	Listado con nombre, duración y número de todas clases de los cursos con ID 2, 5 y 7. --		Ordenados por ID de Curso ascendente y luego por número de clase ascendente.
select Nombre, Duracion, Numero, ID
	from Clases
		where ID in (2,5,7)
		order by ID asc, Numero asc

-- 13	Listado con nombre y fecha de estreno de todos los cursos cuya fecha de estreno haya sido en el segundo semestre del año 2019.
set dateformat 'DMY'
select Nombre, Estreno
	from Cursos
		where Estreno>='30/6/2019' and Estreno<='31/12/2019'

-- 14	Listado de cursos cuya fecha de estreno haya sido en el año 2020.
select *
	from Cursos
		where year(Estreno)=2020

------------------
-- Investigar:
/*
DATEPART:
	devuelve una parte específica de una fecha. Esta función devuelve el resultado como un valor entero.
		Sintaxis: DATEPART(interval, date)
DATEDIFF:
	devuelve la diferencia entre dos fechas.
		Sintaxis: DATEDIFF(interval, date1, date2)
DATEADD:
	agrega un intervalo de hora / fecha a una fecha y luego devuelve la fecha.
		Sintaxis: DATEADD(interval, number, date)
*/
------------------

-- 15	Listado de cursos cuya mes de estreno haya sido entre el 1 y el 4.
select *
	from Cursos
		where month(Estreno) between 1 and 4

-- 16	Listado de clases cuya duración se encuentre entre 15 y 90 minutos.
select *
	from Clases
		where Duracion between 15 and 90

-- 17	Listado de contenidos cuyo tamaño supere los 5000MB y sean de tipo 4 o sean menores a 400MB y sean de tipo 1.
select *
	from Contenidos
		where (Tamaño>5000 and IDTipo=4) or (Tamaño<400 and IDTipo=1)

-- 18	Listado de cursos que no posean ID de nivel.
select * 
	from Cursos	
		where IDNivel is null

-- 19	Listado de cursos cuyo costo de certificación corresponda al 20% o más del costo del curso.
select *
	from Cursos
		where CostoCertificacion >= CostoCurso*0.2

-- 20	Listado de costos de cursado de todos los cursos sin repetir y ordenados de mayor a menor.
select distinct CostoCurso
	from Cursos
		order by CostoCurso desc