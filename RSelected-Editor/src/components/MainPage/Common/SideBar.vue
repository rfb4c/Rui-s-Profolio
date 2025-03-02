<template>
  <el-row class="tac sidebar-container">
    <el-col :span="24">
      <h5 class="mb-2">R Selected 编辑者</h5>
      <el-menu
        default-active="1"
        class="el-menu-vertical-demo"
        @open="handleOpen"
        @close="handleClose"
      >
        <el-menu-item index="1" @click="router.push('/eventList')">
          <el-icon><icon-menu /></el-icon>
          <span>事件管理</span>
        </el-menu-item>
        <el-menu-item index="2" @click="handleReportListClick">
          <el-icon><document /></el-icon>
          <span>报道管理</span>
        </el-menu-item>
        <el-sub-menu index="3">
          <template #title>
            <el-icon><location /></el-icon>
            <span>快速访问</span>
          </template>
          <el-menu-item-group>
            <el-menu-item index="3-1" @click="openUrl('https://news.google.com')"
              >谷歌新闻</el-menu-item
            >
            <el-menu-item index="3-2" @click="openUrl('https://images.google.com')"
              >谷歌图片</el-menu-item
            >
            <el-menu-item index="3-3">R Selected 主站</el-menu-item>
            <el-menu-item index="3-4">翻译</el-menu-item>
          </el-menu-item-group>
        </el-sub-menu>
      </el-menu>
    </el-col>
  </el-row>
</template>

<script lang="ts" setup>
import { Document, Menu as IconMenu, Location } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import { reportsService } from '@/services/reportsService'
import { ElMessage } from 'element-plus'
import { useReportStore } from '@/stores/reportStore'

const router = useRouter()
const reportStore = useReportStore()

const handleOpen = (key: string, keyPath: string[]) => {
  console.log(key, keyPath)
}
const handleClose = (key: string, keyPath: string[]) => {
  console.log(key, keyPath)
}

const openUrl = (url: string) => {
  window.open(url, '_blank')
}

const handleReportListClick = async () => {
  try {
    reportStore.setLoading(true)
    const response = await reportsService.getReportListFull()
    if (response.flag) {
      reportStore.setReportList(response.data)
      router.push('/reportList')
    } else {
      ElMessage.error(response.data || '获取报道列表失败')
    }
  } catch (error) {
    console.error('Failed to get reports list:', error)
    reportStore.setError(error.message)
    ElMessage.error('获取报道列表失败：' + error.message)
    router.push('/reportList')
  } finally {
    reportStore.setLoading(false)
  }
}
</script>

<style>
/* 移除全局滚动条 - 注意这里没有 scoped */
body {
  margin: 0;
  padding: 0;
  overflow: hidden;
}
</style>

<style scoped>
.sidebar-container {
  height: 100vh;
  background-color: var(--el-menu-bg-color);
  overflow: hidden;
  position: fixed; /* 添加固定定位 */
  width: inherit; /* 继承父元素宽度 */
}

.el-menu {
  height: 100%;
  border-right: none;
  overflow: hidden; /* 确保菜单也不会滚动 */
}

.mb-2 {
  padding: 16px;
  margin: 0;
  color: var(--el-text-color-primary);
}
</style>
