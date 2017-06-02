<template>
  <div id="map"></div>
</template>

<script>
import L from 'leaflet'
import 'leaflet-hash'
import 'leaflet/dist/leaflet.css'

delete L.Icon.Default.prototype._getIconUrl

L.Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png')
})

function createMap () {
  var map = L.map('map').setView([46.920, 3.186], 6)

  L.tileLayer('https://api.mapbox.com/styles/v1/mapbox/streets-v10/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoidHJpc3RyYW1nIiwiYSI6ImZlNFBkRTQifQ.Z4kZGvcEijLi0t9stDuEow', {
    maxZoom: 18,
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
                 '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
                 'Imagery © <a href="http://mapbox.com">Mapbox</a>',
    id: 'mapbox.streets'
  }).addTo(map)

  /* eslint-disable no-new */
  new L.Hash(map)
  return map
}

export default {
  name: 'map-view',
  props: {
    coordinates: Array
  },
  data () {
    return {
      map: null,
      marker: null
    }
  },
  mounted () {
    this.map = createMap()
  },
  watch: {
    coordinates () {
      if (this.marker) {
        this.map.removeLayer(this.marker)
        this.marker = null
      }
      let latLng = [this.coordinates[1], this.coordinates[0]]
      this.marker = L.marker(latLng).addTo(this.map)
      this.map.flyTo(latLng, 15)
    }
  }
}
</script>

<style>
#map {
  height: 100%;
}
</style>
