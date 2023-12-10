
use E_Banking_Managment;

--												QUERY T'THJESHTA
SELECT p.Emri,p.Mbiemri,p.NrTelefonit FROM Punetori p WHERE p.Emri like 'Jessica';
SELECT * FROM Klienti k WHERE 	k.Nr_Apartamentit > 30 AND k.Nr_Apartamentit < 50;
SELECT * FROM Departamenti d WHERE d.Emri_Departamentit = 'Fiancave';
SELECT * FROM Keshilltari ksh  WHERE ksh.Lloji_Keshillit = 'Transfereve'OR ksh.Lloji_Keshillit  = 'Fiancave';
														--2 RELACIONE

--Klientet  84901 me llogari te biznesit
SELECT k.Emri,k.Mbiemri, llb.Emri_Biznesit
FROM LlogariaBiznesit llb, Klienti k
WHERE llb.Id_Klienti='84901' and llb.Id_Klienti = k.Nr_Personal;

--Punetoret te cilet jane keshilltare
SELECT p.Emri, p.Mbiemri, p.Punetori_ID
FROM  Punetori p, Keshilltari k
WHERE p.Punetori_ID = k.Keshilltari_ID
order by p.Emri;

--Klientet qe kane kredi dhe id 39403
SELECT k.Emri, k.Mbiemri,k.Nr_Personal ,kr.Nr_Kredise
FROM Kredia kr, Klienti k
WHERE k.Nr_Personal = kr.Nr_Personal_FK AND Nr_Personal = '39403'

--Transeret qe jane bere ne llogarine me id 151706
SELECT ll.Nr_Llogarise, t.Llogaria_Pranuese, t.Shuma
FROM Llogaria ll, Transferi t, LlogariaTransferet llt 
WHERE ll.Nr_Llogarise = llt.Nr_Llogarise AND t.Transferi_id = llt.Transferi_ID AND ll.Nr_Llogarise = '151706';

--													ADVANCED QUERY

--Transferi maksimal i kontrolluar per departamente te ndryshme
SELECT  k.Emri_Departamentit , MAX(t.Shuma) as [Tranfseri Maksimal i kontrolluar]
FROM Transferi t inner join Kontrolla k
ON  k.Transferi = t.Transferi_id 
GROUP BY k.Emri_Departamentit
ORDER BY [Tranfseri Maksimal i kontrolluar]


--NR E PROJEKTEVE TE KRYERA NGA PUNTORI ME ID 1 
SELECT COUNT(pn.Projekti_ID) [Punetore per projekt > 3]
FROM Punon pn inner join Punetori p 
ON pn.Punetori_ID = p.Punetori_ID AND p.Punetori_ID = 1
HAVING count(pn.Projekti_ID) > 2;

--KLIENTET QE NUK KANE KREDI
SELECT K.Emri,K.Mbiemri,kr.Nr_Personal_FK
FROM Klienti k  LEFT JOIN Kredia kr
ON	k.Nr_Personal = kr.Nr_Personal_FK
WHERE kr.Nr_Personal_FK is null;
 

--NR E LLOGARIVE QE MIREMBANE PUNETORI MICHEAL BROWN
SELECT  COUNT(p.Punetori_ID) as [Nr_Llogarive Qe Mirembane Michael Brown]
FROM Llogaria ll INNER JOIN MirembajtesiLlogaria mll
ON ll.Nr_Llogarise = mll.Nr_Llogarise INNER JOIN Punetori p
ON	mll.Punetori_ID = p.Punetori_ID	INNER JOIN Mirembajtsi m
ON p.Punetori_ID = m.Mirembajtesi_ID
WHERE p.Punetori_ID = mll.Punetori_ID AND p.Emri like 'Michael' AND p.Mbiemri like 'Brown'

--													SUBQERIES TE THJESHTA

--Llogaria e Klientit Sara Martinez
 SELECT *
 FROM LlogariaIndividuale ll
 WHERE  ll.Id_Klienti = (SELECT K.Nr_Personal
						 FROM Klienti k
						 WHERE k.Emri like 'Sara' and k.Mbiemri like 'Martinez')

--Klientet qe kane Llogari Biznesi
SELECT *
from Klienti k
WHERE k.Nr_Personal in (SELECT llb.Id_Klienti
						FROM LlogariaBiznesit llb
						WHERE llb.Id_Klienti = k.Nr_Personal);

--Klientet qe kane shume te kredise me te madhe se mesatarja e pageses
SELECT k.Nr_Kredise, (select kl.Nr_Personal
					  from Klienti kl
					  WHERE k.Nr_Personal_FK = kl.Nr_Personal) as [Numri Personal]
FROM Kredia k
WHERE k.Shuma > (SELECT AVG(p.Shuma)
				 FROM Pagesa p);

-- Punetoret qe kane projekte
SELECT p.Punetori_ID, p.Emri,p.Mbiemri
FROM Punetori p 
WHERE p.Punetori_ID in (SELECT pn.Punetori_ID
						FROM Punon pn
						WHERE pn.Punetori_ID = p.Punetori_ID and pn.Projekti_ID in 
						(SELECT pr.Projekti_ID
							FROM Projekti pr
							WHERE pr.Projekti_ID = pn.Projekti_ID));

--											SUBQUERY T'AVANCUME

--Mesataren e pagesave me te vogla se mesatarja e pagesave te pergjithshme
WITH AvgShuma AS (	SELECT avg(p.Shuma) as[Shuma  Mesatare]
					FROM  Pagesa p )

SELECT avg(p.Shuma) as [Shuma  Mesatare]
FROM Kredia  k inner join  Pagesa p
ON k.Nr_Kredise = p.Nr_Kredise
GROUP BY k.Nr_Kredise 
HAVING avg(p.shuma)<= ALL(SELECT a.[Shuma  Mesatare]
							FROM AvgShuma a);


--Kliente qe kane kredi me te madhe se 500
SELECT k.Emri,k.Mbiemri, (	SELECT kr.Shuma
							FROM Kredia kr
							WHERE k.Nr_Personal = kr.Nr_Personal_FK) as [Shuma]
From Klienti k
WHERE  EXISTS(SELECT k.Emri,k.Mbiemri,kr.Shuma
			 FROM Kredia kr
		     WHERE kr.Nr_Personal_FK = k.Nr_Personal and kr.Shuma >500 )


--Llogarite me bilance me te madh se avg i transfereve
SELECT ll.Nr_Llogarise,ll.Bilanci, (SELECT avg(t.shuma)
									FROM Transferi t) as [Transferi me shume mesatare]
FROM Llogaria ll
WHERE ll.Bilanci > ANY(SELECT AVG(t.Shuma)
						FROM Llogaria ll inner join LlogariaTransferet llt
						ON ll.Nr_Llogarise = llt.Nr_Llogarise inner join Transferi t
						ON llt.Transferi_ID = t.Transferi_id )

--Departamentet qe kane shume te operimit me te madhe se mesatarja e departameneteve qe kontrollojne
SELECT  do.Departamenti_Operimeve_PK, do.Shuma_Operimit, AVG(do.Shuma_Operimit) as [Mesatarja e operimit]
FROM Departamenti_Operimeve do
WHERE do.Shuma_Operimit > ALL(SELECT AVG(do.Shuma_Operimit)
							FROM Departamenti_Operimeve do INNER JOIN Kontrolla k
							ON do.Departamenti_Operimeve_PK = k.Emri_Departamentit INNER JOIN Transferi t
							ON t.Transferi_id = k.Transferi)
GROUP BY do.Departamenti_Operimeve_PK,do.Shuma_Operimit;



--										ALGJEBRA RELACIONARE


-- klientet qe kane lindur mes 1990-1995
alter view KlientetMes1990Dhe1995 as
(
	select k.Emri,DataLindjes
	From Klienti k
	where k.DataLindjes >'1990-02-05'
intersect
	Select k.emri,DataLindjes
	from Klienti k
	Where k.DataLindjes <'1995-02-05'
)
select * from KlientetMes1990Dhe1995;


--llogarite e biznesit me emrin scribe ose root
alter view  LlogariteERootDheScribe as (
	select k.Emri,k.Mbiemri,llb.Emri_Biznesit,llb.Nr_Llogarise
	from Klienti k inner join LlogariaBiznesit llb
	on k.Nr_Personal = llb.Id_Klienti and llb.Emri_Biznesit = 'Scribe'
UNION
	select k.Emri,k.Mbiemri,llb.Emri_Biznesit,llb.Nr_Llogarise
	from Klienti k inner join LlogariaBiznesit llb
	on k.Nr_Personal = llb.Id_Klienti and llb.Emri_Biznesit = 'Root'
)

select * from LlogariteERootDheScribe;

--Klientet qe kane llogari indivuduale por jo te biznesit
create view LlogariteInd as(
	select k.emri,k.Mbiemri,k.Nr_Personal
	from Klienti k
	where k.Nr_Personal in (select l.Id_Klienti
							from LlogariaIndividuale l)
EXCEPT 
	select k.emri,k.Mbiemri,k.Nr_Personal
	from Klienti k
	where k.Nr_Personal in (select l.Id_Klienti
							from LlogariaBiznesit l)
)
--Selekto kredite qe menaxhohen nga depeartamenti ne malisheve dhe qe kane daten e perfundimit mbi 2026
create view Malisheva2026 as (
	select  k.Nr_Kredise, k.Data_Perfundimit, d.Emri_Departamentit
	from Kredia k inner join Departamenti d
	on k.Emri_Departamentit_FK = d.Emri_Departamentit and k.Data_Perfundimit > '2026-02-05'
INTERSECT 
	select  k.Nr_Kredise, k.Data_Perfundimit, d.Emri_Departamentit
	from Kredia k inner join Departamenti d
	on k.Emri_Departamentit_FK = d.Emri_Departamentit and d.Qyteti like  'Malisheve'
)
select * from Malisheva2026;
--																STORE PROCEDURE

--Punetoret te cilet jane keshilltare ne transfere
CREATE PROCEDURE PunetoretKeshilltare
AS
BEGIN
	SELECT p.Punetori_ID,Mbiemri,p.Mbiemri, p.NrTelefonit
	FROM Punetori p RIGHT JOIN Keshilltari k
	ON p.Punetori_ID = k.Keshilltari_ID
	WHERE k.Lloji_Keshillit like 'Transfereve'
END

EXEC PunetoretKeshilltare;
--Trego transferet e parave ne baze te pershkrimit i cili dergohet si parameter
CREATE PROCEDURE TransferetPerkatese(
	@Pershkrimi varchar(50))
AS
BEGIN
	SELECT *
	FROM Transferi t
	WHERE t.Pershkrimi like @Pershkrimi 
END
select * from Kredia;
select * from LlogariaIndividuale;
EXEC TransferetPerkatese 'Rryme Elektrike'
--Klientet qe kane llogari indivudale, kane raten e interesit me te madhe dhe bilancin me te madh se parameterat perkates
ALTER PROCEDURE	KlientetMeRate(
	@rate_interesit float,
	@bilanci money,
	@emri varchar(20) OUT,
	@mbiemri varchar(20) OUT,
	@Nr_Personal int OUT, 
	@Bilanci_out money OUT,
	@RataInteresit_out int OUT)
AS
BEGIN
	SELECT @emri = k.emri,@mbiemri = k.mbiemri, @Nr_Personal = k.Nr_Personal, @Bilanci_out = l.Bilanci, @RataInteresit_out = li.RataInteresit
	FROM Klienti k INNER JOIN LlogariaIndividuale li
	ON k.Nr_Personal = li.Id_Klienti INNER JOIN Llogaria l
	ON l.Nr_Llogarise = li.Nr_Llogarise 
	AND @rate_interesit <= li.RataInteresit AND @bilanci  < l.Bilanci

END
ALTER PROCEDURE PrintoKlientet(
	@rate_interesit float,
	@bilanci money)
AS
BEGIN
	DECLARE @emri varchar(20),@mbiemri varchar(20) ,@Nr_Personal int, @Bilanci_out money, @RataInteresit_out int
	EXEC  KlientetMeRate @rate_interesit ,
	@bilanci,
	@emri out,
	@mbiemri out,
	@Nr_Personal out,
	@Bilanci_out out,
	@RataInteresit_out out

	if(@RataInteresit_out < 10)
		print 'IMPORTANT NOTICE: Rata interesit eshte e vogel!'
	else
		print 'IMPORTANT NOTICE: Rata interesit eshte normale!'

	print 'Klienti: ' + @emri+ ' ' + @mbiemri + ' me nr personal: ' +  CONVERT(VARCHAR,@Nr_Personal) + ' ka balancin ' + CONVERT(VARCHAR,@Bilanci_out) + ' dhe rate te interesit ' +  CONVERT(VARCHAR,@RataInteresit_out) + '.';

END
EXEC PrintoKlientet 5, 500;

select * from Kredia;
--Shfaq kredite te cilat jane te kontrolluara nga departamenti
ALTER PROCEDURE KreditePerQytetinPerkates(
@Shuma money,
@Qyteti varchar(30) OUT,
@Shuma_out money OUT,
@Nr_Kredise int OUT)
AS
BEGIN
	SELECT @Qyteti = d.Qyteti ,@Shuma_out = CONVERT(int, K.Shuma) , @Nr_Kredise = k.Nr_Kredise
	FROM Kredia k, Departamenti d
	WHERE k.Emri_Departamentit_FK = d.Emri_Departamentit
	GROUP BY k.Nr_Kredise,k.Shuma,d.Qyteti
	
END
 
ALTER PROCEDURE PrintoKredite(
@Shuma money)
AS
BEGIN
	declare @Qyteti varchar(30) , @Shuma_out money , @Nr_Kredise int
	EXEC KreditePerQytetinPerkates
	@Shuma,
	@Qyteti OUT,
	@Shuma_out OUT,
	@Nr_Kredise OUT
	if(CONVERT(int, @Shuma_out) <= @Shuma)
		print 'Shuma e kredise me nr: ' + CONVERT(VARCHAR,@Nr_Kredise)+ ' eshte me e vogel se ' + CONVERT(VARCHAR,@Shuma) + ' ne qytetin ' + @Qyteti
	else
		print 'Shuma e kredise me nr: ' + CONVERT(VARCHAR,@Nr_Kredise) + ' eshte me e madhe se ' +CONVERT(VARCHAR, @Shuma) + ' ne  qytetin ' + @Qyteti
END
EXEC PrintoKredite 5000;


--------------------------------- QUERY T'THJESHTA=========================

--1.Te selektohet emri,mbiemri  klientit i atyre qe emri ju fillon emri me shkronjen 'M'
select k.Emri,k.Mbiemri
from Klienti k
where k.Emri like 'M%'


--2.Te selektohen qytetet e departameneteve pa perseritje te vlerave.
select  distinct d.Qyteti
from Departamenti d


--3.Selekto LLogarienEBiznesit 'Altinium' ose 'Scribe'
select l.Id_Klienti,l.Emri_Biznesit,l.Nr_Llogarise
from LlogariaBiznesit l
where l.Emri_Biznesit like 'Altinium' or l.Emri_Biznesit like 'Scribe'


--4.Selekto Transferi e parave per pagim te Rrymes Elektrike
select t.Transferi_id,t.Pershkrimi,t.Shuma,t.Llogaria_Pranuese
from Transferi t
where t.Pershkrimi ='Rryme Elektrike'






----------------------QUERY ME DY TABELA==============================================

---1.Te shfaqet shuma e pageses e cila eshte 500.
select k.Nr_Kredise,p.Shuma
from Kredia k,Pagesa p
where k.Nr_Kredise=p.Nr_Kredise and p.Shuma=500


---2.Te shfaqet projekti i cili realizohet ne departamentin e Fiancave
select  p.Projekti_ID,p.Emri_Departamentit_FK,d.Qyteti
from Projekti p,Departamenti d
where p.Emri_Departamentit_FK=d.Emri_Departamentit and p.Emri_Departamentit_FK='Fiancave'


---3.Te shfaqet klienti i cili ka numrin e telefonit '045512743'
select k.Emri,k.Mbiemri,n.Nr_Telefonit
from Klienti k,NumriTelefonit n
where k.Nr_Personal=n.Nr_Personal and n.Nr_Telefonit='045512743'


---4.Te selektohet klienti i cili ka llogari biznesi me emrin 'Scribe'
select l.Id_Klienti,l.Emri_Biznesit,k.Emri,k.Mbiemri
from LlogariaBiznesit l,Klienti k
where l.Id_Klienti=k.Nr_Personal and l.Emri_Biznesit='Scribe'





-----------------------Query te avansuara================================================

-- AVG PER DEPARTAMENTET PERKATESE 
-- SHUMA E TRANSFEREVE MESATRE PER DEPARTAMENTET PERKATESE 
SELECT  k.Emri_Departamentit , AVG(t.Shuma) as [Tranfseri AVG i kontrolluar]
FROM Departamenti_Operimeve do, Kontrolla k, Transferi t
WHERE  k.Emri_Departamentit = do.Departamenti_Operimeve_PK
GROUP BY k.Emri_Departamentit
ORDER BY [Tranfseri AVG i kontrolluar]


--Te shfaqet shuma maksimale e kredise sipas deparatamentit te Malisheves

select k.Data_Marrjes,k.Data_Perfundimit,d.Emri_Departamentit,d.Qyteti,MAX(k.Shuma)as Shumamaksimale
from Kredia k inner join Departamenti d
on k.Emri_Departamentit_FK=d.Emri_Departamentit
where d.Qyteti='Malisheve'
group by  k.Data_Marrjes,k.Data_Perfundimit,d.Emri_Departamentit,d.Qyteti


--KLIENTET QE KANE KREDI
SELECT K.Emri,K.Mbiemri,kr.Nr_Personal_FK
FROM Klienti k  RIGHT JOIN Kredia kr
ON	k.Nr_Personal = kr.Nr_Personal_FK
WHERE kr.Nr_Personal_FK is NOT null;


--te selektohen klientet qe e kane kredi me shume se 10000 euro
SELECT K.Emri, K.Mbiemri, kr.Nr_Personal_FK, kr.Shuma
FROM Klienti k INNER JOIN Kredia kr
ON k.Nr_Personal = kr.Nr_Personal_FK
WHERE kr.Shuma > 10000



------------------------subquery t� thjeshta==============================================

--Klient me emrin Michael Brown
 --KLIENTE QE KANE LLOGARI INDIVIDUALE
SELECT *
from Klienti k
WHERE k.Nr_Personal in (SELECT lli.Id_Klienti
                        FROM LlogariaIndividuale lli
                        WHERE lli.Id_Klienti = k.Nr_Personal);

----Kliente me kredi me te madhe se shuma maksimale e pageses

SELECT k.Nr_Kredise,k.Shuma, (select kl.Nr_Personal
                      from Klienti kl
                      WHERE k.Nr_Personal_FK = kl.Nr_Personal) as [Numri Personal]
FROM Kredia k
WHERE k.Shuma > (SELECT MAX(p.Shuma)
                 FROM Pagesa p);

--Selekto klietet qe kane nr e apartamentit me te madh se mesatarja
SELECT k.emri,k.mbiemri, k.Nr_Apartamentit
FROM Klienti k
WHERE k.Nr_Apartamentit > (SELECT AVG(k.Nr_Apartamentit)
                 FROM Klienti k);

--Llogarite te cilat kane pranuar pages me pershkrimin Rryme Elektrike
SELECT *
FROM Llogaria l
WHERE l.Nr_Llogarise  in (SELECT t.Llogaria_Pranuese
                    FROM  Transferi t
                    WHERE t.Pershkrimi = 'Rryme Elektrike')
					













-----------------------------------Algjebr�s relacionale===================================
 
 

 ------selekto klientet te cilet kan lindur me 01/22/2000 dhe 206/06/2005
create view Datat as
(
 select *
from Klienti
where DataLindjes>'01/22/2000'
Except
Select *
from Klienti
Where DataLindjes<'06/06/2005'
)
select * from Datat;
---- selekto te gjithe Klientet qe kane EmriRruges 3030 Maple St dhe jetojne ne qytetin Washington

create view klientetRR as
(
select k.Emri
from Klienti k
where k.EmriRruges='3030 Maple St'
INTERSECT
select k.Emri
from Klienti k
where  k.Qyteti='Washington'
)
select * from klientetRR;



---- selekto klientet qe kane bilancin me te madhe se 550.25 dhe jane nga Dallas

create view klientetBilanci as(
Select k.Emri,k.Mbiemri,ll.bilanci
from Klienti k,Llogaria ll
where ll.Bilanci in(Select ll.Bilanci
					from Llogaria ll
					where ll.Bilanci>550.25)
EXCEPT
Select k.Emri,k.Mbiemri,ll.bilanci
from Klienti k,Llogaria ll
Where k.Qyteti  in(Select k.Qyteti
							from Klienti k 
							where k.Qyteti like 'Dallas')
)
select * from  klientetBilanci;















 -----------------------------Stored Procedure============================================

 /* 3   Krijoni nj� stored procedure e cila shfaq� numrin e projekteve t� puntorit n� baz� t� id-s�. 
		N�se puntori p�rkat�s ka 1 projekt t� shfaqet mesazhi: �Personi ka vet�m nj� projekt�, dhe n�se personi ka 
		m� shum� se 1 projket t� shfaqet mesazhi: �Personi ka m� shum� se nj� projekt�.*/

 create procedure printProjektet(@Puntori_ID Int)
as
begin
  declare @Projekti_ID int;

  select @Projekti_ID = count(*)
  from  Punetori ph
  where ph.Punetori_ID = @Projekti_ID

  if(@Projekti_ID > 1)
    print 'Puntori ka me shume se nje projekt.'
  else
    print 'Puntori ka vetem nje projekt'
end

exec printProjektet 2




------	Krijoni nj� stored procedure e cila tregon p�rqindjen e klienteve nga Qyteti, n� baz� t� inputit �qyteti�. 

create procedure getPerqindjaByQyteti(@Qyteti varchar(30))
as
  begin

    declare @Perqindja decimal(5,2)

    select @Perqindja = ((count(*) * 100)/(select count(*) from Klienti))  
    from Klienti k
	where k.Qyteti like 'Los Angeles'

	print('Perqindja e personave nga qyteti ' + @Qyteti + ' eshte ' + cast(@Perqindja as varchar(40)))

  end

  execute getPerqindjaByQyteti 'Los Angeles'





	-------Krijoni stored procedure e cila tregon p�rqindjen e personave q� kan� kredi dhe p�rqindjen e personave q� nuk e kan asnje kredi.

  create procedure getPerqindja(@KlientiP decimal(5,2) out, @KrediaP decimal(5,2) out)
as
  begin

   declare @NrKlienteve int = (select count(*) from Klienti)
   declare @NrKlienteveK int = (select  count(*)
	                           from (select k.Nr_Kredise
	                                 from Kredia k inner join Klienti kl
									 on kl.Nr_Personal = K.Nr_Personal_FK
	                                 group by k.Nr_Kredise) as result)

   declare @NrKredis int = (select count(*) from Kredia)
   
   declare @NrKredia int = (select count(*)
                           from (select kr.Nr_Kredise
						         from Kredia kr left join Klienti k
								 on kr.Nr_Personal_FK = k.Nr_Personal
								 where k.Nr_Personal is null) as r)
   

set @KlientiP  = @NrKlienteveK*100/@NrKlienteve
set @KrediaP = @NrKredia*100/@NrKredis
     
  end

declare @Klientat decimal(5,2), @Kredia decimal(5,2)
execute getPerqindja @Klientat out, @Kredia out

print 'Perqindja e klientave te cilet kane kredi eshte:' + cast(@Klientat as varchar(5)) + '%'
print 'Perqindja e kredive qe nuk e ka asnje person eshte:' + cast(@Kredia as varchar(5)) + '%'




------Krijoni nj� stored procedure p�r t� gjetur klientet q� kan� shumen m� t� madhe se shuma mesatare e t� gjithe klienteve.
alter procedure shumaAvg
as
begin
select kr.Emri,kr.Mbiemri,k.shuma
from Kredia k, Klienti kr
where k.Nr_Personal_FK = kr.Nr_Personal and  k.Shuma > all (select avg(k.Shuma)
                     from Kredia k)
end

exec shumaAvg

