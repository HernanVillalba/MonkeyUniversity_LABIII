Use MonkeyUniversity
go
Create table Usuarios(
	ID int not null,
	Nombre varchar(50) not null,
	constraint PK_USU_ID primary key(ID)
)
go
create table Instructores(
	IDUsuario int not null,
	IDCurso smallint not null,
	constraint FK_INS_IDUSU foreign key(IDUsuario) references Usuarios(ID),
	constraint FK_INS_IDCUR foreign key(IDCurso) references Cursos(ID_Curso)
)
ALTER TABLE Instructores
ADD constraint PK_INS_IDS primary key(IDUsuario,IDCurso)
go
Create table Nacionalidad(
	ID tinyint not null,
	Nombre Varchar(30) not null
	constraint PK_NAC_ID primary key(ID)
)
go
Create table Info_Personal(
	ID int not null,
	IDUsuario int not null,
	Nombres varchar(50) not null,
	Apellidos varchar(50) not null,
	FechaNac datetime not null,
	Mail varchar(100) null,
	Genero varchar(1) not null,
	Celular int null,
	Domicilio varchar(150) not null,
	CP int not null,
	IDNacionalidad tinyint not null
	constraint PK_INF_IDIDUSU primary key(ID, IDUsuario),
	constraint FK_INF_IDUSU foreign key(IDUsuario) references Usuarios(ID),
	constraint FK_INF_IDNAC foreign key(IDNacionalidad) references Nacionalidad(ID)
)
go
Create table Inscripciones(
	ID int not null,
	IDCurso smallint not null,
	IDUsuario int not null,
	FechaIns datetime not null,
	constraint PK_INST_ID primary key(ID),
	constraint FK_INST_IDCUR foreign key(IDCurso) references Cursos(ID_Curso),
	constraint FK_INST_IDUSU foreign key(IDUsuario) references Usuarios(ID)
)
go
create table Pagos(
	IDInscripcion int not null,
	Fecha1 datetime null,
	Pago1 money null,
	Fecha2 datetime null,
	Pago2 money null,
	Fecha3 datetime null,
	Pago3 money null,
	constraint FK_PAG_IDINS foreign key(IDInscripcion) references Inscripciones(ID)
)
go
create table Reseñas(
	ID int not null,
	IDInscripcion int not null,
	Reseña varchar(500) not null,
	constraint PK_RES_ID primary key(ID),
	constraint FK_RES_IDINS foreign key(IDInscripcion) references Inscripciones(ID)
)
go
create table Certificaciones(
	IDInscripcion int not null,
	Fecha datetime not null,
	Costo money not null,
	constraint FK_CERT_IDINS foreign key(IDInscripcion) references Inscripciones(ID)
)
/*
use MonkeyUniv
drop database MonkeyUniversity
*/