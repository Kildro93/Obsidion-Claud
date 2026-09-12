/**
 * Nestbau v2.0 – Eingabe-Validierung
 * Spiegelt bewusst die Firestore-Rules: was hier durchgeht, akzeptiert auch
 * der Server. Client-Validierung ist reine UX, die Rules sind die Wahrheit.
 */

export const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;

export const LIMITS = {
  displayName: { min: 2, max: 40 },
  householdName: { min: 2, max: 60 },
  description: { max: 240 },
  password: { min: 10, max: 128 },
  age: { min: 13, max: 120 },
  heightCm: { min: 80, max: 250 },
  weightKg: { min: 25, max: 400 },
  allergies: { max: 30 }
};

export const FITNESS_LEVELS = [
  { value: 'low',     label: 'Wenig aktiv',  hint: 'Sitzender Alltag' },
  { value: 'medium',  label: 'Normal aktiv', hint: '1–2× Sport pro Woche' },
  { value: 'high',    label: 'Sehr aktiv',   hint: '3–5× Sport pro Woche' },
  { value: 'athlete', label: 'Sportlich',    hint: 'Training fast taeglich' }
];

/** Die 14 EU-Hauptallergene, plus was im Alltag am haeufigsten vorkommt. */
export const COMMON_ALLERGENS = [
  'Gluten', 'Laktose', 'Milch', 'Ei', 'Erdnuss', 'Schalenfruechte',
  'Soja', 'Fisch', 'Krebstiere', 'Weichtiere', 'Sellerie', 'Senf',
  'Sesam', 'Lupine', 'Sulfite', 'Histamin', 'Fructose'
];

export const DIETARY_PREFS = [
  'Vegetarisch', 'Vegan', 'Pescetarisch', 'Low Carb',
  'High Protein', 'Halal', 'Koscher', 'Glutenfrei', 'Laktosefrei'
];

export const PROFILE_COLORS = [
  '#1c7d70', '#4a6741', '#8a5f22', '#b5342a',
  '#2f6f9e', '#6b4f8a', '#a8562f', '#3d7a5c'
];

export function isEmail(value) {
  const v = String(value || '').trim();
  return EMAIL_RE.test(v) && v.length <= 254;
}

/**
 * Passwort-Bewertung 0–4. Laenge wiegt schwerer als Zeichenklassen –
 * "Sonnenblume-Kaffee-42" schlaegt "P@ss1!" um Laengen.
 */
export function scorePassword(password) {
  const pw = String(password || '');
  if (!pw) return { score: 0, label: 'Noch leer', color: '#e4ded2', ok: false };

  let score = 0;
  if (pw.length >= 10) score += 1;
  if (pw.length >= 14) score += 1;
  if (pw.length >= 18) score += 1;

  const classes = [/[a-z]/, /[A-Z]/, /\d/, /[^A-Za-z0-9]/]
    .filter((re) => re.test(pw)).length;
  if (classes >= 3) score += 1;

  // Offensichtliche Muster kosten wieder einen Punkt
  if (/^(.)\1+$/.test(pw) || /(1234|abcd|qwert|password|passwort|nestbau)/i.test(pw)) {
    score = Math.max(0, score - 2);
  }
  score = Math.min(4, score);

  const meta = [
    { label: 'Zu schwach',  color: '#b5342a' },
    { label: 'Schwach',     color: '#b5342a' },
    { label: 'Geht so',     color: '#8a5f22' },
    { label: 'Gut',         color: '#4a6741' },
    { label: 'Sehr stark',  color: '#1c7d70' }
  ][score];

  return {
    score,
    label: meta.label,
    color: meta.color,
    ok: pw.length >= LIMITS.password.min && score >= 2
  };
}

export function validatePassword(password) {
  const pw = String(password || '');
  if (pw.length < LIMITS.password.min) {
    return `Mindestens ${LIMITS.password.min} Zeichen.`;
  }
  if (pw.length > LIMITS.password.max) return 'Maximal 128 Zeichen.';
  if (!scorePassword(pw).ok) return 'Zu leicht zu erraten – nimm eine laengere Wortkombination.';
  return null;
}

export function validateDisplayName(value) {
  const v = String(value || '').trim();
  if (v.length < LIMITS.displayName.min) return 'Bitte gib einen Namen an.';
  if (v.length > LIMITS.displayName.max) return 'Maximal 40 Zeichen.';
  return null;
}

export function validateHouseholdName(value) {
  const v = String(value || '').trim();
  if (v.length < LIMITS.householdName.min) return 'Bitte gib dem Haushalt einen Namen.';
  if (v.length > LIMITS.householdName.max) return 'Maximal 60 Zeichen.';
  return null;
}

/** Leere Felder sind erlaubt – Koerperdaten sind optional. */
export function validateNumber(value, key, unit) {
  if (value === '' || value === null || value === undefined) return null;
  const num = Number(value);
  const { min, max } = LIMITS[key];
  if (!Number.isFinite(num)) return 'Bitte eine Zahl eingeben.';
  if (num < min || num > max) return `Zwischen ${min} und ${max} ${unit}.`;
  return null;
}

export function normalizeProfileInput(raw) {
  // NaN wuerde Firestore ablehnen – lieber null als ein kaputter Write.
  const toNumber = (v) => {
    if (v === '' || v == null) return null;
    const n = Number(v);
    return Number.isFinite(n) ? n : null;
  };
  const toInt = (v) => {
    const n = toNumber(v);
    return n == null ? null : Math.round(n);
  };
  return {
    displayName: String(raw.displayName || '').trim(),
    color: PROFILE_COLORS.includes(raw.color) ? raw.color : PROFILE_COLORS[0],
    age: toInt(raw.age),
    heightCm: toNumber(raw.heightCm),
    weightKg: toNumber(raw.weightKg),
    fitnessLevel: FITNESS_LEVELS.some((l) => l.value === raw.fitnessLevel)
      ? raw.fitnessLevel : 'medium',
    allergies: [...new Set((raw.allergies || []).map((a) => String(a).trim()).filter(Boolean))]
      .slice(0, LIMITS.allergies.max),
    dietary: [...new Set((raw.dietary || []).map((d) => String(d).trim()).filter(Boolean))]
      .slice(0, 10),
    shareAllergiesWithHousehold: raw.shareAllergiesWithHousehold === true
  };
}
