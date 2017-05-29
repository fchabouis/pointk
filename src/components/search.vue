<template>
  <div>
    <label>Saisir un axe routier :
      <select v-model="blurp">
        <option v-for="(pk, road) in roads" :value="road">{{road}}</option>
      </select>
        <datalist id="roads">
      </datalist>
    </label>
    Axe sélectionné : {{blurp}}
</div>
</template>

<script>
import Papa from 'papaparse'

function cleanRoadName (roadName) {
  if (roadName) {
    return roadName.replace(/(^[AN])0+(.+$)/, '$1 $2')
  } else {
    return roadName
  }
}

export default {
  name: 'search',
  mounted () {
    this.readPkPr()
  },
  data () {
    console.log('Dataaaa')
    return {
      roads: {},
      selected: '',
      blurp: ''
    }
  },
  methods: {
    parseResult (results) {
      let routes = {}
      for (let row of results.data) {
        let name = cleanRoadName(row[2])
        if (name) {
          routes[name] = routes[name] || []
          routes[name].push({
            lon: row[0],
            lat: row[1]
          })
        }
      }
      this.roads = routes
      console.log('Fin du parsing', Object.keys(routes).length)
    },
    readPkPr () {
      console.log('Lit le CSV')
      var bornes = require('../../static/bornes.csv')
      Papa.parse(bornes, {
        download: true,
        complete: this.parseResult
      })
    }
  }
}
</script>
