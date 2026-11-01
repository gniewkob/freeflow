# Backlog usprawnień — gniewkob/freeflow (FreeFlow Dev)

Zasada: każde usprawnienie = osobna gałąź `feat/<nazwa>` → przegląd → decyzja właściciela → merge do `local/main` → `./BUILD-LOCAL.sh`.
Nic nie trafia do `local/main` bez decyzji właściciela.

## Kontekst bazowy
- Zainstalowana: /Applications/FreeFlow Dev.app (bundle `com.zachlatta.freeflow.dev`), podpis: lokalny cert "FreeFlow Local Signing (gniewkob)".
- Skróty: przytrzymaj = prawy Option (Logitech: prawy opt/ctrl), przełącz = Cmd + prawy Option, Edit Mode ręczny = Shift. Fn nie działa na klawiaturze Logitech.
- Polityka: kontekst okna OFF, zrzut pulpitu OFF, wklejanie do pola startowego ON, updater nie instaluje upstreamu.
- Dostawca: Groq (świadoma decyzja — szybkość); do Groq trafia audio + transkrypt + słownik.

## Kandydaci (priorytet malejąco)
| # | Usprawnienie | Problem, który rozwiązuje | Status |
|---|---|---|---|
| 1 | Edit Mode: gdy zaznaczenia nie da się zastąpić (pole tylko do odczytu, np. czat/strona), pokaż wynik w okienku z przyciskiem „Kopiuj”/„Wklej” zamiast cicho go porzucić | Zaobserwowane 01.11: 2× „Edit mode succeeded”, użytkownik nie zobaczył wyniku | propozycja |
| 2 | Walidacja skrótów: blokada ustawienia tego samego klawisza jako „przytrzymaj” i „przełącz”; ostrzeżenie dla Fn na klawiaturach zewnętrznych (np. Logitech nie wysyła Fn do macOS) | Zaobserwowane 01.11: hold i toggle = prawy Option → klawisz działał jak przełącznik; Fn z Logitecha nie dociera | propozycja |
| 3 | Kopia zapasowa ustawień (eksport/import: skróty, słownik, przełączniki; bez klucza API) + przycisk „Przywróć” | Zaobserwowane 01.11: ustawienia zostały wyzerowane, odtworzenie wymagało kopii z Kosza | propozycja |
| 4 | Lista wykluczonych aplikacji (bundle ID) — brak kontekstu / brak dyktowania | Pozwala ponownie włączyć kontekst poza wrażliwymi aplikacjami (menedżer haseł, bankowość, VDI) | propozycja |
| 5 | Tryb kontekstu „tylko metadane” (nazwa aplikacji + tytuł okna, bez zrzutu i zaznaczenia) | Lepsza pisownia bez wysyłania treści ekranu | propozycja |
| 6 | Klucz API z powrotem w Keychain (zamiast pliku `.settings`) | Klucz w postaci jawnej czytelny dla każdego procesu użytkownika | propozycja |
| 7 | Weryfikacja Team ID / podpisu w UpdateManager (gdyby kiedyś wrócić do auto-update) | Supply-chain | odłożone (auto-install wyłączony) |
| 8 | Widoczny wskaźnik, że kontekst został wysłany | Przejrzystość | propozycja |
