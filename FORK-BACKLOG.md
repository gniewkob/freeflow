# Backlog usprawnień — gniewkob/freeflow (FreeFlow Dev)

Zasada: każde usprawnienie = osobna gałąź `feat/<nazwa>` → przegląd → decyzja właściciela → merge do `local/main` → `./BUILD-LOCAL.sh`.
Nic nie trafia do `local/main` bez decyzji właściciela.

## Kontekst bazowy
- Zainstalowana: /Applications/FreeFlow Dev.app (bundle `com.zachlatta.freeflow.dev`), podpis: lokalny cert "FreeFlow Local Signing (gniewkob)".
- Polityka: kontekst okna OFF, zrzut pulpitu OFF, wklejanie do pola startowego ON, updater nie instaluje upstreamu.
- Dostawca: Groq (świadoma decyzja — szybkość); do Groq trafia audio + transkrypt + słownik.

## Kandydaci (priorytet malejąco)
| # | Usprawnienie | Problem, który rozwiązuje | Status |
|---|---|---|---|
| 1 | Lista wykluczonych aplikacji (bundle ID) — brak kontekstu / brak dyktowania | Pozwala ponownie włączyć kontekst poza wrażliwymi aplikacjami (menedżer haseł, bankowość, VDI) | propozycja |
| 2 | Tryb kontekstu „tylko metadane” (nazwa aplikacji + tytuł okna, bez zrzutu i zaznaczenia) | Lepsza pisownia bez wysyłania treści ekranu | propozycja |
| 3 | Klucz API z powrotem w Keychain (zamiast pliku `.settings`) | Klucz w postaci jawnej czytelny dla każdego procesu użytkownika | propozycja |
| 4 | Weryfikacja Team ID / podpisu w UpdateManager (gdyby kiedyś wrócić do auto-update) | Supply-chain | odłożone (auto-install wyłączony) |
| 5 | Widoczny wskaźnik, że kontekst został wysłany | Przejrzystość | propozycja |
