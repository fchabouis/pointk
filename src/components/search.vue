<template>
  <div>
    <label>Saisir un axe routier <em>national</em>
      <input v-model="selectedRoad" list="roads-datalist" placeholder="Par exemple « A6 »"/>
      <datalist id="roads-datalist">
        <option v-for="(moo, road) in roads"> {{road}} </option>
      </datalist>
    </label>
    <div v-if="validRoad">
      <label>Saisir le côté</label>
        <div v-for="(moo, side) in road">
          <label>
            <input :id="side" :value="side" type="radio" v-model="selectedSide"/>
            <span class="label-body" :for="side">{{side}}</span>
          </label>
        </div>
        </input>
      <label> Saisir le point kilométrique<br/>
        <span class="label-body">
          Entre {{this.lowerBoundPk}} et {{this.upperBoundPk}}
        </span><br/>
        <input v-model.number="pointk" type="number"/>
      </label>
      <div v-if="validPk">
        <strong>Longitude&nbsp;:</strong> {{coordinates[0]}}<br/>
        <strong>Latitude&nbsp;:</strong> {{coordinates[1]}}<br/>
      </div>
    </div>
</div>
</template>

<script>
import Papa from 'papaparse'

function cleanRoadName (roadName) {
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
    validRoad () {
      return !!this.road
    },
    validPk () {
      return this.validRoad && this.selectedSide && (this.pointk !== null) &&
             this.pointk >= this.lowerBoundPk && this.pointk <= this.upperBoundPk
    },
    road () {
      return this.roads[this.selectedRoad]
    },
    pointsk () {
      return this.road[this.selectedSide]
    },
    nearests () {
      if (this.validPk) {
        let upperIndex = this.pointsk.findIndex(el => el.pk >= this.pointk)
        let lowerIndex = Math.max(0, upperIndex - 1)
        return [this.pointsk[lowerIndex], this.pointsk[upperIndex]]
      }
    },
    lowerBoundPk () {
      if (this.validRoad && this.selectedSide) {
        return this.pointsk[0].pk
      }
    },
    upperBoundPk () {
      if (this.validRoad && this.selectedSide) {
        return this.pointsk[this.pointsk.length - 1].pk
      }
    },
    coordinates () {
      if (this.validPk) {
        let u = this.nearests[0]
        let v = this.nearests[1]
        if (u && v) {
          let ratio = u.pk !== v.pk ? (this.pointk - u.pk) / (v.pk - u.pk) : 0

          return [u.lon + ratio * (v.lon - u.lon),
            u.lat + ratio * (v.lat - u.lat)]
        }
      }
    }
  },
  data () {
    return {
      roads: {},
      selectedRoad: null,
      selectedSide: null,
      pointk: null
    }
  },
  methods: {
    parseResult (results) {
      for (let row of results.data) {
        let name = cleanRoadName(row[2])
        if (name && name.match(/^[AN]/)) {
          this.roads[name] = this.roads[name] || {}
          let road = this.roads[name]
          let sideName = cleanSide(row[8])
          road[sideName] = road[sideName] || []
          let side = road[sideName]
          side.push({
            pk: parseInt(row[3]),
            lon: parseFloat(row[0]),
            lat: parseFloat(row[1])
          })
        }
      }

      for (let road in this.roads) {
        for (let side in this.roads[road]) {
          let sorted = this.roads[road][side].sort((a, b) => a.pk - b.pk)
          this.roads[road][side] = sorted
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
      if (this.validPk) {
        this.$emit('newCoord', this.coordinates)
      }
    },
    selectedRoad () {
      this.selectedSide = null
      this.pointk = null
    }
  }
}
</script>
