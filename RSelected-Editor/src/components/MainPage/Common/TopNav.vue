<script lang="ts" setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const activeIndex = ref('1')

const handleSelect = (key: string, keyPath: string[]) => {
  if (key === '2-1') {
    // 跳转到修改密码页面
    router.push('/revisePassword')
  }
}

const handleLogoClick = () => {
  router.push('/eventList')
}
</script>

<template>
  <el-menu
    :default-active="activeIndex"
    class="el-menu-demo"
    mode="horizontal"
    :ellipsis="false"
    @select="handleSelect"
  >
    <el-menu-item index="0" @click="handleLogoClick">
      <img style="width: 30px" src="@/assets/R.png" alt="Logo" />
    </el-menu-item>
    <!-- 注释掉编辑之家
    <el-menu-item index="1">编辑之家</el-menu-item>
    -->
    <el-sub-menu index="2">
      <template #title>用户管理</template>
      <el-menu-item index="2-1">修改密码</el-menu-item>
    </el-sub-menu>
  </el-menu>
</template>

<style>
.el-menu--horizontal > .el-menu-item:nth-child(1) {
  margin-right: auto;
}

/* 调整用户管理下拉菜单的样式 */
.el-menu--popup {
  min-width: 120px;
}
</style>
