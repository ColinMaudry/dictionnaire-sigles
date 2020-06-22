<template>
  <div>
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
    <table id="results" v-if="rows[0]">
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
            <td>{{ row.source }}</td>
          </tr>
        </tbody>
    </table>
    </div>
    <div v-if="loading && !rows">
     <p>loading...</p> 
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
      search: "",
      resource: {
        url: "https://www.data.gouv.fr/fr/datasets/r/0fca6fc3-4919-458d-9c81-a2cf54a801ba"
      },
      showRowId: false,
      columns: [],
      rows: []
    }
  },
  computed: {
    fields () {
      return [
        {
          key: 'term'
        },
        {
          key: 'definition'
        },
        {
          key: 'source'
        }
      ]
    }
  },
  async mounted () {
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
