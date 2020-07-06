<template>
  <div>
    <nav id="nav">
      <ul>
        <li><router-link to="/a-propos">À propos</router-link></li>
        <li><router-link to="/">Dictionnaire</router-link></li>
      </ul>
    </nav>
    <router-view></router-view>
  </div>
</template>

<style>
nav a.router-link-exact-active {
  display:none;
}
</style>

<script>

</script>
