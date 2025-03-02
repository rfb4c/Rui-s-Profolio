<template>
  <el-card class="create-report">
    <template #header>
      <div class="card-header">
        <div class="header-main">
          <span class="header-text">{{ mode === 'create' ? '添加新报道' : '修改报道' }}</span>
        </div>
        <div class="header-info">
          <span class="info-item">事件名称：{{ eventName }}</span>
          <span class="info-item">（ID：{{ eventId }}）</span>
          <span class="info-divider">|</span>
          <span class="info-item">阶段名称：{{ phaseName }}</span>
          <span class="info-item">（ID：{{ phaseId }}）</span>
          <span class="info-divider">|</span>
          <span class="info-item">阶段发生时间：{{ phaseTime }}</span>
        </div>
      </div>
    </template>

    <div class="report-content">
      <!-- 左侧预览区域 -->
      <div class="preview-section">
        <div class="preview-container">
          <div class="preview-image-box">
            <div v-if="previewUrl" class="preview-image">
              <img :src="previewUrl" alt="预览图片" />
            </div>
            <div v-else class="preview-image-placeholder">
              <el-icon :size="32"><Picture /></el-icon>
              <span>暂无图片</span>
            </div>
          </div>

          <div class="preview-info">
            <h3 class="preview-title">{{ reportForm.title || '报道标题' }}</h3>
            <div class="preview-summary">{{ reportForm.summary || '报道摘要' }}</div>
            <div class="preview-meta">
              <span>{{ reportForm.mediaName }}</span>
              <span v-if="reportForm.issuedDate">{{ reportForm.issuedDate }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧表单区域 -->
      <div class="form-section">
        <el-form ref="formRef" :model="reportForm" label-width="100px">
          <el-form-item label="报道标题">
            <el-input v-model="reportForm.title" placeholder="请输入报道标题" />
          </el-form-item>

          <el-form-item label="报道摘要">
            <el-input
              v-model="reportForm.summary"
              type="textarea"
              :rows="4"
              placeholder="请输入报道摘要"
            />
          </el-form-item>

          <!-- 媒体信息一行显示 -->
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="媒体名称">
                <el-input v-model="reportForm.mediaName" placeholder="请输入媒体名称" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="媒体代码">
                <div class="media-code-input">
                  <el-input v-model="reportForm.mediaCode" placeholder="请输入媒体代码" />
                  <el-button type="primary" @click="showMediaCodeDialog">
                    <el-icon><Search /></el-icon>
                    查询
                  </el-button>
                </div>
              </el-form-item>
            </el-col>
          </el-row>

          <!-- 媒体分类 -->
          <el-row :gutter="20">
            <el-col :span="8">
              <el-form-item label="媒体分类1">
                <el-select v-model="reportForm.mediaCategory1" placeholder="请选择" clearable>
                  <el-option
                    v-for="item in mediaCategory1Options"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="媒体分类2">
                <el-select v-model="reportForm.mediaCategory2" placeholder="请选择" clearable>
                  <el-option
                    v-for="item in mediaCategory2Options"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="媒体分类3">
                <el-select v-model="reportForm.mediaCategory3" placeholder="请选择" clearable>
                  <el-option
                    v-for="item in mediaCategory3Options"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>

          <el-form-item label="报道发布时间">
            <el-date-picker
              v-model="reportForm.issuedDate"
              type="datetime"
              placeholder="选择报道发布时间"
              format="YYYY-MM-DD HH:mm"
              value-format="YYYY-MM-DD HH:mm"
            />
          </el-form-item>

          <el-form-item label="报道链接">
            <el-input v-model="reportForm.url" placeholder="请输入报道链接" />
          </el-form-item>

          <el-form-item label="报道配图">
            <div class="image-upload-section">
              <el-radio-group v-model="imageInputType" class="mb-10">
                <el-radio label="url">图片链接</el-radio>
                <el-radio label="upload">本地上传</el-radio>
              </el-radio-group>

              <div v-if="imageInputType === 'upload'" class="upload-area">
                <el-upload
                  class="report-uploader"
                  action="#"
                  :auto-upload="false"
                  :on-change="handleImageChange"
                >
                  <el-button type="primary">选择图片</el-button>
                </el-upload>
              </div>

              <div v-else class="url-area">
                <el-input
                  v-model="reportForm.imageUrl"
                  placeholder="请入图片URL"
                  @input="handleUrlInput"
                />
              </div>
            </div>
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="submitForm()" v-if="mode === 'create'">
              添加新报道
            </el-button>
            <el-button type="primary" @click="updateReport()" v-if="mode === 'update'">
              修改报道
            </el-button>
            <el-button @click="resetForm">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>

    <!-- 媒体代码查询对话框 -->
    <el-dialog
      v-model="mediaCodeDialogVisible"
      title="媒体代码查询"
      width="700px"
      :close-on-click-modal="false"
    >
      <div class="media-code-search">
        <el-input
          v-model="mediaSearchKeyword"
          placeholder="请输入媒体名称关键词"
          clearable
          @keyup.enter="searchMediaCode"
        >
          <template #append>
            <el-button @click="searchMediaCode">
              <el-icon><Search /></el-icon>
            </el-button>
          </template>
        </el-input>

        <!-- 搜索结果表格 -->
        <el-table
          v-if="mediaSearchResults.length > 0"
          :data="mediaSearchResults"
          style="width: 100%; margin-top: 20px"
          height="300"
          border
        >
          <el-table-column prop="mediaName" label="媒体名称" width="120" />
          <el-table-column prop="mediaCode" label="媒体代码" width="100" />
          <el-table-column prop="firstClass" label="媒体分类1" width="100">
            <template #default="scope">
              {{ getMediaFirstClass(scope.row.firstClass) }}
            </template>
          </el-table-column>
          <el-table-column prop="secondClass" label="媒体分类2" width="100">
            <template #default="scope">
              {{ getMediaSecondClass(scope.row.secondClass) }}
            </template>
          </el-table-column>
          <el-table-column prop="thirdClass" label="媒体分类3" width="100">
            <template #default="scope">
              {{ getMediaThirdClass(scope.row.thirdClass) }}
            </template>
          </el-table-column>
          <el-table-column label="操作" width="80" fixed="right">
            <template #default="scope">
              <el-button type="primary" link @click="selectMediaCode(scope.row)"> 选择 </el-button>
            </template>
          </el-table-column>
        </el-table>

        <div v-else-if="hasSearched" class="no-result">未找到相关媒体</div>
      </div>
    </el-dialog>
  </el-card>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Picture, Search } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { reportsService } from '@/services/reportsService'

const router = useRouter()
const route = useRoute()
const formRef = ref(null)
const mode = ref('create')
const imageInputType = ref('url')
const previewUrl = ref('')

// 从路由参数获取事件和阶段信息
const eventName = ref('')
const eventId = ref('')
const phaseName = ref('')
const phaseId = ref('')
const phaseTime = ref('')

const reportForm = ref({
  title: '',
  summary: '',
  mediaName: '',
  mediaCode: '',
  mediaCategory1: '',
  mediaCategory2: '',
  mediaCategory3: '',
  issuedDate: '',
  url: '',
  imageUrl: '',
})

// 媒体代码查询相关
const mediaCodeDialogVisible = ref(false)
const mediaSearchKeyword = ref('')
const mediaSearchResults = ref([])
const hasSearched = ref(false)

// 加载报道详情
const loadReportDetail = async (reportId) => {
  try {
    console.log('Loading report detail for ID:', reportId)
    const response = await reportsService.getReportDetail(reportId)
    if (response.flag && response.data) {
      const reportDetail = response.data
      console.log('Original issuedDate from backend:', reportDetail.issuedDate)

      // 填充表单数据
      reportForm.value = {
        title: reportDetail.title || '',
        summary: reportDetail.summary || '',
        mediaName: reportDetail.mediaName || '',
        mediaCode: reportDetail.mediaCode || '',
        mediaCategory1: getMediaFirstClass(reportDetail.firstClass),
        mediaCategory2: getMediaSecondClass(reportDetail.secondClass),
        mediaCategory3: getMediaThirdClass(reportDetail.thirdClass),
        issuedDate: reportDetail.issuedDate ? reportDetail.issuedDate.replace(/\//g, '-') : '',
        url: reportDetail.url || '',
        imageUrl: reportDetail.imageUrl || '',
      }

      console.log('Formatted issuedDate:', reportForm.value.issuedDate)

      // 如果有图片URL，设置预览
      if (reportDetail.imageUrl) {
        previewUrl.value = reportDetail.imageUrl
      }
    } else {
      ElMessage.error('未找到报道数据')
    }
  } catch (error) {
    console.error('Failed to load report detail:', error)
    ElMessage.error('加载报道数据失败：' + error.message)
  }
}

onMounted(() => {
  console.log('UpdateReport mounted with route query:', route.query)

  // 获取路由参数
  mode.value = String(route.query.mode || 'create')
  eventName.value = String(route.query.eventName || '')
  eventId.value = String(route.query.eventId || '')
  phaseName.value = String(route.query.phaseName || '')
  phaseId.value = String(route.query.phaseId || '')
  phaseTime.value = String(route.query.phaseTime || '')

  // 如果是编辑模式，从路由参数中获取 reportId
  if (mode.value === 'update') {
    try {
      // 从路由参数中获取 reportId
      const reportId = route.query.reportId
      if (reportId) {
        console.log('Found reportId:', reportId)
        loadReportDetail(Number(reportId))
      } else {
        console.error('No reportId found in route query')
        ElMessage.error('未找到报道ID')
      }
    } catch (error) {
      console.error('Error parsing report data:', error)
      ElMessage.error('解析报道数据失败')
    }
  }
})

// 修改媒体分类映射函数
const getFirstClassCode = (value) => {
  const map = {
    中文媒体: 1,
    外媒: 2,
  }
  return map[value] || null
}

const getSecondClassCode = (value) => {
  const map = {
    境内官方媒体: 11,
    境内自媒体: 12,
    境外市场化媒体: 13,
    境外自媒体: 14,
  }
  return map[value] || null
}

const getThirdClassCode = (value) => {
  const map = {
    党媒央媒: 111,
    地方市场化媒体: 112,
    权力机关自办媒体: 113,
    境内自媒体: 121,
    '香港、南洋媒体': 131,
    亲似与中共接近的媒体: 132,
    轮媒: 133,
    海外本地中文媒体: 134,
    境外公民媒体: 141,
    轮媒自媒体: 142,
  }
  return map[value] || null
}

const submitForm = async () => {
  try {
    console.log('Submitting form...') // 调试信息

    // 转换媒体分类为数字代码
    const firstClass = getFirstClassCode(reportForm.value.mediaCategory1)
    const secondClass = getSecondClassCode(reportForm.value.mediaCategory2)
    const thirdClass = getThirdClassCode(reportForm.value.mediaCategory3)

    // 格式化日期为 ISO 8601 格式
    const formattedDate = reportForm.value.issuedDate
      ? new Date(reportForm.value.issuedDate).toISOString()
      : null

    // 构建提交的数据对象
    const reportData = {
      title: reportForm.value.title,
      summary: reportForm.value.summary,
      mediaName: reportForm.value.mediaName,
      mediaCode: reportForm.value.mediaCode,
      firstClass: firstClass,
      secondClass: secondClass,
      thirdClass: thirdClass,
      issuedDate: formattedDate,
      url: reportForm.value.url,
      imageUrl: reportForm.value.imageUrl,
      phaseId: phaseId.value,
      eventId: eventId.value,
    }

    console.log('Report data to submit:', reportData) // 调试信息

    const response = await reportsService.insertReport(reportData)
    if (response.flag) {
      ElMessage.success('报道添加成功')
      router.push({
        path: '/reportList',
        query: {
          eventName: eventName.value,
          eventId: eventId.value,
          phaseName: phaseName.value,
          phaseId: phaseId.value,
          phaseTime: phaseTime.value,
        },
      })
    } else {
      ElMessage.error(response.data || '添加失败')
    }
  } catch (error) {
    console.error('Submit report failed:', error)
    ElMessage.error('提交失败：' + error.message)
  }
}

const handleImageChange = (file) => {
  reportForm.value.imageUrl = '' // 清除URL输入
  previewUrl.value = URL.createObjectURL(file.raw)
}

const handleUrlInput = (value) => {
  previewUrl.value = value
}

const resetForm = () => {
  formRef.value?.resetFields()
  previewUrl.value = ''
}

// 显示查询对话框
const showMediaCodeDialog = () => {
  mediaCodeDialogVisible.value = true
  mediaSearchKeyword.value = ''
  mediaSearchResults.value = []
  hasSearched.value = false
}

// 修改显示用的转换函数
const getMediaFirstClass = (value: number) => {
  const map = {
    1: '中文媒体',
    2: '外媒',
  }
  return map[value] || '未分类'
}

const getMediaSecondClass = (value: number) => {
  const map = {
    11: '境内官方媒体',
    12: '境内自媒体',
    13: '境外市场化媒体',
    14: '境外自媒体',
  }
  return map[value] || '未分类'
}

const getMediaThirdClass = (value: number) => {
  const map = {
    111: '党媒央媒',
    112: '地方市场化媒体',
    113: '权力机关自办媒体',
    121: '境内自媒体',
    131: '香港、南洋媒体',
    132: '亲似与中共接近的媒体',
    133: '轮媒',
    134: '海外本地中文媒体',
    141: '境外公民媒体',
    142: '轮媒自媒体',
  }
  return map[value] || '未分类'
}

// 修改搜索媒体代码的方法
const searchMediaCode = async () => {
  if (!mediaSearchKeyword.value) {
    ElMessage.warning('请输入媒体名称关键词')
    return
  }

  try {
    const response = await reportsService.getMediaCodeByName(mediaSearchKeyword.value)
    hasSearched.value = true

    if (response.flag && response.data) {
      // 直接使用返回的完整媒体信息
      mediaSearchResults.value = [
        {
          mediaName: response.data.mediaName,
          mediaCode: response.data.mediaCode,
          firstClass: response.data.firstClass,
          secondClass: response.data.secondClass,
          thirdClass: response.data.thirdClass,
        },
      ]
    } else {
      mediaSearchResults.value = []
      ElMessage.info('未找到相关媒体')
    }
  } catch (error) {
    console.error('Search media code failed:', error)
    ElMessage.error('查询失败：' + error.message)
    mediaSearchResults.value = []
  }
}

// 修改选择媒体代码的方法
const selectMediaCode = (row) => {
  reportForm.value.mediaCode = row.mediaCode
  reportForm.value.mediaName = row.mediaName
  // 使用映射函数获取分类名称
  reportForm.value.mediaCategory1 = getMediaFirstClass(row.firstClass)
  reportForm.value.mediaCategory2 = getMediaSecondClass(row.secondClass)
  reportForm.value.mediaCategory3 = getMediaThirdClass(row.thirdClass)
  mediaCodeDialogVisible.value = false
}

// 同时更新选项数据
const mediaCategory1Options = [
  { label: '中文媒体', value: '中文媒体' },
  { label: '外媒', value: '外媒' },
]

const mediaCategory2Options = [
  { label: '境内官方媒体', value: '境内官方媒体' },
  { label: '境内自媒体', value: '境内自媒体' },
  { label: '境外市场化媒体', value: '境外市场化媒体' },
  { label: '境外自媒体', value: '境外自媒体' },
]

const mediaCategory3Options = [
  { label: '党媒央媒', value: '党媒央媒' },
  { label: '地方市场化媒体', value: '地方市场化媒体' },
  { label: '权力机关自办媒体', value: '权力机关自办媒体' },
  { label: '境内自媒体', value: '境内自媒体' },
  { label: '香港、南洋媒体', value: '香港、南洋媒体' },
  { label: '亲似与中共接近的媒体', value: '亲似与中共接近的媒体' },
  { label: '轮媒', value: '轮媒' },
  { label: '海外本地中文媒体', value: '海外本地中文媒体' },
  { label: '境外公民媒体', value: '境外公民媒体' },
  { label: '轮媒自媒体', value: '轮媒自媒体' },
]

const updateReport = async () => {
  try {
    const reportId = route.query.reportId

    // 转换媒体分类为数字代码
    const firstClass = getFirstClassCode(reportForm.value.mediaCategory1)
    const secondClass = getSecondClassCode(reportForm.value.mediaCategory2)
    const thirdClass = getThirdClassCode(reportForm.value.mediaCategory3)

    // 确保日期格式正确
    const formattedDate = reportForm.value.issuedDate
      ? new Date(reportForm.value.issuedDate).toISOString()
      : null

    const reportData = {
      issuedDate: formattedDate,
      mediaCode: reportForm.value.mediaCode || null,
      mediaName: reportForm.value.mediaName || '',
      title: reportForm.value.title || '',
      imageUrl: reportForm.value.imageUrl || '',
      summary: reportForm.value.summary || '',
      url: reportForm.value.url || '',
      firstClass: firstClass,
      secondClass: secondClass,
      thirdClass: thirdClass,
    }

    // 添加调试日志
    console.log('Updating report with ID:', reportId)
    console.log('Request data:', JSON.stringify(reportData, null, 2))

    const response = await reportsService.updateReport(reportId, reportData)
    if (response.flag) {
      ElMessage.success('报道更新成功')
      router.push({
        path: '/reportList',
        query: {
          eventName: eventName.value,
          eventId: eventId.value,
          phaseName: phaseName.value,
          phaseId: phaseId.value,
          phaseTime: phaseTime.value,
        },
      })
    } else {
      ElMessage.error(response.data || '更新失败')
    }
  } catch (error) {
    console.error('Failed to update report:', error)
    ElMessage.error('更新失败：' + (error.response?.data || error.message))
  }
}
</script>

<style scoped>
.report-content {
  display: flex;
  gap: 20px;
  padding: 0 20px;
}

.preview-section {
  width: 380px;
  flex-shrink: 0;
  padding: 0;
}

.preview-container {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.preview-image-box {
  width: 100%;
  height: 210px;
  position: relative;
}

.preview-image,
.preview-image-placeholder {
  width: 100%;
  height: 100%;
}

.preview-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.preview-image-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #f5f7fa;
  color: #909399;
}

.preview-info {
  padding: 20px;
}

.preview-title {
  font-size: 18px;
  font-weight: bold;
  margin: 0 0 12px 0;
  line-height: 1.4;
}

.preview-summary {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
  margin-bottom: 12px;
}

.preview-meta {
  display: flex;
  justify-content: space-between;
  color: #909399;
  font-size: 12px;
}

.image-upload-section {
  width: 100%;
}

.mb-10 {
  margin-bottom: 10px;
}

.upload-area,
.url-area {
  margin-top: 8px;
}

:deep(.el-upload-list) {
  width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
}

:deep(.el-upload-list__item) {
  overflow: hidden;
  text-overflow: ellipsis;
}

.create-report {
  margin: 20px;
  min-height: calc(90vh - 120px);
}

.card-header {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 0 20px 15px;
}

.header-main {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-text {
  font-size: 18px;
  font-weight: bold;
  color: #303133;
}

.header-info {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #606266;
  font-size: 14px;
  padding-top: 5px;
  border-top: 1px solid #ebeef5;
}

.info-item {
  color: #606266;
  white-space: nowrap;
}

.info-divider {
  color: #dcdfe6;
}

.form-section {
  flex: 1;
  max-width: 600px;
  padding: 0;
}

:deep(.el-select) {
  width: 100%;
}

:deep(.el-form-item) {
  margin-bottom: 18px;
}

:deep(.el-row) {
  margin-bottom: 0;
}

/* 调整表单项标签的样式 */
:deep(.el-form-item__label) {
  font-weight: 500;
  padding-right: 12px;
}

/* 确保选择器和输入框宽度一致 */
:deep(.el-input),
:deep(.el-select),
:deep(.el-date-editor) {
  width: 100%;
}

/* 调整文本域的高度 */
:deep(.el-textarea__inner) {
  min-height: 100px;
}

.media-code-input {
  display: flex;
  gap: 10px;
}

.media-code-input .el-input {
  flex: 1;
}

.media-code-search {
  padding: 10px 0;
}

.no-result {
  text-align: center;
  color: #909399;
  margin-top: 20px;
  font-size: 14px;
}

:deep(.el-dialog__body) {
  padding-top: 10px;
}

/* 确保搜索按钮和输入框对齐 */
.media-code-search .el-input-group__append {
  padding: 0;
}

.media-code-search .el-input-group__append button {
  border: none;
  height: 100%;
  padding: 0 15px;
}
</style>
