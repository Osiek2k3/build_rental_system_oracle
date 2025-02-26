----------------------------------------------------------------------------------------------------------------------
-- Usuwanie istniej�cych tabel i typ�w (DROP)-------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

-- Usuwanie tabel

BEGIN
  FOR cur_rec IN (SELECT object_name, object_type 
                  FROM   user_objects
                  WHERE  object_type IN ('TABLE', 'TYPE')) LOOP
    BEGIN
      IF cur_rec.object_type = 'TABLE' THEN
        IF instr(cur_rec.object_name, 'STORE') = 0 then
          EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" CASCADE CONSTRAINTS';
        END IF;
      ELSIF cur_rec.object_type = 'TYPE' THEN
        EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" FORCE';
      ELSE
        EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('FAILED: DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"');
    END;
  END LOOP;
END;
/

----------------------------------------------------------------------------------------------------------------------
-- Tworzenie typ�w ---------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE TYPE TypFirma AS OBJECT (
    NazwaFirmy VARCHAR2(100),
    NIP VARCHAR2(20),
    KRS VARCHAR2(20),
    Telefon VARCHAR2(20),
    Email VARCHAR2(50),
    AdresFirmy VARCHAR2(200),
    MEMBER PROCEDURE Init(Nazwa IN VARCHAR2, NIP IN VARCHAR2, KRS IN VARCHAR2, Telefon IN VARCHAR2, Email IN VARCHAR2, Adres IN VARCHAR2)
);
/
CREATE OR REPLACE TYPE BODY TypFirma AS
    MEMBER PROCEDURE Init(Nazwa IN VARCHAR2, NIP IN VARCHAR2, KRS IN VARCHAR2, Telefon IN VARCHAR2, Email IN VARCHAR2, Adres IN VARCHAR2) IS
    BEGIN
        Self.NazwaFirmy := Nazwa;
        Self.NIP := NIP;
        Self.KRS := KRS;
        Self.Telefon := Telefon;
        Self.Email := Email;
        Self.AdresFirmy := Adres;
    END;
END;
/
CREATE OR REPLACE TYPE TypOsobaPrywatna AS OBJECT (
    Imie VARCHAR2(50),
    Nazwisko VARCHAR2(50),
    Uprawnienia Number(1),
    AdresZamieszkania VARCHAR2(200),
    Telefon VARCHAR2(20),
    MEMBER PROCEDURE Init(Imie IN VARCHAR2, Nazwisko IN VARCHAR2, Uprawnienia IN Number, Adres IN VARCHAR2, Telefon IN VARCHAR2)
);
/
CREATE OR REPLACE TYPE BODY TypOsobaPrywatna AS
    MEMBER PROCEDURE Init(Imie IN VARCHAR2, Nazwisko IN VARCHAR2, Uprawnienia IN Number, Adres IN VARCHAR2, Telefon IN VARCHAR2) IS
    BEGIN
        Self.Imie := Imie;
        Self.Nazwisko := Nazwisko;
        Self.Uprawnienia := Uprawnienia;
        Self.AdresZamieszkania := Adres;
        Self.Telefon := Telefon;
    END;
END;
/

CREATE OR REPLACE TYPE TypKlient AS OBJECT (
    IDKlient NUMBER,
    Firma TypFirma,
    Osoba TypOsobaPrywatna,
    MEMBER PROCEDURE Init(ID IN NUMBER, Firma IN TypFirma, Osoba IN TypOsobaPrywatna)
);
/
CREATE OR REPLACE TYPE BODY TypKlient AS
    MEMBER PROCEDURE Init(ID IN NUMBER, Firma IN TypFirma, Osoba IN TypOsobaPrywatna) IS
    BEGIN
        Self.IDKlient := ID;
        Self.Firma := Firma;
        Self.Osoba := Osoba;
    END;
END;
/

CREATE TABLE Klienci OF TypKlient (
    IDKlient PRIMARY KEY
);
/


CREATE OR REPLACE TYPE TypKategoria AS OBJECT (
    IDKategoria NUMBER,
    Nazwa VARCHAR2(100),
    Opis VARCHAR2(200),
    MEMBER PROCEDURE Init(ID IN NUMBER, Nazwa IN VARCHAR2, Opis IN VARCHAR2)
);
/
CREATE OR REPLACE TYPE BODY TypKategoria AS
    MEMBER PROCEDURE Init(ID IN NUMBER, Nazwa IN VARCHAR2, Opis IN VARCHAR2) IS
    BEGIN
        Self.IDKategoria := ID;
        Self.Nazwa := Nazwa;
        Self.Opis := Opis;
    END;
END;
/

CREATE OR REPLACE TYPE TypKategoriaTable AS TABLE OF TypKategoria;
/

CREATE TABLE Kategorie OF TypKategoria (
    IDKategoria PRIMARY KEY
);
/

CREATE OR REPLACE TYPE TypSprzet AS OBJECT (
    IDSprzet NUMBER,
    NazwaSprzetu VARCHAR2(100),
    Kategoria TypKategoriaTable,
    Uprawnienia NUMBER(1),
    Status VARCHAR2(50),
    KwotaZaDzien NUMBER
);
/

CREATE TABLE SprzetBudowlany OF TypSprzet (
    IDSprzet PRIMARY KEY
) NESTED TABLE Kategoria STORE AS KategorieNestedTable;
/

CREATE OR REPLACE TYPE TypZajeteDni AS OBJECT (
    IDZajeteDni NUMBER,
    Data DATE,
    RefSprzet REF TypSprzet 
);
/

CREATE TABLE ZajeteDniSprzetu OF TypZajeteDni (
    CONSTRAINT pk_zajete_dni PRIMARY KEY (IDZajeteDni)
);
/


CREATE OR REPLACE TYPE TypRezerwacja AS OBJECT (
    IDRezerwacja NUMBER,
    RefKlient REF TypKlient,
    RefSprzet REF TypSprzet,
    data_rezerwacji DATE,
    data_startu DATE,
    data_konca DATE
);
/

CREATE TABLE Rezerwacje OF TypRezerwacja (
    IDRezerwacja PRIMARY KEY
);
/

CREATE TYPE TypRezerwacjaArchiwalna AS OBJECT (
    IDRezerwacja NUMBER,
    IDKlient NUMBER,
    IDSprzet NUMBER,
    data_rezerwacji DATE,
    data_startu DATE,
    data_konca DATE,
    status VARCHAR2(20)
);
/

CREATE TABLE Rezerwacje_Archiwalne OF TypRezerwacjaArchiwalna (
    IDRezerwacja PRIMARY KEY,
    CONSTRAINT chk_status_arch CHECK (status IN ('Zrealizowana', 'Anulowana'))
);
/

CREATE OR REPLACE TYPE TypWypozyczenie AS OBJECT (
    IDWypozyczenie NUMBER,
    RefKlient REF TypKlient, 
    RefSprzet REF TypSprzet,
    DataWypozyczenia DATE,
    DataZwrotu DATE,
    Kwota NUMBER,
    Zaliczka NUMBER,
    MEMBER PROCEDURE Init(ID IN NUMBER, KlientID IN REF TypKlient,SprzetID IN REF TypSprzet,DataWyp IN DATE, DataZwrotu IN DATE, Kwota IN NUMBER, Zaliczka IN NUMBER)
);
/
CREATE OR REPLACE TYPE BODY TypWypozyczenie AS
    MEMBER PROCEDURE Init(ID IN NUMBER, KlientID IN REF TypKlient, SprzetID IN REF TypSprzet,DataWyp IN DATE, DataZwrotu IN DATE, Kwota IN NUMBER, Zaliczka IN NUMBER
    ) IS
    BEGIN
        Self.IDWypozyczenie := ID;
        Self.RefKlient := KlientID;
        Self.RefSprzet := SprzetID;
        Self.DataWypozyczenia := DataWyp;
        Self.DataZwrotu := DataZwrotu;
        Self.Kwota := Kwota;
        Self.Zaliczka := Zaliczka;
    END;
END;
/
CREATE TABLE Wypozyczenia OF TypWypozyczenie (
    IDWypozyczenie PRIMARY KEY,
    CONSTRAINT chk_kaucja CHECK (Zaliczka >= 0.3 * Kwota)
);
/

CREATE OR REPLACE TYPE TypWypozyczenie_Archiwalne AS OBJECT (
    IDWypozyczenie NUMBER,
    IDKlient NUMBER,
    IDSprzet NUMBER,
    DataWypozyczenia DATE,
    DataZwrotu DATE,
    Kwota NUMBER,
    Zaliczka NUMBER
);
/

CREATE TABLE Wypozyczenia_Archiwalne OF TypWypozyczenie_Archiwalne (
    IDWypozyczenie PRIMARY KEY
);
/

CREATE OR REPLACE TYPE TypDodatkoweKoszta AS OBJECT (
    IDKoszt NUMBER,
    Nazwa VARCHAR2(100),
    Opis VARCHAR2(500),
    Kwota NUMBER(10, 2),
    RefWypozyczenie REF TypWypozyczenie,
    MEMBER PROCEDURE DodajKoszt(ID IN NUMBER, NazwaKosztu IN VARCHAR2, OpisKosztu IN VARCHAR2, KwotaKosztu IN NUMBER,RefWyp IN REF TypWypozyczenie)
);
/

CREATE OR REPLACE TYPE BODY TypDodatkoweKoszta AS
    MEMBER PROCEDURE DodajKoszt(ID IN NUMBER, NazwaKosztu IN VARCHAR2, OpisKosztu IN VARCHAR2, KwotaKosztu IN NUMBER,RefWyp IN REF TypWypozyczenie) IS
    BEGIN
        SELF.IDKoszt := ID;
        SELF.Nazwa := NazwaKosztu;
        SELF.Opis := OpisKosztu;
        SELF.Kwota := KwotaKosztu;
        SELF.RefWypozyczenie := RefWyp;
    END;
END;
/

CREATE TABLE DodatkoweKoszta OF TypDodatkoweKoszta (
    IDKoszt PRIMARY KEY
);
/

CREATE OR REPLACE TYPE TypPrzegladyNaprawy AS OBJECT (
    IDNaprawa NUMBER,
    RefSprzet REF TypSprzet,
    Sprzet VARCHAR2(100),
    Data DATE,
    Koszt NUMBER(10, 2),
    Typ VARCHAR2(50),
    Opis VARCHAR2(500),
    MEMBER PROCEDURE DodajNaprawe(ID IN NUMBER,IDSprzet IN REF TypSprzet,SprzetNaprawa IN VARCHAR2, DataNaprawy IN DATE, KosztNaprawy IN NUMBER, TypNaprawy IN VARCHAR2, OpisNaprawy IN VARCHAR2)
);
/

CREATE OR REPLACE TYPE BODY TypPrzegladyNaprawy AS
    MEMBER PROCEDURE DodajNaprawe(ID IN NUMBER,IDSprzet IN REF TypSprzet,SprzetNaprawa IN VARCHAR2, DataNaprawy IN DATE, KosztNaprawy IN NUMBER, TypNaprawy IN VARCHAR2, OpisNaprawy IN VARCHAR2) 
    IS
    BEGIN
        SELF.IDNaprawa := ID;
        SELF.RefSprzet := IDSprzet;
        SELF.Sprzet := SprzetNaprawa;
        SELF.Data := DataNaprawy;
        SELF.Koszt := KosztNaprawy;
        SELF.Typ := TypNaprawy;
        SELF.Opis := OpisNaprawy;
    END;
END;
/

CREATE TABLE PrzegladyNaprawy OF TypPrzegladyNaprawy (
    IDNaprawa PRIMARY KEY
);
/




----------------------------------------------------------------------------------------------------------------------
-- Skrypt gotowy do u�ycia -------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

BEGIN
    PAKIETKLIENCI.DodajKlientaFirma(1, 'Firma A Sp. z o.o.', 'PL1234567890', '0001234567', '221234567', 'kontakt1@firmaA.pl', 'ul. Przemys�owa 1, Warszawa, 00-001'); 
    PAKIETKLIENCI.DodajKlientaFirma(2, 'Firma B Sp. z o.o.', 'PL1234567891', '0001234568', '221234568', 'kontakt2@firmaB.pl', 'ul. Przemys�owa 2, Warszawa, 00-002'); 
    PAKIETKLIENCI.DodajKlientaFirma(3, 'Firma C Sp. z o.o.', 'PL1234567892', '0001234569', '221234569', 'kontakt3@firmaC.pl', 'ul. Przemys�owa 3, Warszawa, 00-003'); 
    PAKIETKLIENCI.DodajKlientaFirma(4, 'Firma D Sp. z o.o.', 'PL1234567893', '0001234570', '221234570', 'kontakt4@firmaD.pl', 'ul. Przemys�owa 4, Warszawa, 00-004'); 
    PAKIETKLIENCI.DodajKlientaFirma(5, 'Firma E Sp. z o.o.', 'PL1234567894', '0001234571', '221234571', 'kontakt5@firmaE.pl', 'ul. Przemys�owa 5, Warszawa, 00-005'); 
    PAKIETKLIENCI.DodajKlientaFirma(6, 'Firma F Sp. z o.o.', 'PL1234567895', '0001234572', '221234572', 'kontakt6@firmaF.pl', 'ul. Przemys�owa 6, Warszawa, 00-006'); 
    PAKIETKLIENCI.DodajKlientaFirma(7, 'Firma G Sp. z o.o.', 'PL1234567896', '0001234573', '221234573', 'kontakt7@firmaG.pl', 'ul. Przemys�owa 7, Warszawa, 00-007'); 
    PAKIETKLIENCI.DodajKlientaFirma(8, 'Firma H Sp. z o.o.', 'PL1234567897', '0001234574', '221234574', 'kontakt8@firmaH.pl', 'ul. Przemys�owa 8, Warszawa, 00-008'); 
    PAKIETKLIENCI.DodajKlientaFirma(9, 'Firma I Sp. z o.o.', 'PL1234567898', '0001234575', '221234575', 'kontakt9@firmaI.pl', 'ul. Przemys�owa 9, Warszawa, 00-009'); 
    PAKIETKLIENCI.DodajKlientaFirma(10, 'Firma J Sp. z o.o.', 'PL1234567899', '0001234576', '221234576', 'kontakt10@firmaJ.pl', 'ul. Przemys�owa 10, Warszawa, 00-010'); 
END;
/


BEGIN
    PAKIETKLIENCI.DodajKlientaOsobaPrywatna(11, 'Jan', 'Nowak', 1, 'ul. Pi�ciomorgowa 1, Warszawa, 00-001', '503111111'); 
    PAKIETKLIENCI.DodajKlientaOsobaPrywatna(12, 'Anna', 'Kowalska', 0, 'ul. Pi�ciomorgowa 2, Warszawa, 00-002', '503111112'); 
    PAKIETKLIENCI.DodajKlientaOsobaPrywatna(13, 'Marek', 'Wi�niewski', 1, 'ul. Pi�ciomorgowa 3, Warszawa, 00-003', '503111113'); 
    PAKIETKLIENCI.DodajKlientaOsobaPrywatna(14, 'Katarzyna', 'Zieli�ska', 0, 'ul. Pi�ciomorgowa 4, Warszawa, 00-004', '503111114'); 
    PAKIETKLIENCI.DodajKlientaOsobaPrywatna(15, 'Piotr', 'W�jcik', 1, 'ul. Pi�ciomorgowa 5, Warszawa, 00-005', '503111115'); 
    PAKIETKLIENCI.DodajKlientaOsobaPrywatna(16, 'Magdalena', 'Lewandowska', 0, 'ul. Pi�ciomorgowa 6, Warszawa, 00-006', '503111116'); 
    PAKIETKLIENCI.DodajKlientaOsobaPrywatna(17, 'Tomasz', 'Kaczmarek', 1, 'ul. Pi�ciomorgowa 7, Warszawa, 00-007', '503111117'); 
    PAKIETKLIENCI.DodajKlientaOsobaPrywatna(18, 'Agnieszka', 'Mazur', 0, 'ul. Pi�ciomorgowa 8, Warszawa, 00-008', '503111118'); 
    PAKIETKLIENCI.DodajKlientaOsobaPrywatna(19, 'Micha�', 'Szyma�ski', 1, 'ul. Pi�ciomorgowa 9, Warszawa, 00-009', '503111119'); 
    PAKIETKLIENCI.DodajKlientaOsobaPrywatna(110, 'Ewa', 'Kwiatkowska', 0, 'ul. Pi�ciomorgowa 10, Warszawa, 00-010', '503111120'); 
END;

/





BEGIN
    PAKIETKATEGORIE.DodajKategorie(1, 'Maszyny ziemne', 'Sprz�t wykorzystywany do prac ziemnych, takich jak koparki, �adowarki i inne maszyny do wykop�w.');
    PAKIETKATEGORIE.DodajKategorie(2, 'Maszyny do transportu', 'Sprz�t wykorzystywany do transportu ci�kich materia��w, np. d�wigi, w�zki wid�owe.');
    PAKIETKATEGORIE.DodajKategorie(3, 'Maszyny do betonu', 'Sprz�t wykorzystywany do produkcji i mieszania betonu, np. betoniarki.');
    PAKIETKATEGORIE.DodajKategorie(4, 'Maszyny do prac wyburzeniowych', 'Sprz�t do rozbi�rki budynk�w, np. m�oty wyburzeniowe, koparki do wyburze�.');
    PAKIETKATEGORIE.DodajKategorie(5, 'Maszyny do rob�t drogowych', 'Sprz�t wykorzystywany do budowy dr�g, np. frezy drogowe, walce.');
END;

/


DECLARE
    v_Kategorie1 TypKategoriaTable := TypKategoriaTable(
        TypKategoria(1, 'Maszyny ziemne', 'Sprz�t do prac ziemnych'),
        TypKategoria(3, 'Maszyny do betonu', 'Sprz�t do mieszania betonu')
    );
    v_Kategorie2 TypKategoriaTable := TypKategoriaTable(
        TypKategoria(2, 'Maszyny transportowe', 'Sprz�t do transportu materia��w'),
        TypKategoria(5, 'Maszyny do rob�t drogowych', 'Sprz�t do budowy dr�g')
    );
    v_Kategorie3 TypKategoriaTable := TypKategoriaTable(
        TypKategoria(4, 'Maszyny wyburzeniowe', 'Sprz�t do wyburze� budynk�w'),
        TypKategoria(1, 'Maszyny ziemne', 'Sprz�t do prac ziemnych')
    );
    v_Kategorie4 TypKategoriaTable := TypKategoriaTable(
        TypKategoria(5, 'Maszyny do rob�t drogowych', 'Sprz�t do budowy dr�g'),
        TypKategoria(3, 'Maszyny do betonu', 'Sprz�t do mieszania betonu')
    );
    v_Kategorie5 TypKategoriaTable := TypKategoriaTable(
        TypKategoria(1, 'Maszyny ziemne', 'Sprz�t do prac ziemnych'),
        TypKategoria(2, 'Maszyny transportowe', 'Sprz�t do transportu materia��w')
    );
BEGIN
    -- Dodawanie koparek g�sienicowych
    PAKIETSPRZETBUDOWLANY.DodajSprzet(1001, 'Koparka g�sienicowa', v_Kategorie1, 1, 'Dost�pny', 500);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(1002, 'Koparka g�sienicowa', v_Kategorie1, 1, 'Dost�pny', 500);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(1003, 'Koparka g�sienicowa', v_Kategorie1, 1, 'Dost�pny', 500);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(1004, 'Koparka g�sienicowa', v_Kategorie1, 1, 'Dost�pny', 500);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(1005, 'Koparka g�sienicowa', v_Kategorie1, 1, 'Dost�pny', 500);

    -- Dodawanie betoniarek przemys�owych
    PAKIETSPRZETBUDOWLANY.DodajSprzet(2001, 'Betoniarka przemys�owa', v_Kategorie2, 0, 'Dost�pny', 300);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(2002, 'Betoniarka przemys�owa', v_Kategorie2, 0, 'Dost�pny', 300);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(2003, 'Betoniarka przemys�owa', v_Kategorie2, 0, 'Dost�pny', 300);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(2004, 'Betoniarka przemys�owa', v_Kategorie2, 0, 'Dost�pny', 300);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(2005, 'Betoniarka przemys�owa', v_Kategorie2, 0, 'Dost�pny', 300);

    -- Dodawanie m�ot�w wyburzeniowych
    PAKIETSPRZETBUDOWLANY.DodajSprzet(3001, 'M�ot wyburzeniowy', v_Kategorie3, 0, 'Dost�pny', 400);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(3002, 'M�ot wyburzeniowy', v_Kategorie3, 0, 'Dost�pny', 400);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(3003, 'M�ot wyburzeniowy', v_Kategorie3, 0, 'Dost�pny', 400);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(3004, 'M�ot wyburzeniowy', v_Kategorie3, 0, 'Dost�pny', 400);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(3005, 'M�ot wyburzeniowy', v_Kategorie3, 0, 'Dost�pny', 400);

    -- Dodawanie walc�w drogowych
    PAKIETSPRZETBUDOWLANY.DodajSprzet(4001, 'Walec drogowy', v_Kategorie4, 1, 'Dost�pny', 600);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(4002, 'Walec drogowy', v_Kategorie4, 1, 'Dost�pny', 600);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(4003, 'Walec drogowy', v_Kategorie4, 1, 'Dost�pny', 600);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(4004, 'Walec drogowy', v_Kategorie4, 1, 'Dost�pny', 600);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(4005, 'Walec drogowy', v_Kategorie4, 1, 'Dost�pny', 600);

    -- Dodawanie w�zk�w wid�owych
    PAKIETSPRZETBUDOWLANY.DodajSprzet(5001, 'W�zek wid�owy', v_Kategorie5, 1, 'Dost�pny', 250);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(5002, 'W�zek wid�owy', v_Kategorie5, 1, 'Dost�pny', 250);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(5003, 'W�zek wid�owy', v_Kategorie5, 1, 'Dost�pny', 250);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(5004, 'W�zek wid�owy', v_Kategorie5, 1, 'Dost�pny', 250);
    PAKIETSPRZETBUDOWLANY.DodajSprzet(5005, 'W�zek wid�owy', v_Kategorie5, 1, 'Dost�pny', 250);

END;
/






