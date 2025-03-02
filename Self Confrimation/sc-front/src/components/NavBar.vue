<template>
  <div class="nav-section">
    <img src="@/assets/home.png" class="home-icon" @click="goHome" />
    <div class="avatar"></div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

const goHome = () => {
  router.push('/')
}
</script>

<style scoped>
.nav-section {
  height: 24px;
  position: relative;
  padding: 8px;
  background: #ffffff;
  border-bottom: 1px solid #eee;
}

.home-icon {
  width: 24px;
  height: 24px;
  position: absolute;
  top: 8px;
  left: 16px;
  cursor: pointer;
}

.avatar {
  width: 24px;
  height: 24px;
  background: linear-gradient(-60deg,
    #7F7FD5 0%,
    #86A8E7 50%,
    #91EAE4 100%
  );
  border-radius: 50%;
  position: absolute;
  top: 8px;
  right: 16px;
}
</style> 