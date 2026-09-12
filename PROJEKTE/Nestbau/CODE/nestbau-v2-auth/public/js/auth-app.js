/**
 * Nestbau v2.0 – Auth-Flow Controller
 *
 * Route-Logik (in dieser Reihenfolge):
 *   nicht angemeldet        -> Login
 *   Email unbestaetigt      -> Verifikation
 *   Profil unvollstaendig   -> Profil-Wizard
 *   kein Haushalt           -> Haushalt anlegen / Einladung annehmen
 *   sonst                   -> App
 */

import {
  $, showScreen, toast, setFieldError, clearFieldErrors,
  withBusy, renderChips, bindSingleChoice,
  setSteps, setText
} from './ui.js';

import {
  register, login, logout, requestVerificationEmail, refreshVerification,
  requestPasswordReset, syncAuthState, watchAuth, toMessage, throttleStatus,
  currentUser
} from './auth-service.js';

import {
  getProfile, saveProfile, uploadAvatar, initials
} from './profile-service.js';

import {
  createHousehold, inviteMember, acceptInvite, declineInvite,
  listMyInvites, watchMembers, readInviteFromUrl, listMyHouseholds
} from './household-service.js';

import {
  isEmail, validatePassword, validateDisplayName, validateHouseholdName,
  validateNumber, scorePassword, FITNESS_LEVELS, COMMON_ALLERGENS,
  DIETARY_PREFS, PROFILE_COLORS
} from './validation.js';

const APP_URL = './index.html';

const state = {
  step: 0,
  profile: {
    displayName: '', color: PROFILE_COLORS[0], age: '', heightCm: '', weightKg: '',
    fitnessLevel: 'medium', allergies: new Set(), dietary: new Set(),
    shareAllergiesWithHousehold: false
  },
  householdId: null,
  householdName: '',
  pendingInvite: readInviteFromUrl(),   // Deep-Link aus der Einladungs-Email
  unsubscribeMembers: null
};

// =============================================================== Routing
async function route(user) {
  if (!user) {
    if (state.pendingInvite) {
      toast('Melde dich an oder registriere dich, um die Einladung anzunehmen.', 'info', 6000);
    }
    showScreen('screen-login');
    return;
  }

  if (!user.emailVerified) {
    setText($('#verify-email'), user.email);
    showScreen('screen-verify');
    return;
  }

  let status;
  try {
    status = await syncAuthState();
  } catch (err) {
    console.error('[Nestbau] syncAuthState:', err);
    toast(toMessage(err), 'error');
    showScreen('screen-login');
    return;
  }

  // Einladung aus dem Deep-Link direkt einloesen
  if (state.pendingInvite) {
    const invite = state.pendingInvite;
    state.pendingInvite = null;
    try {
      const res = await acceptInvite(invite);
      state.householdId = res.householdId;
      state.householdName = res.householdName;
      toast(`Du bist jetzt Teil von "${res.householdName}".`, 'success');
      status = await syncAuthState();
    } catch (err) {
      toast(toMessage(err), 'error', 6000);
    }
  }

  if (!status.profileComplete) {
    await hydrateProfileForm();
    goToStep(0);
    showScreen('screen-profile');
    return;
  }

  if (!status.householdIds.length) {
    await renderPendingInvites();
    showScreen('screen-household');
    return;
  }

  state.householdId = status.activeHouseholdId || status.householdIds[0];
  if (!state.householdName) {
    const households = await listMyHouseholds().catch(() => []);
    state.householdName = households.find((h) => h.id === state.householdId)?.name || '';
  }
  setText($('#done-text'),
    state.householdName
      ? `Dein Haushalt "${state.householdName}" ist eingerichtet.`
      : 'Dein Nestbau ist eingerichtet.');
  showScreen('screen-done');
}

// =============================================================== Login
$('#form-login').addEventListener('submit', withBusy($('#btn-login'), async () => {
  clearFieldErrors($('#screen-login'));
  const email = $('#login-email').value;
  const password = $('#login-password').value;

  let ok = setFieldError('login-email', isEmail(email) ? null : 'Bitte gueltige Email eingeben.');
  ok = setFieldError('login-password', password ? null : 'Bitte Passwort eingeben.') && ok;
  if (!ok) return;

  const blocked = throttleStatus();
  if (blocked.blocked) {
    setFieldError('login-password', `Zu viele Versuche. Warte noch ${blocked.seconds} Sekunden.`);
    return;
  }

  try {
    await login({ email, password, remember: $('#login-remember').checked });
  } catch (err) {
    // Generische Meldung – kein Hinweis darauf, ob das Konto existiert.
    setFieldError('login-password', toMessage(err));
  }
}, { busyLabel: 'Anmelden …' }));

// =============================================================== Registrierung
const regPassword = $('#reg-password');
regPassword.addEventListener('input', () => {
  const { score, label, color } = scorePassword(regPassword.value);
  const fill = $('#reg-strength-fill');
  fill.style.width = `${(score / 4) * 100}%`;
  fill.style.background = color;
  setText($('#reg-strength-text'),
    regPassword.value ? `${label} – mehrere Woerter sind sicherer als Sonderzeichen.`
                      : 'Mindestens 10 Zeichen. Mehrere Woerter sind sicherer als Sonderzeichen.');
});

$('#form-register').addEventListener('submit', withBusy($('#btn-register'), async () => {
  clearFieldErrors($('#screen-register'));
  const email = $('#reg-email').value;
  const password = regPassword.value;
  const password2 = $('#reg-password2').value;

  let ok = setFieldError('reg-email', isEmail(email) ? null : 'Bitte gueltige Email eingeben.');
  ok = setFieldError('reg-password', validatePassword(password)) && ok;
  ok = setFieldError('reg-password2',
    password === password2 ? null : 'Die Passwoerter stimmen nicht ueberein.') && ok;
  if (!ok) return;

  try {
    const user = await register({ email, password });
    setText($('#verify-email'), user.email);
    showScreen('screen-verify');
    toast('Bestaetigungs-Email unterwegs.', 'success');
  } catch (err) {
    const field = err.code === 'auth/email-already-in-use' ? 'reg-email' : 'reg-password';
    setFieldError(field, toMessage(err));
  }
}, { busyLabel: 'Konto wird erstellt …' }));

// =============================================================== Passwort-Reset
$('#form-reset').addEventListener('submit', withBusy($('#btn-reset'), async () => {
  clearFieldErrors($('#screen-reset'));
  const email = $('#reset-email').value;
  if (!setFieldError('reset-email', isEmail(email) ? null : 'Bitte gueltige Email eingeben.')) return;

  await requestPasswordReset(email);
  // Immer dieselbe Antwort – unabhaengig davon, ob das Konto existiert.
  toast('Falls ein Konto existiert, ist die Email unterwegs.', 'success', 6000);
  showScreen('screen-login');
}, { busyLabel: 'Senden …' }));

// =============================================================== Verifikation
$('#btn-verify-check').addEventListener('click', withBusy($('#btn-verify-check'), async () => {
  const verified = await refreshVerification();
  if (verified) {
    toast('Email bestaetigt.', 'success');
    await route(currentUser());
  } else {
    toast('Noch nicht bestaetigt. Schau nochmal in dein Postfach.', 'error');
  }
}, { busyLabel: 'Pruefen …' }));

$('#btn-verify-resend').addEventListener('click', withBusy($('#btn-verify-resend'), async () => {
  await requestVerificationEmail();
  toast('Email erneut gesendet.', 'success');
}, { busyLabel: 'Senden …' }));

// Kommt der User ueber den Bestaetigungslink zurueck: sofort nachpruefen.
if (new URLSearchParams(location.search).has('verified')) {
  setTimeout(() => refreshVerification().catch(() => {}), 800);
}

// =============================================================== Profil-Wizard
function renderColorChoices() {
  const host = $('#profile-colors');
  host.innerHTML = '';
  PROFILE_COLORS.forEach((color) => {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'nb-color';
    button.dataset.value = color;
    button.style.background = color;
    button.setAttribute('aria-label', `Farbe ${color}`);
    button.setAttribute('aria-pressed', color === state.profile.color ? 'true' : 'false');
    host.appendChild(button);
  });
}

function renderFitnessChoices() {
  const host = $('#profile-fitness');
  host.innerHTML = '';
  FITNESS_LEVELS.forEach((level) => {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'nb-segment__item';
    button.dataset.value = level.value;
    button.setAttribute('aria-pressed', level.value === state.profile.fitnessLevel ? 'true' : 'false');
    const strong = document.createElement('strong');
    strong.textContent = level.label;
    const span = document.createElement('span');
    span.textContent = level.hint;
    button.append(strong, span);
    host.appendChild(button);
  });
}

function updateAvatarPreview(url) {
  const host = $('#profile-avatar');
  host.innerHTML = '';
  if (url) {
    const img = document.createElement('img');
    img.src = url;
    img.alt = '';
    host.appendChild(img);
  } else {
    host.textContent = initials(state.profile.displayName);
    host.style.background = `${state.profile.color}22`;
    host.style.color = state.profile.color;
  }
}

async function hydrateProfileForm() {
  const profile = await getProfile().catch(() => null);
  if (profile) {
    state.profile.displayName = profile.displayName || '';
    state.profile.color = PROFILE_COLORS.includes(profile.color) ? profile.color : PROFILE_COLORS[0];
    state.profile.age = profile.age ?? '';
    state.profile.heightCm = profile.heightCm ?? '';
    state.profile.weightKg = profile.weightKg ?? '';
    state.profile.fitnessLevel = profile.fitnessLevel || 'medium';
    state.profile.allergies = new Set(profile.allergies || []);
    state.profile.dietary = new Set(profile.dietary || []);
    state.profile.shareAllergiesWithHousehold = profile.shareAllergiesWithHousehold === true;
  }

  $('#profile-name').value = state.profile.displayName;
  $('#profile-age').value = state.profile.age;
  $('#profile-height').value = state.profile.heightCm;
  $('#profile-weight').value = state.profile.weightKg;
  $('#profile-share-allergies').checked = state.profile.shareAllergiesWithHousehold;

  renderColorChoices();
  renderFitnessChoices();
  renderChips($('#profile-allergies'), COMMON_ALLERGENS, state.profile.allergies, { allowCustom: true });
  renderChips($('#profile-dietary'), DIETARY_PREFS, state.profile.dietary);
  updateAvatarPreview(profile?.photoURL);
}

bindSingleChoice($('#profile-colors'), {
  onSelect: (color) => {
    state.profile.color = color;
    if (!$('#profile-avatar').querySelector('img')) updateAvatarPreview(null);
  }
});
bindSingleChoice($('#profile-fitness'), {
  onSelect: (value) => { state.profile.fitnessLevel = value; }
});

$('#profile-name').addEventListener('input', (event) => {
  state.profile.displayName = event.target.value;
  if (!$('#profile-avatar').querySelector('img')) updateAvatarPreview(null);
});

function goToStep(index) {
  state.step = index;
  document.querySelectorAll('#screen-profile [data-step]').forEach((el) => {
    el.hidden = Number(el.dataset.step) !== index;
  });
  setSteps($('#profile-steps'), index, 3);
  window.scrollTo({ top: 0, behavior: 'instant' });
}

function validateStep(index) {
  clearFieldErrors($('#screen-profile'));
  if (index === 0) {
    return setFieldError('profile-name', validateDisplayName($('#profile-name').value));
  }
  if (index === 1) {
    let ok = setFieldError('profile-age', validateNumber($('#profile-age').value, 'age', 'Jahre'));
    ok = setFieldError('profile-height', validateNumber($('#profile-height').value, 'heightCm', 'cm')) && ok;
    ok = setFieldError('profile-weight', validateNumber($('#profile-weight').value, 'weightKg', 'kg')) && ok;
    return ok;
  }
  return true;
}

document.querySelectorAll('[data-wizard]').forEach((button) => {
  button.addEventListener('click', () => {
    const direction = button.dataset.wizard;
    if (direction === 'next') {
      if (!validateStep(state.step)) return;
      goToStep(Math.min(2, state.step + 1));
    } else {
      goToStep(Math.max(0, state.step - 1));
    }
  });
});

$('#btn-avatar').addEventListener('click', () => $('#input-avatar').click());
$('#input-avatar').addEventListener('change', withBusy($('#btn-avatar'), async (event) => {
  const file = event.target.files?.[0];
  if (!file) return;
  const url = await uploadAvatar(file);
  updateAvatarPreview(url);
  toast('Profilbild gespeichert.', 'success');
  event.target.value = '';
}, { busyLabel: 'Laedt …' }));

$('#btn-profile-save').addEventListener('click', withBusy($('#btn-profile-save'), async () => {
  if (!validateStep(0) || !validateStep(1)) {
    toast('Bitte pruef die markierten Felder.', 'error');
    return;
  }
  await saveProfile({
    displayName: $('#profile-name').value,
    color: state.profile.color,
    age: $('#profile-age').value,
    heightCm: $('#profile-height').value,
    weightKg: $('#profile-weight').value,
    fitnessLevel: state.profile.fitnessLevel,
    allergies: [...state.profile.allergies],
    dietary: [...state.profile.dietary],
    shareAllergiesWithHousehold: $('#profile-share-allergies').checked
  }, { markComplete: true });

  toast('Profil gespeichert.', 'success');
  const status = await syncAuthState();
  if (status.householdIds.length) {
    state.householdId = status.activeHouseholdId || status.householdIds[0];
    await openInviteScreen();
  } else {
    await renderPendingInvites();
    showScreen('screen-household');
  }
}, { busyLabel: 'Speichern …' }));

// =============================================================== Einladungen
async function renderPendingInvites() {
  const block = $('#pending-invites-block');
  const list = $('#pending-invites');
  list.innerHTML = '';

  let invites = [];
  try {
    invites = await listMyInvites();
  } catch (err) {
    console.warn('[Nestbau] Einladungen konnten nicht geladen werden:', err);
  }
  block.hidden = invites.length === 0;
  if (!invites.length) return;

  invites.forEach((invite) => {
    const item = document.createElement('li');
    item.className = 'nb-item';

    const avatar = document.createElement('div');
    avatar.className = 'nb-item__avatar';
    avatar.style.background = '#8a5f22';
    avatar.textContent = initials(invite.householdName);

    const body = document.createElement('div');
    body.className = 'nb-item__body';
    const name = document.createElement('div');
    name.className = 'nb-item__name';
    name.textContent = invite.householdName || 'Haushalt';
    const meta = document.createElement('div');
    meta.className = 'nb-item__meta';
    meta.textContent = invite.role === 'admin' ? 'Als Administrator' : 'Als Mitglied';
    body.append(name, meta);

    // Ohne Token aus der Email kann die Einladung hier nicht angenommen
    // werden – das ist Absicht: der Token ist der eigentliche Nachweis.
    const hint = document.createElement('span');
    hint.className = 'nb-badge nb-badge--pending';
    hint.textContent = 'Link in Email';

    const decline = document.createElement('button');
    decline.type = 'button';
    decline.className = 'nb-btn nb-btn--ghost nb-btn--sm';
    decline.innerHTML = '<span class="nb-btn__label">Ablehnen</span>';
    decline.addEventListener('click', withBusy(decline, async () => {
      await declineInvite(invite.id);
      toast('Einladung abgelehnt.', 'info');
      await renderPendingInvites();
    }));

    item.append(avatar, body, hint, decline);
    list.appendChild(item);
  });
}

// =============================================================== Haushalt
$('#form-household').addEventListener('submit', withBusy($('#btn-household'), async () => {
  clearFieldErrors($('#screen-household-create'));
  const name = $('#household-name').value;
  if (!setFieldError('household-name', validateHouseholdName(name))) return;

  const res = await createHousehold({
    name,
    description: $('#household-description').value.trim()
  });
  state.householdId = res.householdId;
  state.householdName = res.name;
  toast(`"${res.name}" erstellt.`, 'success');
  await openInviteScreen();
}, { busyLabel: 'Erstellen …' }));

async function openInviteScreen() {
  setText($('#invite-household-name'),
    state.householdName ? `Haushalt: ${state.householdName}` : '');

  state.unsubscribeMembers?.();
  state.unsubscribeMembers = watchMembers(state.householdId, (members) => {
    const list = $('#member-list');
    list.innerHTML = '';
    members.forEach((member) => {
      const item = document.createElement('li');
      item.className = 'nb-item';

      const avatar = document.createElement('div');
      avatar.className = 'nb-item__avatar';
      avatar.style.background = member.color || '#1c7d70';
      if (member.photoURL) {
        const img = document.createElement('img');
        img.src = member.photoURL;
        img.alt = '';
        img.style.width = img.style.height = '100%';
        img.style.objectFit = 'cover';
        avatar.appendChild(img);
      } else {
        avatar.textContent = initials(member.displayName);
      }

      const body = document.createElement('div');
      body.className = 'nb-item__body';
      const name = document.createElement('div');
      name.className = 'nb-item__name';
      name.textContent = member.displayName || 'Mitglied';
      const meta = document.createElement('div');
      meta.className = 'nb-item__meta';
      meta.textContent = member.allergiesShared && member.allergies?.length
        ? `Allergien: ${member.allergies.join(', ')}`
        : 'Keine geteilten Allergien';
      body.append(name, meta);

      const badge = document.createElement('span');
      badge.className = 'nb-badge';
      badge.textContent = member.role === 'admin' ? 'Admin' : 'Mitglied';

      item.append(avatar, body, badge);
      list.appendChild(item);
    });
  });

  showScreen('screen-invite');
}

$('#form-invite').addEventListener('submit', withBusy($('#btn-invite'), async () => {
  clearFieldErrors($('#screen-invite'));
  const email = $('#invite-email').value;
  if (!setFieldError('invite-email', isEmail(email) ? null : 'Bitte gueltige Email eingeben.')) return;

  try {
    await inviteMember({
      householdId: state.householdId,
      email,
      role: $('#invite-role').value
    });
    $('#invite-email').value = '';
    toast('Einladung verschickt.', 'success');
  } catch (err) {
    setFieldError('invite-email', toMessage(err));
  }
}, { busyLabel: 'Senden …' }));

// =============================================================== Aktionen
document.addEventListener('click', async (event) => {
  const goto = event.target.closest('[data-goto]');
  if (goto) {
    clearFieldErrors();
    showScreen(goto.dataset.goto);
    return;
  }

  const reveal = event.target.closest('[data-reveal]');
  if (reveal) {
    const input = document.getElementById(reveal.dataset.reveal);
    const show = input.type === 'password';
    input.type = show ? 'text' : 'password';
    reveal.textContent = show ? 'Verbergen' : 'Zeigen';
    reveal.setAttribute('aria-label', show ? 'Passwort verbergen' : 'Passwort anzeigen');
    return;
  }

  const action = event.target.closest('[data-action]')?.dataset.action;
  if (!action) return;

  if (action === 'logout') {
    await logout();
    state.unsubscribeMembers?.();
    showScreen('screen-login');
  }
  if (action === 'skip-household') {
    setText($('#done-text'),
      'Du kannst jederzeit unter Einstellungen einen Haushalt anlegen.');
    showScreen('screen-done');
  }
  if (action === 'finish') {
    setText($('#done-text'), `Dein Haushalt "${state.householdName}" ist eingerichtet.`);
    showScreen('screen-done');
  }
  if (action === 'enter-app') {
    location.href = APP_URL;
  }
});

// =============================================================== Start
watchAuth((user) => {
  route(user).catch((err) => {
    console.error('[Nestbau] Routing:', err);
    toast(toMessage(err), 'error');
  });
});
