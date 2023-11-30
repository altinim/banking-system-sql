create database E_Banking_Managment;

use E_Banking_Managment;

--INSTERTIMI I TE DHENAVE
create table Klienti(
	Nr_Personal int not null primary key,
	Emri varchar(20) not null,
	Mbiemri varchar(20) not null,
	Qyteti varchar(30) not null,
	EmriRruges varchar(50),
	Nr_Apartamentit int,
	DataLindjes date not null CHECK (DATEDIFF(year,DataLindjes,getdate()) >= 18),
	Emri_Departamentit varchar(30),
	foreign key(Emri_Departamentit) references Departamenti(Emri_Departamentit);
);
create table NumriTelefonit(
	Nr_Personal int not null,
	Nr_Telefonit varchar(10) not null unique,
	constraint NumriTelefonit_PK primary key(Nr_Personal,Nr_Telefonit),
	foreign key(Nr_Personal) references Klienti(Nr_Personal)
)
create table Llogaria(
	Nr_Llogarise int not null primary key,
	Bilanci money not null,
	Data_Skadimit date not null,
	Sesioni TIMESTAMP,
)
create table LlogariaIndividuale(
	Nr_Llogarise int not null references Llogaria(Nr_Llogarise),
	primary key(Nr_Llogarise),
	RataInteresit float not null,
	Emri_Individit varchar(20) not null,
	Id_Klienti int not null,
	foreign key(Id_Klienti) references Klienti(Nr_Personal)
)
create table LlogariaBiznesit(
	Nr_Llogarise int not null references Llogaria(Nr_Llogarise),
	primary key(Nr_Llogarise),
	Emri_Biznesit varchar(20) not null,
	Id_Klienti int not null,
	foreign key(Id_Klienti) references Klienti(Nr_Personal)
)

create table Punetori(
	Punetori_ID int not null primary key identity(1,1),
	Emri varchar(20) not null,
	Mbiemri varchar(20) not null,
	NrTelefonit varchar(10) not null unique,
	DataFillimit date not null,
)
create table Mirembajtsi(
	Mirembajtesi_ID int references Punetori(Punetori_ID),
	primary key(Mirembajtesi_ID),
	Lloji_Mirembatjes varchar(30),
)
create table Keshilltari(
	Keshilltari_ID int references Punetori(Punetori_ID),
	primary key(Keshilltari_ID),
	Lloji_Keshillit varchar(20),
	Mentori_ID int,
	constraint Mentori foreign key(Mentori_ID)references Punetori(Punetori_ID)
)
create table MirembajtesiLlogaria(
	Punetori_ID int,
	Nr_Llogarise int,
	constraint MirembajtesiLlogaria_PK primary key(Nr_Llogarise,Punetori_ID),

	foreign key(Nr_Llogarise) references Llogaria(Nr_llogarise),
	foreign key(Punetori_ID) references Punetori(Punetori_ID)
)
create table Departamenti(
	Emri_Departamentit varchar(30) primary key,
	Qyteti varchar(20) not null,
	Asetet varchar(30),
)
alter table Departamenti 
drop column Asetet;
create table Projekti(
	Projekti_ID int primary key,
	Emri_Departamentit_FK varchar(30) not null,
	foreign key(Emri_Departamentit_FK) references Departamenti(Emri_Departamentit)
)
create table Punon(
	Punetori_ID int not null,
	Projekti_ID int not null,
	Emri_Departamentit varchar(30) not null,
	primary key(Punetori_ID,Projekti_ID,Emri_Departamentit),
	foreign key(Punetori_ID) references Punetori(Punetori_ID),
	foreign key(Projekti_ID) references Projekti(Projekti_ID),
	foreign key(Emri_Departamentit) references Departamenti(Emri_Departamentit),	
)


create table Departamenti_Kujdesit(
	Departmenti_Kujdesit_FK varchar(30) references Departamenti(Emri_Departamentit),
	primary key(Departmenti_Kujdesit_FK),
	Lloji_Kujdesit varchar(30),

)
ALTER TABLE Departamenti_Kujdesit
drop column Lloji_Kujdesit;

create table Departamenti_Operimeve(
	Departamenti_Operimeve_PK varchar(30) references Departamenti(Emri_Departamentit),
	primary key(Departamenti_Operimeve_PK),
	Shuma_Operimit money not null,
)

create table Kredia(
	Nr_Kredise int primary key,
	Shuma money not null,
	Data_Marrjes date not null,
	Data_Perfundimit date,
	Nr_Personal_FK int,
	Emri_Departamentit_FK varchar(30),

	foreign key(Nr_Personal_FK) references Klienti(Nr_Personal),
	foreign key(Emri_Departamentit_FK) references Departamenti(Emri_Departamentit)
)

create table Pagesa(
	Nr_Pageses int not null identity(1,1),
	Nr_Kredise int not null,
	Shuma money not null,
	constraint Pagesa_ID primary key(Nr_Pageses,Nr_Kredise),
)
create table Transferi(
	Transferi_id int primary key identity(1,1),
	Llogaria_Pranuese int references Llogaria(Nr_Llogarise),
	Pershkrimi varchar(50),
	Shuma money,
)
create table LlogariaTransferet(
	Transferi_ID int,
	Nr_Llogarise int,
	constraint LlogariaTransferet_PK primary key(Nr_Llogarise,Transferi_ID),

	Data_Transferit date,
	foreign key(Nr_Llogarise) references Llogaria(Nr_llogarise),
	foreign key(Transferi_ID) references Transferi(Transferi_iD),
)
create table Kontrolla(
	 Nr_llogarise int,
	 Transferi int,
	 Emri_Departamentit varchar(30),

	 primary key(Nr_llogarise,Transferi,Emri_Departamentit),
	 foreign key(Emri_Departamentit) references Departamenti_Operimeve(Departamenti_Operimeve_PK),
	 foreign key(Nr_llogarise,Transferi) references LlogariaTransferet(Nr_Llogarise,Transferi_ID)
)
--INSEERTIMI I TE DHENAVE
SELECT * FROM Klienti;
INSERT	 INTO Klienti VALUES
	(84901, 'Emily','Johnson', 'Los Angeles', '5678 Park Ave', 82, '06/06/2005'),
	(84166, 'John', 'Smith', 'New York', '1234 Main St', 72 ,'01/01/2005'),
    (70235, 'Michael','Brown', 'Chicago', '9101 Oak St', 90, '01/03/1952'),
    (93847, 'Samantha','Williams', 'Houston', '1213 Pine St', 12, '01/04/1996'),
    (62617, 'Ashley','Taylor', 'Philadelphia', '1415 Cedar St', 63, '01/05/1990'),
    (55179, 'David','Anderson', 'Phoenix', '1617 Palm St', 15, '01/06/1996'),
    (51616, 'Jessica','Thomas', 'San Antonio', '1819 Maple St', 31, '01/07/1990'),
    (93501, 'James','Moore', 'San Diego', '2020 Birch St', 20, '01/08/1996'),
    (38290, 'Elizabeth','Jackson', 'Dallas', '2121 Cedar St', 96, '01/09/1996'),
    (64983, 'William','Thompson', 'San Jose', '2222 Pine St', 55, '01/10/1952'),
    (83740, 'Joseph','Martin', 'Austin', '2323 Oak St', 76, '01/11/1996'),
    (91345, 'Sarah ','Davis', 'Jacksonville', '2424 Cedar St', 82, '01/12/1996'),
    (39403, 'Christopher ','Garcia', 'Fort Worth', '2525 Palm St', 14, '01/13/1990'),
    (68174, 'Amanda','Rodriguez', 'Charlotte', '2626 Maple St', 81, '01/14/2000'),
    (40298, 'Matthew','Baker', 'Seattle', '2727 Birch St', 92, '01/15/2000'),
    (91357, 'Melissa','Jones', 'Denver', '2828 Cedar St', 35, '01/16/1990'),
    (84930, 'Robert','Taylor', 'El Paso', '2929 Palm St', 49, '01/17/1990'),
    (78106, 'Sara','Martinez', 'Washington', '3030 Maple St', 61, '01/18/1969'),
    (93572, 'William','Anderson', 'Boston', '3131 Birch St', 27, '01/19/1988'),
    (93825, 'Jessica','Jackson', 'Nashville', '3232 Cedar St', 82, '01/20/1990'),
    (93840, 'James','Davis', 'Portland', '3333 Palm St', 47, '01/21/1985'),
    (70239, 'Christopher','Martinez', 'Las Vegas', '3434 Maple St', 35, '01/22/2000'),
    (62311, 'Amanda','Baker', 'Oklahoma City', '3535 Birch St', 17, '01/23/1993'),
	(62317, 'Amanda','Baker', 'Oklahoma City','3535 Birch St', 17, '01/23/1990'),
	(50829, 'Samantha','Jones', 'Tucson','3636 Cedar S', 29, '01/24/1999'),
	(84176, 'Emily','Taylor', 'New Orleans', '3737 Palm St', 76, '01/25/2000');

SELECT * FROM NumriTelefonit;
INSERT	 INTO NumriTelefonit VALUES
	(84901,'044263901'),
	(84166,'049864471'),
	(70235,'045270936'),
	(93847,'045714852'),
	(62617,'049876822'),
	(55179,'044757387'),
	(51616,'049608565'),
	(93501,'045415392'),
	(38290,'045512743'),
	(64983,'045215984'),
	(83740,'044129082'),
	(91345,'049293093'),
	(39403,'049293092'),
	(68174,'049293012'),
	(40298,'049212097'),
	(91357,'049295090'),
	(84930,'049293078'),
	(78106,'049293065'),
	(93572,'049293054'),
	(93825,'049293006'),
	(93840,'049293056'),
	(70239,'049293067'),
	(62311,'049293456'),
	(62317,'049293123'),
	(50829,'049292078');

SELECT * FROM Departamenti;
INSERT	 INTO Departamenti values
	('Hapje_Llogarise','Prishtine'),
	('Mirembajte','Ferizaj'),
	('Resurseve_Humane','Malisheve'),
	('Fiancave','Ferizaj'),
	('Transfereve','Malisheve'),
	('Transfereve_Online','Prizren'),
	('Hapjes_Llogarise','Prishtine'),
	('Sigurise','Prizren'),
	('Privatesise','Malisheve'),
	('Kredise','Malisheve');

SELECT * FROM Departamenti_Kujdesit;
INSERT	 INTO Departamenti_Kujdesit values
	('Hapje_Llogarise'),
	('Mirembajte'),
	('Privatesise');

SELECT * FROM Departamenti_Operimeve;
INSERT	 INTO Departamenti_Operimeve values
	('Transfereve_Online',1000),
	('Transfereve',200),
	('Fiancave',500);


DBCC CHECKIDENT('Punetori', RESEED, 0);

SELECT * FROM Punetori;
INSERT	 INTO Punetori (Emri, Mbiemri, NrTelefonit,DataFillimit) VALUES 
	('Jessica', 'Smith','044-251212', '2022-01-01'),
	('Michael', 'Brown','044-892513', '2022-01-02'),
	('Jason', 'Williams','044-254256', '2022-01-03'),
	('Ashley', 'Jones','044-579124', '2022-01-04'),
	('Sarah', 'Miller', '044-251512', '2022-01-05'),
	('Christopher', 'Davis', '044-69196', '2022-01-06'),
	('Emily', 'Garcia', '044-25167', '2022-01-07'),
	('Matthew', 'Rodriguez', '044-457216', '2022-01-08'),
	('David', 'Martinez', '044-483168', '2022-01-09'),
	('James', 'Hernandez','044-721863', '2022-01-10'),
	('John', 'Lopez', '044-457316', '2022-01-11'),
	('Robert', 'Gonzalez', '044-762931', '2022-01-12'),
	('Elizabeth', 'Wilson', '044-741258', '2022-01-13'),
	('Samantha', 'Anderson', '044-598773', '2022-01-14'),
	('William', 'Thomas', '044-145632', '2022-01-15'),
	('Amanda', 'Jackson', '044-789132', '2022-01-16'),
	('Jessica', 'White', '044-753159', '2022-01-17'),
	('Christopher', 'Harris','044-325874', '2022-01-18'),
	('Emily', 'Martin','044-475121', '2022-01-19'),
	('Matthew', 'Thompson', '044-431462', '2022-01-20'),
	('David', 'Moore','044-452554', '2022-01-21'),
	('James', 'Taylor', '044-579212', '2022-01-22'),
	('John', 'Jackson', '044-821653', '2022-01-23'),
	('Robert', 'Harris', '044-751344', '2022-01-24'),
	('Elizabeth', 'Martin', '044-973128', '2022-01-25');

SELECT * FROM Projekti;
INSERT	 INTO Projekti VALUES
	(1,'Hapje_Llogarise'),
	(2,'Fiancave'),
	(3,'Fiancave'),
	(4,'Sigurise'),
	(5,'Sigurise');

SELECT * FROM Punon;
INSERT	 INTO Punon VALUES 
	(05,1,'Fiancave'),
	(06,1,'Fiancave'),
	(07,1,'Fiancave'),
	(01,1,'Fiancave'),
	(19,1,'Fiancave'),
	(20,1,'Fiancave'),
	(11,1,'Fiancave'),
	(12,1,'Fiancave'),
	(10,2,'Transfereve'),
	(11,2,'Transfereve'),
	(12,2,'Transfereve'),
	(13,2,'Transfereve'),
	(14,2,'Transfereve'),
	(15,2,'Transfereve'),
	(18,2,'Transfereve'),
	(24,2,'Transfereve_Online'),
	(00,2,'Transfereve_Online'),
	(22,2,'Transfereve_Online'),
	(21,2,'Transfereve_Online'),
	(16,2,'Transfereve_Online'),
	(19,2,'Transfereve_Online'),
	(01,3,'Sigurise'),
	(21,3,'Sigurise'),
	(01,4,'Sigurise'),
	(18,4,'Sigurise'),
	(17,4,'Sigurise');

SELECT * FROM Keshilltari
INSERT	 INTO Keshilltari VALUES
	(01,'Operimeve',01),
	(15,'Fiancave',15)	,
	(09,'Fiancave',09);

SELECT * FROM Mirembajtsi;
INSERT	 INTO Mirembajtsi VALUES
	(01,'Transfereve'),
	(09,'Fiancave'),
	(18,'Transfereve');

SELECT * FROM Llogaria;
INSERT	 INTO Llogaria VALUES
	(151706,506.60,DATEADD(YEAR,4,	CONVERT(DATE ,'2021-07-01')),null),
	(509486,5061.65,DATEADD(YEAR,4,	CONVERT(DATE ,'2022-03-17')),null),
	(382957,550.25,DATEADD(YEAR,4,	CONVERT(DATE ,'2022-07-20')),null),
	(102949,5325.20,DATEADD(YEAR,4,	CONVERT(DATE ,'2020-05-17')),null),
	(449215,5301.00,DATEADD(YEAR,4, CONVERT(DATE ,'2020-05-07')),null),
	(559249,139355.5,DATEADD(YEAR,4,CONVERT(DATE ,'2020-05-17')),null),
	(330928,5306.00,DATEADD(YEAR,4, CONVERT(DATE ,'2020-04-22')),null),
	(449238,00.00,DATEADD(YEAR,4,	CONVERT(DATE ,'2020-06-01')),null),
	(660485,05.05,DATEADD(YEAR,4,	CONVERT(DATE ,'2020-05-17')),null),
	(660301,35.05,DATEADD(YEAR,4,	CONVERT(DATE ,'2001-05-17')),null);

SELECT * FROM LlogariaBiznesit
INSERT	 INTO LlogariaBiznesit VALUES
	(151706,'Altinium',84901),
	(559249,'Scribe',84166),
	(660301,'Root',84176);

declare @C1 varchar(20);
declare @C2 varchar(20);
declare @C3 varchar(20);

SET @C1 = (SELECT Klienti.Emri from Klienti where Klienti.Nr_Personal = 51616);
SET @C2 = (SELECT Klienti.Emri from Klienti where Klienti.Nr_Personal = 78106);
SET @C3 = (SELECT Klienti.Emri from Klienti where Klienti.Nr_Personal = 84901);

SELECT * FROM LlogariaIndividuale;
INSERT	 INTO LlogariaIndividuale VALUES
	(151706,5.0,@C1,51616),
	(382957,6.0,@C2,78106),
	(449238, 3.0,@C3,84901);

DBCC CHECKIDENT('Transferi', RESEED, 0);
SELECT * FROM Transferi;
INSERT   INTO Transferi VALUES
	(151706,'Rryme Elektrike',20.00),
	(151706,'Internetit',25.00),
	(382957,'Ujesjellesi',20.00),
	(449238,'Termokos',50.00),
	(559249,'Mallra',5000.00);

SELECT * FROM LlogariaTransferet;
DELETE FROM LlogariaTransferet
INSERT INTO LlogariaTransferet VALUES
	(1,151706,'2021-09-06'),
	(1,509486,'2022-02-14'),
	(1,382957,'2022-05-02'),
	(1,102949,'2021-12-11'),
	(1,449215,'2022-01-09'),
	(1,559249,'2021-07-01'),
	(2,330928,'2022-03-17'),
	(2,449238,'2022-07-20'),
	(2,660485,'2020-05-17'),
	(2,660301,'2020-05-07'),
	(2,151706,'2020-05-17'),
	(3,509486,'2020-04-22'),
	(3,382957,'2020-06-01'),
	(3,102949,'2020-05-17'),
	(3,449215,'2001-05-17'),
	(3,559249,'2003-05-16'),
	(4,330928,'2020-04-11'),
	(4,449238,'2020-05-05'),
	(4,660485,'2020-02-06'),
	(5,660301,'2022-05-25'),
	(5,151706,'2020-06-30'),
	(5,382957,'2014-05-28'),
	(5,449238,'2002-04-03'),
	(5,660485,'2002-04-03');
	
 
DECLARE	@DATA_MARRJES_K1 DATE = (SELECT CONVERT(DATE, CURRENT_TIMESTAMP));
DECLARE @DATA_MARRJES_K2 DATE = (SELECT CONVERT(DATE, CURRENT_TIMESTAMP));
DECLARE @DATA_MARRJES_K3 DATE = (SELECT CONVERT(DATE, CURRENT_TIMESTAMP));
DECLARE @DATA_PERFUNDIMIT_K1 DATE = (SELECT DATEADD(YEAR,10, CONVERT(DATE, CURRENT_TIMESTAMP)));
DECLARE @DATA_PERFUNDIMIT_K2 DATE = (SELECT DATEADD(MONTH,16, CONVERT(DATE, CURRENT_TIMESTAMP)));
DECLARE @DATA_PERFUNDIMIT_K3 DATE = (SELECT DATEADD(YEAR,4, CONVERT(DATE, CURRENT_TIMESTAMP)));


SELECT * FROM Kredia;
INSERT	 INTO Kredia VALUES
	(151706,20000.00,@DATA_MARRJES_K1, @DATA_PERFUNDIMIT_K1,83740,'Transfereve'),
	(509486,1200.00,@DATA_MARRJES_K2, @DATA_PERFUNDIMIT_K2,91345,'Kredise'),
	(382957,5000.00,@DATA_MARRJES_K3, @DATA_PERFUNDIMIT_K3,39403,'Kredise');
		
		
SELECT * FROM Kontrolla;
INSERT	 INTO Kontrolla VALUES
	(151706,1,'Fiancave'),
	(449238,2,'Transfereve_Online'),
	(330928,4,'Fiancave');

SELECT * FROM Pagesa;
INSERT	 INTO Pagesa VALUES
	(151706,500.00),
	(382957,700.00),
	(449238,300.00);

SELECT * FROM MirembajtesiLlogaria;
INSERT	 INTO MirembajtesiLlogaria VALUES
	(1	,151706),
	(6	,509486),
	(9	,382957),
	(24	,102949),
	(1	,449215),
	(7	,559249),
	(16	,330928),
	(18	,449238),
	(14	,660485),
	(5	,660301),
	(10	,151706),
	(3	,509486),
	(11	,382957),
	(1	,102949),
	(9	,449215),
	(10	,559249),
	(13	,330928),
	(21	,449238),
	(15	,660485),
	(15	,660301),
	(2	,151706),
	(20	,509486),
	(22	,382957),
	(3	,102949),
	(15	,449215),
	(20	,559249),
	(7	,330928);
		
--UPDATES

UPDATE Klienti SET  Nr_Apartamentit = 111 WHERE Nr_Personal = 55179;
UPDATE Klienti SET 	EmriRruges = '6201 Johnson St' WHERE Nr_Personal = 51616;
UPDATE Klienti SET  Mbiemri = ' Carles' WHERE Nr_Personal = 93501;
UPDATE NumriTelefonit SET Nr_Telefonit = '044-59150' WHERE Nr_Personal = 51616;
UPDATE Punetori SET	NrTelefonit = '044-10506' WHERE Punetori_ID = 3;
UPDATE Keshilltari SET Lloji_Keshillit = 'Transfereve' WHERE Keshilltari_ID > 03 AND Keshilltari_ID < 15;
UPDATE Mirembajtsi SET Lloji_Mirembatjes = 'E-BANKING' WHERE Mirembajtesi_ID > 15 AND Mirembajtesi_ID < 50;
UPDATE Transferi SET Pershkrimi =  'Pagesa Kredise' WHERE Transferi_id = 2;
UPDATE TRANSFERI SET SHUMA = '600' WHERE Transferi_id = 2;
UPDATE Punon set Emri_Departamentit = 'Hapjes_Llogarise' WHERE Punetori_ID < 5;
UPDATE Punetori SET	DataFillimit = '2022-01-10' WHERE Punetori_ID = 5;
UPDATE Departamenti SET Qyteti = 'Mitrovice' WHERE Emri_Departamentit = 'Sigurise';
UPDATE Departamenti_Operimeve SET Shuma_Operimit = 50000 WHERE Departamenti_Operimeve_PK = 'Transfereve';
UPDATE Departamenti_Operimeve SET Shuma_Operimit = 20000 WHERE Departamenti_Operimeve_PK = 'Transfereve_Online';
UPDATE Departamenti_Operimeve SET Shuma_Operimit = 25000 WHERE Departamenti_Operimeve_PK = 'Fiancave';
UPDATE Kredia SET Data_Perfundimit  = DATEADD(YEAR,8,CURRENT_TIMESTAMP) WHERE Nr_Kredise = 509486;
UPDATE Kredia SET Data_Perfundimit  = '2025-05-27' WHERE Nr_Kredise = 151706;
UPDATE LlogariaBiznesit SET Emri_Biznesit = 'HHOGene' WHERE Nr_Llogarise =151706;
UPDATE LlogariaIndividuale SET RataInteresit = 5.0 WHERE Nr_Llogarise = 449238;
UPDATE Llogaria SET Data_Skadimit = DATEADD(YEAR,5,CURRENT_TIMESTAMP) WHERE Nr_Llogarise = 449215;


--DELETES
ALTER TABLE NumriTelefonit DROP CONSTRAINT NumriTelefonit_PK;
ALTER TABLE Pagesa DROP CONSTRAINT Pagesa_ID;
DELETE FROM Punon WHERE Punetori_ID = 06;
DELETE FROM Llogaria WHERE Data_Skadimit < CURRENT_TIMESTAMP;
DELETE FROM Punetori WHERE NrTelefonit = '044-751344';
DELETE FROM Kontrolla WHERE Nr_llogarise = 151706;
DELETE FROM Kredia WHERE Data_Perfundimit < CAST('2025-05-05' AS DATE);
DELETE FROM LlogariaIndividuale WHERE RataInteresit < 10.0;
