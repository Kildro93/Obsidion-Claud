'use strict';

/**
 * Nestbau v2.0 – Cloud Functions (Bot 1: Auth & Profile)
 * Region: europe-west1
 *
 * Aufteilung:
 *   lib/common.js      Admin-SDK, Auth-Guards, Validierung
 *   lib/mail.js        Email-Rendering + Queue (Trigger-Email-Extension)
 *   lib/users.js       Auth-Trigger, Verifikation, Profil-Sync
 *   lib/households.js  Haushalte, Einladungen, Rollen
 */

const { setGlobalOptions } = require('firebase-functions/v2');
const { REGION } = require('./lib/common');

setGlobalOptions({
  region: REGION,
  maxInstances: 10,     // Kostenbremse: dieser Haushalt braucht keine 1000
  memory: '256MiB',
  timeoutSeconds: 60
});

const users = require('./lib/users');
const households = require('./lib/households');

// --- Auth / Profil ---
exports.onUserCreated = users.onUserCreated;
exports.onUserDeleted = users.onUserDeleted;
exports.sendVerificationEmail = users.sendVerificationEmail;
exports.syncAuthState = users.syncAuthState;
exports.onProfileWritten = users.onProfileWritten;

// --- Haushalte ---
exports.createHousehold = households.createHousehold;
exports.inviteToHousehold = households.inviteToHousehold;
exports.acceptHouseholdInvite = households.acceptHouseholdInvite;
exports.declineHouseholdInvite = households.declineHouseholdInvite;
exports.revokeHouseholdInvite = households.revokeHouseholdInvite;
exports.removeHouseholdMember = households.removeHouseholdMember;
exports.leaveHousehold = households.leaveHousehold;
exports.updateMemberRole = households.updateMemberRole;
