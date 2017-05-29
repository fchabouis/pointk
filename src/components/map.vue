<template>
  <div id="map"></div>
</template>

<script>
import L from 'leaflet'
import 'leaflet-hash'
import 'leaflet/dist/leaflet.css'

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
  data () {
    return {}
  },
  mounted () {
    createMap()
  }
}
</script>

<style>
#map {
  height: 100%;
}
</style>
