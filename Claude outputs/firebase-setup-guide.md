# 🔥 Firebase Setup Guide für Nestbau v2.0

**Für die Bots: Folge dieser Anleitung zur Firebase-Konfiguration**

---

## 📊 Schritt 1: Firebase Project erstellen

### 1.1 Im Firebase Console

```
1. Gehe zu: https://console.firebase.google.com
2. Klicke: "Neues Projekt hinzufügen"
3. Projektname: nestbau-app
4. Google Analytics: Optional (empfohlen für später)
5. Erstelle Projekt
```

### 1.2 Web-App registrieren

```
1. Im Firebase Console: "+ Web" (oder </> Symbol)
2. App-Name: "Nestbau PWA"
3. Firebase SDK einrichten
4. Kopiere die Config:

const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "nestbau-app.firebaseapp.com",
  projectId: "nestbau-app",
  storageBucket: "nestbau-app.appspot.com",
  messagingSenderId: "123...",
  appId: "1:123...:web:abc...",
  databaseURL: "https://nestbau-app.firebaseio.com"
};

firebase.initializeApp(firebaseConfig);
```

---

## 🔐 Schritt 2: Authentication aktivieren

### 2.1 Email/Password Auth

```
1. Firebase Console → Authentication (links)
2. Sign-in method
3. Email/Password → Enable
4. Email link (passwordless) → Disable (für später)
5. Save
```

### 2.2 Email Verification Template

```
Firebase Console → Authentication → Email Templates
→ Email Verification
→ Customize Standard:

Subject: Bestätige deine Nestbau Email ✨
Header: Willkommen bei Nestbau!
Body:
  "Danke für deine Registrierung!
  Klicke hier, um deine Email zu bestätigen:
  %LINK%"
Footer: Nestbau – Haushalt. Aufgaben. Rezepte.
```

---

## 💾 Schritt 3: Firestore Database

### 3.1 Firestore aktivieren

```
1. Firebase Console → Firestore Database (links)
2. Create database
3. Location: europe-west1 (Zürich - Schweiz)
4. Security rules: Start in TEST MODE (später ändern!)
5. Enable
```

### 3.2 Firestore Schema/Collections

**Erstelle diese Collections:**

#### **Collection: `users`**
```json
{
  "uid": "auto-generated",
  "email": "indra@example.com",
  "createdAt": "2024-09-03T...",
  "lastLogin": "2024-09-03T...",
  "emailVerified": true,
  "status": "active"
}
```

#### **Collection: `profiles`**
```json
{
  "uid": "users/{uid}",
  "name": "Indra",
  "age": 28,
  "height": 180,
  "weight": 75,
  "fitnessLevel": "medium", // low, medium, high, athlete
  "allergies": ["Nüsse", "Gluten"],
  "profileImage": "gs://bucket/profiles/uid.jpg",
  "createdAt": "2024-09-03T...",
  "updatedAt": "2024-09-03T..."
}
```

#### **Collection: `households`**
```json
{
  "id": "auto-generated",
  "name": "Haushalt Zürich",
  "description": "Zusammenleben",
  "adminUid": "uid-of-creator",
  "createdAt": "2024-09-03T...",
  "members": {
    "uid1": "admin",
    "uid2": "member"
  }
}
```

#### **Collection: `recipes`**
```json
{
  "id": "auto-generated",
  "householdId": "households/123",
  "name": "Spaghetti Carbonara",
  "category": "lunch", // breakfast, lunch, dinner, snack, dessert
  "image": "gs://bucket/recipes/id.jpg",
  "prepTime": 15,
  "cookTime": 20,
  "servings": 4,
  "ingredients": [
    {
      "ingredientId": "ingredients/123",
      "name": "Spaghetti",
      "amount": 400,
      "unit": "g"
    }
  ],
  "steps": [
    "Wasser aufkochen",
    "Spaghetti kochen"
  ],
  "nutrition": {
    "calories": 450,
    "protein": 15,
    "carbs": 60,
    "fat": 12
  },
  "createdBy": "uid",
  "createdAt": "2024-09-03T..."
}
```

#### **Collection: `ingredients`**
```json
{
  "id": "auto-generated",
  "householdId": "households/123",
  "name": "Tomaten",
  "category": "vegetables",
  "image": "gs://bucket/ingredients/id.jpg",
  "nutritionPer100g": {
    "calories": 18,
    "protein": 0.9,
    "carbs": 3.9,
    "fat": 0.2,
    "fiber": 1.2
  },
  "allergies": [],
  "createdAt": "2024-09-03T..."
}
```

#### **Collection: `menuPlans`**
```json
{
  "id": "auto-generated",
  "householdId": "households/123",
  "date": "2024-09-15",
  "breakfast": {
    "recipeId": "recipes/123",
    "servings": 2
  },
  "lunch": {
    "recipeId": "recipes/456",
    "servings": 2
  },
  "dinner": {
    "recipeId": "recipes/789",
    "servings": 2
  },
  "snacks": "Apfel, Yogurt",
  "totalNutrition": {
    "calories": 2000
  }
}
```

#### **Collection: `calendarIntegrations`**
```json
{
  "id": "auto-generated",
  "uid": "users/uid",
  "provider": "google", // google, outlook
  "accessToken": "encrypted...",
  "refreshToken": "encrypted...",
  "expiresAt": 1234567890,
  "calendarId": "primary",
  "syncEnabled": true,
  "lastSync": "2024-09-03T..."
}
```

---

## 🔒 Schritt 4: Firebase Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Authentifizierung erforderlich für alles
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
    
    // Users - nur eigene Daten lesen
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    
    // Profiles - nur eigene lesen
    match /profiles/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    
    // Households - Mitglieder lesen/schreiben, Admin kann verwalten
    match /households/{householdId} {
      allow read: if request.auth.uid in resource.data.members;
      allow write: if request.auth.uid == resource.data.adminUid;
      allow create: if request.auth != null;
      
      // Household Members - nur Admin ändern
      match /members/{memberId} {
        allow read: if request.auth.uid in get(/databases/$(database)/documents/households/$(householdId)).data.members;
        allow write: if request.auth.uid == get(/databases/$(database)/documents/households/$(householdId)).data.adminUid;
      }
    }
    
    // Recipes - Haushalt-Mitglieder lesen
    match /recipes/{recipeId} {
      allow read: if request.auth.uid in get(/databases/$(database)/documents/households/$(resource.data.householdId)).data.members;
      allow write: if request.auth.uid in get(/databases/$(database)/documents/households/$(resource.data.householdId)).data.members;
    }
    
    // Calendar Integrations - nur eigene lesen
    match /calendarIntegrations/{integrationId} {
      allow read, write: if request.auth.uid == resource.data.uid;
    }
  }
}
```

---

## 💾 Schritt 5: Firebase Storage

### 5.1 Storage aktivieren

```
1. Firebase Console → Storage (links)
2. Get started
3. Location: europe-west1
4. Create
```

### 5.2 Storage Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // Profile Images
    match /profiles/{uid}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth.uid == uid && 
                      request.resource.size < 5 * 1024 * 1024 && // 5MB max
                      request.resource.contentType.matches('image/.*');
    }
    
    // Recipe Images
    match /recipes/{recipeId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null &&
                      request.resource.size < 10 * 1024 * 1024 &&
                      request.resource.contentType.matches('image/.*');
    }
    
    // Ingredient Images
    match /ingredients/{ingredientId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null &&
                      request.resource.size < 5 * 1024 * 1024 &&
                      request.resource.contentType.matches('image/.*');
    }
  }
}
```

---

## ☁️ Schritt 6: Cloud Functions

### 6.1 Cloud Functions aktivieren

```
1. Firebase Console → Functions (links)
2. Klicke "Get started"
3. Deploy your first function
4. Wähle region: europe-west1
5. Warte auf Setup
```

### 6.2 Cloud Functions Code (Node.js)

**File: `functions/index.js`**

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// Neue Benutzer erstellen → Email Verifizierung senden
exports.onUserCreated = functions.auth.user().onCreate(async (user) => {
  console.log(`New user created: ${user.email}`);
  
  // Sende Verification Email
  await admin.auth().generateEmailVerificationLink(user.email);
  
  // Erstelle Profile-Dokument
  await admin.firestore().collection('profiles').doc(user.uid).set({
    uid: user.uid,
    createdAt: new Date(),
    updatedAt: new Date()
  });
});

// Household Invitation
exports.inviteToHousehold = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 
      'User not authenticated');
  }
  
  const { householdId, email } = data;
  
  // Validierung
  if (!householdId || !email) {
    throw new functions.https.HttpsError('invalid-argument', 
      'Missing parameters');
  }
  
  // Email senden (mit SendGrid)
  // ...
  
  return { success: true };
});
```

---

## 🔗 Schritt 7: Google Calendar Integration

### 7.1 Google Cloud Project

```
1. Gehe zu: https://console.cloud.google.com
2. Project auswählen (oder neu erstellen)
3. APIs & Services → Library
4. Suche: "Google Calendar API"
5. Enable
```

### 7.2 OAuth Consent Screen

```
1. APIs & Services → OAuth consent screen
2. User Type: External
3. Fill in:
   - App name: Nestbau
   - User support email: indra.kroeger@live.com
   - Developer contact: indra.kroeger@live.com
4. Scopes: Wähle "calendar" Scope
5. Test users: Deine Email hinzufügen
```

### 7.3 OAuth Credentials

```
1. APIs & Services → Credentials
2. Create Credentials → OAuth 2.0 Client ID
3. Application type: Web application
4. Authorized redirect URIs:
   - https://nestbau-app.firebaseapp.com/auth/google/callback
   - http://localhost:3000/auth/google/callback (für lokales Testen)
5. Create
6. Kopiere Client ID + Client Secret
```

---

## 🌐 Schritt 8: Microsoft Outlook Integration

### 8.1 Azure Portal

```
1. Gehe zu: https://entra.microsoft.com
2. Applications → App registrations
3. New registration
4. Name: Nestbau
5. Supported account types: Multitenant
6. Redirect URI:
   - Web: https://nestbau-app.firebaseapp.com/auth/outlook/callback
7. Register
```

### 8.2 Credentials erstellen

```
1. Certificates & secrets
2. New client secret
3. Kopiere Client Secret (schnell!)
```

### 8.3 API Permissions

```
1. API permissions
2. Add permission
3. Microsoft Graph → Calendar.Read
4. Grant admin consent
```

---

## 📝 Checkliste für die Bots

- [ ] Firebase Project erstellt
- [ ] Web-App registriert
- [ ] Config-Werte kopiert
- [ ] Authentication (Email) aktiviert
- [ ] Firestore Database erstellt
- [ ] Collections erstellt
- [ ] Security Rules deployed
- [ ] Storage aktiviert
- [ ] Cloud Functions deployed
- [ ] Google Calendar API aktiviert
- [ ] OAuth Credentials erstellt
- [ ] Azure App registriert
- [ ] Config in index.html eingefügt

---

## 🚀 Firebase Config in der App

**In `index.html` einfügen:**

```html
<script src="https://www.gstatic.com/firebasejs/9.23.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.23.0/firebase-auth.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.23.0/firebase-firestore.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.23.0/firebase-storage.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.23.0/firebase-functions.js"></script>

<script>
const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "nestbau-app.firebaseapp.com",
  projectId: "nestbau-app",
  storageBucket: "nestbau-app.appspot.com",
  messagingSenderId: "123...",
  appId: "1:123...:web:abc...",
  databaseURL: "https://nestbau-app.firebaseio.com"
};

firebase.initializeApp(firebaseConfig);
const auth = firebase.auth();
const db = firebase.firestore();
const storage = firebase.storage();
</script>
```

---

## 💡 Tipps für die Bots

1. **Token-Sicherheit**: Verwende `.runtimeconfig.json` für Secrets, nicht in Code!
2. **Firestore Limits**: Free-Tier hat Limits, watch the budget
3. **Storage**: Komprimiere Bilder vor Upload
4. **Security Rules**: Teste gründlich!
5. **Performance**: Nutze Indexes für häufige Queries

---

**Alles bereit für die Bots!** 🚀

