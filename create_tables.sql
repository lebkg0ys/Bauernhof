DROP TABLE IF EXISTS Lieferant;
DROP TABLE IF EXISTS VKArtikel;
DROP TABLE IF EXISTS Artikeltyp;
DROP TABLE IF EXISTS Schlachtung;
DROP TABLE IF EXISTS Rind;
DROP TABLE IF EXISTS Stall;
DROP TABLE IF EXISTS Bestellung;
DROP TABLE IF EXISTS Mitarbeiter;
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
