--Wy�wietlenie wszystkich klient�w
begin 
    PAKIETKLIENCI.WyswietlWszystkichKlientow;
end;
/
--Wy�wietlenie wszystkich sprzet�w budowlanych
begin 
    PAKIETSPRZETBUDOWLANY.WyswietlWszystkieSprzety;
end;


--dodanie poprawnego wypozyczenia 
BEGIN
    PakietWypozyczenia.DodajWypozyczenie(
        p_IDKlient => 1,
        p_IDSprzet => 1004,
        p_DataWypozyczenia => SYSDATE+94,
        p_DataZwrotu => SYSDATE+110
    );
END;
/

--dodanie poprawngo wypozyczenia
BEGIN
    PakietWypozyczenia.DodajWypozyczenie(
        p_IDKlient => 2,
        p_IDSprzet => 1003,
        p_DataWypozyczenia => SYSDATE+10,
        p_DataZwrotu => SYSDATE +16
    );
END;
/

--dodanie poprawnego wypozyczenia 
BEGIN
    PakietWypozyczenia.DodajWypozyczenie(
        p_IDKlient => 5,
        p_IDSprzet => 5001,
        p_DataWypozyczenia => SYSDATE+2,
        p_DataZwrotu => SYSDATE + 16
    );
END;
/
--dodanie poprawnego wypozyczenia kr�tszego ni� 1 dzie�
BEGIN
    PakietWypozyczenia.DodajWypozyczenie(
        p_IDKlient => 6,
        p_IDSprzet => 5005,
        p_DataWypozyczenia => SYSDATE+2,
        p_DataZwrotu => SYSDATE + 4
    );
END;
/

--dodanie nie poprawnego wypozyczenia w okresie poza 3 miesiace
BEGIN
    PakietWypozyczenia.DodajWypozyczenie(
        p_IDKlient => 3,
        p_IDSprzet => 1004,
        p_DataWypozyczenia => SYSDATE+70,
        p_DataZwrotu => SYSDATE +92
    );
END;
/

--dodanie nie poprawnego wypozyczenia w okresie poza powy�ej 30 dni dla firmy lub 14 dla osoby prywatnej
BEGIN
    PakietWypozyczenia.DodajWypozyczenie(
        p_IDKlient => 5,
        p_IDSprzet => 4001,
        p_DataWypozyczenia => SYSDATE,
        p_DataZwrotu => SYSDATE +32
    );
END;
/

--dodanie nie poprawnego wypozyczenia osoba prywatna nie ma uprawnieni
BEGIN
    PakietWypozyczenia.DodajWypozyczenie(
        p_IDKlient => 12,
        p_IDSprzet => 4003,
        p_DataWypozyczenia => SYSDATE,
        p_DataZwrotu => SYSDATE +12
    );
END;
/

--dodanie nie poprawnego wypozyczenia zaliczka jest zbyt ma�a
BEGIN
    PakietWypozyczenia.DodajWypozyczenie(
        p_IDKlient => 9,
        p_IDSprzet => 4003,
        p_DataWypozyczenia => SYSDATE,
        p_DataZwrotu => SYSDATE +12
    );
END;
/
---Wy�wietlnie wszystkich aktualnych wypo�yczeni
BEGIN
    PakietWypozyczenia.wyswietlwszystkiewypozyczenia;
END;

--Zajete dni maszyny o Id 1001
begin
    pakietzajetedni.WyswietlZajeteDni(p_IDSprzet =>1001);
end;


--Us�wanie wypo�yczenia
BEGIN
    PakietWypozyczenia.UsunWypozyczenie(
        p_IDWypozyczenie => 18);
END;


--Wy�wietlanie wolnych termin�w maszyny o ID 1001
begin
    pakietzajetedni.WyswietlWolneTerminy(p_IDSprzet =>1001);
end;


select *from wypozyczenia_archiwalne;


--Dodanie poprawnej rezerwacji
BEGIN
    PAKIETREZERWACJE.DodajRezerwacje(
        p_IDKlient =>8,
        p_IDSprzet =>1002,
        p_DataRezerwacji =>SYSDATE ,
        p_DataStartu =>SYSDATE+9,
        p_DataKonca =>SYSDATE+50
    );
END;

--Dodanie poprawnej rezerwacji
BEGIN
    PAKIETREZERWACJE.DodajRezerwacje(
        p_IDKlient =>13,
        p_IDSprzet =>3005,
        p_DataRezerwacji =>SYSDATE ,
        p_DataStartu =>SYSDATE+15,
        p_DataKonca =>SYSDATE+19
    );
END;

-- B�edna rezerwacja z powodu zajetego w tym terminie sprzetu
BEGIN
    PAKIETREZERWACJE.DodajRezerwacje(
        p_IDKlient =>3,
        p_IDSprzet =>1001,
        p_DataRezerwacji =>SYSDATE ,
        p_DataStartu =>SYSDATE+1,
        p_DataKonca =>SYSDATE+8
    );
END;


--b�ad przy dodaniu rezerwacji po 3 miesiacach
BEGIN
    PAKIETREZERWACJE.DodajRezerwacje(
        p_IDKlient =>11,
        p_IDSprzet =>5001,
        p_DataRezerwacji =>SYSDATE ,
        p_DataStartu =>SYSDATE+2,
        p_DataKonca =>SYSDATE+
    );
END;

--b�ad przy dodaniu rezerwacji na d�u�ysz okres ni� 30 dni dla firmy i 14 dla osoby prywatnej
BEGIN
    PAKIETREZERWACJE.DodajRezerwacje(
        p_IDKlient =>1,
        p_IDSprzet =>5005,
        p_DataRezerwacji =>SYSDATE ,
        p_DataStartu =>SYSDATE,
        p_DataKonca =>SYSDATE+10
    );
END;

-- wy�wietlenie wszystkich rezerwacji 
BEGIN
    PAKIETREZERWACJE.WyswietlWszystkieRezerwacje;
END;
--wy�wietlanie wolnych dni dla maszynyu o ID 1001 przed usuni�ciem rezerwacji
begin
    pakietzajetedni.wyswietlwolneterminy(p_IDSprzet =>1005);
end;
--Us�wanie rezerwacji po ID
BEGIN
    PAKIETREZERWACJE.UsunRezerwacje(
        p_IDRezerwacja =>29
    );
END;
--wy�wietlanie zajetych dni dla maszyny o ID 1001
begin
    pakietzajetedni.WyswietlZajeteDni(p_IDSprzet =>1001);
end;
--wy�wietlanie wolnych dni dla maszynyu o ID 1001
begin
    pakietzajetedni.wyswietlwolneterminy(p_IDSprzet =>1001);
end;

--dodanie przegladu maszyny
begin
    PakietPrzegladyNaprawy.DodajNaprawe(p_IDNaprawa =>5, p_IDSprzet =>5002, p_Sprzet =>'koparka', p_Data =>Sysdate, p_Koszt=> 200, p_Typ=>'napraw', p_Opis =>'cos');
end;

--dodanie przegladu maszyny
begin
    PakietPrzegladyNaprawy.DodajNaprawe(p_IDNaprawa =>5, p_IDSprzet =>3003, p_Sprzet =>'koparka', p_Data =>Sysdate+10, p_Koszt=> 200, p_Typ=>'napraw', p_Opis =>'cos');
end;

--wyswietlenie przeglad�w i napraw
begin
    PakietPrzegladyNaprawy.wyswietlnaprawy;
end;

--us�wanie przegladu i naprawy
begin
    PakietPrzegladyNaprawy.UsunNaprawe(p_IDNaprawa =>5);
end;


---Wy�wietlnie wszystkich aktualnych wypo�yczeni
BEGIN
    PakietWypozyczenia.wyswietlwszystkiewypozyczenia;
END;

--dodawanie dodatkowych koszt�w przy odbiorze 
begin
    PakietDodatkoweKoszta.DodajKoszt(p_IDKoszt =>3, p_Nazwa =>'uszkodzenie', p_Opis =>'uszkodzenie drzwi koparki', p_Kwota =>1500, p_IDWypozyczenie => 13);
end;
--wy�wieltenie dodatkowych koszt�w
begin
    PakietDodatkoweKoszta.WyswietlKoszta;
end;




---Prezentacjia od strony klienta 


--Klient tw�rzy sw�j profil
begin 
    PAKIETKLIENT.DodajKlientaFirma(21, 'Firma J Sp. z o.o.', 'PL1234567899', '0001234576', '221234576', 'kontakt10@firmaJ.pl', 'ul. Przemys�owa 10, Warszawa, 00-010');
end;

-- wy�wieltenie prze klienta sowich danych 
begin 
    PAKIETKLIENT.wyswietlklienta(IDKlient =>21);
end;
--wy�wietlenie wszystkich sprzet�w w ofercie
begin 
    PAKIETKLIENT.wyswietlwszystkiesprzety;
end;
--wy�wietlenie dostepnych termin�w danej maszyny
begin 
    PAKIETKLIENT.wyswietlwolneterminy(p_IDSprzet =>4002);
end;

--zrobineie rezerwacji przez klienta
begin 
    PAKIETKLIENT.DodajRezerwacje(p_IDKlient =>21,p_IDSprzet =>4002,p_DataRezerwacji => Sysdate,p_DataStartu => Sysdate,p_DataKonca => SYSDATE +7);
end;

--sprawdzenie rezerwacji danego klienta 
begin 
    PAKIETKLIENT.wyswietlrezerwacjeklienta(p_IDKlient =>21);
end;


--Pracownik usuwa rezerwacje kt�re zaczynaj� si� danego dnia

begin 
    PAKIETREZERWACJE.UsunRezerwacje(
        p_IDRezerwacja =>42
    );
end;
--Pracownik dodaje wypo�yczenie
BEGIN
    PakietWypozyczenia.DodajWypozyczenie(
        p_IDKlient => 21,
        p_IDSprzet => 4005,
        p_DataWypozyczenia => Sysdate,
        p_DataZwrotu => SYSDATE +7
    );
END;

--sprawdzenie wypozyczneia danego klienta 
begin 
    PAKIETKLIENT.wyswietlwypozyczeniaklienta(p_IDKlient =>21);
end;



--zwrot maszyny po przez klienta
--pracownik usuwa wypozyczenie i sprawdza czy nie ma dodatkowych koszt�w
begin
    PakietDodatkoweKoszta.DodajKoszt(p_IDKoszt =>6, p_Nazwa =>'uszkodzenie', p_Opis =>'uszkodzenie drzwi walca', p_Kwota =>1500, p_IDWypozyczenie =>50);
end;
--klient i pracownik mo�e sprawdzi� ile jest do zap�aty
begin
     PAKIETKLIENT.DoZaplaty(p_IDWypozyczenia=>50);
end;
--jesli sa dodtkowe koszta, po zap�acie pracownik usuwa doadtkowe koszta i wypozyczenie
begin
    PakietDodatkoweKoszta.usunkoszt(p_IDKoszt =>3);
end;

BEGIN
    PakietWypozyczenia.UsunWypozyczenie(
        p_IDWypozyczenie => 11);
END;


