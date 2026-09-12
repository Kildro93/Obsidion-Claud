'use strict';

// Diese Zeilen in die bestehende functions/index.js uebernehmen.
// (Nicht ersetzen – die Auth-/Haushalts-Exports von Bot 1 bleiben bestehen.)

const recipeImport = require('./lib/recipeImport');

// --- Web Clipper -----------------------------------------------------------
exports.clipRecipe = recipeImport.clipRecipe;                 // HTTP, Bearer-Token
exports.processRecipeImport = recipeImport.processRecipeImport; // Firestore-Trigger

// --- Import aus der App ----------------------------------------------------
exports.importRecipeFromUrl = recipeImport.importRecipeFromUrl;
exports.retryRecipeImport = recipeImport.retryRecipeImport;
exports.commitRecipeImport = recipeImport.commitRecipeImport;
exports.deleteRecipeImport = recipeImport.deleteRecipeImport;

// --- Geraete-Verwaltung fuer den Clipper -----------------------------------
exports.createClipperToken = recipeImport.createClipperToken;
exports.listClipperDevices = recipeImport.listClipperDevices;
exports.revokeClipperDevice = recipeImport.revokeClipperDevice;
