Use MonkeyUniv

-- (1)  Listado con apellidos y nombres de los usuarios que no se hayan inscripto a cursos durante el año 2019.
select Dat.ID, Dat.Apellidos, Dat.Nombres from Datos_Personales as Dat
where Dat.ID not in (
	select distinct IdUsuario from Inscripciones
	where year(Fecha) = 2019
)

-- 2  Listado con apellidos y nombres de los usuarios que se hayan inscripto a cursos pero no hayan realizado ningún pago.
select Dat.Apellidos, Dat.Nombres
from Datos_Personales as Dat
where Dat.Id in(
	select distinct ID from Inscripciones as I
	where I.ID  not in(
		select IdInscripcion from Pagos	
	)
)

-- 3  Listado de países que no tengan usuarios relacionados.
select * from Paises as P
where P.ID not in(
	select distinct IdPais from Datos_Personales as Dat
)

-- (4)  Listado de clases cuya duración sea mayor a la duración promedio.
select C.Nombre,C.Duracion
from Clases as C
where C.Duracion > (
	  select avg(Duracion) from Clases
)

-- (5)  Listado de contenidos cuyo tamaño sea mayor al tamaño de todos los contenidos de tipo 'Audio de alta calidad'.
select * from Contenidos
where Tamaño > (
	select Max(C.Tamaño) from Contenidos as C
	join TiposContenido	as TC on TC.ID = C.IDTipo
	where TC.Nombre = 'Audio de alta calidad'
)

-- 6  Listado de contenidos cuyo tamaño sea menor al tamaño de algún contenido de tipo 'Audio de alta calidad'.
select * from Contenidos
where Tamaño < (
	select max(C.Tamaño) from Contenidos as C
	join TiposContenido as TP on TP.ID=C.IDTipo
	where TP.Nombre = 'Audio de alta calidad'
)


-- (7)  Listado con nombre de país y la cantidad de usuarios de género masculino y la cantidad de usuarios de género femenino que haya registrado.
select P.Nombre,
(
	select count(*) from Datos_Personales as DP 
	where Genero = 'F' and DP.IDPais = P.ID
) as CantF,
(
	select count(*) from Datos_Personales as DP 
	where Genero = 'M' and DP.IDPais = P.ID
) as CantM
from Paises as P

-- 8  Listado con apellidos y nombres de los usuarios y la cantidad de inscripciones realizadas en el 2019 y la cantidad de inscripciones realizadas en el 2020.
Select DP.Id, DP.Apellidos, Dp.Nombres,
(
	select count(*) from Inscripciones as I
	where DP.ID=I.IDUsuario and year(I.Fecha)=2019
) as Cant2019,
(
	select count(*) from Inscripciones as I
	where DP.ID=I.IDUsuario and year(I.Fecha)=2020
) as Cant2020
from Datos_Personales as DP

-- 9  Listado con nombres de los cursos y la cantidad de idiomas de cada tipo. Es decir, la cantidad de idiomas de audio, 
--	  la cantidad de subtítulos y la cantidad de texto de video.
select C.Nombre,
(
	select count(*) from Idiomas_x_Curso as IxC
	join TiposIdioma as TI on TI.ID = IxC.IDTipo
	where TI.Nombre = 'Audio' and IxC.IDCurso = C.ID
)as CantAudio,
(
	select count(*) from Idiomas_x_Curso as IxC
	join TiposIdioma as TI on TI.ID=IxC.IDTipo
	where TI.Nombre = 'Subtítulo' and IxC.IDCurso=C.ID
) as CantSub,
(
	select count(*) from Idiomas_x_Curso as IxC
	join TiposIdioma as TI on TI.ID = IxC.IDTipo
	where TI.Nombre = 'Texto del video'
) as CantTextoVideo
from Cursos as C

select*from TiposIdioma
select*from Idiomas_x_Curso as IxC where IxC.IDTipo=2

-- 10  Listado con apellidos y nombres de los usuarios, nombre de usuario y cantidad de cursos de nivel 'Principiante' que realizó y cantidad de cursos de nivel 'Avanzado' que realizó.
select DAT.Apellidos, DAT.Nombres,
(
	select count(*)	from Niveles as N
	join Cursos as C on C.IDNivel=N.ID
	join Inscripciones as I on I.IDCurso=C.ID
	where DAT.ID=I.IDUsuario and N.Nombre='Principiante'
) as CantPrincipiantes,
(
	select count(*) from Niveles as N
	join Cursos as C on C.IDNivel=N.ID
	join Inscripciones as I on I.IDCurso=C.ID
	where DAT.ID=I.ID and N.Nombre='Avanzado'
) as CantAvanzado
from Datos_Personales as DAT

-- 11  Listado con nombre de los cursos y la recaudación de inscripciones de usuarios de género femenino que se inscribieron y la recaudación de inscripciones de usuarios de género masculino.
select C.Nombre,
(
	select isnull(sum(I.Costo),0) from Inscripciones as I
	join Datos_Personales as DAT on DAT.ID=I.IDUsuario
	where DAT.Genero='F' and C.ID=I.IDCurso
)	as CantF,
(
	select isnull(sum(I.Costo),0) from Inscripciones as I
	join Datos_Personales as DAT on DAT.ID=I.IDUsuario
	where DAT.Genero='M'and C.ID=I.IDCurso
)	as CantM
from Cursos as C

-- 12  Listado con nombre de país de aquellos que hayan registrado más usuarios de género masculino que de género femenino.
select AUX.Nombre as Pais from (
	select P.Nombre,
	(
		 select count(*) from Datos_Personales as DAT
		 where DAT.Genero='F' and P.ID=DAT.IDPais
	) as CantF,
	(
		select count(*) from Datos_Personales as DAT
		where DAT.Genero='M' and DAT.IDPais=P.ID
	) as CantM
	from Paises as P
) as AUX
where AUX.CantM > AUX.CantF

-- 13  Listado con nombre de país de aquellos que hayan registrado más usuarios de género masculino que de género femenino 
--	   pero que haya registrado al menos un usuario de género femenino.
select AUX.Nombre as Pais from
(
	select P.Nombre,
	(
		select count(*) from Datos_Personales as DAT
		where DAT.Genero='F' and DAT.IDPais=P.ID
	) as CantF,
	(
		select count(*) from Datos_Personales as DAT
		where DAT.Genero='M' and DAT.IDPais=P.ID
	) as CantM
	from Paises as P
) as AUX
where AUX.CantM>AUX.CantF and AUX.CantF>0

-- 14  Listado de cursos que hayan registrado la misma cantidad de idiomas de audio que de subtítulos.
select AUX.Nombre as 'Cursos con más audios que subtitulos' from
(
	select C.Nombre,
	(
		select count(*) from TiposIdioma as TI
		join Idiomas_x_Curso as IxC on IxC.IDCurso=C.ID
		where TI.Nombre='Audio' and TI.ID=IxC.IDTipo
	) as CantAudio,
	(
		select count(*) from TiposIdioma as TI
		join Idiomas_x_Curso as IxC on IxC.IDTipo=TI.ID
		where TI.Nombre='Subtítulo' and IxC.IDCurso=C.ID

	) as CantSub
	from Cursos as C

) as AUX
where AUX.CantAudio=AUX.CantSub

-- 15  Listado de usuarios que hayan realizado más cursos en el año 2018 que en el 2019 y a su vez más cursos en el año 2019 que en el 2020.
select AUX.Apellidos,AUX.Nombres from
(
	select DAT.Apellidos, DAT.Nombres,
	(
		select count(*) from Inscripciones as I
		where I.IDUsuario=DAT.ID and year(I.Fecha)=2018
	) as Cant18,
	(
		select count(*) from Inscripciones as I
		where I.IDUsuario=DAT.ID and year(I.Fecha)=2019
	) as Cant19,
	(
		select count(*) from Inscripciones as I
		where I.IDUsuario=DAT.ID and year(I.Fecha)=2020
	) as Cant20
	from Datos_Personales as DAT
) as AUX
where AUX.Cant18>AUX.Cant19 and AUX.Cant19>AUX.Cant20

-- 16  Listado de apellido y nombres de usuarios que hayan realizado cursos pero nunca se hayan certificado.
--(Forma 1)
select AUX.Apellidos,AUX.Nombres from
(
	select DAT.ID as IDUsuario, DAT.Apellidos, DAT.Nombres,
	(
		select count(*) from Inscripciones as I
		where DAT.ID=I.IDUsuario
	) as CantIns,
	(
		select isnull(count(*),0) from Certificaciones as CER
		join Inscripciones as I on I.ID=CER.IDInscripcion
		where DAT.ID=I.IDUsuario
	) as CantCerti
	from Datos_Personales as DAT
) as AUX
where AUX.CantIns>0 and AUX.CantCerti=0

-----------------------------------------------------------------------------------------
--(Forma 2)
select DAT.ID, DAT.Apellidos, DAT.Nombres
from Datos_Personales as DAT
where DAT.ID in
(
	select I.IDUsuario from Inscripciones as I
	where I.ID not in
	(
		select C.IDInscripcion from Certificaciones as C
	)
)