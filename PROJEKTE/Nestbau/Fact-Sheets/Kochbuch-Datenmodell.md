# Kochbuch – Entwurf (umgesetzt am 27.08.2026)

Status: **Erledigt und veröffentlicht.** Details siehe [[Learnings]]. Dieser Entwurf bleibt als Referenz für das Datenmodell stehen.

Ersetzt die bisherige Kategorie "Rezepte" komplett durch "Kochbuch" mit 3 Unterreitern: Zutaten, Rezepte, Menüplan.

## Datenmodell (state-Erweiterungen)

```js
var INGREDIENT_DEFAULT_CATEGORIES = [
  { id: "obst", label: "Obst" },
  { id: "gemuese", label: "Gemüse" },
  { id: "fleisch", label: "Fleisch" },
  { id: "gefluegel", label: "Geflügel" },
  { id: "fisch", label: "Fisch" },
  { id: "staerkebeilagen", label: "Stärkebeilagen" },
  { id: "huelsenfruechte", label: "Hülsenfrüchte" },
  { id: "nuesse", label: "Nüsse" },
  { id: "milchprodukte", label: "Milchprodukte" },
  { id: "oele_fette", label: "Öle & Fette" },
  { id: "gewuerze", label: "Gewürze" },
  { id: "sonstiges", label: "Sonstiges" }
];
// state.ingredientCategories = Standard + benutzerdefinierte { id, label, custom:true }
// state.ingredientGroups = [{ id, name, categoryIds: [...] }]  // zusammengefasste Ansicht mehrerer Kategorien
// state.ingredients = [{ id, name, categoryId, kcal, protein, fat, carbs, aminoAcids(optional), description(optional), allergies(optional), photo(optional, verkleinerte Data-URL) }]

var DISH_CATEGORIES = [
  { id: "fruehstueck", label: "Frühstück", tok: "flame" },
  { id: "mittagessen", label: "Mittagessen", tok: "teal" },
  { id: "abendessen", label: "Abendessen", tok: "amber" },
  { id: "snack", label: "Snack", tok: "maroon" },
  { id: "dessert", label: "Dessert", tok: "flame" },
  { id: "getraenk", label: "Getränk", tok: "teal" }
];
// state.recipes = [{ id, title, desc, categories:[dishCategoryId,...] (Mehrfachauswahl), time, portions, assignee,
//                    utensils:[string,...], steps:[string,...],
//                    ingredients:[{ingredientId, amount, unit}], favorite }]
// Migration Altbestand: alte Rezepte (categoryId einzeln, freie Zutaten-Zeilen, manuelle Makros) →
//   categories:[altes categoryId], ingredients:[] (nicht automatisch verknüpfbar), Makros werden künftig
//   automatisch berechnet statt manuell gepflegt.

var UNIT_GRAMS = { g:1, kg:1000, ml:1, l:1000, stueck:100, el:15, tl:5, prise:1 };
var UNIT_LABELS = { g:"g", kg:"kg", ml:"ml", l:"l", stueck:"Stück", el:"EL", tl:"TL", prise:"Prise" };
// Annahme (Nutzer noch nicht bestätigt): Zutaten-Nährwerte werden pro 100g eingetragen; "Stück" wird
// pauschal als 100g gerechnet (Kompromiss, da keine Gewichts-pro-Stück-Angabe vorgesehen ist).

// state.menuPlan = { "<yyyy-mm-dd>": { fruehstueck:[recipeId,...], mittagessen:[...], abendessen:[...], snacks:[...] } }
```

## Nährwert-Berechnung

```js
function recipeNutritionTotal(recipe) {
  var total = { kcal:0, protein:0, fat:0, carbs:0 };
  recipe.ingredients.forEach(function (ri) {
    var ing = state.ingredients.filter(function (i) { return i.id === ri.ingredientId; })[0];
    if (!ing) return;
    var grams = (ri.amount || 0) * (UNIT_GRAMS[ri.unit] || 1);
    var factor = grams / 100;
    total.kcal += (ing.kcal || 0) * factor;
    total.protein += (ing.protein || 0) * factor;
    total.fat += (ing.fat || 0) * factor;
    total.carbs += (ing.carbs || 0) * factor;
  });
  return total;
}
function recipeNutritionPerPortion(recipe) {
  var total = recipeNutritionTotal(recipe);
  var portions = recipe.portions > 0 ? recipe.portions : 1;
  return { kcal: total.kcal / portions, protein: total.protein / portions, fat: total.fat / portions, carbs: total.carbs / portions };
}
function dayNutrition(dateKey) {
  var day = state.menuPlan[dateKey];
  var total = { kcal: 0, protein: 0, fat: 0, carbs: 0 };
  if (!day) return total;
  ["fruehstueck", "mittagessen", "abendessen", "snacks"].forEach(function (slot) {
    (day[slot] || []).forEach(function (rid) {
      var r = state.recipes.filter(function (x) { return x.id === rid; })[0];
      if (!r) return;
      var pp = recipeNutritionPerPortion(r);
      total.kcal += pp.kcal; total.protein += pp.protein; total.fat += pp.fat; total.carbs += pp.carbs;
    });
  });
  return total;
}
```

## UI-Struktur

- `view-rezepte` wird zu `view-kochbuch`, Tab-Icon/Label "Rezepte" → "Kochbuch".
- Direkt unter dem Tab drei Chips (wie `.chip-btn`-Muster): Zutaten / Rezepte / Menüplan → schaltet zwischen drei `.kb-sub`-Containern um (nur einer sichtbar, analog Listen-Switcher in Aufgaben).

### 1. Zutaten
- Kategorie-Chip-Filter (Standard 12 + benutzerdefinierte), Mehrfach-Kategorien als "Gruppe" zusammenfassbar (kleines "+ Gruppe"-Aktion: Name + Checkbox-Auswahl mehrerer Kategorien → gemeinsame Filter-Ansicht).
- "+"-Icon (Ecke, wie `.todo-add-btn`-Muster) öffnet Formular: Titel, Kategorie-Select, Kalorien/Protein/Fett/Kohlenhydrate (Zahl, pro 100g), Aminosäuren (optional, Text), Beschreibung (optional), Allergiehinweise (optional).
- Kamera: `<input type="file" accept="image/*" capture="environment">` → Foto wird клиent-seitig auf Canvas verkleinert (z. B. max 480px) und als Data-URL gespeichert (Vorschau-Thumbnail in der Zutaten-Karte). Ehrliche Einschränkung: automatische Nährwert-Erkennung aus dem Foto ist in der veröffentlichten Artifact-Umgebung technisch nicht zuverlässig möglich (Netzwerksperre für OCR/Wasm-Nachladen) – Foto dient als visuelle Referenz, Nährwerte werden danach manuell geprüft/eingetragen (wie vom Nutzer als Alternative vorgesehen).
- Liste zeigt: Foto-Thumbnail (falls vorhanden) · Titel · Kategorie-Pill · Makro-Kurzangabe · Allergie-Hinweis-Badge (falls vorhanden).

### 2. Rezepte
- Formular: Titel, Beschreibung, Mehrfachauswahl Gerichte-Kategorie (Chip-Toggle statt Select), Zeit, Portionen, Person (fillAssigneeSelect), Utensilien (Text, Komma-getrennt → Chips), Zutaten-Zeilen (Select aus Zutaten-DB + Menge-Zahl + Einheit-Select + "Hinzufügen"-Button → Liste mit Entfernen-Button, analog Event-Todo-Zeilen im Kalender), Zubereitungsschritte (Textarea, eine Zeile = ein Schritt), Favorit-Checkbox.
- Karte zeigt automatisch berechnete Nährwerte (gesamt + pro Portion) statt manueller Eingabe.

### 3. Menüplan
- Woche/Monat-Umschalter (Chip-Paar wie Kalender).
- Wochenansicht: Tage-Streifen (wie `#cal-week-strip`), Auswahl eines Tages zeigt 4 Slot-Karten (Frühstück/Mittagessen/Abendessen/Snacks): Platzhalter „leer", darunter Vorschläge aus passender Gerichte-Kategorie (anklickbar → übernimmt Rezept in den Slot), platzierte Rezepte als Zeilen mit "×" (entfernen) und "→" (auf nächsten Tag kopieren) sowie einer kleinen "Verschieben"-Auswahl (Zieltag der aktuellen Woche).
- Unter jedem Tag: Nährwert-Summenzeile (Kalorien/Protein/Fett/Kohlenhydrate), berechnet aus `dayNutrition()`.
- Monatsansicht: Kalendergitter mit Punkt-Markierung an Tagen mit Einträgen (wie `.cal-dot`), Klick wechselt zur Wochenansicht auf diesem Tag.

## Offene Annahmen (dem Nutzer beim nächsten Schritt kurz mitteilen)
1. Zutaten-Nährwerte werden pro 100g gepflegt; „Stück" wird pauschal als 100g umgerechnet.
2. Automatische Nährwert-Erkennung per Foto ist in der Artifact-Umgebung nicht zuverlässig möglich – Foto wird als Referenz gespeichert, Werte danach manuell einpflegen.
3. „Verschieben" von Rezepten im Menüplan läuft über eine kleine Ziel-Tag-Auswahl statt Drag & Drop (robuster auf Mobilgeräten, besser testbar).

## Nächste Schritte sobald Datei lesbar ist
1. Aktuelle nestbau.html vom Artefakt laden.
2. Obiges Datenmodell + Migration einbauen (state-Erweiterungen, Migration alter Rezepte).
3. HTML/CSS/JS wie oben beschrieben umsetzen (view-rezepte → view-kochbuch, 3 Unterreiter).
4. Node-Syntax-Check, Playwright-Funktionstests (Zutat anlegen inkl. Foto, Rezept mit Zutaten-Verknüpfung + automatische Nährwerte, Menüplan-Slot befüllen + Tages-Summe, Woche/Monat-Umschalter), 5-Tab-Hell/Dunkel-Regressionssweep.
5. Test-Artefakte löschen, auf bestehende URL veröffentlichen.
6. Profil.md-Status + Learnings.md aktualisieren.
