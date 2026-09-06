# Snippet: Menüplan-Migration (String → Objekt)

**Quelle:** [[2026-09-05-Kochbuch-Menuplan-GitHub]] (Chat-Export)
**Sprache:** JavaScript
**Kontext:** Menüplan-Slots hielten früher reine Rezept-ID-Strings. Mehrfacheinträge pro Slot/Tag + Mengen-Stepper brauchten ein Objekt-Modell `{type, id, qty}`. Beim Laden alte Daten konvertieren, sonst brechen gespeicherte Zustände.
**Verknüpft mit:** [[kochbuch-naehrwert-berechnung]], [[PROJEKT-LEARNINGS]] (Erkenntnis 5: Migration mitdenken)

```js
// Migration: alte Menüplan-Einträge (reine ID-Strings) in Objektform überführen
day[slot.id] = day[slot.id].map(function (entry) {
  if (typeof entry === "string") return { type: "recipe", id: entry, qty: 1 };
  return entry;
});
```

**Muster (gilt auch für):** Vitamine/Aminosäuren/Utensilien (Freitext → Tag-Liste), alte Dish-Kategorien (Mittag+Abend → „Mittag-/Abendessen"), Allergie-Freitext → feste 10er-Auswahl. Regel: alte Form erkennen, konvertieren, nie Alt-Daten erfinden (`prep` bleibt leer statt geraten).
