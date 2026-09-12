/**
 * Nestbau v2.0 – UI-Bausteine
 * Kein Framework: die App ist eine PWA, die schnell starten soll.
 */

export const $ = (sel, root = document) => root.querySelector(sel);
export const $$ = (sel, root = document) => Array.from(root.querySelectorAll(sel));

/** Text sicher einsetzen – nie innerHTML mit User-Daten. */
export function setText(el, value) {
  if (el) el.textContent = value == null ? '' : String(value);
}

// ---------------------------------------------------------------- Screens
export function showScreen(id) {
  $$('.nb-screen').forEach((el) => el.classList.toggle('is-active', el.id === id));
  const active = document.getElementById(id);
  if (active) {
    window.scrollTo({ top: 0, behavior: 'instant' });
    const focusTarget = active.querySelector('[data-autofocus]');
    if (focusTarget) setTimeout(() => focusTarget.focus(), 60);
  }
}

// ---------------------------------------------------------------- Toasts
let toastHost;

export function toast(message, variant = 'info', ms = 4200) {
  if (!toastHost) {
    toastHost = document.createElement('div');
    toastHost.className = 'nb-toasts';
    toastHost.setAttribute('role', 'status');
    toastHost.setAttribute('aria-live', 'polite');
    document.body.appendChild(toastHost);
  }
  const el = document.createElement('div');
  el.className = `nb-toast nb-toast--${variant}`;
  el.textContent = message;
  toastHost.appendChild(el);
  setTimeout(() => el.remove(), ms);
}

// ------------------------------------------------------------ Feldfehler
export function setFieldError(inputId, message) {
  const input = document.getElementById(inputId);
  const error = document.getElementById(`${inputId}-error`);
  if (input) input.setAttribute('aria-invalid', message ? 'true' : 'false');
  if (error) {
    error.textContent = message || '';
    error.classList.toggle('is-visible', Boolean(message));
  }
  return !message;
}

export function clearFieldErrors(root = document) {
  $$('.nb-error', root).forEach((el) => {
    el.textContent = '';
    el.classList.remove('is-visible');
  });
  $$('[aria-invalid="true"]', root).forEach((el) => el.setAttribute('aria-invalid', 'false'));
}

// ---------------------------------------------------------------- Button
export function setBusy(button, busy, busyLabel) {
  if (!button) return;
  button.classList.toggle('is-busy', busy);
  button.disabled = busy;
  const label = button.querySelector('.nb-btn__label');
  if (label) {
    if (busy) {
      if (!label.dataset.idle) label.dataset.idle = label.textContent;
      if (busyLabel) label.textContent = busyLabel;
    } else if (label.dataset.idle) {
      label.textContent = label.dataset.idle;
    }
  }
}

/** Umschliesst einen async-Handler mit Busy-State und einheitlichem Fehler-Toast. */
export function withBusy(button, handler, { busyLabel, onError } = {}) {
  return async (event) => {
    event?.preventDefault?.();
    if (button?.disabled) return;
    setBusy(button, true, busyLabel);
    try {
      await handler(event);
    } catch (err) {
      console.error('[Nestbau]', err);
      if (onError) onError(err);
      else toast(err?.message || 'Etwas ist schiefgelaufen.', 'error');
    } finally {
      setBusy(button, false);
    }
  };
}

// ----------------------------------------------------------------- Chips
/**
 * Mehrfachauswahl als Chips. `selected` ist ein Set, das direkt mutiert wird.
 * `allowCustom` haengt ein "+ Eigene"-Chip an, das per prompt() ergaenzt.
 */
export function renderChips(container, options, selected, { allowCustom = false, onChange } = {}) {
  if (!container) return;
  container.innerHTML = '';

  const all = [...new Set([...options, ...selected])];
  all.forEach((value) => {
    const chip = document.createElement('button');
    chip.type = 'button';
    chip.className = 'nb-chip';
    chip.textContent = value;
    chip.setAttribute('aria-pressed', selected.has(value) ? 'true' : 'false');
    chip.addEventListener('click', () => {
      if (selected.has(value)) selected.delete(value);
      else selected.add(value);
      chip.setAttribute('aria-pressed', selected.has(value) ? 'true' : 'false');
      onChange?.(selected);
    });
    container.appendChild(chip);
  });

  if (allowCustom) {
    const add = document.createElement('button');
    add.type = 'button';
    add.className = 'nb-chip nb-chip--custom';
    add.textContent = '+ Eigene';
    add.addEventListener('click', () => {
      const value = prompt('Welche Allergie oder Unvertraeglichkeit?')?.trim();
      if (!value || selected.has(value)) return;
      selected.add(value);
      renderChips(container, options, selected, { allowCustom, onChange });
      onChange?.(selected);
    });
    container.appendChild(add);
  }
}

/** Einfachauswahl (Farbe, Fitnesslevel). */
export function bindSingleChoice(container, { onSelect } = {}) {
  if (!container) return;
  container.addEventListener('click', (event) => {
    const button = event.target.closest('[data-value]');
    if (!button || !container.contains(button)) return;
    $$('[data-value]', container).forEach((el) =>
      el.setAttribute('aria-pressed', el === button ? 'true' : 'false'));
    onSelect?.(button.dataset.value);
  });
}

export function setSingleChoice(container, value) {
  $$('[data-value]', container).forEach((el) =>
    el.setAttribute('aria-pressed', el.dataset.value === value ? 'true' : 'false'));
}

// ------------------------------------------------------------ Fortschritt
export function setSteps(container, current, total) {
  if (!container) return;
  container.innerHTML = '';
  for (let i = 0; i < total; i += 1) {
    const dot = document.createElement('div');
    dot.className = 'nb-steps__dot' + (i <= current ? ' is-done' : '');
    container.appendChild(dot);
  }
}
