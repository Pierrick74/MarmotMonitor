# MarmotMonitor 👶


**Accompagnez chaque étape des premiers jours de votre bébé. L'application iOS indispensable pour les parents modernes.**

---

## 📱 À propos

MarmotMonitor est une application iOS native qui aide les parents à suivre facilement les activités quotidiennes de leur bébé. De l'alimentation au sommeil, en passant par la croissance et les changements de couches — tout est centralisé dans une interface intuitive et accessible.

**Développée à Annecy** 🏔️ avec une approche **accessibility-first**, cette app met l'accent sur l'inclusivité et la performance.

### Points clés

✨ **Suivi intuitif** - Interface épurée, utilisable d'une seule main
🎯 **Accessibilité prioritaire** - Support VoiceOver et Dynamic Type
📊 **Visualisation données** - Courbes de croissance et histoires chronologiques
⚡ **Hors ligne** - Les données restent sécurisées localement
🎨 **Personnalisable** - Thèmes d'icônes et modes sombre/clair

---

## 🚀 Démarrage rapide

### Prérequis

- **Xcode 15.4+**
- **iOS 17+** (cible de déploiement)
- **macOS 13.5+** (pour la compilation)

### Installation locale

```bash
# Cloner le repository
git clone https://github.com/Pierrick74/MarmotMonitor.git
cd MarmotMonitor

# Ouvrir le projet Xcode
open MarmotMonitor.xcodeproj

# Build & Run
# ⌘ + R (ou bouton Play dans Xcode)
```

Aucune dépendance externe — le projet fonctionne immédiatement ! ✨

---

## ✨ Fonctionnalités principales

### 📈 Courbes de croissance
Enregistrez la taille et le poids de votre bébé, consultez son évolution graphique au fil des jours et des mois.

### 🍼 Suivi des repas
- **Allaitement** : Timer et durée par sein
- **Biberon** : Quantité en ml, visualisation interactive
- **Diversification** : Spoon feeding et repas à la cuillère

### 🛏️ Sommeil
Enregistrez chaque sieste et période de sommeil nocturne avec chronologie complète.

### 👶 Gestion des couches
Distinguez les changements par type (urine, selles, complet) pour une meilleure organisation.

### ⚙️ Paramètres avancés
- Mode sombre/clair avec respect des préférences système
- Sélection d'icônes d'app (5 thèmes)
- Unités de mesure personnalisables (kg/lb, cm/in)
- Gestion du profil bébé (nom, genre, date de naissance)

---

## 🏗️ Architecture

### Stack technologique

| Couche | Technologie |
|--------|-------------|
| **UI** | SwiftUI (100% native) |
| **Persistence** | SwiftData + CoreData |
| **Tests** | Swift Testing + XCTest |
| **Quality** | SwiftLint + GitHub Actions |
| **Patterns** | MVVM + Manager Pattern |

### Structures de dossiers

```
MarmotMonitor/
├── AddInformation/          # Écrans d'ajout d'activités
│   ├── Food/                # Biberon, allaitement, cuillère
│   ├── Sleep/               # Gestion du sommeil
│   ├── Diaper/              # Changements de couches
│   └── Growth/              # Courbes de croissance
├── Monitor/                 # Vue principale d'affichage
│   ├── ActivityView/        # Histoires + légende
│   ├── detailView/          # Détails d'une activité
│   └── GrowthView/          # Graphique croissance
├── Today/                   # Vue "Aujourd'hui"
│   ├── Row/                 # Composants ligne
│   └── StripName/           # Bande de sélection
├── OnBoarding/              # Flux d'initialisation
├── SetupView/               # Écran paramètres
├── Data/                    # Gestion données
│   ├── swiftData/           # Modèles SwiftData
│   └── AppStorage/          # Préférences utilisateur
├── Common/                  # Extensions & utilitaires
└── Ressources/              # Assets, couleurs, strings
```

## Structure des tests

```
MarmotMonitorTests/
├── AddView/             # Tests d'ajout d'activités
├── Monitor/             # Tests affichage
├── Today/               # Tests vue aujourd'hui
├── onBoarding/          # Tests onboarding
├── data/                # Tests SwiftDataManager
└── Mock/                # Données factices
```

## ♿ Accessibilité

L'accessibilité est **intégrée par défaut**, pas ajoutée après-coup.

### Normes respectées

✅ **WCAG 2.1 Level AA** (cible : AAA)
✅ **VoiceOver** complet — tous les éléments sont vocalisables
✅ **Dynamic Type** — Support de tous les tailles de texte (xSmall → xxxLarge)
✅ **Contraste** — Ratio minimum 4.5:1
✅ **Focus** — Navigation clavier fluide

---

## 📊 Widgets

### SimpleWidget (iOS 17+)

Un widget pour afficher rapidement les activités d'aujourd'hui. Configurable :
- Actualisation : Toutes les heures
- Taillesavailable : Small, Medium, Large

## 📋 État du projet

| Aspect | Status |
|--------|--------|
| **Build** | ✅ Stable (CI/CD green) |
| **Tests** | ✅ 11+ test suites |
| **Accessibility** | ✅ WCAG 2.1 AA |
| **iOS Support** | ✅ 17+ |
| **Production** | ✅ App Store ready |

---

## 📄 Licence

Ce projet est sous licence **MIT**.

Libre d'utilisation, de modification et de distribution (usage personnel & commercial).

---

## 👤 Auteur

**Pierrick Viret**
- 📧 Email: pierrickviret@gmail.com
- 🔗 GitHub: [@Pierrick74](https://github.com/Pierrick74)
- 📍 Annecy, Haute-Savoie, France

---

<div align="center">

Made with ❤️ in Annecy | ⭐ Si ce projet vous plaît, n'hésitez pas à le mettre en favori !

</div>
