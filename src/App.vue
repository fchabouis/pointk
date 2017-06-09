<template>
  <div id="App">
    <Search v-on:newCoord="newCoord"></Search>
    <MapView :coordinates="coordinates"></MapView>
</div>
</template>

<script>
import MapView from './components/map'
import Search from './components/search'
export default {
  name: 'app',
  components: { MapView, Search },
  data () {
    return {
      coordinates: null
    }
  },
  methods: {
    newCoord (coord) {
      if (coord) {
        this.coordinates = coord
      }
    }
  }
}
</script>

<style>
#App {
  height: 100%;
  width: 100%;
}
</style>
