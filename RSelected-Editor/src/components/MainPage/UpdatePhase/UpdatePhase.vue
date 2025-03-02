<template>
  <el-card class="create-event">
    <template #header>
      <div class="card-header">
        <div class="header-content">
          <span class="header-text">{{ mode === 'create' ? '添加新阶段' : '修改阶段' }}</span>
          <span class="event-id">事件ID：{{ eventId }}</span>
        </div>
      </div>
    </template>

    <div class="event-content">
      <!-- 左侧预览区域 -->
      <div class="preview-section">
        <h3 class="preview-title">预览效果</h3>
        <el-timeline>
          <el-timeline-item
            v-if="previousPhase.phaseName"
            :timestamp="previousPhase.phaseOccurrenceTime"
            placement="top"
          >
            <el-card shadow="never" class="timeline-card">
              <template #header>
                <div class="card-header">
                  <h3>{{ previousPhase.phaseName }}</h3>
                  <div class="time-range">{{ previousPhase.phaseOccurrenceTime }}</div>
                </div>
              </template>
              <div class="card-content">
                <p>{{ previousPhase.phaseSum }}</p>
                <div class="source">来源：{{ previousPhase.phaseSumSource }}</div>
              </div>
            </el-card>
          </el-timeline-item>

          <el-timeline-item
            :timestamp="phaseForm.phaseOccurrenceTime || '未设置时间'"
            placement="top"
            type="primary"
          >
            <el-card shadow="never" class="timeline-card">
              <template #header>
                <div class="card-header">
                  <h3>{{ phaseForm.phaseName || '未设置名称' }}</h3>
                  <div class="time-range">{{ phaseForm.phaseOccurrenceTime || '未设置时间' }}</div>
                </div>
              </template>
              <div class="card-content">
                <p>{{ phaseForm.phaseSum || '未设置概要' }}</p>
                <div class="source">来源：{{ phaseForm.phaseSumSource || '未设置来源' }}</div>
              </div>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </div>

      <!-- 右侧表单区域 -->
      <div class="form-section">
        <el-form ref="formRef" :model="phaseForm" label-width="100px">
          <el-form-item label="阶段名称">
            <el-input v-model="phaseForm.phaseName" placeholder="请输入阶段名称" />
          </el-form-item>

          <el-form-item label="发生时间">
            <el-date-picker
              v-model="phaseForm.phaseOccurrenceTime"
              type="datetime"
              placeholder="选择日期和时间"
              format="YYYY-MM-DD HH:mm:ss"
              value-format="YYYY-MM-DD HH:mm:ss"
              :default-time="new Date(2000, 1, 1, 0, 0, 0)"
            />
          </el-form-item>

          <el-form-item label="阶段概要">
            <el-input
              v-model="phaseForm.phaseSum"
              type="textarea"
              :rows="4"
              placeholder="请输入阶段概要"
            />
          </el-form-item>

          <el-form-item label="概要来源">
            <el-input v-model="phaseForm.phaseSumSource" placeholder="请输入概要来源" />
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="submitForm">提交</el-button>
            <el-button @click="resetForm">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>
  </el-card>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { phaseService } from '@/services/phaseService'

const route = useRoute()
const router = useRouter()
const mode = ref('create')
const formRef = ref(null)
const eventId = ref('')

// 表单数据
const phaseForm = ref({
  phaseName: '',
  phaseOccurrenceTime: '',
  phaseSum: '',
  phaseSumSource: '',
})

// 上一个阶段的数据
const previousPhase = ref({
  phaseName: '',
  phaseOccurrenceTime: '',
  phaseSum: '',
  phaseSumSource: '',
})

onMounted(() => {
  try {
    // 获取路由中的 mode 参数
    mode.value = String(route.query.mode || 'create')
    eventId.value = String(route.query.eventId || '')

    const previousPhaseStr = String(route.query.previousPhase || '{}')
    const previousPhaseData = JSON.parse(previousPhaseStr)

    console.log('Previous Phase Data:', previousPhaseData) // 调试用

    // 设置上一个阶段的数据
    if (previousPhaseData && Object.keys(previousPhaseData).length > 0) {
      previousPhase.value = {
        phaseName: previousPhaseData.phaseName || '',
        phaseOccurrenceTime: previousPhaseData.phaseOccurrenceTime || '',
        phaseSum: previousPhaseData.phaseSum || '',
        phaseSumSource: previousPhaseData.phaseSumSource || '',
      }
    }

    // 如果是更新模式，填充表单数据
    if (mode.value === 'update') {
      const phaseStr = String(route.query.phase || '{}')
      const phaseData = JSON.parse(phaseStr)

      console.log('Phase Data:', phaseData) // 调试用

      if (phaseData && Object.keys(phaseData).length > 0) {
        phaseForm.value = {
          phaseName: phaseData.phaseName || '',
          phaseOccurrenceTime: phaseData.phaseOccurrenceTime || '',
          phaseSum: phaseData.phaseSum || '',
          phaseSumSource: phaseData.phaseSumSource || '',
        }
      }
    }

    console.log('Component mounted with eventId:', eventId.value)
  } catch (error) {
    console.error('Error parsing phase data:', error)
  }
})

const submitForm = async () => {
  if (!formRef.value) return

  try {
    // 表单验证
    await formRef.value.validate()

    if (mode.value === 'create') {
      // 准备提交数据
      const submitData = {
        eventId: eventId.value,
        phaseName: phaseForm.value.phaseName,
        phaseOccurrenceTime: phaseForm.value.phaseOccurrenceTime,
        phaseSum: phaseForm.value.phaseSum,
        phaseSumSource: phaseForm.value.phaseSumSource,
      }

      // 确保日期格式正确
      if (submitData.phaseOccurrenceTime) {
        // 确保时间包含秒数
        if (!submitData.phaseOccurrenceTime.includes(':ss')) {
          submitData.phaseOccurrenceTime += ':00'
        }
      }

      // 调用服务插入新阶段
      const response = await phaseService.insertPhase(submitData)

      if (response.flag) {
        ElMessage.success(response.message || '阶段创建成功')
        // 返回阶段列表页面
        router.push({
          path: '/phaseList',
          query: {
            eventId: eventId.value,
          },
        })
      } else {
        ElMessage.error(response.message || '阶段创建失败')
      }
    } else if (mode.value === 'update') {
      // 准备更新数据
      const phaseStr = String(route.query.phase || '{}')
      const phaseData = JSON.parse(phaseStr)

      // 添加调试日志
      console.log('Phase Data from route:', phaseData)

      // 确保从路由参数中正确获取 phaseId
      const phaseId = phaseData.phaseId || route.query.phaseId

      // 将日期字符串转换为 Date 对象
      const occurrenceTime = phaseForm.value.phaseOccurrenceTime
        ? new Date(phaseForm.value.phaseOccurrenceTime)
        : null

      const updateData = {
        phaseId: Number(phaseId), // 确保 phaseId 是数字类型
        phaseName: phaseForm.value.phaseName,
        phaseOccurrenceTime: occurrenceTime,
        phaseSum: phaseForm.value.phaseSum,
        phaseSumSource: phaseForm.value.phaseSumSource,
      }

      // 添加调试日志
      console.log('Update Data:', updateData)

      // 调用服务更新阶段
      const response = await phaseService.updatePhase(updateData)

      if (response.flag) {
        ElMessage.success(response.message || '阶段更新成功')

        // 添加调试日志
        console.log('Current route query:', route.query)
        console.log('EventId:', eventId.value)

        // 返回阶段列表页面，确保使用正确的事件ID
        router.push({
          path: '/phaseList',
          query: {
            eventId: route.query.eventId || eventId.value, // 优先使用路由参数中的事件ID
            eventName: route.query.eventName,
            eventStartDate: route.query.eventStartDate,
          },
        })
      } else {
        ElMessage.error(response.message || '阶段更新失败')
      }
    }
  } catch (error) {
    console.error('Submit form error:', error)
    ElMessage.error('提交失败：' + (error.message || '未知错误'))
  }
}

const resetForm = () => {
  formRef.value?.resetFields()
}
</script>

<style scoped>
.create-event {
  margin: 20px;
  height: calc(90vh - 120px);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-text {
  font-size: 18px;
  font-weight: bold;
  color: #303133;
}

.event-content {
  display: flex;
  gap: 30px;
  height: 100%;
  padding-top: 20px;
}

/* 左侧预览区域样式 */
.preview-section {
  flex: 0.8;
  border-right: 1px solid #ebeef5;
  padding-right: 20px;
  max-width: 45%;
  overflow-y: auto;
}

.preview-title {
  margin: 0 0 20px 0;
  color: #909399;
  font-size: 14px;
}

/* 右侧表单区域样式 */
.form-section {
  flex: 1.2;
  max-width: 55%;
  padding-left: 20px;
  overflow-y: auto;
}

/* Timeline 卡片样式 */
.timeline-card {
  width: 280px;
  margin-left: 10px;
  border: none;
}

.timeline-card :deep(.el-card__header) {
  padding: 10px;
  border-bottom: none;
}

.timeline-card :deep(.el-card__body) {
  padding: 0 10px 10px 10px;
}

.card-header h3 {
  margin: 0;
  color: #303133;
  font-size: 14px;
  font-weight: bold;
}

.time-range {
  color: #909399;
  font-size: 12px;
}

.card-content {
  color: #606266;
  font-size: 13px;
}

.card-content p {
  margin: 0 0 8px 0;
}

.source {
  color: #909399;
  font-size: 12px;
  font-style: italic;
}

.header-content {
  display: flex;
  align-items: center;
  gap: 12px;
}

.event-id {
  font-size: 13px;
  color: #909399;
  font-weight: normal;
}
</style>
