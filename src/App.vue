<template>
  <div>
    <div id="app2">
    <input id="search" v-model="search" v-on:keyup="makeSearch">
      <b-container
        fluid
      >
        <b-table
          v-if="rows.length > 0"
          small
          :fields="fields"
          primary-key="rowid"
          :items="rows"
          head-variant="light"
          :no-border-collapse="true"
          responsive
          :per-page="perPage"
          :current-page="currentPage"
        >
          <template #cell(rowid)="data">
            <b-link
              append
              :to="`row/${data.item.rowid}`"
            >
              {{ data.item.rowid }}
            </b-link>
          </template>
          <template
            v-slot:table-caption
            v-if="error"
          >
            <b-container>
              <b-alert
                show
                variant="danger"
              >
                {{ error }}
              </b-alert>
            </b-container>
          </template>
        </b-table>
      </b-container>
    </div>
    <div v-if="loading">
      <b-spinner
        small
        type="grow"
        label="Loading..."
        variant="secondary"
      />
    </div>
  </div>
</template>

<style>
.full-width {
    width: 100vw;
    position: relative;
    margin-left: -50vw;
    left: 50%;
}
.full-height {
  height: 100vh;
}

</style>

<script>
import axios from 'axios'
import BootstrapVue from 'bootstrap-vue'
import Vue from 'vue'
//import 'bootstrap/dist/css/bootstrap.css'
//import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.use(BootstrapVue)

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
