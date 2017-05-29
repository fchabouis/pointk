<template>
  <div class="container">
    <div class="row">
      <MapView class="nine columns"></MapView>
      <div class="three columns">
        <Search></Search>
      </div>
    </div>
</div>
</template>

<script>
import MapView from './components/map'
import Search from './components/search'
export default {
  name: 'app',
  components: { MapView, Search }
}
</script>

<style>
</style>
