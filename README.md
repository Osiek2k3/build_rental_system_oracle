# Wypożyczalnia Sprzętu Budowlanego - Projekt Baza Danych

## Opis projektu

Celem tego projektu jest opracowanie systemu rejestracji w ramach bazy danych dla wypożyczalni sprzętu budowlanego. System ten umożliwia efektywne zarządzanie klientami, sprzętem budowlanym oraz procesami wypożyczania i zwrotu sprzętu. Poniżej przedstawione zostały główne założenia i funkcjonalności systemu.

### Założenia:

1. **Brak weryfikacji uprawnień dla firm:** Firmy same weryfikują uprawnienia swoich pracowników.
2. **Wymóg uprawnień dla osób prywatnych:** Osoba prywatna musi posiadać odpowiednie uprawnienia do obsługi sprzętu.
3. **Rezerwacja sprzętu:** Klient może rezerwować sprzęt w dostępnych terminach.
4. **Anulowanie rezerwacji:** Tylko pracownik ma uprawnienia do anulowania rezerwacji.
5. **Dostępność sprzętu:** Można wypożyczyć tylko sprzęt, który jest dostępny w danym momencie.
6. **Kaucja:** Kaucja wynosi co najmniej 30% wartości wypożyczenia.
7. **Limit wypożyczenia:** Limit czasu wypożyczenia to 14 dni dla osoby prywatnej, 30 dni dla firm.
8. **Minimalny okres wypożyczenia:** Minimalny okres to 1 dzień.
9. **Dodatkowa opłata za uszkodzenie sprzętu:** Pobierana jest dodatkowa opłata w przypadku uszkodzenia sprzętu.
10. **Brak zwrotu kosztów za wcześniejszy zwrot:** Klient nie otrzymuje zwrotu kosztów za wcześniejszy zwrot sprzętu.
11. **Dostępność sprzętu:** Rezerwacja możliwa jest na maksymalnie 3 miesiące do przodu.

---

## Realizacja założeń

Do realizacji założeń projektu w Oracle zastosowano mechanizmy tablic zagnieżdżonych, referencji do obiektów, wyzwalaczy oraz pakietów z funkcjami pomocniczymi. Poniżej przedstawiono kluczowe funkcje i procedury implementujące logikę biznesową:

### 1. Firma nie wymaga sprawdzenia uprawnień
- **Funkcja:** `CzyKlientMaUprawnienia` (Pakiet: `PakietWypozyczenia`)
- **Opis:** Pomija weryfikację uprawnień dla klientów będących firmami.

### 2. Osoba prywatna musi mieć odpowiednie uprawnienia
- **Funkcja:** `CzyKlientMaUprawnienia` (Pakiet: `PakietWypozyczenia`)
- **Opis:** Funkcja sprawdza, czy klient prywatny ma uprawnienia do obsługi sprzętu.

### 3. Klient może rezerwować sprzęt, jeśli jest dostępny
- **Procedura:** `DodajRezerwacje` (Pakiet: `PAKIETREZERWACJE`)
- **Opis:** Weryfikuje dostępność sprzętu przed dokonaniem rezerwacji.

### 4. Anulowanie rezerwacji tylko przez pracownika
- **Procedura:** `UsunRezerwacje` (Pakiet: `PAKIETREZERWACJE`)
- **Opis:** Procedura sprawdza rolę użytkownika przed anulowaniem rezerwacji.

### 5. Wypożyczenie tylko dostępnego sprzętu
- **Procedura:** `DodajWypozyczenie` (Pakiet: `PakietWypozyczenia`)
- **Opis:** Sprawdza dostępność sprzętu w danym okresie przed jego wypożyczeniem.

### 6. Kaucja wynosi co najmniej 30% wartości wypożyczenia
- **Procedura:** `DodajWypozyczenie` (Pakiet: `PakietWypozyczenia`)
- **Opis:** Weryfikuje wysokość kaucji przed zapisaniem wypożyczenia.

### 7. Limit czasu wypożyczenia
- **Funkcja:** `CzyLimitCzasuWypozyczeniaPrzekroczony` (Pakiet: `PakietWypozyczenia`)
- **Opis:** Sprawdza, czy okres wypożyczenia nie przekracza limitów dla różnych typów klientów.

### 8. Minimalny okres wypożyczenia/rezerwacji
- **Procedura:** `DodajRezerwacje` i `DodajWypozyczenie` (Pakiety: `PAKIETREZERWACJE`, `PakietWypozyczenia`)
- **Opis:** Weryfikuje, czy minimalny okres wynosi co najmniej 1 dzień.

### 9. Dodatkowa opłata za uszkodzenie sprzętu
- **Procedura:** `DodajNaprawe` (Pakiet: `PakietPrzegladyNaprawy`)
- **Opis:** Generuje dodatkową opłatę za naprawę uszkodzonego sprzętu.

### 10. Brak zwrotu kosztów za wcześniejszy zwrot
- **Opis:** Klient jest informowany o braku zwrotu kosztów za wcześniejszy zwrot.

### 11. Wyświetlanie dostępności sprzętu
- **Procedura:** `WyswietlWolneTerminy` (Pakiet: `PAKIETZAJETEDNI`)
- **Opis:** Wyświetla dostępność sprzętu w okresie maksymalnie 3 miesięcy do przodu.

---

## Funkcjonalności dostępne dla klienta

- **Rejestracja w systemie:** Klient może samodzielnie zarejestrować swoje konto, podając dane, takie jak imię, nazwisko, telefon, e-mail oraz (dla osób prywatnych) uprawnienia do obsługi sprzętu.
- **Przegląd dostępnego sprzętu:** Klient ma dostęp do pełnej listy sprzętu budowlanego, w tym nazwy, kategorii, wymaganych uprawnień, dostępności i stawki wypożyczenia.
- **Sprawdzanie dostępności sprzętu:** Klient może sprawdzić dostępność sprzętu w wybranym przedziale czasowym (maksymalnie 3 miesiące wprzód).
- **Rezerwacja sprzętu:** Klient może rezerwować sprzęt, wybierając daty rozpoczęcia i zakończenia rezerwacji.
- **Dostęp do informacji o koncie:** Klient ma dostęp do swoich danych osobowych, takich jak imię, nazwisko, telefon i e-mail.

## Funkcjonalności dostępne dla pracownika

- **Wgląd do szczegółowych informacji o klientach:** Pracownik ma dostęp do pełnych danych klientów, historii rezerwacji, wypożyczeń oraz naliczonych opłat.
- **Zarządzanie sprzętem budowlanym:** Pracownik może dodawać lub usuwać sprzęt w systemie.
- **Zarządzanie rezerwacjami i wypożyczeniami:** Pracownik może zatwierdzać lub anulować rezerwacje oraz przekształcać je w wypożyczenia.
- **Przegląd historii rezerwacji i wypożyczeń:** Pracownik ma dostęp do pełnej historii rezerwacji i wypożyczeń, w tym szczegółów dotyczących kosztów.
- **Przegląd dostępności sprzętu:** Pracownik może sprawdzać dostępność sprzętu na podstawie zapisanych terminów.
- **Naliczanie dodatkowych opłat:** Pracownik może naliczyć dodatkowe opłaty w przypadku uszkodzenia sprzętu lub innych sytuacji wymagających kosztów.

## Diagram bazy danych
