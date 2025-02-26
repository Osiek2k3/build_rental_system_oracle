----------------------------------------------------------------------------------------------------------------------
-- Tworzenie Pakietu dla obiketów klienci ----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
create or replace PACKAGE PAKIETKLIENCI AS 

    PROCEDURE DodajKlientaFirma(IDKlient IN NUMBER, NazwaFirmy IN VARCHAR2, NIP IN VARCHAR2, KRS IN VARCHAR2, Telefon IN VARCHAR2, Email IN VARCHAR2, AdresFirmy IN VARCHAR2);
    PROCEDURE DodajKlientaOsobaPrywatna(IDKlient IN NUMBER, Imie IN VARCHAR2, Nazwisko IN VARCHAR2, Uprawnienia IN Number, AdresZamieszkania IN VARCHAR2, Telefon IN VARCHAR2);
    PROCEDURE AktualizujKlientaFirma(IDKlient IN NUMBER, NazwaFirmy IN VARCHAR2, NIP IN VARCHAR2, KRS IN VARCHAR2, Telefon IN VARCHAR2, Email IN VARCHAR2, AdresFirmy IN VARCHAR2);
    PROCEDURE AktualizujKlientaOsobaPrywatna(IDKlient IN NUMBER, Imie IN VARCHAR2, Nazwisko IN VARCHAR2, Uprawnienia IN Number, AdresZamieszkania IN VARCHAR2, Telefon IN VARCHAR2);
    PROCEDURE UsunKlienta(IDKlient IN NUMBER);
    PROCEDURE WyswietlKlienta(IDKlient IN NUMBER);
    PROCEDURE WyswietlWszystkichKlientow;
    
END PAKIETKLIENCI;
/
create or replace PACKAGE BODY PAKIETKLIENCI AS 

    PROCEDURE DodajKlientaFirma(IDKlient IN NUMBER, NazwaFirmy IN VARCHAR2, NIP IN VARCHAR2, KRS IN VARCHAR2, Telefon IN VARCHAR2, Email IN VARCHAR2, AdresFirmy IN VARCHAR2) IS
        Firma TypFirma; Klient TypKlient;
    BEGIN
        Firma := TypFirma(NazwaFirmy, NIP, KRS, Telefon, Email, AdresFirmy);
        Klient := TypKlient(IDKlient, Firma, NULL);
        
        INSERT INTO Klienci VALUES (Klient.IDKlient, Klient.Firma, Klient.Osoba);
        
        DBMS_OUTPUT.PUT_LINE('Dodano klienta-firmê: ' || NazwaFirmy || ' ');
        
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas dodawania klienta-firmy: ' || SQLERRM || ' ');
    END DodajKlientaFirma;

    PROCEDURE DodajKlientaOsobaPrywatna(IDKlient IN NUMBER, Imie IN VARCHAR2, Nazwisko IN VARCHAR2, Uprawnienia IN Number, AdresZamieszkania IN VARCHAR2, Telefon IN VARCHAR2) IS
        Osoba TypOsobaPrywatna; Klient TypKlient;
    BEGIN
        Osoba := TypOsobaPrywatna(Imie, Nazwisko, Uprawnienia, AdresZamieszkania, Telefon);
        Klient := TypKlient(IDKlient, NULL, Osoba);
        
        INSERT INTO Klienci VALUES (Klient.IDKlient, Klient.Firma, Klient.Osoba);
        
        DBMS_OUTPUT.PUT_LINE('Dodano klienta-osobê prywatn¹: ' || Imie || ' ' || Nazwisko || ' ');
        
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas dodawania klienta-osoby prywatnej: ' || SQLERRM || ' ');
    END DodajKlientaOsobaPrywatna;

    PROCEDURE AktualizujKlientaFirma(IDKlient IN NUMBER, NazwaFirmy IN VARCHAR2, NIP IN VARCHAR2, KRS IN VARCHAR2, Telefon IN VARCHAR2, Email IN VARCHAR2, AdresFirmy IN VARCHAR2) IS
        Firma TypFirma;
    BEGIN
        Firma := TypFirma(NazwaFirmy, NIP, KRS, Telefon, Email, AdresFirmy);
        UPDATE Klienci SET Firma = Firma WHERE IDKlient = IDKlient AND Firma IS NOT NULL;
        
        DBMS_OUTPUT.PUT_LINE('Zaktualizowano dane firmy: ' || NazwaFirmy || ' ');
        
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas aktualizacji danych firmy: ' || SQLERRM || ' ');
    END AktualizujKlientaFirma;

    PROCEDURE AktualizujKlientaOsobaPrywatna(IDKlient IN NUMBER, Imie IN VARCHAR2, Nazwisko IN VARCHAR2, Uprawnienia IN Number, AdresZamieszkania IN VARCHAR2, Telefon IN VARCHAR2) IS
        Osoba TypOsobaPrywatna;
    BEGIN
        Osoba := TypOsobaPrywatna(Imie, Nazwisko, Uprawnienia, AdresZamieszkania, Telefon);
        UPDATE Klienci SET Osoba = Osoba WHERE IDKlient = IDKlient AND Osoba IS NOT NULL;
        
        DBMS_OUTPUT.PUT_LINE('Zaktualizowano dane osoby prywatnej: ' || Imie || ' ' || Nazwisko || ' ');
        
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas aktualizacji danych osoby prywatnej: ' || SQLERRM || ' ');
    END AktualizujKlientaOsobaPrywatna;

    PROCEDURE UsunKlienta(IDKlient IN NUMBER) IS
    BEGIN
        DELETE FROM Klienci WHERE IDKlient = IDKlient;
        
        DBMS_OUTPUT.PUT_LINE('Usuniêto klienta o ID: ' || IDKlient || ' ');
        
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas usuwania klienta: ' || SQLERRM || ' ');
    END UsunKlienta;

   PROCEDURE WyswietlKlienta(IDKlient IN NUMBER) IS
        Klient TypKlient := TypKlient(NULL, NULL, NULL);
    BEGIN
        BEGIN
            SELECT IDKlient, Firma, Osoba 
            INTO Klient.IDKlient, Klient.Firma, Klient.Osoba
            FROM Klienci
            WHERE IDKlient = IDKlient
            FETCH FIRST 1 ROW ONLY;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Nie znaleziono klienta o ID: ' || IDKlient);
                RETURN;
        END;
    
        IF Klient.Firma IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Dane klienta-firmy: ' || Klient.Firma.NazwaFirmy || 
                                 ', NIP: ' || Klient.Firma.NIP || 
                                 ', KRS: ' || Klient.Firma.KRS || 
                                 ', Telefon: ' || Klient.Firma.Telefon || 
                                 ', Email: ' || Klient.Firma.Email || 
                                 ', Adres: ' || Klient.Firma.AdresFirmy);
        ELSIF Klient.Osoba IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Dane klienta-osoby prywatnej: ' || Klient.Osoba.Imie || 
                                 ' ' || Klient.Osoba.Nazwisko || 
                                 ', Uprawnienia: ' || Klient.Osoba.Uprawnienia || 
                                 ', Adres: ' || Klient.Osoba.AdresZamieszkania || 
                                 ', Telefon: ' || Klient.Osoba.Telefon);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Brak danych dla klienta o ID: ' || IDKlient);
        END IF;
    
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas wyœwietlania klienta: ' || SQLERRM);
    END WyswietlKlienta;
    
    
    PROCEDURE WyswietlWszystkichKlientow IS
    CURSOR c_Klienci IS
        SELECT IDKlient, Firma, Osoba
        FROM Klienci;

    Klient TypKlient := TypKlient(NULL, NULL, NULL); -- Inicjalizacja obiektu
BEGIN
    OPEN c_Klienci;
    LOOP
        FETCH c_Klienci INTO Klient.IDKlient, Klient.Firma, Klient.Osoba;
        EXIT WHEN c_Klienci%NOTFOUND;

        IF Klient.Firma IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Dane klienta-firmy: ' || Klient.Firma.NazwaFirmy || 
                                 ', NIP: ' || Klient.Firma.NIP || 
                                 ', KRS: ' || Klient.Firma.KRS || 
                                 ', Telefon: ' || Klient.Firma.Telefon || 
                                 ', Email: ' || Klient.Firma.Email || 
                                 ', Adres: ' || Klient.Firma.AdresFirmy);
        ELSIF Klient.Osoba IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Dane klienta-osoby prywatnej: ' || Klient.Osoba.Imie || 
                                 ' ' || Klient.Osoba.Nazwisko || 
                                 ', Uprawnienia: ' || Klient.Osoba.Uprawnienia || 
                                 ', Adres: ' || Klient.Osoba.AdresZamieszkania || 
                                 ', Telefon: ' || Klient.Osoba.Telefon);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Brak danych dla klienta o ID: ' || Klient.IDKlient);
        END IF;
    END LOOP;
    CLOSE c_Klienci;

EXCEPTION
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('B³¹d podczas wyœwietlania klientów: ' || SQLERRM);
END WyswietlWszystkichKlientow;

END PAKIETKLIENCI;
/
----------------------------------------------------------------------------------------------------------------------
-- Tworzenie Pakietu dla obiketów kategorie ----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

create or replace PACKAGE PAKIETKATEGORIE AS 

    PROCEDURE DodajKategorie(ID IN NUMBER, Nazwa IN VARCHAR2, Opis IN VARCHAR2);
    PROCEDURE AktualizujKategorie(ID IN NUMBER, Nazwa IN VARCHAR2, Opis IN VARCHAR2);
    PROCEDURE WyswietlKategorie(ID IN NUMBER);
    PROCEDURE UsunKategorie(ID IN NUMBER);
    
END PAKIETKATEGORIE;
/
create or replace PACKAGE BODY PAKIETKATEGORIE AS 

    PROCEDURE DodajKategorie(ID IN NUMBER, Nazwa IN VARCHAR2, Opis IN VARCHAR2) IS
    BEGIN
        INSERT INTO Kategorie (IDKategoria, Nazwa, Opis) VALUES (ID, Nazwa, Opis);
        
        DBMS_OUTPUT.PUT_LINE('Dodano kategoriê: ' || Nazwa);
        
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas dodawania kategorii: ' || SQLERRM);
    END DodajKategorie;

    PROCEDURE AktualizujKategorie(ID IN NUMBER, Nazwa IN VARCHAR2, Opis IN VARCHAR2) IS
    BEGIN
        UPDATE Kategorie SET Nazwa = Nazwa, Opis = Opis WHERE IDKategoria = ID;
        IF SQL%ROWCOUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Zaktualizowano kategoriê: ' || Nazwa);
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono kategorii o ID: ' || ID);
        END IF;
        
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas aktualizacji kategorii: ' || SQLERRM);
    END AktualizujKategorie;

    PROCEDURE WyswietlKategorie(ID IN NUMBER) IS
        v_Nazwa VARCHAR2(100); v_Opis VARCHAR2(200);
    BEGIN
        SELECT Nazwa, Opis INTO v_Nazwa, v_Opis FROM Kategorie WHERE IDKategoria = ID;
        
        DBMS_OUTPUT.PUT_LINE('Kategoria ID ' || ID || ': ' || v_Nazwa || ' - ' || v_Opis);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Brak kategorii o ID: ' || ID);
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas wyœwietlania kategorii: ' || SQLERRM);
    END WyswietlKategorie;

    PROCEDURE UsunKategorie(ID IN NUMBER) IS
    BEGIN
        DELETE FROM Kategorie WHERE IDKategoria = ID;
        IF SQL%ROWCOUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Usuniêto kategoriê o ID: ' || ID);
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono kategorii o ID: ' || ID);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas usuwania kategorii: ' || SQLERRM);
    END UsunKategorie;

END PAKIETKATEGORIE;
/
----------------------------------------------------------------------------------------------------------------------
-- Tworzenie Pakietu dla obiketów sprzet budowlany ----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
create or replace PACKAGE PAKIETSPRZETBUDOWLANY AS

    PROCEDURE DodajSprzet(ID IN NUMBER, Nazwa IN VARCHAR2, Kategoria IN TypKategoriaTable, Uprawnienia IN Number, Status IN VARCHAR2, Kwota IN NUMBER);
    PROCEDURE AktualizujSprzet(ID IN NUMBER, Nazwa IN VARCHAR2, Kategoria IN TypKategoriaTable, Uprawnienia IN Number, Status IN VARCHAR2, Kwota IN NUMBER);
    PROCEDURE WyswietlSprzet(ID IN NUMBER);
    PROCEDURE WyswietlWszystkieSprzety;
    PROCEDURE UsunSprzet(ID IN NUMBER);
    
END PAKIETSPRZETBUDOWLANY;
/
create or replace PACKAGE BODY PAKIETSPRZETBUDOWLANY AS

    PROCEDURE DodajSprzet(ID IN NUMBER, Nazwa IN VARCHAR2, Kategoria IN TypKategoriaTable, Uprawnienia IN Number, Status IN VARCHAR2, Kwota IN NUMBER) IS
    BEGIN
        INSERT INTO SprzetBudowlany (IDSprzet, NazwaSprzetu, Kategoria, Uprawnienia, Status, KwotaZaDzien) 
        VALUES (ID, Nazwa, Kategoria, Uprawnienia, Status, Kwota); 
        
        DBMS_OUTPUT.PUT_LINE('Dodano sprzêt budowlany: ' || Nazwa);
        
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas dodawania sprzêtu: ' || SQLERRM);
    END DodajSprzet;

    PROCEDURE AktualizujSprzet(ID IN NUMBER, Nazwa IN VARCHAR2, Kategoria IN TypKategoriaTable, Uprawnienia IN Number, Status IN VARCHAR2, Kwota IN NUMBER) IS
    BEGIN
        UPDATE SprzetBudowlany SET NazwaSprzetu = Nazwa, Kategoria = Kategoria, Uprawnienia = Uprawnienia, Status = Status, KwotaZaDzien = Kwota 
        WHERE IDSprzet = ID;
        IF SQL%ROWCOUNT > 0 THEN 
            DBMS_OUTPUT.PUT_LINE('Zaktualizowano sprzêt: ' || Nazwa);
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono sprzêtu o ID: ' || ID);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('B³¹d podczas aktualizacji sprzêtu: ' || SQLERRM);
    END AktualizujSprzet;

    PROCEDURE WyswietlSprzet(ID IN NUMBER) IS
        v_Nazwa VARCHAR2(100); v_Uprawnienia Number; v_Status VARCHAR2(50); v_Kwota NUMBER; v_Kategoria TypKategoriaTable;
    BEGIN
        SELECT NazwaSprzetu, Uprawnienia, Status, KwotaZaDzien, Kategoria INTO v_Nazwa, v_Uprawnienia, v_Status, v_Kwota, v_Kategoria 
        FROM SprzetBudowlany WHERE IDSprzet = ID;
        
        DBMS_OUTPUT.PUT_LINE('Sprzêt: ' || v_Nazwa || ', Uprawnienia: ' || v_Uprawnienia || ', Status: ' || v_Status || ', Kwota za dzieñ: ' || v_Kwota);
        
        FOR i IN 1 .. v_Kategoria.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Kategoria: ' || v_Kategoria(i).Nazwa);
        END LOOP;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('Brak sprzêtu o ID: ' || ID);
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas wyœwietlania sprzêtu: ' || SQLERRM);
    END WyswietlSprzet;
    
    
    PROCEDURE WyswietlWszystkieSprzety IS
        CURSOR c_Sprzet IS
            SELECT IDSprzet, NazwaSprzetu, Uprawnienia, Status, KwotaZaDzien, CAST(Kategoria AS TypKategoriaTable) AS Kategoria
            FROM SprzetBudowlany;
    
        v_IDSprzet NUMBER;
        v_Nazwa VARCHAR2(100);
        v_Uprawnienia NUMBER;
        v_Status VARCHAR2(50);
        v_Kwota NUMBER;
        v_Kategoria TypKategoriaTable;
    BEGIN
        OPEN c_Sprzet;
        LOOP
            FETCH c_Sprzet INTO v_IDSprzet, v_Nazwa, v_Uprawnienia, v_Status, v_Kwota, v_Kategoria;
            EXIT WHEN c_Sprzet%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('IDSprzêt: ' || v_IDSprzet || 
                                 ', Sprzêt: ' || v_Nazwa || 
                                 ', Uprawnienia: ' || v_Uprawnienia || 
                                 ', Status: ' || v_Status || 
                                 ', Kwota za dzieñ: ' || v_Kwota);
    
            IF v_Kategoria IS NOT NULL THEN
                FOR i IN 1 .. v_Kategoria.COUNT LOOP
                    DBMS_OUTPUT.PUT_LINE('   Kategoria: ' || v_Kategoria(i).Nazwa);
                END LOOP;
            ELSE
                DBMS_OUTPUT.PUT_LINE('   Brak kategorii dla tego sprzêtu.');
            END IF;
        END LOOP;
        CLOSE c_Sprzet;
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas wyœwietlania sprzêtów: ' || SQLERRM);
    END WyswietlWszystkieSprzety;
    

    PROCEDURE UsunSprzet(ID IN NUMBER) IS
    BEGIN
        DELETE FROM SprzetBudowlany WHERE IDSprzet = ID;
        IF SQL%ROWCOUNT > 0 THEN 
            DBMS_OUTPUT.PUT_LINE('Usuniêto sprzêt o ID: ' || ID); 
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono sprzêtu o ID: ' || ID); 
        END IF;
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas usuwania sprzêtu: ' || SQLERRM);
    END UsunSprzet;

END PAKIETSPRZETBUDOWLANY;
/
---------------------------------------------------------------------------------------------------------------------
-- Tworzenie Pakietu dla obiketów przeglad naprawy ----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
create or replace PACKAGE PakietPrzegladyNaprawy AS 

    PROCEDURE DodajNaprawe(p_IDNaprawa IN NUMBER, p_IDSprzet IN NUMBER, p_Sprzet IN VARCHAR2, p_Data IN DATE, p_Koszt IN NUMBER, p_Typ IN VARCHAR2, p_Opis IN VARCHAR2);
    PROCEDURE AktualizujNaprawe(p_IDNaprawa IN NUMBER, p_IDSprzet IN NUMBER, p_Sprzet IN VARCHAR2, p_Data IN DATE, p_Koszt IN NUMBER, p_Typ IN VARCHAR2, p_Opis IN VARCHAR2);
    PROCEDURE UsunNaprawe(p_IDNaprawa IN NUMBER);
    PROCEDURE WyswietlNaprawy;

END PakietPrzegladyNaprawy;
/

create or replace PACKAGE BODY PakietPrzegladyNaprawy AS
    PROCEDURE DodajNaprawe(
        p_IDNaprawa IN NUMBER,
        p_IDSprzet IN NUMBER,
        p_Sprzet IN VARCHAR2,
        p_Data IN DATE,
        p_Koszt IN NUMBER,
        p_Typ IN VARCHAR2,
        p_Opis IN VARCHAR2
    ) IS
        v_Data DATE;
        v_Count NUMBER;
        v_RefSprzet REF TypSprzet;
    BEGIN
        SELECT REF(s)
        INTO v_RefSprzet
        FROM SprzetBudowlany s
        WHERE s.IDSprzet = p_IDSprzet;

        INSERT INTO PrzegladyNaprawy
        VALUES (TypPrzegladyNaprawy(p_IDNaprawa, v_RefSprzet, p_Sprzet, p_Data, p_Koszt, p_Typ, p_Opis));
        
        v_Data := p_Data;

        WHILE v_Data <= p_Data + 1 LOOP
            SELECT COUNT(*)
            INTO v_Count
            FROM ZajeteDniSprzetu z
            WHERE DEREF(z.RefSprzet).IDSprzet = p_IDSprzet
              AND z.Data = v_Data;
    
            IF v_Count > 0 THEN
                RAISE_APPLICATION_ERROR(-20006, 'Sprzêt o ID ' || p_IDSprzet || ' jest ju¿ zajêty w dniu: ' || TO_CHAR(v_Data, 'YYYY-MM-DD'));
            END IF;
    
            PAKIETZAJETEDNI.DodajZajetyDzien(
                p_IDZajeteDni => SEQ_ZajeteDni.NEXTVAL,
                p_Data => v_Data,
                p_IDSprzet => p_IDSprzet
            );
            

            v_Data := v_Data + 1;
        END LOOP;
    
        DBMS_OUTPUT.PUT_LINE('Naprawa zosta³a dodana i dni zosta³y oznaczone jako zajête.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas dodawania naprawy: ' || SQLERRM);
    END DodajNaprawe;

    PROCEDURE AktualizujNaprawe(
        p_IDNaprawa IN NUMBER,
        p_IDSprzet IN NUMBER,
        p_Sprzet IN VARCHAR2,
        p_Data IN DATE,
        p_Koszt IN NUMBER,
        p_Typ IN VARCHAR2,
        p_Opis IN VARCHAR2
    ) IS
        v_RefSprzet REF TypSprzet;
    BEGIN
        SELECT REF(s)
        INTO v_RefSprzet
        FROM SprzetBudowlany s
        WHERE s.IDSprzet = p_IDSprzet;


        UPDATE PrzegladyNaprawy
        SET RefSprzet = v_RefSprzet, Sprzet = p_Sprzet, Data = p_Data, Koszt = p_Koszt, Typ = p_Typ, Opis = p_Opis
        WHERE IDNaprawa = p_IDNaprawa;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono naprawy o podanym ID.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Naprawa zosta³a zaktualizowana.');
        END IF;
    END AktualizujNaprawe;


    PROCEDURE UsunNaprawe(p_IDNaprawa IN NUMBER) IS
        v_IDSprzet NUMBER;
        v_Data DATE;
        v_DataKoniec DATE;
        v_RefSprzet REF TypSprzet;
        CURSOR c_ZajeteDni IS
            SELECT IDZajeteDni
            FROM ZajeteDniSprzetu z
            WHERE DEREF(z.RefSprzet) = DEREF(v_RefSprzet)
              AND z.Data BETWEEN v_Data AND v_DataKoniec;
        v_ZajetyDzienID NUMBER;
    BEGIN
        SELECT RefSprzet, Data, Data + 1 
        INTO v_RefSprzet, v_Data, v_DataKoniec
        FROM PrzegladyNaprawy
        WHERE IDNaprawa = p_IDNaprawa;
    
        DELETE FROM PrzegladyNaprawy
        WHERE IDNaprawa = p_IDNaprawa;
    
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono naprawy o podanym ID.');
            RETURN;
        END IF;
    
        OPEN c_ZajeteDni;
        LOOP
            FETCH c_ZajeteDni INTO v_ZajetyDzienID;
            EXIT WHEN c_ZajeteDni%NOTFOUND;
    
            PAKIETZAJETEDNI.UsunZajetyDzien(v_ZajetyDzienID);
            DBMS_OUTPUT.PUT_LINE('Zajêty dzieñ o ID ' || v_ZajetyDzienID || ' zosta³ usuniêty.');
        END LOOP;
        CLOSE c_ZajeteDni;
    
        DBMS_OUTPUT.PUT_LINE('Naprawa zosta³a usuniêta wraz z zajêtymi dniami.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono naprawy o podanym ID.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas usuwania naprawy: ' || SQLERRM);
    END UsunNaprawe;

    PROCEDURE WyswietlNaprawy IS
        CURSOR curNaprawy IS 
            SELECT IDNaprawa, DEREF(RefSprzet).IDSprzet AS IDSprzet, Sprzet, Data, Koszt, Typ, Opis 
            FROM PrzegladyNaprawy;
        recNaprawa curNaprawy%ROWTYPE;
    BEGIN
        OPEN curNaprawy;
        LOOP
            FETCH curNaprawy INTO recNaprawa;
            EXIT WHEN curNaprawy%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE('ID Naprawy: ' || recNaprawa.IDNaprawa || 
                                 ', ID Sprzêtu: ' || recNaprawa.IDSprzet || 
                                 ', Sprzêt: ' || recNaprawa.Sprzet);
            DBMS_OUTPUT.PUT_LINE('Data: ' || recNaprawa.Data || 
                                 ', Koszt: ' || recNaprawa.Koszt || 
                                 ', Typ: ' || recNaprawa.Typ || 
                                 ', Opis: ' || recNaprawa.Opis);
            DBMS_OUTPUT.PUT_LINE('----------------------------------');
        END LOOP;
        CLOSE curNaprawy;
    END WyswietlNaprawy;

END PakietPrzegladyNaprawy;
/
---------------------------------------------------------------------------------------------------------------------
-- Tworzenie Pakietu dla obiketów dodatkowe koszta ----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
create or replace PACKAGE PakietDodatkoweKoszta AS

    PROCEDURE DodajKoszt(p_IDKoszt IN NUMBER, p_Nazwa IN VARCHAR2, p_Opis IN VARCHAR2, p_Kwota IN NUMBER, p_IDWypozyczenie IN NUMBER);
    PROCEDURE UsunKoszt(p_IDKoszt IN NUMBER);
    PROCEDURE AktualizujKoszt(p_IDKoszt IN NUMBER, p_Nazwa IN VARCHAR2, p_Opis IN VARCHAR2, p_Kwota IN NUMBER, p_IDWypozyczenie IN NUMBER);
    PROCEDURE WyswietlKoszta;
    Procedure DoZaplaty(p_IDWypozyczenia IN NUmber);

END PakietDodatkoweKoszta;
/
create or replace PACKAGE BODY PakietDodatkoweKoszta AS

    PROCEDURE DodajKoszt(p_IDKoszt IN NUMBER, p_Nazwa IN VARCHAR2, p_Opis IN VARCHAR2, p_Kwota IN NUMBER, p_IDWypozyczenie IN NUMBER) IS
        v_RefWypozyczenie REF TypWypozyczenie;
    BEGIN
        SELECT REF(w)
        INTO v_RefWypozyczenie
        FROM Wypozyczenia w
        WHERE w.IDWypozyczenie = p_IDWypozyczenie;

        INSERT INTO DodatkoweKoszta VALUES (TypDodatkoweKoszta(p_IDKoszt, p_Nazwa, p_Opis, p_Kwota, v_RefWypozyczenie));
        
        DBMS_OUTPUT.PUT_LINE('Koszt zosta³ dodany.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono wypo¿yczenia o ID: ' || p_IDWypozyczenie);
    END DodajKoszt;

    PROCEDURE UsunKoszt(p_IDKoszt IN NUMBER) IS
    BEGIN
        DELETE FROM DodatkoweKoszta WHERE IDKoszt = p_IDKoszt;
        IF SQL%ROWCOUNT = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono kosztu o podanym ID.');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Koszt zosta³ usuniêty.');
        END IF;
    END UsunKoszt;

    PROCEDURE AktualizujKoszt(p_IDKoszt IN NUMBER, p_Nazwa IN VARCHAR2, p_Opis IN VARCHAR2, p_Kwota IN NUMBER, p_IDWypozyczenie IN NUMBER) IS
        v_RefWypozyczenie REF TypWypozyczenie;
    BEGIN
        SELECT REF(w)
        INTO v_RefWypozyczenie
        FROM Wypozyczenia w
        WHERE w.IDWypozyczenie = p_IDWypozyczenie;

        UPDATE DodatkoweKoszta 
        SET Nazwa = p_Nazwa, 
            Opis = p_Opis, 
            Kwota = p_Kwota, 
            RefWypozyczenie = v_RefWypozyczenie
        WHERE IDKoszt = p_IDKoszt;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono kosztu o podanym ID.');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Koszt zosta³ zaktualizowany.');
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono wypo¿yczenia o ID: ' || p_IDWypozyczenie);
    END AktualizujKoszt;

    PROCEDURE WyswietlKoszta IS
        CURSOR curKoszta IS 
            SELECT dk.IDKoszt, dk.Nazwa, dk.Opis, dk.Kwota, DEREF(dk.RefWypozyczenie).IDWypozyczenie AS ID_Wypozyczenia
            FROM DodatkoweKoszta dk;

        recKoszt curKoszta%ROWTYPE;
    BEGIN
        OPEN curKoszta;
        LOOP
            FETCH curKoszta INTO recKoszt;
            EXIT WHEN curKoszta%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('ID Kosztu: ' || recKoszt.IDKoszt || 
                                 ', Nazwa: ' || recKoszt.Nazwa || 
                                 ', Opis: ' || recKoszt.Opis || 
                                 ', Kwota: ' || recKoszt.Kwota || 
                                 ', ID Wypo¿yczenia: ' || recKoszt.ID_Wypozyczenia);
        END LOOP;
        CLOSE curKoszta;
    END WyswietlKoszta;
    
    PROCEDURE DoZaplaty(p_IDWypozyczenia IN NUMBER)
    IS
        v_KwotaWypozyczenia NUMBER := 0;
        v_Zaliczka NUMBER := 0;
        v_DodatkoweKoszty NUMBER := 0;
        v_KwotaDoZaplaty NUMBER := 0;
    
        v_RefWypozyczenie REF TypWypozyczenie;
        v_Wypozyczenie TypWypozyczenie;
    BEGIN
        SELECT REF(w)
        INTO v_RefWypozyczenie
        FROM Wypozyczenia w
        WHERE w.IDWypozyczenie = p_IDWypozyczenia;

        SELECT DEREF(v_RefWypozyczenie)
        INTO v_Wypozyczenie
        FROM DUAL;
    
        v_KwotaWypozyczenia := v_Wypozyczenie.Kwota;
        v_Zaliczka := v_Wypozyczenie.Zaliczka;

        SELECT NVL(SUM(dk.Kwota), 0)
        INTO v_DodatkoweKoszty
        FROM DodatkoweKoszta dk
        WHERE dk.RefWypozyczenie.IDWypozyczenie = p_IDWypozyczenia;

        v_KwotaDoZaplaty := v_KwotaWypozyczenia - v_Zaliczka + v_DodatkoweKoszty;
    
        DBMS_OUTPUT.PUT_LINE('Kwota do zap³aty dla wypo¿yczenia o ID ' || p_IDWypozyczenia || ' wynosi: ' || v_KwotaDoZaplaty);
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono wypo¿yczenia o podanym ID: ' || p_IDWypozyczenia);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
    END;
    
    

END PakietDodatkoweKoszta;
/
----------------------------------------------------------------------------------------------------------------------
-- Tworzenie Pakietu dla obiekt rezerwacje ----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

create or replace PACKAGE PAKIETREZERWACJE AS 

    PROCEDURE DodajRezerwacje(p_IDKlient IN NUMBER,p_IDSprzet IN NUMBER,p_DataRezerwacji IN DATE,p_DataStartu IN DATE,p_DataKonca IN DATE );
    PROCEDURE UsunRezerwacje(p_IDRezerwacja IN NUMBER);
    PROCEDURE WyswietlRezerwacjeKlienta(p_IDKlient IN NUMBER);
    PROCEDURE WyswietlWszystkieRezerwacje;

END PAKIETREZERWACJE;
/
create or replace PACKAGE BODY PAKIETREZERWACJE AS

    PROCEDURE DodajRezerwacje(
        p_IDKlient IN NUMBER,
        p_IDSprzet IN NUMBER,
        p_DataRezerwacji IN DATE,
        p_DataStartu IN DATE,
        p_DataKonca IN DATE
    ) IS
        v_ID number;
        v_Count NUMBER;
        v_Uprawnienia BOOLEAN;
        v_Data DATE;
        v_RefKlient REF TypKlient; 
        v_RefSprzet REF TypSprzet; 
    BEGIN
        SELECT REF(k)
        INTO v_RefKlient
        FROM Klienci k
        WHERE k.IDKlient = p_IDKlient;

        SELECT REF(s)
        INTO v_RefSprzet
        FROM SprzetBudowlany s
        WHERE s.IDSprzet = p_IDSprzet;
        
        v_Uprawnienia := CzyKlientMaUprawnienia(p_IDKlient, p_IDSprzet);
        IF NOT v_Uprawnienia THEN
            RAISE_APPLICATION_ERROR(-20004, 'Klient nie ma wymaganych uprawnieñ na sprzêt.');
        END IF;

        IF NOT CzyLimitCzasuWypozyczeniaPrzekroczony(
            IDKlienta => p_IDKlient,
            DataZwrotu => p_DataKonca,
            DataWypozyczenia => p_DataStartu
        ) THEN
            RAISE_APPLICATION_ERROR(-20002, 'Limit czasu wypo¿yczenia zosta³ przekroczony.');
        END IF;

        

        SELECT COUNT(*)
        INTO v_Count
        FROM ZajeteDniSprzetu z
        WHERE DEREF(z.RefSprzet).IDSprzet = p_IDSprzet
          AND z.Data BETWEEN p_DataStartu AND p_DataKonca;

        IF v_Count > 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Sprzêt jest zajêty w podanym okresie.');
        END IF;
        
        v_ID :=seq_rezerwacje.nextval;
        INSERT INTO Rezerwacje VALUES (
            v_ID,
            v_RefKlient,
            v_RefSprzet,
            p_DataRezerwacji,
            p_DataStartu,
            p_DataKonca
        );


        v_Data := p_DataStartu;
        WHILE v_Data <= p_DataKonca LOOP
            PAKIETZAJETEDNI.DodajZajetyDzien(
                p_IDZajeteDni => SEQ_ZAJETEDNI.NEXTVAL, 
                p_Data => v_Data,
                p_IDSprzet => p_IDSprzet
            );
            v_Data := v_Data + 1;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('Dodano rezerwacjê ID: ' || v_ID);

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas dodawania rezerwacji: ' || SQLERRM);
    END DodajRezerwacje;


    PROCEDURE UsunRezerwacje(
        p_IDRezerwacja IN NUMBER
    ) IS
        v_RefSprzet REF TypSprzet;
        v_DataStart DATE;
        v_DataKoniec DATE;
        v_IDZajeteDni NUMBER;
        CURSOR c_ZajeteDni IS
            SELECT IDZajeteDni
            FROM ZajeteDniSprzetu z
            WHERE DEREF(z.RefSprzet) = DEREF(v_RefSprzet)
              AND z.Data BETWEEN v_DataStart AND v_DataKoniec;
    BEGIN
        SELECT RefSprzet, Data_Startu, Data_Konca
        INTO v_RefSprzet, v_DataStart, v_DataKoniec
        FROM Rezerwacje
        WHERE IDRezerwacja = p_IDRezerwacja;
    
        DELETE FROM Rezerwacje
        WHERE IDRezerwacja = p_IDRezerwacja;
    
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono rezerwacji o ID: ' || p_IDRezerwacja);
            RETURN;
        END IF;
    
        OPEN c_ZajeteDni;
        LOOP
            FETCH c_ZajeteDni INTO v_IDZajeteDni;
            EXIT WHEN c_ZajeteDni%NOTFOUND;
    
            BEGIN
                PAKIETZAJETEDNI.UsunZajetyDzien(
                    p_IDZajeteDni => v_IDZajeteDni
                );
    
                DBMS_OUTPUT.PUT_LINE('Usuniêto zajêty dzieñ o ID: ' || v_IDZajeteDni || ' dla sprzêtu');
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('B³¹d podczas usuwania zajêtego dnia o ID: ' || v_IDZajeteDni || ' - ' || SQLERRM);
            END;
        END LOOP;
        CLOSE c_ZajeteDni;
    
        DBMS_OUTPUT.PUT_LINE('Rezerwacja ID: ' || p_IDRezerwacja || ' zosta³a usuniêta wraz z zajêtymi dniami.');
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono rezerwacji o ID: ' || p_IDRezerwacja);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas usuwania rezerwacji: ' || SQLERRM);
    END UsunRezerwacje;


    PROCEDURE WyswietlRezerwacjeKlienta(
        p_IDKlient IN NUMBER
    ) IS
        v_RefKlient REF TypKlient;
    BEGIN
        SELECT REF(k)
        INTO v_RefKlient
        FROM Klienci k
        WHERE k.IDKlient = p_IDKlient;
    
        FOR rec IN (
            SELECT r.IDRezerwacja, r.data_startu, r.data_konca, DEREF(r.RefSprzet).IDSprzet AS SprzetID
            FROM Rezerwacje r
            WHERE r.RefKlient = v_RefKlient
            ORDER BY r.data_rezerwacji
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('ID Rezerwacji: ' || rec.IDRezerwacja ||
                                 ', Sprzêt ID: ' || rec.SprzetID ||  -- U¿ycie aliasu SprzetID
                                 ', Data Startu: ' || rec.data_startu ||
                                 ', Data Koñca: ' || rec.data_konca);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas wyœwietlania rezerwacji: ' || SQLERRM);
    END WyswietlRezerwacjeKlienta;
    
    PROCEDURE WyswietlWszystkieRezerwacje IS
    BEGIN
        FOR rec IN (
            SELECT r.IDRezerwacja, r.data_startu, r.data_konca, 
                   DEREF(r.RefSprzet).IDSprzet AS SprzetID, r.data_rezerwacji
            FROM Rezerwacje r
            ORDER BY r.data_rezerwacji 
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('ID Rezerwacji: ' || rec.IDRezerwacja ||
                                 ', Sprzêt ID: ' || rec.SprzetID ||  -- U¿ycie aliasu SprzetID
                                 ', Data Startu: ' || rec.data_startu ||
                                 ', Data Koñca: ' || rec.data_konca ||
                                 ', Data Rezerwacji: ' || rec.data_rezerwacji);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas wyœwietlania rezerwacji: ' || SQLERRM);
    END WyswietlWszystkieRezerwacje;

END PAKIETREZERWACJE;
/
---------------------------------------------------------------------------------------------------------------------
-- Tworzenie Pakietu dla obiketów wypozyczniea ----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
create or replace PACKAGE PakietWypozyczenia AS 

    PROCEDURE DodajWypozyczenie( p_IDKlient IN NUMBER, p_IDSprzet IN NUMBER, p_DataWypozyczenia IN DATE, p_DataZwrotu IN DATE); 
    PROCEDURE UsunWypozyczenie(p_IDWypozyczenie IN NUMBER); 
    PROCEDURE WyswietlWypozyczeniaKlienta(p_IDKlient in NUMBER);
    PROCEDURE WyswietlWszystkieWypozyczenia;
    
END PakietWypozyczenia;
/
create or replace PACKAGE BODY PakietWypozyczenia AS

    PROCEDURE DodajWypozyczenie(
        p_IDKlient IN NUMBER,
        p_IDSprzet IN NUMBER,
        p_DataWypozyczenia IN DATE,
        p_DataZwrotu IN DATE
    ) IS
        v_ID number;
        v_RefKlient REF TypKlient;
        v_RefSprzet REF TypSprzet;
        v_kwota NUMBER;
        v_Count NUMBER;
        v_Data DATE;
        v_Uprawnienia BOOLEAN;
        v_Return BOOLEAN;
    BEGIN
        SELECT REF(k) INTO v_RefKlient
        FROM Klienci k
        WHERE k.IDKlient = p_IDKlient;

        SELECT REF(s) INTO v_RefSprzet
        FROM SprzetBudowlany s
        WHERE s.IDSprzet = p_IDSprzet;

        v_Return := CzyLimitCzasuWypozyczeniaPrzekroczony(
            IDKlienta => p_IDKlient,
            DataZwrotu => p_DataZwrotu,
            DataWypozyczenia => p_DataWypozyczenia
        );

        IF NOT v_Return THEN
            RAISE_APPLICATION_ERROR(-20002, 'Limit czasu wypo¿yczenia zosta³ przekroczony.');
        END IF;

        

        SELECT COUNT(*)
        INTO v_Count
        FROM ZajeteDniSprzetu
        WHERE DEREF(RefSprzet).IDSprzet = p_IDSprzet
          AND Data BETWEEN p_DataWypozyczenia AND p_DataZwrotu;

        IF v_Count > 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Sprzêt jest zajêty w podanym okresie.');
        END IF;
        
        v_Uprawnienia := CzyKlientMaUprawnienia(p_IDKlient, p_IDSprzet);

        IF NOT v_Uprawnienia THEN
            RAISE_APPLICATION_ERROR(-20005, 'Klient nie ma wymaganych uprawnieñ na sprzêt.');
        END IF;

        v_kwota := OBLICZKWOTEWYPOZYCZENIA(
            IDSprzet2 => p_IDSprzet,
            DataWyp => p_DataWypozyczenia,
            DataZwrotu => p_DataZwrotu
        );
    
    
        v_ID := seq_wypozyczenia.nextval;
        INSERT INTO Wypozyczenia 
        VALUES (
            TypWypozyczenie(v_ID, v_RefKlient, v_RefSprzet, p_DataWypozyczenia, p_DataZwrotu, v_Kwota, v_Kwota*0.3)
        );

        v_Data := p_DataWypozyczenia;
        WHILE v_Data <= p_DataZwrotu LOOP
            PAKIETZAJETEDNI.DodajZajetyDzien(
                p_IDZajeteDni => SEQ_ZAJETEDNI.NEXTVAL,
                p_Data => v_Data,
                p_IDSprzet => p_IDSprzet
            );
            v_Data := v_Data + 1;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('Wypo¿yczenie zosta³o dodane. ID: ' || v_ID);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d: Klient lub sprzêt nie istnieje.');
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d: Wypo¿yczenie o ID ' || v_ID || ' ju¿ istnieje.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Nieoczekiwany b³¹d: ' || SQLERRM);
    END DodajWypozyczenie;


    PROCEDURE UsunWypozyczenie(p_IDWypozyczenie IN NUMBER) IS
        v_RefKlient REF TypKlient;
        v_RefSprzet REF TypSprzet;
        v_DataStart DATE;
        v_DataKoniec DATE;
        v_IDSprzet NUMBER; 
        CURSOR c_ZajeteDni IS
            SELECT IDZajeteDni
            FROM ZajeteDniSprzetu z
            WHERE DEREF(z.RefSprzet) = DEREF(v_RefSprzet)
              AND z.Data BETWEEN v_DataStart AND v_DataKoniec;
        v_ZajetyDzienID NUMBER;
    BEGIN

        SELECT RefSprzet, DataWypozyczenia, DataZwrotu
        INTO v_RefSprzet, v_DataStart, v_DataKoniec
        FROM Wypozyczenia
        WHERE IDWypozyczenie = p_IDWypozyczenie;
    
        DELETE FROM Wypozyczenia
        WHERE IDWypozyczenie = p_IDWypozyczenie;
    
        OPEN c_ZajeteDni;
        LOOP
            FETCH c_ZajeteDni INTO v_ZajetyDzienID;
            EXIT WHEN c_ZajeteDni%NOTFOUND;
    
            PAKIETZAJETEDNI.UsunZajetyDzien(v_ZajetyDzienID);
            DBMS_OUTPUT.PUT_LINE('Zajêty dzieñ o ID ' || v_ZajetyDzienID || ' zosta³ usuniêty.');
        END LOOP;
        CLOSE c_ZajeteDni;
    
        DBMS_OUTPUT.PUT_LINE('Wypo¿yczenie zosta³o usuniête wraz z zajêtymi dniami. ID: ' || p_IDWypozyczenie);
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono wypo¿yczenia o podanym ID: ' || p_IDWypozyczenie);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas usuwania wypo¿yczenia: ' || SQLERRM);
    END UsunWypozyczenie;


    PROCEDURE WyswietlWypozyczeniaKlienta(p_IDKlient IN NUMBER) IS 
        v_RefKlient REF TypKlient; 
    BEGIN
        SELECT REF(k)
        INTO v_RefKlient
        FROM Klienci k
        WHERE k.IDKlient = p_IDKlient;
    
        FOR rec IN (
            SELECT w.IDWypozyczenie, w.DataWypozyczenia, w.DataZwrotu, 
                   DEREF(w.RefSprzet).IDSprzet AS SprzetID, w.Kwota, w.Zaliczka
            FROM Wypozyczenia w
            WHERE w.RefKlient = v_RefKlient 
            ORDER BY w.DataWypozyczenia 
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('ID Wypo¿yczenia: ' || rec.IDWypozyczenie ||
                                 ', Sprzêt ID: ' || rec.SprzetID ||  -- U¿ycie aliasu SprzetID
                                 ', Data Wypo¿yczenia: ' || rec.DataWypozyczenia ||
                                 ', Data Zwrotu: ' || rec.DataZwrotu ||
                                 ', Kwota: ' || rec.Kwota ||
                                 ', Zaliczka: ' || rec.Zaliczka);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas wyœwietlania wypo¿yczeñ: ' || SQLERRM);
    END WyswietlWypozyczeniaKlienta;
    
    PROCEDURE WyswietlWszystkieWypozyczenia IS
    BEGIN
        FOR rec IN (
            SELECT w.IDWypozyczenie, w.DataWypozyczenia, w.DataZwrotu, 
                   DEREF(w.RefSprzet).IDSprzet AS SprzetID, w.Kwota, w.Zaliczka
            FROM Wypozyczenia w
            ORDER BY w.DataWypozyczenia 
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('ID Wypo¿yczenia: ' || rec.IDWypozyczenie ||
                                 ', Sprzêt ID: ' || rec.SprzetID ||  -- U¿ycie aliasu SprzetID
                                 ', Data Wypo¿yczenia: ' || rec.DataWypozyczenia ||
                                 ', Data Zwrotu: ' || rec.DataZwrotu ||
                                 ', Kwota: ' || rec.Kwota ||
                                 ', Zaliczka: ' || rec.Zaliczka);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas wyœwietlania wypo¿yczeñ: ' || SQLERRM);
    END WyswietlWszystkieWypozyczenia;
END PakietWypozyczenia;
/
---------------------------------------------------------------------------------------------------------------------
-- Tworzenie Pakietu dla obiketów zajetedni ----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
create or replace PACKAGE PAKIETZAJETEDNI AS
    
    PROCEDURE DodajZajetyDzien(p_IDZajeteDni IN NUMBER,p_Data IN DATE,p_IDSprzet number);
    PROCEDURE WyswietlZajeteDni(p_IDSprzet IN NUMBER);
    PROCEDURE UsunZajetyDzien(p_IDZajeteDni IN NUMBER);
    PROCEDURE WyswietlWolneTerminy(p_IDSprzet IN NUMBER);
    
END PAKIETZAJETEDNI;
/

create or replace PACKAGE BODY PAKIETZAJETEDNI AS
    PROCEDURE DodajZajetyDzien(
        p_IDZajeteDni IN NUMBER,
        p_Data IN DATE,
        p_IDSprzet IN NUMBER
    ) AS
        v_RefSprzet REF TypSprzet;
    BEGIN
        SELECT REF(s) INTO v_RefSprzet
        FROM SprzetBudowlany s
        WHERE s.IDSprzet = p_IDSprzet;

        INSERT INTO ZajeteDniSprzetu (IDZajeteDni, Data, RefSprzet)
        VALUES (p_IDZajeteDni, p_Data, v_RefSprzet);
        COMMIT;
    END DodajZajetyDzien;

    PROCEDURE WyswietlZajeteDni(
        p_IDSprzet IN NUMBER
    ) AS
        CURSOR c_ZajeteDni IS
            SELECT IDZajeteDni, Data
            FROM ZajeteDniSprzetu z
            WHERE DEREF(z.RefSprzet).IDSprzet = p_IDSprzet;
        v_Row c_ZajeteDni%ROWTYPE;
    BEGIN
        OPEN c_ZajeteDni;
        LOOP
            FETCH c_ZajeteDni INTO v_Row;
            EXIT WHEN c_ZajeteDni%NOTFOUND;
    
            DBMS_OUTPUT.PUT_LINE('ID Zajête Dni: ' || v_Row.IDZajeteDni);
            DBMS_OUTPUT.PUT_LINE('Data: ' || TO_CHAR(v_Row.Data, 'DD-MM-YYYY'));
            DBMS_OUTPUT.PUT_LINE('-------------------------');
        END LOOP;
        CLOSE c_ZajeteDni;
    END WyswietlZajeteDni;
    
    PROCEDURE WyswietlWolneTerminy(
        p_IDSprzet IN NUMBER
    ) AS
        v_DzisiejszaData DATE := SYSDATE;
        v_DataKoncowa DATE := ADD_MONTHS(SYSDATE, 3); 
        v_DataIteracji DATE;
        v_Count NUMBER; 
    BEGIN
        v_DataIteracji := TRUNC(v_DzisiejszaData); 
    
        DBMS_OUTPUT.PUT_LINE('Wolne terminy dla sprzêtu ID: ' || p_IDSprzet || ' w ci¹gu najbli¿szych 3 miesiêcy:');
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    

        WHILE v_DataIteracji <= v_DataKoncowa LOOP
            SELECT COUNT(*)
            INTO v_Count
            FROM ZajeteDniSprzetu z
            WHERE DEREF(z.RefSprzet).IDSprzet = p_IDSprzet
              AND TRUNC(z.Data) = v_DataIteracji;
    
            IF v_Count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Wolny termin: ' || TO_CHAR(v_DataIteracji, 'DD-MM-YYYY'));
            END IF;

            v_DataIteracji := v_DataIteracji + 1;
        END LOOP;
    
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d podczas wyœwietlania wolnych terminów: ' || SQLERRM);
    END WyswietlWolneTerminy;

    
    PROCEDURE UsunZajetyDzien(
        p_IDZajeteDni IN NUMBER
    ) AS
    BEGIN
        DELETE FROM ZajeteDniSprzetu
        WHERE IDZajeteDni = p_IDZajeteDni;
        COMMIT;
    END UsunZajetyDzien;

END PAKIETZAJETEDNI;
/
-----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
---- funkcja sprawdzajca czy liczba dni wypozyczeni rezerwacji jest poprawna

create or replace FUNCTION CzyLimitCzasuWypozyczeniaPrzekroczony(
    IDKlienta IN NUMBER,
    DataZwrotu IN DATE,
    DataWypozyczenia IN DATE
) RETURN BOOLEAN IS
    DniLimit NUMBER;
    RodzajKlienta VARCHAR2(20);
BEGIN

    SELECT 
        CASE 
            WHEN Firma IS NOT NULL THEN 'Firma'
            WHEN Osoba IS NOT NULL THEN 'OsobaPrywatna'
            ELSE 'Nieznany'
        END
    INTO RodzajKlienta
    FROM Klienci
    WHERE IDKlient = IDKlienta;

    IF RodzajKlienta = 'Firma' THEN
        DniLimit := 30;
    ELSIF RodzajKlienta = 'OsobaPrywatna' THEN
        DniLimit := 14;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Nieznany typ klienta');
    END IF;
    
    IF DataZwrotu<  DataWypozyczenia THEN
        RAISE_APPLICATION_ERROR(-20006, 'Data zwrotu musi byæ póŸniesza ni¿ data wypo¿yczenia.');
    END IF;

    IF (DataZwrotu - DataWypozyczenia) <= 1 THEN
        RAISE_APPLICATION_ERROR(-20005, 'nie mo¿na wpo¿yczyæ na jeden dzien.');
    END IF;

    IF (DataZwrotu - DataWypozyczenia) > DniLimit THEN
        RAISE_APPLICATION_ERROR(-20005, 'Przekroczony limit dni.');
    END IF;

    IF DataWypozyczenia < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20002, 'Data wypo¿yczenia nie mo¿e byæ wczeœniejsza ni¿ dzisiaj.');
    END IF;

    IF DataWypozyczenia > ADD_MONTHS(SYSDATE, 3) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Data wypo¿yczenia nie mo¿e byæ póŸniejsza ni¿ 3 miesi¹ce od dzisiaj.');
    END IF;

    IF DataZwrotu > ADD_MONTHS(SYSDATE, 3) THEN
        RAISE_APPLICATION_ERROR(-20004, 'Data zwrotu nie mo¿e byæ póŸniejsza ni¿ 3 miesi¹ce od dzisiaj.');
    END IF;

    RETURN TRUE;
END;
/
--------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- funkcja sprawdzajaca czy klient ma uprawnienia
create or replace FUNCTION CzyKlientMaUprawnienia(
    IDKlienta IN NUMBER,
    IDSprzet2 IN NUMBER
) RETURN BOOLEAN IS
    v_Osoba TypOsobaPrywatna;
    v_UprawnieniaKlienta NUMBER(1);
    v_UprawnieniaSprzetu NUMBER(1);
    v_RodzajKlienta VARCHAR2(10);
BEGIN
    BEGIN
        SELECT Uprawnienia
        INTO v_UprawnieniaSprzetu
        FROM SprzetBudowlany
        WHERE IDSprzet = IDSprzet2;

    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Sprzêt o ID ' || IDSprzet2 || ' zwraca wiêcej ni¿ jeden wiersz w tabeli SprzetBudowlany.');
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'Nie znaleziono sprzêtu o ID ' || IDSprzet2 || ' w tabeli SprzetBudowlany.');
    END;

    BEGIN
        SELECT CASE 
                   WHEN Firma IS NOT NULL THEN 'Firma'
                   WHEN Osoba IS NOT NULL THEN 'Osoba'
                   ELSE 'Nieznany'
               END
        INTO v_RodzajKlienta
        FROM Klienci
        WHERE IDKlient = IDKlienta;

    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20004, 'Klient o ID ' || IDKlienta || ' zwraca wiêcej ni¿ jeden wiersz w tabeli Klienci.');
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20005, 'Nie znaleziono klienta o ID ' || IDKlienta || ' w tabeli Klienci.');
    END;

    IF v_RodzajKlienta = 'Firma' THEN
        RETURN TRUE;
    END IF;

    BEGIN
        SELECT Osoba
        INTO v_Osoba
        FROM Klienci
        WHERE IDKlient = IDKlienta
          AND Osoba IS NOT NULL;

    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20006, 'Klient o ID ' || IDKlienta || ' zwraca wiêcej ni¿ jedn¹ osobê w tabeli Klienci.');
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20007, 'Klient o ID ' || IDKlienta || ' nie jest osob¹ prywatn¹ w tabeli Klienci.');
    END;

    v_UprawnieniaKlienta := v_Osoba.Uprawnienia;

    IF v_UprawnieniaSprzetu IS NOT NULL THEN
        IF v_UprawnieniaKlienta = 1 THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    ELSE
        RETURN TRUE;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nieoczekiwany b³¹d podczas sprawdzania uprawnieñ: ' || SQLERRM);
END CzyKlientMaUprawnienia;
/


--------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
------Funkcja obliczajaca kwote wypozyczneia
create or replace FUNCTION ObliczKwoteWypozyczenia (
    IDSprzet2 IN NUMBER,
    DataWyp IN DATE,
    DataZwrotu IN DATE   
) RETURN NUMBER IS
    StawkaDzienna NUMBER;
    LiczbaDni NUMBER;
    KwotaCalkowita NUMBER;
BEGIN
    SELECT KwotaZaDzien
    INTO StawkaDzienna
    FROM SprzetBudowlany
    WHERE IDSprzet = IDSprzet2;

    LiczbaDni := GREATEST(1, DataZwrotu - DataWyp);

    KwotaCalkowita := LiczbaDni * StawkaDzienna;

    RETURN KwotaCalkowita;
END;
/

-------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
------------------triger przepisujacy usuniete rezerwacje do archiwum
create or replace TRIGGER trg_delete_rezerwacje
AFTER DELETE ON Rezerwacje
FOR EACH ROW
DECLARE
    v_status VARCHAR2(20);
    v_RefKlient REF TypKlient;
    v_RefSprzet REF TypSprzet;
    v_Klient TypKlient;
    v_Sprzet TypSprzet;
BEGIN
    IF :OLD.data_startu <= SYSDATE THEN
        v_status := 'Zrealizowana';
    ELSE
        v_status := 'Anulowana';
    END IF;

    v_RefKlient := :OLD.RefKlient;
    v_RefSprzet := :OLD.RefSprzet;

    SELECT DEREF(v_RefKlient) INTO v_Klient FROM DUAL;
    SELECT DEREF(v_RefSprzet) INTO v_Sprzet FROM DUAL;

    INSERT INTO Rezerwacje_Archiwalne (
        IDRezerwacja,
        IDKlient,
        IDSprzet,
        data_rezerwacji,
        data_startu,
        data_konca,
        status
    ) VALUES (
        :OLD.IDRezerwacja,
        v_Klient.IDKlient,
        v_Sprzet.IDSprzet,
        :OLD.data_rezerwacji,
        :OLD.data_startu,
        :OLD.data_konca,
        v_status
    );

    DBMS_OUTPUT.PUT_LINE('Rezerwacja o ID ' || :OLD.IDRezerwacja || ' przeniesiona do tabeli archiwalnej z status: ' || v_status);
END trg_delete_rezerwacje;
/
------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
------triger przenoszacy wypozyczenia do archiwum

create or replace TRIGGER trg_delete_wypozyczenia
AFTER DELETE ON Wypozyczenia
FOR EACH ROW
DECLARE
    v_RefKlient REF TypKlient;
    v_RefSprzet REF TypSprzet;
    v_Klient TypKlient;
    v_Sprzet TypSprzet;
BEGIN
    v_RefKlient := :OLD.RefKlient;
    v_RefSprzet := :OLD.RefSprzet;

    SELECT DEREF(v_RefKlient) INTO v_Klient FROM DUAL;
    SELECT DEREF(v_RefSprzet) INTO v_Sprzet FROM DUAL;

    INSERT INTO Wypozyczenia_Archiwalne (
        IDWypozyczenie,
        IDKlient,
        IDSprzet,
        DataWypozyczenia,
        DataZwrotu,
        Kwota,
        Zaliczka
    ) VALUES (
        :OLD.IDWypozyczenie,
        v_Klient.IDKlient,
        v_Sprzet.IDSprzet,
        :OLD.DataWypozyczenia,
        :OLD.DataZwrotu,
        :OLD.Kwota,
        :OLD.Zaliczka
    );

    DBMS_OUTPUT.PUT_LINE('Wypo¿yczenie o ID ' || :OLD.IDWypozyczenie || ' przeniesione do tabeli archiwalnej.');
END trg_delete_wypozyczenia;
/


------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------proceduraw wysy³ajace skonczone wypozyczenia do archiwum 



create or replace PROCEDURE UsunPrzeterminowaneWypozyczenia IS
    CURSOR c_Wypozyczenia IS
        SELECT IDWypozyczenie, IDKlient, IDSprzet, DataWypozyczenia, DataZwrotu, Kwota, Zaliczka
        FROM Wypozyczenia
        WHERE DataZwrotu < SYSDATE;
BEGIN
    FOR rec IN c_Wypozyczenia LOOP
        BEGIN
            INSERT INTO Wypozyczenia_Archiwalne
            VALUES (
                TypWypozyczenie(
                    rec.IDWypozyczenie,
                    rec.IDKlient,
                    rec.IDSprzet,
                    rec.DataWypozyczenia,
                    rec.DataZwrotu,
                    rec.Kwota,
                    rec.Zaliczka
                )
            );

            DELETE FROM Wypozyczenia
            WHERE IDWypozyczenie = rec.IDWypozyczenie;

            DBMS_OUTPUT.PUT_LINE('Wypo¿yczenie ID ' || rec.IDWypozyczenie || ' zosta³o przeniesione do archiwum.');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('B³¹d podczas przetwarzania wypo¿yczenia ID ' || rec.IDWypozyczenie || ': ' || SQLERRM);
        END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Proces usuwania przeterminowanych wypo¿yczeñ zakoñczony.');
END UsunPrzeterminowaneWypozyczenia;






