<template>
  <div class="container">
    <div class="row">
      <MapView :coordinates="coordinates" class="eight columns"></MapView>
      <div class="four columns">
        <h2> Points kilométriques </h2>
        <Search v-on:newCoord="newCoord"></Search>
      </div>
    </div>
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
.container, .row {
  height: 100%;
}
</style>
