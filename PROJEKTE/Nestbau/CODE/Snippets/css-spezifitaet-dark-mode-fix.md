# Snippet: CSS-Spezifität – Dark-Mode-Fix

**Quelle:** [[2026-09-05-Kochbuch-Menuplan-GitHub]] (Chat-Export)
**Sprache:** CSS
**Kontext:** Die aktiven Kochbuch-Kacheln nutzten `.chip-btn.active`. Diese Klasse übersteuerte per Spezifität die Kachel-Farbe `.tile-teal` – nur im Dunkelmodus sichtbar. Fix: eigene Klasse `.kb-tile-btn` statt Wiederverwendung.
**Verknüpft mit:** [[PROJEKT-LEARNINGS]] (Erkenntnis 4: CSS-Spezifität versteckt Dark-Mode-Bugs), [[Design-System]]

```css
/* Fix: eigene Klasse statt chip-btn.active — vermeidet Spezifitäts-Konflikt */
.kb-tile-btn.active { border-color: var(--ink); transform: scale(1.03); }
.tile-teal { background: var(--teal); }
```

**Regel:** UI-Klassen nicht quer wiederverwenden, wenn sie visuelle States tragen. Screenshot-Review in Hell **und** Dunkel – reines Code-Lesen findet solche Bugs nicht.
