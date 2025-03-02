<script setup lang="ts">
import NavVue from './Common/TopNav.vue'
import SideBarVue from './Common/SideBar.vue'
</script>

<template>
  <div class="common-layout">
    <el-container class="container">
      <!-- head -->
      <el-header class="header">
        <NavVue />
      </el-header>
      <el-container>
        <!-- side -->
        <el-aside class="aside" width="200px">
          <SideBarVue />
        </el-aside>
        <!-- main -->
        <el-main>
          <router-view />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>
<!-- 修改4 -->
<style scoped>
.container {
  height: 100vh;
  background-color: #f5f7fa; /* 添加浅灰色背景 */
}

.header {
  padding: 0;
  margin: 0;
}

.aside {
  height: 80%;
  background-color: #030303;
}

:deep(.el-main) {
  overflow-x: hidden;
  width: 100%;
  height: calc(100vh - 60px); /* 设置为视窗高度减去header高度 */
  max-height: calc(100vh - 60px); /* 确保不会超过这个高度 */

  overflow-y: auto; /* 允许垂直方向滚动 */
}

:deep(.el-aside) {
  overflow-x: hidden;
}
</style>
<!-- 修改哦5 -->
