<template>
  <el-card class="phase-list-container">
    <template #header>
      <div class="main-header">
        <div class="header-content">
          <h2>事件阶段管理</h2>
          <el-button type="primary" @click="onCreatePhase">新建阶段</el-button>
        </div>
        <div class="project-info">
          <span>事件ID：{{ eventId }}</span>
          <span>事件名称：{{ eventName }}</span>
          <span>事件起始点：{{ eventStartDate }}</span>
        </div>
      </div>
    </template>

    <div class="phase-list">
      <el-timeline>
        <el-timeline-item
          v-for="(phase, index) in sortedPhases"
          :key="phase.id"
          :timestamp="phase.getPhaseOccurrenceTime()"
          placement="top"
          :type="index === 0 ? 'primary' : ''"
        >
          <el-card shadow="never" class="timeline-card">
            <template #header>
              <div class="card-header">
                <div class="header-left">
                  <h3 @click="onPhaseClick(phase, getPreviousPhase(index))">
                    {{ phase.getPhaseName() }}
                    <span class="phase-id">{{ phase.id }}</span>
                  </h3>
                  <div class="time-range">{{ phase.getPhaseOccurrenceTime() }}</div>
                </div>
                <div class="header-actions">
                  <el-button
                    type="success"
                    :icon="Document"
                    circle
                    @click="onManageReports(phase)"
                    title="管理阶段报道"
                  />
                  <el-button
                    type="danger"
                    :icon="Delete"
                    circle
                    @click="onDeletePhase(phase)"
                    title="删除阶段"
                  />
                </div>
              </div>
            </template>
            <div class="card-content">
              <div class="phase-info">
                <p>{{ phase.getPhaseSum() }}</p>
                <div class="source">来源：{{ phase.getPhaseSumSource() }}</div>
              </div>
            </div>
          </el-card>
        </el-timeline-item>
      </el-timeline>
    </div>
  </el-card>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Document, Delete } from '@element-plus/icons-vue'
import { ElMessageBox, ElMessage } from 'element-plus'
import { phaseService } from '@/services/phaseService'

const route = useRoute()
const router = useRouter()
const eventId = ref('')
const eventName = ref('')
const eventStartDate = ref('')

onMounted(() => {
  eventId.value = String(route.query.eventId || '')
  eventName.value = String(route.query.eventName || '')
  eventStartDate.value = String(route.query.eventStartDate || '')

  if (eventId.value) {
    loadPhaseData(eventId.value)
  }
})

const phases = ref([])

// 添加计算属性来排序阶段
const sortedPhases = computed(() => {
  return [...phases.value].sort((a, b) => {
    const timeA = new Date(a.getPhaseOccurrenceTime())
    const timeB = new Date(b.getPhaseOccurrenceTime())
    return timeA - timeB // 按时间升序排列
  })
})

const loadPhaseData = async (id) => {
  try {
    console.log('Loading phases for event:', id)
    const response = await phaseService.getPhasesByEventId(id)

    if (response.flag) {
      if (Array.isArray(response.data)) {
        phases.value = response.data.map((phase) => ({
          id: phase.phaseId,
          phaseId: `PH${String(phase.phaseId).padStart(4, '0')}`,
          getPhaseName: () => phase.phaseName,
          getPhaseOccurrenceTime: () => phase.phaseOccurrenceTime,
          getPhaseSum: () => phase.phaseSum,
          getPhaseSumSource: () => phase.phaseSumSource,
        }))
      } else {
        // 如果没有找到阶段数据
        phases.value = []
        ElMessage.info(response.data)
      }
    } else {
      ElMessage.error(response.message || '获取阶段数据失败')
    }
  } catch (error) {
    console.error('Failed to load phase data:', error)
    ElMessage.error('获取阶段数据失败：' + (error.message || '未知错误'))
  }
}

const onCreatePhase = () => {
  // 获取排序后的阶段列表中的最后一个阶段（最新的阶段）
  const lastPhase = sortedPhases.value[sortedPhases.value.length - 1]

  if (lastPhase) {
    router.push({
      path: '/updatePhase',
      query: {
        mode: 'create',
        eventId: eventId.value,
        previousPhase: JSON.stringify({
          phaseName: lastPhase.getPhaseName(),
          phaseOccurrenceTime: lastPhase.getPhaseOccurrenceTime(),
          phaseSum: lastPhase.getPhaseSum(),
          phaseSumSource: lastPhase.getPhaseSumSource(),
        }),
      },
    })
  } else {
    // 如果没有阶段，则不传递 previousPhase 参数
    router.push({
      path: '/updatePhase',
      query: {
        mode: 'create',
        eventId: eventId.value,
      },
    })
  }
}

const getPreviousPhase = (currentIndex) => {
  return currentIndex > 0 ? phases.value[currentIndex - 1] : null
}

const onPhaseClick = (phase, previousPhase) => {
  const queryObj = {
    mode: 'update',
    eventId: eventId.value,
    eventName: eventName.value,
    eventStartDate: eventStartDate.value,
    phase: JSON.stringify({
      phaseId: phase.id,
      phaseName: phase.getPhaseName(),
      phaseOccurrenceTime: phase.getPhaseOccurrenceTime(),
      phaseSum: phase.getPhaseSum(),
      phaseSumSource: phase.getPhaseSumSource(),
    }),
  }

  if (previousPhase) {
    queryObj.previousPhase = JSON.stringify({
      phaseName: previousPhase.getPhaseName(),
      phaseOccurrenceTime: previousPhase.getPhaseOccurrenceTime(),
      phaseSum: previousPhase.getPhaseSum(),
      phaseSumSource: previousPhase.getPhaseSumSource(),
    })
  }

  router.push({
    path: '/updatePhase',
    query: queryObj,
  })
}

const onManageReports = (phase) => {
  router.push({
    path: '/reportList',
    query: {
      eventId: eventId.value,
      eventName: eventName.value,
      phaseId: phase.id,
      phaseName: phase.getPhaseName(),
      phaseTime: phase.getPhaseOccurrenceTime(),
    },
  })
}

const onDeletePhase = (phase) => {
  ElMessageBox.confirm(`确定要删除阶段"${phase.getPhaseName()}"吗？`, '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(async () => {
      try {
        const response = await phaseService.deletePhase(phase.id)

        if (response.flag) {
          ElMessage.success(response.message || '阶段删除成功')
          // 重新加载阶段数据
          await loadPhaseData(eventId.value)
        } else {
          ElMessage.error(response.message || '阶段删除失败')
        }
      } catch (error) {
        console.error('Delete phase error:', error)
        ElMessage.error('阶段删除失败：' + (error.message || '未知错误'))
      }
    })
    .catch(() => {
      // 用户取消删除，不做任何操作
    })
}
</script>

<style scoped>
.phase-list-container {
  margin: 20px;
}

.main-header {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.main-header h2 {
  margin: 0;
  color: #303133;
}

.project-info {
  display: flex;
  gap: 20px;
  color: #606266;
  font-size: 14px;
  flex-wrap: wrap;
}

.phase-list {
  margin-top: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px;
  width: 100%;
  box-sizing: border-box;
}

.header-left {
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
  padding-right: 20px;
}

.header-left h3 {
  display: flex;
  align-items: center;
  margin: 0;
  color: #303133;
  font-size: 14px;
  font-weight: bold;
  text-align: left;
}

.header-actions {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-left: 16px;
}

.header-actions :deep(.el-button) {
  padding: 8px;
  font-size: 14px;
}

.card-content {
  color: #606266;
  font-size: 13px;
  padding: 0 10px;
  width: 100%;
  box-sizing: border-box;
}

.phase-info {
  padding-left: 0;
  width: 100%;
  box-sizing: border-box;
}

.phase-info p {
  margin: 0 0 8px 0;
  width: 100%;
  line-height: 1.4;
  word-wrap: break-word;
  text-align: left;
}

.source {
  color: #909399;
  font-size: 12px;
  font-style: italic;
  word-break: break-all;
  width: 100%;
  margin-top: 4px;
  text-align: left;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.header-content h2 {
  margin: 0;
}

.timeline-card {
  width: 60%;
  margin-left: 10px;
  border: none;
  min-width: 400px;
}

.timeline-card :deep(.el-card__header) {
  padding: 10px;
  border-bottom: none;
}

.timeline-card :deep(.el-card__body) {
  padding: 0 10px 10px 10px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px;
  width: 100%;
  box-sizing: border-box;
}

.header-left {
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
  padding-right: 20px;
}

.header-left h3 {
  display: flex;
  align-items: center;
  margin: 0;
  color: #303133;
  font-size: 14px;
  font-weight: bold;
  text-align: left;
}

.card-content {
  color: #606266;
  font-size: 13px;
  padding: 0 10px;
  width: 100%;
  box-sizing: border-box;
}

.phase-info {
  padding-left: 0;
  width: 100%;
  box-sizing: border-box;
}

.phase-info p {
  margin: 0 0 8px 0;
  width: 100%;
  line-height: 1.4;
  word-wrap: break-word;
  text-align: left;
}

.source {
  color: #909399;
  font-size: 12px;
  font-style: italic;
  word-break: break-all;
  width: 100%;
  margin-top: 4px;
  text-align: left;
}

.card-header h3 {
  cursor: pointer;
}

.card-header h3:hover {
  color: #409eff;
}

.phase-id {
  margin-left: 8px;
  font-size: 12px;
  color: #909399;
  font-weight: normal;
}
</style>
