use MODELOPARCIAL2_PUNTO2

/*
A) El ganador del torneo es aquel que haya capturado el pez más pesado entre todos los
peces siempre y cuando se trate de un pez no descartado. Puede haber más de un ganador
del torneo. Listar Apellido y nombre, especie de pez que capturó y el pesaje del mismo.*/
select top 1 with ties PA.APELLIDO, PA.NOMBRE, ESP.ESPECIE, max(PE.PESO) 
from PESCA as PE
join ESPECIES as ESP on ESP.IDESPECIE=PE.IDESPECIE
join PARTICIPANTES as PA on PA.IDPARTICIPANTE=PE.IDPARTICIPANTE
group by PA.APELLIDO,PA.NOMBRE, ESP.ESPECIE
order by max(PE.PESO) desc

/*
B) Listar todos los participantes que no hayan pescado ningún tipo de bagre. (ninguna
especie cuyo nombre contenga la palabra "bagre"). Listar apellido y nombre.*/
select AUX.APELLIDO, AUX.NOMBRE from(
	select PA.APELLIDO, PA.NOMBRE,
	(
		select count(*) from ESPECIES as E
		join PESCA as PE on PE.IDESPECIE=E.IDESPECIE
		where E.ESPECIE like '%bagre%' and PE.IDPARTICIPANTE=PA.IDPARTICIPANTE
	) as cantBagres
	from PARTICIPANTES as PA
) as AUX
where AUX.cantBagres=0


/*
C) Listar los participantes cuyo promedio de pesca (en kilos) sea mayor a 30. Listar apellido,
nombre y promedio de kilos. ATENCIÓN: No tener en cuenta los peces descartados.*/select PA.APELLIDO, PA.NOMBRE, avg(PE.PESO) as PesoPromediofrom PARTICIPANTES as PAjoin PESCA as PE on PE.IDPARTICIPANTE=PA.IDPARTICIPANTEjoin ESPECIES as E on E.IDESPECIE=PE.IDESPECIEgroup by PA.APELLIDO, PA.NOMBREhaving avg(PE.PESO) > 30/*D) Por cada especie listar la cantidad de veces que han sido capturadas por un pescador
durante la noche. (Se tiene en cuenta a la noche como el horario de la competencia entre las
21pm y las 5am -ambas inclusive-).*/select E.ESPECIE, count(PE.IDESPECIE) as Cantfrom PESCA as PEjoin ESPECIES as E on PE.IDESPECIE=E.IDESPECIEwhere  (DATEPART(hour, PE.FECHA_HORA) between 21 and 24) or  DATEPART(hour, PE.FECHA_HORA) between 0 and 5group by E.ESPECIE/*E) Por cada participante, listar apellido, nombres, la cantidad de peces no descartados y la
cantidad de peces descartados que capturó.*/select PA.APELLIDO, PA.NOMBRE,(	select count(*)	from PESCA as PE	where PE.IDESPECIE is null and PE.IDPARTICIPANTE=PA.IDPARTICIPANTE) as Descartados,(	select count(*)	from PESCA as PE	join ESPECIES as E on E.IDESPECIE=PE.IDESPECIE	where PE.IDPARTICIPANTE=PA.IDPARTICIPANTE) as NoDescartadosfrom PARTICIPANTES as PA/*F) Listar apellido y nombre del participante y nombre de la especie de cada pez que haya capturado el pescador/a. 
Si alguna especie de pez no ha sido pescado nunca entonces deberá aperecer en el listado de todas formas pero sin datos de pescador. 
El listado debe aparecer ordenado por nombre de especie de manera creciente. La combinación apellido,nombre y nombre de la especie debe aparecer sólo una vez en este listado.*/select PA.APELLIDO, PA.NOMBRE, E.ESPECIE, count(*) as cant from ESPECIES as Eleft join PESCA as PE on PE.IDESPECIE=E.IDESPECIEleft join PARTICIPANTES as PA on PA.IDPARTICIPANTE=PE.IDPARTICIPANTEgroup by PA.APELLIDO, PA.NOMBRE, E.ESPECIEorder by E.ESPECIE asc