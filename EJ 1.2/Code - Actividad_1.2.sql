Create database MonkeyUniversity
go
use MonkeyUniversity

--Tabla NIVEL con sus restricciones
go
create table Nivel(
	ID_Nivel tinyint not null check(ID_Nivel>0),
	Nombre varchar(30) not null
)
go
alter table Nivel 
add constraint PK_Nivel_ID primary key(ID_Nivel)
go

--Tabla "CURSOS" con sus restricciones--
create table Cursos(
	ID_Curso smallint identity(1,1),
	Nombre varchar(50) not null,
	Fec_Estreno datetime not null,
	ID_Nivel tinyint null,
)
go
alter table Cursos 
add constraint PK_ID_Curso primary key(ID_Curso)
go
alter table Cursos 
add constraint FK_Cursos_Nivel foreign key(ID_Nivel) references Nivel(ID_Nivel)

--Tabla "COSTOS" con sus restricciones--
go
create table Costos(
	ID_Curso smallint not null,
	Cursado smallmoney not null check(Cursado>=0),
	Certificacion smallmoney not null check(Certificacion>0)
)
go
alter table Costos 
add constraint PK_Costos_IDCurso primary key(ID_Curso)
go
alter table Costos 
add constraint FK_Costos_IDCurso foreign key(ID_Curso) references Cursos(ID_Curso)

--Tabla "CATEGORIAS" con sus restricciones
go
create table Categorias(
	ID_Cat smallint not null check(ID_Cat>0),
	Nombre varchar(30) not null
)
go
alter table Categorias
add constraint PK_Cat_IDCat primary key(ID_Cat)

--Tabla "CATEGORIAS_X_CURSO" con sus restricciones--
go
create table Categorias_x_Curso(
	ID_Cat smallint not null,
	ID_Curso smallint not null,
)
go
alter table Categorias_x_Curso 
add constraint PK_Cat_x_Cur_Compuesta primary key(ID_Cat,ID_Curso)
go
alter table Categorias_x_Curso 
add constraint FK_Cat_x_Cur_IDCat foreign key(ID_cat) references Categorias(ID_Cat)
go 
alter table Categorias_x_Curso 
add constraint FK_Cat_x_Cur_IDCurso foreign key(ID_Curso) references Cursos(ID_Curso)

--Tabla "IDIOMA" con sus restricciones--
go
create table Idioma(
	ID_Idioma smallint identity (1,1),
	Nombre varchar(30) not null
)
go 
alter table Idioma 
add constraint PK_Idioma_IDIdioma primary key(ID_Idioma)

--Tabla "AUDIO_SUB" con sus restricciones--
go
create table Audio_Sub(
	ID_Curso smallint not null,
	ID_Audio smallint not null,
	ID_Sub smallint not null
)
go
alter table Audio_Sub 
add constraint PK_AudSub_Compuesta primary key(ID_Curso, ID_Audio, ID_Sub)
go
alter table Audio_Sub 
add constraint FK_AudSub_IDCurso foreign key(ID_Curso) references Cursos(ID_Curso)
go
alter table Audio_Sub 
add constraint FK_AudSub_IDAudio foreign key(ID_Audio) references Idioma(ID_Idioma)
go
alter table Audio_Sub 
add constraint FK_Aud_Cur_IDSub foreign key(ID_Sub) references Idioma(ID_Idioma)

--Tabla "CLASES" + restricciones
go
create table Clases(
	ID_Clase smallint identity(1,1),
	ID_Curso smallint not null, check(ID_Curso > 0),
	Nombre varchar(30) not null,
	Numero tinyint not null check(Numero>0),
	Duracion tinyint not null check(Duracion>0)
)
go
alter table Clases 
add constraint PK_Clases_IDClase primary key(ID_Clase)
go 
alter table Clases
add constraint FK_Clases_IDCurso foreign key(ID_Curso) references Cursos(ID_Curso)

--Tabla "TIPO_CONTENIDO" con sus restricciones--
go
create table Tipo_Contenido(
	ID_Tipo_Contenido smallint identity(1,1),
	Tipo varchar(30) not null
)
go
alter table Tipo_Contenido 
add constraint PK_TipCont_IDTipCont primary key(ID_Tipo_Contenido)

--Tabla "CONTENIDOS" + restricciones
go
create table Contenidos(
	ID_Clase smallint,
	ID_Contenido smallint not null,
	ID_Tipo_Contenido smallint,
	Tamaño_MB smallint check(Tamaño_MB>0)
)
go
alter table Contenidos 
add constraint PK_Cont_IDCont primary key(ID_Contenido)
go
alter table Contenidos
add constraint FK_Cont_IDClase foreign key(ID_Clase) references Clases(ID_Clase)
go
alter table Contenidos 
add constraint FK_Cont_IDTipCont foreign key(ID_Tipo_contenido) references Tipo_Contenido(ID_Tipo_Contenido)

/
use Videojuegos
drop Database MonkeyUniversity
*/
