  
-- 1) Por cada a�o, la cantidad de cursos que se estrenaron en dicho a�o y el promedio de costo de cursada.
select year(C.Estreno) as A�o, count(*) as CantidadCursos, avg(C.CostoCurso) as PromedioCosto
from Cursos as C
group by year(C.Estreno)

-- 2) El idioma que se haya utilizado m�s veces como subt�tulo. Si hay varios idiomas en esa condici�n, mostrarlos a todos.
select top 1 I.Nombre as Idioma, count(*) as Cant
from Idiomas as I
join Idiomas_x_Curso as IxC on IxC.IDIdioma=I.ID
join TiposIdioma as TI on TI.ID=IxC.IDTipo
where TI.Nombre='Subt�tulo'
group by I.Nombre
order by 2 desc

-- 3) Apellidos y nombres de usuarios que cursaron alg�n curso y nunca fueron instructores de cursos.
select AUX.Apellidos, AUX.Nombres from (
	select DAT.Apellidos, DAT.Nombres,
	(
		select count(*) from Inscripciones as I
		where I.IDUsuario=DAT.ID
	) as CantAlumno,
	(
		select count(*) from Instructores_x_Curso as IxC
		where IxC.IDUsuario=DAT.ID
	) as CantInstructor
	from Datos_Personales as DAT
) as AUX
where AUX.CantAlumno>0 and AUX.CantInstructor=0
------------------------------------------------------------------
select DAT.Apellidos, DAT.Nombres from Datos_Personales as DAT
where DAT.ID in
(
	select I.IDUsuario from Inscripciones as I
	where DAT.ID=I.IDUsuario
) and DAT.ID not in
(
	select IxC.IDUsuario from Instructores_x_Curso as IxC
	where DAT.ID=IxC.IDUsuario
)


-- 4) Para cada usuario mostrar los apellidos y nombres y el costo m�s caro de un curso al que se haya inscripto. 
--    En caso de no haberse inscripto a ning�n curso debe figurar igual pero con importe igual a -1.
select DAT.Apellidos, DAT.Nombres, isnull(max(I.Costo),-1)
from Datos_Personales as DAT
left join Inscripciones as I on I.IDUsuario=DAT.ID
group by DAT.Apellidos, DAT.Nombres


-- 5) La cantidad de usuarios que hayan realizado rese�as positivas (Puntaje>=7) pero nunca una rese�a negativa (Puntaje<7).
select count(*) as CantUsuarios from
(
	select DAT.Apellidos, DAT.Nombres,
	(
		select count(*) from Rese�as as R
		where R.IDInscripcion=I.ID and R.Puntaje>=7
	) as CantPos,
	(
		select count(*) from Rese�as as R
		where R.IDInscripcion=I.ID and R.Puntaje<7
	) as CantNeg
	from Datos_Personales as DAT
	join Inscripciones as I on I.IDUsuario=DAT.ID
) as AUX
where AUX.CantPos>0 and AUX.CantNeg=0