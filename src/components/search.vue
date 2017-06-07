<template>
  <div>
    <label>Saisir un axe routier <em>national</em>
      <input v-model="selectedRoad" list="roads-datalist" placeholder="Par exemple « A6 »"/>
      <datalist id="roads-datalist">
        <option v-for="(moo, road) in roads"> {{road}} </option>
      </datalist>
    </label>
    <div v-if="road">
      <label>Saisir le côté</label>
        <div v-for="(moo, side) in road">
          <label>
            <input :id="side" :value="side" type="radio" v-model="selectedSide"/>
            <span class="label-body" :for="side">{{side}}</span>
          </label>
        </div>
        </input>
      <label v-if="bounds"> Saisir le point kilométrique<br/>
        <span class="label-body">
          Entre {{bounds.lower}} et {{bounds.upper}}
        </span><br/>
        <input v-model.number="pointk" type="number"/>
      </label>
      <div v-for="coord in coordinates">
        <p>
          <strong>Longitude&nbsp;:</strong> {{coord.lng}} <br/>
          <strong>Latitude&nbsp;:</strong> {{coord.lat}} <br/>
          <strong>Département&nbsp;:</strong> {{coord.departement}}
        </p>
      </div>
      <div v-if="!ok">{{reason}}</div>
    </div>
</div>
</template>

<script>
import Papa from 'papaparse'

function cleanRoadName (roadName, dep) {
  if (roadName) {
    return roadName.replace(/(^[AN])0+(.+$)/, '$1$2')
  } else {
    return roadName
  }
}

function cleanSide (side) {
  let map = {
    D: 'Droite',
    G: 'Gauche',
    I: 'Inconnu'
  }
  return map[side]
}

export default {
  name: 'search',
  created () {
    this.readPkPr()
  },
  computed: {
    road () {
      return this.roads[this.selectedRoad]
    },
    pointsk () {
      return this.road[this.selectedSide]
    },
    nearests () {
      if (this.road && this.selectedSide && this.pointk) {
        return [this.pointsk[Math.floor(this.pointk)],
          this.pointsk[Math.ceil(this.pointk)]]
      }
    },
    bounds () {
      if (this.road && this.selectedSide) {
        let pks = Object.keys(this.pointsk).map(x => parseInt(x))
        return {
          lower: Math.min(...pks),
          upper: Math.max(...pks)
        }
      }
    },
    coordinates () {
      let result = []
      if (this.nearests) {
        let u = this.nearests[0]
        let v = this.nearests[1]
        if (u && v) {
          if (u.length === 1 && v.length === 1) {
            u = u[0]
            v = v[0]
            let ratio = u.pk !== v.pk ? (this.pointk - u.pk) / (v.pk - u.pk) : 0
            this.ok = true
            result = [{
              lng: u.lng + ratio * (v.lng - u.lng),
              lat: u.lat + ratio * (v.lat - u.lat),
              departement: u.departement
            }]
          } else if (Math.floor(this.pointk) === Math.ceil(this.pointk)) {
            this.ok = true
            result = u
          } else {
            this.ok = false
            this.reason = 'Impossible d’interpoler. Utilisez une valeur pk entière'
          }
        } else {
          this.ok = false
          this.reason = 'Les coordonnées du point sont introuvables'
        }
      }
      return result
    }
  },
  data () {
    return {
      roads: {},
      selectedRoad: null,
      selectedSide: null,
      pointk: null,
      ok: true,
      reason: ''
    }
  },
  methods: {
    parseResult (results) {
      for (let row of results.data) {
        let name = cleanRoadName(row[2], row[4])
        if (name && name.match(/^[AN]/)) {
          this.roads[name] = this.roads[name] || {}
          let road = this.roads[name]
          let sideName = cleanSide(row[8])
          road[sideName] = road[sideName] || {}
          let side = road[sideName]
          let pk = row[3]
          side[pk] = side[pk] || []
          let pks = side[pk]
          pks.push({
            pk: pk,
            lng: parseFloat(row[0]),
            lat: parseFloat(row[1]),
            departement: row[4]
          })
        }
      }
    },
    readPkPr () {
      var bornes = require('../../static/bornes.csv')

      Papa.parse(bornes, {
        download: true,
        complete: this.parseResult
      })
    }
  },
  watch: {
    coordinates () {
      this.$emit('newCoord', this.coordinates)
    },
    selectedRoad () {
      this.selectedSide = null
      this.pointk = null
    }
  }
}
</script>
