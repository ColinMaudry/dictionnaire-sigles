<template>
    <div id="app2">
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
      <p v-show="!rows[0] && search === ''">Recherchez la signification d'un sigle parmi les XX que comptent ce dictionnaire</p>
      <table id="results" v-show="rows[0] && !loading">
        <colgroup>
          <col style="min-width=100px"/>
          <col style=""/>
          <col style="min-width=12Opx"/>
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
      <p v-show="!loading && !rows[0]">Le dictionnaire ne contient pas de sigle contenant le texte <strong>{{ search }}</strong>.</p>
      <div v-show="loading">
       <p>Chargement...</p> 
    </div>
  </div>
</template>

<style>

</style>

<script>
import axios from 'axios'

export default {
  data () {
    return {
      endpoint: null,
      total: 0,
      error: null,
      currentPage: 1,
      perPage: 100,
      loading: false,
      search: this.$route.params.search || "",
      resource: {
        url: "https://static.data.gouv.fr/resources/dictionnaire-des-sigles-et-acronymes-de-ladministration/20200623-140224/acronymes.csv"
      },
      showRowId: false,
      columns: [],
      rows: []
    }
  },
  computed: {},
  async mounted () {
    if (this.search) {
      this.makeSearch();
    }
  },
  methods: {
    makeSearch() {
      let ctx=this
      console.log(this.search);
      const url = 'https://csvapi.data.gouv.fr/apify'
      this.loading = true
      axios.get(`${url}?url=${encodeURIComponent(this.resource.url)}`)
        .then((res) => {
          this.endpoint = res.data.endpoint
          return this.endpoint
        })
        .then(endpoint => {
          let params = `_offset=${(ctx.currentPage - 1) * ctx.perPage}&_shape=objects&term__contains=${this.search}`
          if (!this.showRowId) {
            params += '&_rowid=hide'
          }
          return axios.get(`${endpoint}?${params}`)
        })
        .then(res => {
          this.loading = false
          this.columns = res.data.columns
          this.total = res.data.total
          this.rows = res.data.rows
        })
        .catch((error) => {
          this.loading = false
          if (error.response) {
            this.error = error.response.data.error
          } else {
            this.error = error.toString()
          }
          //callback(null)
        })
      return null
    }
  }
}
</script>
