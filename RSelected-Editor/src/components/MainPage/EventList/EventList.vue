<script setup>
import { useRouter } from 'vue-router'
import { ref, computed, onMounted, onUnmounted, reactive } from 'vue'
import { eventService } from '@/services/eventService'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Edit, Delete, List } from '@element-plus/icons-vue'

const router = useRouter()

// 表单相关
const formInline = reactive({
  user: '',
  region: '',
  date: '',
})

// 事件数据相关
const tableData = ref([])
const loading = ref(false)

// 获取事件数据的方法
const fetchEventData = async () => {
  try {
    loading.value = true
    const response = await eventService.getEventsWithStats()
    if (response.flag) {
      tableData.value = response.data.map((event) => ({
        eventId: event.eventId,
        name: event.eventName,
        phaseCount: event.phaseCount || 0,
        currentPhase: event.latestPhase || '未开始',
        reportCount: event.reportCount || 0,
        date: event.occurrenceTime ? new Date(event.occurrenceTime).toLocaleDateString() : '未设置',
        state: event.publishState ? '已发布' : '未发布',
        comment: event.sidebarComment || '暂无评论',
      }))
      console.log('Mapped data:', tableData.value)
    } else {
      ElMessage.error(response.message || '获取事件数据失败')
    }
  } catch (error) {
    ElMessage.error('获取事件数据失败：' + (error.message || '未知错误'))
  } finally {
    loading.value = false
  }
}

// 分页相关
const value2 = ref('')
const currentPage4 = ref(1)
const pageSize4 = ref(5)
const size = ref('default')
const background = ref(false)
const disabled = ref(false)
const is1080p = ref(window.innerHeight <= 1080)

// 计算属性
const displayData = computed(() => {
  const startIndex = (currentPage4.value - 1) * pageSize4.value
  const endIndex = startIndex + pageSize4.value
  return tableData.value.slice(startIndex, endIndex)
})

// 事件处理方法
const onSubmit = () => {
  console.log('submit!')
}

const onClick = () => {
  router.push('/createEvent')
}

const handleSizeChange = (val) => {
  pageSize4.value = val
  currentPage4.value = 1
}

const handleCurrentChange = (val) => {
  currentPage4.value = val
}

// 生命周期钩子
onMounted(() => {
  fetchEventData()
  window.addEventListener('resize', () => {
    is1080p.value = window.innerHeight <= 1080
  })
})

onUnmounted(() => {
  window.removeEventListener('resize', () => {
    is1080p.value = window.innerHeight <= 1080
  })
})

// 操作按钮方法
const onEditClick = (row) => {
  router.push({
    path: '/updateEvent',
    query: {
      eventId: row.eventId,
    },
  })
}

const onManagePhaseClick = (row) => {
  router.push({
    path: '/phaseList',
    query: {
      eventId: row.eventId,
      eventName: row.name,
      eventStartDate: row.date,
    },
  })
}

// 添加删除事件方法
const onDeleteEvent = (row) => {
  const eventId = parseInt(row.eventId)
  if (isNaN(eventId)) {
    ElMessage.error('无效的事件ID')
    return
  }

  console.log('Attempting to delete event:', row)

  ElMessageBox.confirm(
    `确定要删除事件"${row.name}"吗？此操作将永久删除该事件及其所有相关数据。`,
    '警告',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    },
  )
    .then(async () => {
      try {
        const response = await eventService.deleteEvent(eventId)
        console.log('Delete response in component:', response)

        if (response.flag) {
          ElMessage.success(response.message || '删除成功')
          await fetchEventData()
        } else {
          ElMessage.error(response.message || '删除失败')
        }
      } catch (error) {
        console.error('Error in component:', error)
        ElMessage.error('删除失败：' + (error.message || '未知错误'))
      }
    })
    .catch(() => {
      // 用户点击取消，不做任何操作
    })
}
</script>

<template>
  <div class="event-form-container">
    <el-card shadow="never">
      <template #header>
        <div class="main-header">
          <div class="header-content">
            <h2>事件管理</h2>
            <el-button type="primary" @click="onClick">新建事件</el-button>
          </div>
        </div>
      </template>

      <el-form :inline="true" :model="formInline" class="demo-form-inline">
        <el-form-item label="事件名">
          <el-input
            v-model="formInline.user"
            placeholder="输入查询的事件名"
            clearable
            style="width: 150px"
          />
        </el-form-item>
        <el-form-item label="是否发布">
          <el-select
            v-model="formInline.region"
            placeholder="发布类型"
            clearable
            style="width: 150px"
          >
            <el-option label="已发布" value="shanghai" />
            <el-option label="未发布" value="beijing" />
          </el-select>
        </el-form-item>

        <el-form-item label="事件发生日期">
          <div class="block">
            <el-date-picker
              v-model="value2"
              type="datetimerange"
              range-separator="To"
              start-placeholder="Start date"
              end-placeholder="End date"
              style="width: 300px"
            />
          </div>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="onSubmit">搜索</el-button>
          <el-button @click="onSubmit">重置</el-button>
        </el-form-item>
      </el-form>

      <div class="table-wrapper">
        <el-scrollbar :class="{ 'scrollbar-1080p': is1080p, 'scrollbar-higher': !is1080p }">
          <el-table
            v-loading="loading"
            :data="displayData"
            style="width: 100%"
            border
            :header-cell-style="{ background: '#f5f7fa' }"
            stripe
            class="el-table"
          >
            <el-table-column prop="eventId" label="事件ID" width="80" align="center" />
            <el-table-column prop="name" label="事件名" width="150">
              <template #default="scope">
                <strong>{{ scope.row.name }}</strong>
              </template>
            </el-table-column>
            <el-table-column prop="phaseCount" label="阶段数" width="70" align="center" />
            <el-table-column prop="currentPhase" label="当前阶段" width="100" />
            <el-table-column prop="reportCount" label="报道量" width="70" align="center" />
            <el-table-column prop="date" label="事件始点" width="100" />
            <el-table-column prop="state" label="发布状态" width="80" align="center" />
            <el-table-column
              prop="comment"
              label="编辑评论"
              min-width="200"
              show-overflow-tooltip
            />
            <el-table-column label="操作" width="180" fixed="right">
              <template #default="scope">
                <el-button
                  type="primary"
                  :icon="Edit"
                  circle
                  @click="onEditClick(scope.row)"
                  title="编辑事件"
                />
                <el-button
                  type="success"
                  circle
                  @click="onManagePhaseClick(scope.row)"
                  :icon="List"
                  title="管理阶段"
                />
                <el-button
                  type="danger"
                  :icon="Delete"
                  circle
                  @click="onDeleteEvent(scope.row)"
                  title="删除事件"
                />
              </template>
            </el-table-column>
          </el-table>
        </el-scrollbar>
      </div>

      <div class="pagination-container">
        <el-pagination
          v-model:current-page="currentPage4"
          v-model:page-size="pageSize4"
          :page-sizes="[5, 10, 15, 20]"
          :size="size"
          :disabled="disabled"
          :background="background"
          layout="total, sizes, prev, pager, next, jumper"
          :total="tableData.length"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>
  </div>
</template>

<style scoped>
.event-form-container {
  height: calc(100vh - 100px);
  padding: 20px;
  box-sizing: border-box;
  overflow: hidden;
}

.el-card {
  height: 100%;
  display: flex;
  flex-direction: column;
  position: relative;
}

.main-header {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-content h2 {
  margin: 0;
  font-size: 20px;
  font-weight: bold;
  color: #303133;
}

.demo-form-inline {
  margin: 20px 0;
  display: flex;
  align-items: center;
  white-space: nowrap;
}

:deep(.el-form-item) {
  margin-bottom: 0;
  margin-right: 10px;
}

:deep(.el-form-item__label) {
  font-size: 13px;
}

:deep(.el-input__wrapper) {
  padding: 0 8px;
}

:deep(.el-input__inner) {
  font-size: 13px;
}

:deep(.el-select) {
  font-size: 13px;
}

:deep(.el-form-item:last-child) {
  margin-right: 0;
  margin-left: auto;
}

.table-wrapper {
  flex: 1;
  padding: 0 20px;
  margin-bottom: 60px;
}

:deep(.el-scrollbar__wrap) {
  overflow-x: hidden;
}

:deep(.el-table) {
  margin-top: 20px;
  font-size: 13px;
}

:deep(.el-table .cell) {
  white-space: nowrap;
}

:deep(.el-table__header-wrapper th) {
  font-weight: bold;
  color: #606266;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 15px 20px;
  background-color: white;
  border-top: 1px solid #ebeef5;
  z-index: 1;
}

.scrollbar-1080p {
  height: 400px !important;
}

.scrollbar-higher {
  height: 950px !important;
}
</style>
