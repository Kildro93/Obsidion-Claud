# Snippet: Kochbuch-Nährwert-Berechnung

**Quelle:** [[Kochbuch-Datenmodell]] (System/Kochbuch-Entwurf, 27.08.2026)
**Sprache:** JavaScript (Vanilla, App-intern)
**Kontext:** Nährwerte werden nicht gespeichert, sondern live aus verknüpften Zutaten berechnet – Zutat → Rezept (gesamt + pro Portion) → Tag.
**Verknüpft mit:** [[Features]] (Kochbuch), [[Datenbank-Schema]], [[nestbau-testing]] (Allergie-Aggregation Bug)

```js
var UNIT_GRAMS = { g:1, kg:1000, ml:1, l:1000, stueck:100, el:15, tl:5, prise:1 };

function recipeNutritionTotal(recipe) {
  var total = { kcal:0, protein:0, fat:0, carbs:0 };
  recipe.ingredients.forEach(function (ri) {
    var ing = state.ingredients.filter(function (i) { return i.id === ri.ingredientId; })[0];
    if (!ing) return;
    var grams = (ri.amount || 0) * (UNIT_GRAMS[ri.unit] || 1);
    var factor = grams / 100;          // bzw. / ing.baseGrams (Basisgewicht-Feld, Standard 100)
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
  return { kcal: total.kcal/portions, protein: total.protein/portions,
           fat: total.fat/portions, carbs: total.carbs/portions };
}

function dayNutrition(dateKey) {
  var day = state.menuPlan[dateKey];
  var total = { kcal:0, protein:0, fat:0, carbs:0 };
  if (!day) return total;
  ["fruehstueck","mittagessen","abendessen","snacks"].forEach(function (slot) {
    (day[slot] || []).forEach(function (entry) {
      // entry: { type:"recipe", id, qty } | { type:"food", ingredientId, amount, unit }
      var r = state.recipes.filter(function (x){ return x.id === entry.id; })[0];
      if (!r) return;
      var pp = recipeNutritionPerPortion(r);
      var q = entry.qty || 1;
      total.kcal += pp.kcal*q; total.protein += pp.protein*q;
      total.fat += pp.fat*q; total.carbs += pp.carbs*q;
    });
  });
  return total;
}
```

**Wichtig / Learnings**
- Basisgewicht ist konfigurierbar (Feld pro Zutat, Standard 100 g) – nicht mehr fest 100.
- `Stück`/`EL`/`TL`/`Prise` werden pauschal umgerechnet (Stück≈100 g). Annahme, pro Zutat anpassbar.
- Menüplan-Slot-Einträge sind Objekte, nicht ID-Strings – Migration siehe [[menuplan-migration]].
- „Zuletzt gekocht" wird live aus dem Menüplan berechnet, nicht als History gespeichert (vermeidet Sync-Bugs).
