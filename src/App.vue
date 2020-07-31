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
          <copy-button v-bind:search="search" v-show="hasClipboardApi && search !== ''"/>
      </div>
      <p v-show="!rows[0] && search === ''">Recherchez la signification d'un sigle parmi les {{ nbTerms }} que compte ce dictionnaire</p>
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
      <about-section id="about" v-show="!rows[0]"/>
  </div>
</template>

<style>

</style>

<script>
import AboutSection from "./AboutSection.md";
import CopyButton from "./CopyButton.vue";
export default {
  components: {
    AboutSection,
    CopyButton
  },
  data () {
    return {
      endpoint: null,
      total: 0,
      error: null,
      hasClipboardApi:false,
      currentPage: 1,
      perPage: 100,
      loading: false,
      search: "",
      nbTerms: process.env.VUE_APP_NBTERMS,
      resource: {
        url: process.env.VUE_APP_RESOURCEURL
      },
      showRowId: false,
      columns: [],
      rows: []
    }
  },
  created() {
    let split=window.location.href.split("/");
    let search=split[split.length - 1];
    if (search !== "#" && search[0] !== "#") {
      this.search=search;
      this.makeSearch();
    }
    if (navigator.clipboard.writeText) {
      this.hasClipboardApi=true;
    } else {
      console.log("Votre navigateur ne supporte pas la méthode writeText de l'API presse-papier.")
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
