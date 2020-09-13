use MonkeyUniv
-- (1)  Listado con la cantidad de cursos.
select count(*) as 'Cantidad cursos' from cursos

-- 2  Listado con la cantidad de usuarios.
select count(*) as 'Cantidad de usuarios' from Usuarios

-- (3)  Listado con el promedio de costo de certificación de los cursos.
select avg(CostoCertificacion) as Promedio from Cursos
Select avg(CostoCertificacion) as Promedio From Cursos

-- 4  Listado con el promedio general de calificación de reseñas.
select avg(R.Puntaje) as Promedio from Reseñas as R

-- (5)  Listado con la fecha de estreno de curso más antigua.
select min(C.estreno) from Cursos as C

--select top 1 estreno from cursos
--order by estreno asc

-- 6  Listado con el costo de certificación menos costoso.
select min(C.CostoCertificacion) as 'Certificacion menos costosa' from Cursos as C


-- (7)  Listado con el costo total de todos los cursos.
select sum(CostoCurso) as Total from Cursos

-- 8  Listado con la suma total de todos los pagos.
select sum(Importe) as Total from Pagos

-- 9  Listado con la cantidad de cursos de nivel principiante.
select count(*) Cantidad 
from Cursos as C
inner join Niveles as N on N.ID=C.IDNivel
where N.Nombre like 'Principiante'

-- 10  Listado con la suma total de todos los pagos realizados en 2019.
select sum(P.Importe) as Suma
from Pagos as P
where year(P.Fecha)=2019

-- (11)  Listado con la cantidad de usuarios que son instructores.
select count(distinct IDUsuario) as Cantidad
from Instructores_x_Curso

-- Listado de usuarios distintos de Instructores_x_curso
select distinct IDUsuario From Instructores_x_Curso

-- 12  Listado con la cantidad de usuarios distintos que se hayan certificado.
select count(distinct I.IDUsuario) as Cantidad
from Certificaciones as C
join Inscripciones as I on I.ID=C.IDInscripcion


-- (13)  Listado con el nombre del país y la cantidad de usuarios de cada país.
select P.Nombre as Pais, count(Dat.ID) as Cantidad
from Paises as P
left join Datos_Personales as Dat on P.ID=Dat.IDPais
group by P.Nombre
order by 2 desc

-- (14)  Listado con el apellido y nombres del usuario y el importe más costoso abonado como pago. Sólo listar aquellos que hayan abonado más de $7500.
select Dat.Apellidos, Dat.Nombres, max(P.Importe) as ImporteMax
from Pagos as P
join Inscripciones as I on I.ID=P.IDInscripcion
join Usuarios as U on U.ID=I.IDUsuario
join Datos_Personales as Dat on Dat.ID=U.ID
group by Dat.Apellidos, Dat.Nombres
having max(P.Importe)>7500
order by Dat.Apellidos asc,Dat.Nombres asc

-- 15  Listado con el apellido y nombres de usuario y el importe más costoso de curso al cual se haya inscripto.
select Dat.Apellidos, Dat.Nombres, max(P.Importe) as MaxImporte
from Cursos as C
join Inscripciones as I on I.IDCurso = C.ID
join Pagos as P on P.IDInscripcion = I.ID
join Usuarios as U on U.ID = I.IDUsuario
join Datos_Personales as Dat on Dat.ID = U.ID
group by Dat.Apellidos, Dat.Nombres
order by Dat.Apellidos asc, Dat.Nombres asc

-- 16  Listado con el nombre del curso, nombre del nivel, cantidad total de clases y duración total del curso en minutos.
select C.Nombre as Nombre,
	   N.Nombre as Nivel,
	   count(Cla.IDCurso) as CantidadClases,
	   sum(Cla.Duracion) as DuracionMin
from Cursos as C
join Niveles as N on N.ID = C.IDNivel
join Clases as Cla on Cla.IDCurso = C.ID
group by C.Nombre, N.Nombre


-- 17  Listado con el nombre del curso y cantidad de contenidos registrados. Sólo listar aquellos cursos que tengan más de 10 contenidos registrados.
select C.Nombre as Curso,
	   count(*)	as CantidadContenidos
from Cursos as C
join Clases as Cla on Cla.IDCurso = C.ID
join Contenidos as Cont on Cont.IDClase = Cla.ID
group by C.Nombre
having count(*)>10


-- 18  Listado con nombre del curso, nombre del idioma y cantidad de tipos de idiomas.
select C.Nombre as Curso,
       I.Nombre as Idiomas,
	   count(IxC.IDTipo) as CantidadTipos
from Cursos as C
join Idiomas_x_Curso as IxC on IxC.IDCurso = C.ID
join Idiomas as I on I.ID = IxC.IDIdioma
join TiposIdioma as TI on TI.ID = IxC.IDTipo
group by C.Nombre, I.Nombre
order by C.Nombre asc


-- 19  Listado con el nombre del curso y cantidad de idiomas distintos disponibles.
select C.Nombre as Curso,
	   count(distinct IxC.IDIdioma) as CantidadIdiomas	
from Cursos as C
join Idiomas_x_Curso as IxC on IxC.IDCurso = C.ID
group by C.Nombre
order by CantidadIdiomas desc, C.Nombre asc

-- 20  Listado de categorías de curso y cantidad de cursos asociadas a cada categoría. Sólo mostrar las categorías con más de 5 cursos.
select Cat.Nombre as Categoria,
	   count(CxC.IDCurso) as CantidadCursos
from Categorias_x_Curso as CxC
join Categorias as Cat on Cat.ID = CxC.IDCategoria
group by Cat.Nombre
having 	count(CxC.IDCurso)>5

-- 21  Listado con tipos de contenido y la cantidad de contenidos asociados a cada tipo. Mostrar aquellos tipos que no hayan registrado contenidos con cantidad 0.
select TC.Nombre as Contenido,
	   count(Cont.IDTipo) as Cantidad
from TiposContenido as TC
join Contenidos as Cont on Cont.IDTipo = TC.ID
group by TC.Nombre


-- 22  Listado con Nombre del curso, nivel, año de estreno y el total recaudado en concepto de inscripciones. 
--     Listar aquellos cursos sin inscripciones con total igual a $0.
select C.Nombre as Curso,
	   N.Nombre as Nivel,
	   year(C.Estreno) as AnioEstreno,
	   sum(I.Costo) as TotalRecaudado
from Inscripciones as I
join Cursos as C on C.ID = I.IDCurso
left join Niveles as N on N.ID = C.IDNivel
group by C.Nombre, N.Nombre, year(C.Estreno)


-- 23  Listado con Nombre del curso, costo de cursado y certificación y cantidad de usuarios distintos inscriptos cuyo costo de cursado 
--     sea menor a $10000 y cuya cantidad de usuarios inscriptos sea menor a 5. Listar aquellos cursos sin inscripciones con cantidad 0.
select C.Nombre as Curso,
	   C.CostoCurso as Cursado,
	   C.CostoCertificacion as Certificacion,
	   count(distinct I.IDUsuario) as UsuariosInscriptos
from Cursos as C
join Inscripciones as I on I.IDCurso = C.ID
group by C.Nombre, C.CostoCurso, C.CostoCertificacion
having C.CostoCurso<10000 and count(distinct I.IDUsuario)<5


-- 24  Listado con Nombre del curso, fecha de estreno y nombre del nivel del curso que más recaudó en concepto de certificaciones.
select top 1 
	   C.Nombre as Curso,
	   C.Estreno,
	   N.Nombre as Nivel,
	   sum(Cer.Costo) as MaxRecaudacionCertificaciones
from Cursos as C
join Niveles as N on N.ID = C.IDNivel
join Inscripciones as I on I.IDCurso = C.ID
join Certificaciones as Cer on Cer.IDInscripcion = I.ID
group by C.Nombre, C.Estreno, N.Nombre
order by sum(Cer.Costo) desc


-- 25  Listado con Nombre del idioma del idioma más utilizado como subtítulo.
select top 1
	   I.Nombre as Idioma,
	   count(IxC.IDTipo) as Cantidad
from Idiomas as I
join Idiomas_x_Curso as IxC on IxC.IDIdioma = I.ID
join TiposIdioma as TI on TI.ID = IxC.IDTipo
group by I.Nombre
order by count(IxC.IDTipo) desc



-- 26  Listado con Nombre del curso y promedio de puntaje de reseñas apropiadas.
select C.Nombre as Curso,
	   avg(R.Puntaje) as PromedioPuntaje
from Cursos as C
join Inscripciones as I on I.IDCurso = C.ID
join Reseñas as R on R.IDInscripcion = I.ID
where R.Inapropiada = 0
group by C.Nombre

-- 27  Listado con Nombre de usuario y la cantidad de reseñas inapropiadas que registró.
select U.NombreUsuario,
	   count(R.Inapropiada) as ReseñasInapropiadas
from Usuarios as U
join Inscripciones as I on I.IDUsuario = U.ID
join Reseñas as R on R.IDInscripcion = I.ID
where R.Inapropiada = 1
group by U.NombreUsuario


-- 28  Listado con Nombre del curso, nombre y apellidos de usuarios y la cantidad de veces que dicho usuario realizó dicho curso.
--     No mostrar cursos y usuarios que contabilicen cero.
select C.Nombre as Curso, U.ID,
	   DP.Apellidos,
	   DP.Nombres,
	   count(I.IDCurso) as 'Cantidad de veces que cursó'
from Datos_Personales as DP
join Usuarios as U on U.ID = DP.ID
join Inscripciones as I on I.IDUsuario = U.ID
join Cursos as C on C.ID = I.IDCurso
group by C.Nombre, U.ID, DP.Apellidos, DP.Nombres
order by C.Nombre asc, DP.Apellidos asc, DP.Nombres


-- 29  Listado con Apellidos y nombres, mail y duración total en concepto de clases de cursos a los que se haya inscripto. 
--	   Sólo listar información de aquellos registros cuya duración total supere los 400 minutos.
select Dat.Apellidos,
	   Dat.Nombres,
	   Dat.Email,
	   sum(Cla.Duracion) as DuracionClases
from Datos_Personales as Dat
join Usuarios as U on U.ID = Dat.ID
join Inscripciones as I on I.IDUsuario = U.ID
join Cursos as C on C.ID = I.IDCurso
join Clases as Cla on Cla.IDCurso = C.ID
group by Dat.Apellidos, Dat.Nombres, Dat.Email
having	sum(Cla.Duracion)>400


-- 30  Listado con nombre del curso y recaudación total. La recaudación total consiste en la sumatoria de costos de inscripción y de certificación. 
--	   Listarlos ordenados de mayor a menor por recaudación.
select C.Nombre as Curso,
	   sum(I.Costo) as Recaudacion
from Cursos as C
join Inscripciones as I on I.IDCurso=C.ID
left join Certificaciones as Cer on Cer.IDInscripcion = I.ID
group by C.Nombre
order by Recaudacion desc
