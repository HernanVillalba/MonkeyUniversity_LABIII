Use MonkeyUniv
-- (1) Listado con nombre de usuario de todos los usuarios y sus respectivos nombres y apellidos.
select U.NombreUsuario as Usuario, 
	   DAT.Nombres, 
	   DAT.Apellidos
from Usuarios as U
inner join Datos_Personales as DAT on U.ID=DAT.ID

-- Lo que realiza la cláusula join en memoria
Select *
From Usuarios as U
Inner Join Datos_Personales as DAT ON U.ID = DAT.ID


-- 2 Listado con apellidos, nombres, fecha de nacimiento y nombre del país de nacimiento. 
select DP.Apellidos, DP.Nombres, DP.Nacimiento, P.Nombre as PaisNac
from Datos_Personales as DP
inner join Paises as P on DP.IDPais = P.ID

-- (3) Listado con nombre de usuario, apellidos, nombres, email o celular de todos los usuarios que vivan en una domicilio cuyo nombre contenga el término 'Presidente' o 'General'. NOTA: Si no tiene email, obtener el celular.
select U.NombreUsuario as Usuario,
	   DP.Apellidos, DP.Nombres, 
	   isnull(DP.Email, DP.Celular) as Contacto, 
	   DP.Domicilio
from Usuarios as U
inner join Datos_Personales as DP on U.ID = DP.ID
where DP.Domicilio like '%Presidente%' or DP.Domicilio like '%General%'



-- 4 Listado con nombre de usuario, apellidos, nombres, email o celular o domicilio como 'Información de contacto'.  NOTA: Si no tiene email, obtener el celular y si no posee celular obtener el domicilio.
select U.NombreUsuario as Usuario, DAT.Apellidos, DAT.Nombres, coalesce(DAT.EMail, DAT.Celular, DAT.Domicilio) as InfoContacto
From Usuarios as U
inner join Datos_Personales as DAT on U.ID = DAT.ID

-- (5) Listado con apellido y nombres, nombre del curso y costo de la inscripción de todos los usuarios inscriptos a cursos.  NOTA: No deben figurar los usuarios que no se inscribieron a ningún curso.
select Dat.Apellidos,
	   Dat.Nombres,
	   C.Nombre as Curso, 
	   I.Costo as CostoIns
from Cursos as C
inner join Inscripciones as I on C.ID = I.IDCurso
inner join Usuarios as U on I.IDUsuario=U.ID
inner join Datos_Personales as Dat on U.ID = Dat.ID
order by C.Nombre asc, Dat.Apellidos asc, Dat.Nombres

-- Ejemplo de Union
select DAT.Apellidos, DAT.Nombres, 'Estudiante' as Rol
From Cursos as C
Inner Join Inscripciones as I ON C.ID = I.IDCurso
Inner Join Usuarios as U ON U.ID = I.IDUsuario
Inner Join Datos_Personales as DAT ON DAT.ID = U.ID
Where C.ID = 11
Union All
select DAT.Apellidos, DAT.Nombres, 'Instructor' as Rol
From Cursos as C
Inner Join Instructores_x_Curso as IxC on IxC.IDCurso = C.ID
Inner Join Usuarios as U ON U.ID = IxC.IDUsuario
Inner Join Datos_Personales as DAT ON DAT.ID = U.ID
Where C.ID = 11

-- 6 Listado con nombre de curso, nombre de usuario y mail de todos los inscriptos a cursos que se hayan estrenado en el año 2020.
select 	C.Nombre as Curso,
		C.Estreno,
		U.NombreUsuario as Usuario, 
		Dat.Email
From Inscripciones as I
inner join Cursos as C on I.IDCurso=C.ID
inner join Usuarios as U on I.ID=U.ID
inner join Datos_Personales as Dat on U.ID = Dat.ID
where year(C.Estreno)=2020

-- 7 Listado con nombre de curso, nombre de usuario, apellidos y nombres, fecha de inscripción, costo de inscripción, fecha de pago e importe de pago. Sólo listar información de aquellos que hayan pagado
select C.Nombre as Curso,
	   U.NombreUsuario as Usuario,
	   Dat.Apellidos,
	   Dat.Nombres,
	   I.Fecha as 'Fecha Inscripcion',
	   P.Fecha as 'Fecha Pago',
	   P.Importe
from Inscripciones as I
inner join Pagos as P on I.ID=P.IDInscripcion
inner join Cursos as C on I.IDCurso=C.ID
inner join Usuarios as U on I.IDUsuario=U.ID
inner join Datos_Personales as Dat on U.ID=Dat.ID
order by Dat.Apellidos asc,Dat.Nombres asc, P.Fecha asc


-- 8 Listado con nombre y apellidos, genero, fecha de nacimiento, mail, nombre del curso y fecha de certificación de todos aquellos usuarios que se hayan certificado.
select Dat.Apellidos,
	   Dat.Nombres,
	   Dat.Genero,
	   Dat.Nacimiento as FechaNac,
	   Dat.Email as Mail,
	   C.Nombre as Curso,
	   Cer.Fecha as FechaCertificacion
From Certificaciones as Cer
inner join Inscripciones as I on Cer.IDInscripcion=I.ID
inner join Usuarios as U on I.IDUsuario=U.ID
inner join Datos_Personales as Dat on U.ID=Dat.ID
inner join Cursos as C on I.IDCurso=C.ID
order by Dat.Apellidos asc, Dat.Nombres asc

-- 9 Listado de cursos con nombre, costo de cursado y certificación, costo total (cursado + certificación) con 10% de todos los cursos de nivel Principiante.
select C.Nombre,
	   C.CostoCurso,
	   C.CostoCertificacion,
	   iif(C.IDNivel=5, (C.CostoCertificacion+C.CostoCurso)*1.1, C.CostoCertificacion+C.CostoCurso) as CostoTotal
from Cursos as C
inner join Niveles as N on C.IDNivel=N.ID

-- 10 Listado con nombre y apellido y mail de todos los instructores. Sin repetir.
select distinct
	   Dat.Apellidos, 
	   Dat.Nombres,
	   Dat.Email
from Instructores_x_Curso as IC
inner join Usuarios as U on IC.IDUsuario=U.ID
inner join Datos_Personales as Dat on U.ID=Dat.ID

use MonkeyUniv
-- 11 Listado con nombre y apellido de todos los usuarios que hayan cursado algún curso cuya categoría sea 'Historia'.
select Dat.Apellidos,
	   Dat.Nombres
from Inscripciones as I
inner join Usuarios as U on I.IDUsuario=U.ID
inner join Datos_Personales as Dat on U.ID=Dat.ID
inner join Cursos as C on I.IDCurso=C.ID
inner join Categorias_x_Curso as CxC on CxC.IDCurso=C.ID
inner join Categorias as Cat on CxC.IDCategoria=Cat.ID
--where Cat.Nombre like 'Historia'
where Cat.Nombre = 'Historia'
order by Dat.Apellidos asc, Dat.Nombres asc

-- (12) Listado con nombre de idioma, código de curso y código de tipo de idioma. Listar todos los idiomas indistintamente si no tiene cursos relacionados.
Select I.Nombre, 
	   IxC.IDCurso,
	   IxC.IDTipo
From Idiomas as I
left Join Idiomas_x_Curso as IxC on I.ID = IxC.IDIdioma

-- 13 Listado con nombre de idioma de todos los idiomas que no tienen cursos relacionados.
select I.Nombre
from Idiomas as I
left join Idiomas_x_Curso as IxC on I.ID=IxC.IDIdioma
where IxC.IDCurso is null

-- 14 Listado con nombres de idioma que figuren como audio de algún curso. Sin repeticiones.
select distinct I.Nombre
from Idiomas_x_Curso as IxC
inner join Cursos as C on IxC.IDCurso=C.ID
inner join Idiomas as I on IxC.IDIdioma=I.ID
inner join TiposIdioma as TI on IxC.IDTipo=TI.ID
--where TI.Nombre like 'Audio'
where TI.ID=2

-- (15) Listado con nombres y apellidos de todos los usuarios y el nombre del país en el que nacieron. Listar todos los países indistintamente si no tiene usuarios relacionados.
select Dat.Apellidos, Dat.Nombres, P.Nombre as Pais
from Datos_Personales as Dat
right join Paises as P on Dat.IDPais=P.ID
Order by Dat.Apellidos asc, Dat.Nombres asc

use monkeyUniv
-- 16 Listado con nombre de curso, fecha de estreno y nombres de usuario de todos los inscriptos. Listar todos los nombres de usuario indistintamente si no se inscribieron a ningún curso.
select C.Nombre as Curso,
	   C.Estreno,
	   U.NombreUsuario as Usuario
from Inscripciones as I
inner join Cursos as C on I.IDCurso=C.ID
right join Usuarios as U on I.IDUsuario=U.ID
inner join Datos_Personales as DP on U.ID=DP.ID

-- 17 Listado con nombre de usuario, apellido, nombres, género, fecha de nacimiento y mail de todos los usuarios que no cursaron ningún curso.
select U.NombreUsuario,
	   Dat.Apellidos,
	   Dat.Nombres,
	   Dat.Genero,
	   Dat.Nacimiento,
	   Dat.Email
from Inscripciones as I
right join Usuarios as U on I.IDUsuario=U.ID
join Datos_Personales as Dat on U.ID=Dat.ID
where I.IDCurso is null
order by Dat.Apellidos asc, Dat.Nombres asc


-- 18 Listado con nombre y apellido, nombre del curso, puntaje otorgado y texto de la reseña. Sólo de aquellos usuarios que hayan realizado una reseña inapropiada.
select Dat.Apellidos,
	   Dat.Nombres,
	   C.Nombre as Curso,
	   R.Puntaje,
	   R.Observaciones
from  Inscripciones as I
join Usuarios as U on I.IDUsuario=U.ID
join Datos_Personales as Dat on U.ID=Dat.ID
join Cursos as C on I.IDCurso=C.ID
join Reseñas as R on I.ID=R.IDInscripcion
where R.Inapropiada=1

/* 19 Listado con nombre del curso, costo de cursado, costo de certificación, nombre del idioma y nombre del tipo de idioma de todos los cursos cuya fecha de estreno haya sido antes del año actual. 
      Ordenado por nombre del curso y luego por nombre de tipo de idioma. Ambos ascendentemente.*/
select C.Nombre as Curso,
       C.CostoCurso as CostoCursado,
	   C.CostoCertificacion,
	   I.Nombre as Idioma,
	   TI.Nombre as TipoIdioma,
	   C.Estreno
from Cursos as C
join Idiomas_x_Curso as IxC on IxC.IDCurso=C.ID
join Idiomas as I on I.ID=IxC.IDIdioma
join TiposIdioma as TI on TI.ID=IxC.IDTipo
where year(C.Estreno)<2020
order by Curso asc, TipoIdioma asc

-- 20 Listado con nombre del curso y todos los importes de los pagos relacionados.
select C.Nombre as Curso,
	   P.Importe
from Inscripciones as I
join Cursos as C on C.ID=I.IDCurso
right join Pagos as P on P.IDInscripcion=I.ID


/* 21 Listado con nombre de curso, costo de cursado y una leyenda que indique "Costoso" si el costo de cursado es mayor a $ 15000, 
      "Accesible" si el costo de cursado está entre $2500 y $15000, "Barato" si el costo está entre $1 y $2499 y "Gratis" si el costo es $0.*/
select C.Nombre as curso, C.CostoCurso,
	   case
	   when C.CostoCurso>=15000 then 'Costoso'
       when C.CostoCurso>=25000 then 'Accesible'
	   when C.CostoCurso>=1 then 'Barato'
	   else 'Gratis'
	   end as 'Cartel'
from Cursos	as C
order by C.Nombre
