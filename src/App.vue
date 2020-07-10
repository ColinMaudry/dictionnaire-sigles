<template>
   <div id="app2">
      <div id="search-frame">
        <input
          id="search"
          v-model="search"
          v-on:keyup="makeSearch"
          title="Champ de recherche"
          placeholder="Sigle ou acronyme"
          aria-label="Rechercher un sigle ou acronyme"
          type="search"
          autofocus="autofocus"
          >
      </div>
      <p v-show="!rows[0] && search === ''">Recherchez la signification d'un sigle parmi les 4 320 que compte ce dictionnaire</p>
      <table id="results" v-show="rows[0] && !loading && search">
        <colgroup>
          <col style=""/>
          <col style=""/>
          <col style=""/>
        </colgroup>
        <thead>
          <td>Sigle</td>
          <td>Définition</td>
          <td>Source</td>
          </thead>
          <tbody>
            <tr v-for="row in rows" :key="row.term + row.definition">
              <td>{{ row.term }}</td>
              <td>{{ row.definition }}</td>
              <td><a v-bind:href="row.url_source" target="_blank">{{ row.source }}</a></td>
            </tr>
          </tbody>
      </table>
      <p v-show="!loading && !rows[0] && search !== ''">Le dictionnaire ne contient pas de sigle contenant le texte <strong>{{ search }}</strong>.</p>
      <div v-show="loading">
       <p>Chargement...</p> 
    </div>

  <div v-show="!rows[0]" id="about">
    <h1>Dictionnaire des sigles de l'administration française</h1>

    <p>Ce dictionnaire en ligne est destiné à combler le fossé qui existe en France entre les personnes qui connaissent le sens des sigles, et celles qui ne le connaissent pas.</p>

    <p><strong>Les données</strong> de ce dictionnaire ont été rassemblées et triées par <a href="https://colin.maudry.fr">Colin Maudry</a>. Elles peuvent être téléchargées <a href="https://www.data.gouv.fr/datasets/5ee0d624d915e528468166c6">sur data.gouv.fr</a>, et sont publiées selon les termes de la <a href="http://creativecommons.org/publicdomain/zero/1.0/">licence Creative Commons Zero</a>.</p>

    <p><strong>Le code source</strong> de cette application est hébergé <a href="https://github.com/ColinMaudry/dictionnaire-sigles">sur github.com</a>, et est publié selon les termes de la licence MIT.</p>

    <p>Cette application a été développée par Colin Maudry (<a href="https://github.com/ColinMaudry/">Github</a>, <a href="https://twitter.com/col1m">Twitter</a>). Quelques précieuses heures ont été économisées grâce à du code partagé par <a href="https://github.com/taniki">Tam-Kien Duong</a>.</p>

    <p>Elle se veut volontairement minimaliste de façon à être accessible, rapide et peu gourmande en énergie.</p>

   <h2 id="commentcontribuer">Comment contribuer</h2>

    <p>Si vous souhaitez ajouter ou corriger un sigle, ça se passe <a href="https://docs.google.com/spreadsheets/d/1kEJzE-8nCBZakKWptfrc5HhuctOEnMYy8AgxGz6dNW4/edit">par ici</a> (tableur Google).</p>

    <p>Si vous souhaitez ajouter une épaisse liste de sigles à ce dictionnaire et que vous l'avez sous forme de fichier, merci de <a href="#contact">me contacter</a>. Il doit s'agir de sigles utilisés par l'administration française ou utilisés dans la loi française et non présents dans ce dictionnaire.</p>
    <p>Souvent, la limite à ne pas franchir est celle du vocabulaire technique ou scientifique, même s'il y a des exceptions pour les termes les plus employés.</p>

    <p>Merci de privilégier les formats structurés, par ordre de préférence :</p>
    <ul>
      <li>csv</li>
      <li>json</li>
      <li>xml</li>
      <li>ods, xlsx</li>
      <li>html</li>
    </ul>

   <h2 id="lessources">Les sources</h2>

    <ul>
      <li><a href="https://www.senat.fr/histoire/sigles.html">Petit dictionnaire des sigles du Sénat</a></li>

      <li><a href="http://www.metiers-fonctionpubliquehospitaliere.sante.gouv.fr/Lexique-des-abreviations-ou-sigles.html">Lexique des abréviations ou sigles de la direction générale de l’offre de soins (DGOS)</a></li>

      <li><a href="https://github.com/betagouv/glossary-bot">Les contributions de la communauté beta.gouv.fr</a></li>

      <li><a href="http://www.cce-lrv.com/documents/images/general_photos/151_Fichier.pdf">Petit dictionnaire des sigles et acronymes de la Compagnie des commissaires-enquêteurs du Languedoc-Roussillon</a>, assemblé par Michel Lefay</li>

      <li><a href="http://maraudes.fr/glossaire-sigles-social-de-sante-de-ladministration/">Glossaire des sigles du social, de la santé et de l’administration</a>, par <a href="https://twitter.com/lolobobo">Laurent Bohu</a></li>

      <li><a href="https://www.cnle.gouv.fr/Sigles-de-l-Administration.html">Sigles de l’Administration</a> du Conseil national des politiques de lutte contre la pauvreté et l'exclusion sociale (CNLE)</li>

      <li><a href="http://www.marche-public.fr/Marches-publics/Definitions/Marches-publics-Sigles.htm">Sigles et acronymes relatifs aux marchés publics</a>, par <a href="https://twitter.com/marchespublics">Frédéric Makowski</a></li>

      <li><a href="https://www.fonction-publique.gouv.fr/files/files/statistiques/rapports_annuels/2016/G_Liste_des_sigles.pdf">Liste des sigles</a>, par la Direction générale de l’administration et de la fonction publique (DGAFP)</li>

      <li><a href="http://www.justice.gouv.fr/art_pix/Stat_Annuaire_ministere-justice_sigles.pdf">Sigles et abbréviations utilisées</a>, par le Ministère de la justice</li>

      <li><a href="https://www.keratocone.net/acronymes.html">Acronymes administratifs</a>, par l'association Keratocone</li>

      <li><a href="https://concours-fonction-publique.publidia.fr/guide-fonction-publique/infos-utiles/lexique-fonction-publique">Lexique des abréviations de la Fonction Publique</a>, par Publidia</li>

      <li><a href="http://www.ac-grenoble.fr/college/poisy/orientation/orientation-sigles-et-acronymes/">Glossaire des sigles et acronymes</a>, par le collège de Poisy (académie de Grenoble), à partir d'un manuel de l'Onisep</li>

      <li>Sources indiquées par les contributeurs et contributrices de ce dictionnaire</li>
    </ul>

    <h2 id="contact">Contact</h2>

    <ul>
      <li>email : colin+sigles@maudry.com</li>
      <li>twitter : <a href="https://twitter.com/col1m">@col1m</a></li>
    </ul>

    <h2 id="vieprive">Vie privée</h2>

    <h3 id="cookiesdpossetoptout">Cookies déposés et opt-out</h3>

    <p>Ce site dépose un petit fichier texte (un « cookie ») sur votre ordinateur lorsque vous le consultez. Cela me permet de mesurer le nombre de visites et de comprendre quelles sont les pages les plus consultées.</p>
    <div style="background-color: #ccc;">
      <iframe
      style="border: 0; height: 200px; width: 600px;" title="Opt-out du cookie de suivi"
      src="https://analytics.maudry.com/index.php?module=CoreAdminHome&action=optOut&language=fr&backgroundColor=&fontColor=&fontSize=&fontFamily="
      ></iframe>
    </div>

    <p>Ce site n'affiche pas de bannière de consentement aux cookies, pourquoi ?</p>

    <p>C'est vrai, vous n'avez pas eu à cliquer sur un bloc qui recouvre la moitié de la page pour dire que vous êtes d'accord avec le dépôt de cookies.</p>

    <p>Rien d'exceptionnel, je respecte simplement la loi, qui dit que certains outils de suivi d'audience, correctement configurés pour respecter la vie privée, sont exemptés d'autorisation préalable.</p>

    <p>J'utilise pour cela <a href="https://matomo.org/">Matomo</a>, un outil <a href="https://matomo.org/free-software/">libre</a>, paramétré pour être en conformité avec la <a href="https://www.cnil.fr/fr/solutions-pour-les-cookies-de-mesure-daudience">recommandation « Cookies »</a> de la <abbr title="Commission Nationale de l'Informatique et des Libertés">CNIL</abbr>. Cela signifie que votre adresse IP, par exemple, est anonymisée avant d'être enregistrée. Il m'est donc impossible d'associer vos visites sur ce site à votre personne.</p>

    <h2 id="mentionslgales">Mentions légales</h2>

    <p>Le dictionnaire des sigles de l'administration française a été compilé et édité par Colin Maudry, inscrit au répertoire SIRENE sous le numéro 812 231 132, et dont le siège social est situé au 7 avenue Aristide Briand, 35000 Rennes.</p>

    <p>Le dictionnaire des sigles de l'administration française est hébergé par la société Github, propriété de Microsoft Corporation.</p>
  </div>
  </div>
</template>

<style>

</style>

<script>
export default {
  data () {
    return {
      endpoint: null,
      total: 0,
      error: null,
      currentPage: 1,
      perPage: 100,
      loading: false,
      search: "",
      resource: {
        url: "https://static.data.gouv.fr/resources/dictionnaire-des-sigles-et-acronymes-de-ladministration/20200623-140224/acronymes.csv"
      },
      showRowId: false,
      columns: [],
      rows: []
    }
  },
  created() {
    let split=window.location.href.split("/");
    let search=split[split.length - 1];
    if (search !== "#") {
      this.search=search;
      this.makeSearch();
    }
  },
  computed: {},
  async mounted () {
    if (this.search) {
      this.makeSearch();
    }
  },
  methods: {
    request(method, url) {
      return new Promise(function (resolve, reject) {
        var xhr = new XMLHttpRequest();
        xhr.open(method, url);
        xhr.onload = resolve;
        xhr.onerror = reject;
        xhr.send();
    });
    },
    makeSearch() {
    if (this.search !== "") {
      let ctx=this;
      console.log("Let's search " + this.search);
      const url = 'https://csvapi.data.gouv.fr/apify'
      this.loading = true
      this.request("GET", `${url}?url=${encodeURIComponent(this.resource.url)}`)
        .then((res) => {
          let response=JSON.parse(res.target.response);
          this.endpoint = response.endpoint;
          return this.endpoint;
        })
        .then(endpoint => {
          let params = `_offset=${(ctx.currentPage - 1) * ctx.perPage}&_shape=objects&term__contains=${this.search}`
          if (!this.showRowId) {
            params += '&_rowid=hide'
          }
          return this.request("GET", `${endpoint}?${params}`)
        })
        .then((res) => {
        let response=JSON.parse(res.target.response);
          this.loading = false
          this.columns = response.columns
          this.total = response.total
          this.rows = response.rows
        })
        .catch((error) => {
          this.loading = false
          if (error.target.response) {
            this.error = error.response.error
          } else {
            this.error = error.toString()
          }
          //callback(null)
        })
      return null

      } else {
        this.rows=[]
      }
    }
  }
}
</script>
