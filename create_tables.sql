
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
CREATE TABLE Stall (
    ID int NOT NULL IDENTITY(1,1),
    AnzahlPlätze int,
    Primary Key (ID)
);
CREATE TABLE Rind (
    ID int NOT NULL IDENTITY(1,1),
    Lebendig bit Default 1,
    ST_ID int NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (ST_ID) REFERENCES Stall(ID)
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
	FOREIGN KEY (VK_A_ID) REFERENCES VKArtikel(ID),
	FOREIGN KEY (VK_ID) REFERENCES Verkauf(ID),
	CONSTRAINT VK_POS_ID PRIMARY KEY (VK_A_ID,VK_ID)
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
