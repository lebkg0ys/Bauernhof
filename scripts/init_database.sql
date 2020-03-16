/*
 * DROP ALL TABLES FOR A CLEAN SETUP
 */
DROP TABLE IF EXISTS VerkaufsPosition;
DROP TABLE IF EXISTS Verkauf;
DROP TABLE IF EXISTS VKArtikel;
DROP TABLE IF EXISTS Schlachtung;
DROP TABLE IF EXISTS Rind;
DROP TABLE IF EXISTS Stall;
DROP TABLE IF EXISTS Mitarbeiter;
DROP TABLE IF EXISTS BestellungsPosition;
DROP TABLE IF EXISTS EKArtikel;
DROP TABLE IF EXISTS Bestellung;
DROP TABLE IF EXISTS Lieferant;
DROP TABLE IF EXISTS Artikeltyp;

/*
 * CREATE FUNCTION FOR CHECKING IF THERE IS ENOUGH SPACE FOR COW
 */
CREATE OR ALTER FUNCTION check_available_stall(@ST_ID int)
RETURNS bit
AS
BEGIN
	DECLARE @switch bit
	IF (SELECT COUNT(*) FROM dbo.Rind WHERE lebendig=1 AND ST_ID=@ST_ID) < (SELECT AnzahlPlaetze FROM dbo.Stall WHERE ID=@ST_ID)
	BEGIN
		SET @switch = 1
	END
	ELSE
	BEGIN
		SET @switch = 0
	END
	RETURN @switch 
END;
/*
 * CREATE FUNCTION FOR CHECKING IF THERE IS ENOUGH OF THE PRODUCT LEFT
 */
CREATE OR ALTER FUNCTION check_available_vk(@A_ID int,@menge float(5))
RETURNS bit
AS
BEGIN
	DECLARE @switch bit
	IF (SELECT SUM(Menge) FROM VerkaufsPosition vp WHERE VK_A_ID=A_ID + @menge) < (SELECT Menge FROM VKArtikel v where A_ID=@A_ID)
	BEGIN
		SET @switch = 1
	END
	ELSE
	BEGIN
		SET @switch = 0
	END
	RETURN @switch 
END;

CREATE TABLE Stall (
    ID int NOT NULL IDENTITY(1,1),
    AnzahlPlaetze int,
    Primary Key (ID)
);
CREATE TABLE Rind (
    ID int NOT NULL IDENTITY(1,1),
    Lebendig bit Default 1,
    ST_ID int NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (ST_ID) REFERENCES Stall(ID),
    CONSTRAINT check_rind CHECK (dbo.check_available_stall(ST_ID) = 1)
);
CREATE TABLE Mitarbeiter (
    ID int NOT NULL IDENTITY(1,1),
    Name varchar(10),
    Vorname varchar(10),
    PRIMARY KEY (ID)
);
CREATE TABLE Schlachtung (
    ID int NOT NULL IDENTITY(1,1),
    Schlachtgewicht float(5),
    R_ID int NOT NULL,
    M_ID int NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (R_ID) REFERENCES Rind(ID),
    FOREIGN KEY (M_ID) REFERENCES Mitarbeiter(ID)
);
CREATE TABLE Lieferant (
    ID int NOT NULL IDENTITY(1,1),
    Name varchar(10),
    Adresse varchar(10),
    PRIMARY KEY (ID)
);
CREATE TABLE Artikeltyp (
    ID int NOT NULL IDENTITY(1,1),
    Bezeichnung varchar(10),
    KG_Preis float(5),
    PRIMARY KEY (ID)
);
CREATE TABLE VKArtikel (
    ID int NOT NULL IDENTITY(1,1),
    S_ID int NOT NULL,
    A_ID int NOT NULL,
    Menge float(5) NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (S_ID) REFERENCES Schlachtung(ID),
    FOREIGN KEY (A_ID) REFERENCES Artikeltyp(ID)
);
CREATE TABLE Verkauf (
	ID int IDENTITY(1,1) NOT NULL,
	M_ID int NOT NULL,
	Summe money NULL,
	Datum datetime default current_timestamp,
	PRIMARY KEY (ID),
	FOREIGN KEY (M_ID) REFERENCES Mitarbeiter(ID)
);
CREATE TABLE VerkaufsPosition (
	VK_A_ID int NOT NULL,
	VK_ID int NOT NULL,
	Menge float(5),
	FOREIGN KEY (VK_A_ID) REFERENCES VKArtikel(ID),
	FOREIGN KEY (VK_ID) REFERENCES Verkauf(ID),
	CONSTRAINT VK_POS_ID PRIMARY KEY (VK_A_ID,VK_ID),
	CONSTRAINT check_verkauf CHECK (dbo.check_available_vk(VK_A_ID,Menge) = 1)
);
CREATE TABLE Bestellung (
	ID int IDENTITY(1,1) NOT NULL,
	L_ID int NOT NULL,
	Summe money NULL,
	Datum datetime default current_timestamp,
	PRIMARY KEY (ID),
	FOREIGN KEY (L_ID) REFERENCES Lieferant(ID)
);
CREATE TABLE EKArtikel (
    ID int NOT NULL IDENTITY(1,1),
    B_ID int NOT NULL,
    A_ID int NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (B_ID) REFERENCES Bestellung(ID),
    FOREIGN KEY (A_ID) REFERENCES Artikeltyp(ID)
);
CREATE TABLE BestellungsPosition (
	EK_A_ID int NOT NULL,
	B_ID int NOT NULL,
	FOREIGN KEY (EK_A_ID) REFERENCES EKArtikel(ID),
	FOREIGN KEY (B_ID) REFERENCES Bestellung(ID),
	CONSTRAINT B_POS_ID PRIMARY KEY (EK_A_ID,B_ID)
);