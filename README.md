# Dictionnaire des sigles

> Version 1.3.2

==> https://dicosigles.fr

## Utilisation

**Pour comparer un fichier CSV de termes** (en-têtes : `id,term,definition,explanation`, `explanation` peut être vide) avec data/sigles.csv :

```bash
./scripts/compareKeysWithDic.sh [fichier de termes] [nom de la source de ce fichier] [URL de la source]
```

Le script produit un fichier `.new.csv` à côté du fichier de termes contenant les termes qui ne sont pas encore présents dans data/sigles.csv (et dicosigles.fr).

**Pour détecter les explications dans un fichier CSV de termes pouvant compléter des termes existants** dans data/sigles.csv :

```bash
scripts/saveNewExplanations.sh [fichier de termes] [nom de la source de ce fichier] [URL de la source]
```

## Notes de version

### 1.3.2 (01/09/2020)

- bug dans le script de fusion des sigles

### 1.3.1 (31/07/2020)

- la largeur de la documentation s'adapte aux petits écrans
- ajout d'une marge entre les `<li>` des sources
- désactivation de l'import de markdown brut pour la documentation (les éléments HTML n'étaient pas interprétés)

### 1.3.0 (31/07/2020)

- ajout d'un bouton pour copier un lien court vers la recherche dans le presse-papier

### 1.2.0 (28/07/2020)

- script pour ajouter des sigles en masse avec dédoublonnage par clé ([#20](https://github.com/ColinMaudry/dictionnaire-sigles/issues/20))
- ajout de 688 sigles liés à la gendarmerie et à la police nationale (Merci [Denis Merigoux](https://merigoux.ovh) !)
- nombre total de termes injecté dans package.json pour affichage

#### 1.1.1 (25/07/2020)

- l'app ne gérait pas bien les colonnes supplémentaires (`explanation`, etc.)

### 1.1.0 (25/07/2020)

- scripts d'aggrégation et de publication

### 1.0.0 (12/07/2020)

- Première version, sans scripts d'aggrégation

## Project setup
```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

### Compiles and minifies for production
```
npm run build
```

### Lints and fixes files
```
npm run lint
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).
