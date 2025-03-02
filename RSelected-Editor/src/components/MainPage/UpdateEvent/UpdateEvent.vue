<template>
  <el-card class="create-event">
    <div class="event-content">
      <!-- 左侧预览区域 -->
      <div class="preview-section">
        <!-- 手机外壳 -->
        <div class="phone-container">
          <!-- 手机顶部状态栏 -->
          <div class="phone-header">
            <div class="notch">
              <div class="notch-container">
                <div class="camera"></div>
                <div class="speaker"></div>
                <div class="sensor"></div>
              </div>
            </div>
            <div class="status-bar">
              <div class="time">12:00</div>
              <div class="right-items">
                <div class="signal">●●●●</div>
                <div class="wifi">◐</div>
                <div class="battery">98%</div>
              </div>
            </div>
          </div>

          <!-- 网页内容区域 -->
          <div class="webpage-container">
            <!-- 网页头部 -->
            <div class="webpage-header">
              <div class="site-title">R Selected</div>
              <div class="title-underline"></div>
              <div class="nav-menu">
                <div class="main-nav text-center">WORLD</div>
                <div class="event-title text-center">最新事件</div>
                <div class="sub-regions text-center">
                  <span>回到中国</span>
                  <span>亚洲</span>
                  <span>美洲</span>
                  <span>欧洲</span>
                  <span>中东</span>
                </div>
              </div>
              <div class="nav-underline"></div>
            </div>

            <!-- 原有的预览内容 -->
            <div class="preview-content">
              <div class="preview-image-box">
                <div v-if="previewUrl" class="preview-image">
                  <img :src="previewUrl" alt="预览图片" />
                  <!-- <div class="image-credits">
                    <div class="credits-row">
                      <span v-if="eventForm.eventImagePhotographer"
                        >w {{ eventForm.eventImagePhotographer }}</span
                      >
                      <span v-if="eventForm.eventImageMedia"
                        >via {{ eventForm.eventImageMedia }}</span
                      >
                    </div>
                  </div> -->
                </div>
                <div v-else class="preview-image-placeholder">
                  <el-icon :size="32"><Picture /></el-icon>
                  <span>暂无图片</span>
                </div>
              </div>

              <div class="preview-tags">
                <span class="tag" v-if="eventForm.majorRegion">{{ eventForm.majorRegion }}</span>
                <span class="tag" v-if="eventForm.midRegion">{{ eventForm.midRegion }}</span>
                <span class="tag" v-if="eventForm.minorRegion">{{ eventForm.minorRegion }}</span>
                <span class="tag" v-if="eventForm.eventType">{{ eventForm.eventType }}</span>
              </div>

              <div class="preview-event-name">
                {{ eventForm.eventName || '事件名称' }}
              </div>

              <div class="preview-event-description">
                {{ eventForm.eventSum || '事件描述' }}
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧表单区域 -->
      <div class="form-section">
        <el-form ref="formRef" :model="eventForm" label-width="120px">
          <el-form-item label="事件名称">
            <el-input v-model="eventForm.eventName" placeholder="请输入事件名称" />
          </el-form-item>

          <el-form-item label="发生时间">
            <el-date-picker
              v-model="eventForm.occurrenceTime"
              type="datetime"
              placeholder="选择日期和时间"
              format="YYYY-MM-DD HH:mm"
              value-format="YYYY-MM-DD HH:mm"
            />
          </el-form-item>

          <el-form-item label="地区">
            <div class="region-inputs">
              <el-select
                v-model="eventForm.majorRegion"
                placeholder="大区域"
                filterable
                allow-create
                default-first-option
                :reserve-keyword="false"
                @create="handleCreateMajorRegion"
              >
                <el-option v-for="item in majorRegions" :key="item" :label="item" :value="item" />
              </el-select>

              <el-select
                v-model="eventForm.midRegion"
                placeholder="中区域"
                filterable
                allow-create
                default-first-option
                :reserve-keyword="false"
                @create="handleCreateMidRegion"
              >
                <el-option v-for="item in midRegions" :key="item" :label="item" :value="item" />
              </el-select>

              <el-select
                v-model="eventForm.minorRegion"
                placeholder="小区域"
                filterable
                allow-create
                default-first-option
                :reserve-keyword="false"
                @create="handleCreateMinorRegion"
              >
                <el-option v-for="item in minorRegions" :key="item" :label="item" :value="item" />
              </el-select>
            </div>
          </el-form-item>

          <el-form-item label="事件类型">
            <el-select
              v-model="eventForm.eventType"
              placeholder="选择事件类型"
              filterable
              allow-create
              default-first-option
              :reserve-keyword="false"
              @create="handleCreateEventType"
            >
              <el-option v-for="item in eventTypes" :key="item" :label="item" :value="item" />
            </el-select>
          </el-form-item>

          <el-form-item label="事件概要">
            <el-input
              v-model="eventForm.eventSum"
              type="textarea"
              :rows="4"
              placeholder="请输入事件概要"
            />
          </el-form-item>

          <el-form-item label="概要来源">
            <el-input v-model="eventForm.eventSumSource" placeholder="请输入概要来源" />
          </el-form-item>

          <el-form-item label="事件图片">
            <div class="image-upload-section">
              <el-radio-group v-model="imageInputType" class="mb-10">
                <el-radio label="upload">本地上传</el-radio>
                <el-radio label="url">图片链接</el-radio>
              </el-radio-group>

              <div v-if="imageInputType === 'upload'" class="upload-area">
                <el-upload
                  class="event-uploader"
                  action="#"
                  :auto-upload="false"
                  :on-change="handleImageChange"
                >
                  <el-button type="primary">选择图片</el-button>
                </el-upload>
              </div>

              <div v-else class="url-area">
                <el-input
                  v-model="eventForm.imageUrl"
                  placeholder="请输入图片URL"
                  @input="handleUrlInput"
                />
              </div>
            </div>
          </el-form-item>

          <el-form-item label="图片信息">
            <div class="image-info-section">
              <el-input
                v-model="eventForm.eventImagePhotographer"
                placeholder="摄影师"
                class="photographer-input"
              />
              <el-input
                v-model="eventForm.eventImageMedia"
                placeholder="图片来源"
                class="media-input"
              />
            </div>
          </el-form-item>

          <el-form-item label="侧边栏备注">
            <el-input
              v-model="eventForm.sidebarComment"
              type="textarea"
              :rows="3"
              placeholder="请输入侧边栏备注"
            />
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

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Picture } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { eventService } from '@/services/eventService'

const route = useRoute()
const router = useRouter()
const eventId = ref('')

onMounted(async () => {
  eventId.value = route.query.eventId
  if (eventId.value) {
    await loadEventData(eventId.value)
  }
})

// 加载事件数据的函数
const loadEventData = async (id) => {
  try {
    const response = await eventService.getEventDetail(id)
    if (response.flag) {
      const eventData = response.data

      // 将后端返回的数据填充到表单中
      eventForm.value = {
        eventName: eventData.eventName || '',
        occurrenceTime: eventData.occurrenceTime
          ? new Date(eventData.occurrenceTime).toISOString().slice(0, 16)
          : '',
        majorRegion: eventData.majorRegion || '',
        midRegion: eventData.midRegion || '',
        minorRegion: eventData.minorRegion || '',
        eventType: eventData.eventType || '',
        eventSum: eventData.eventSum || '',
        eventSumSource: eventData.eventSumSource || '',
        imageUrl: eventData.eventImage || '',
        eventImagePhotographer: eventData.eventImagePhotographer || '',
        eventImageMedia: eventData.eventImageMedia || '',
        sidebarComment: eventData.sidebarComment || '',
      }

      // 如果有图片URL，更新预览和图片输入类型
      if (eventData.eventImage) {
        previewUrl.value = eventData.eventImage
        imageInputType.value = 'url' // 默认使用URL模式
      }
    } else {
      ElMessage.error(response.message || '获取事件数据失败')
    }
  } catch (error) {
    console.error('Failed to load event data:', error)
    ElMessage.error('获取事件数据失败：' + (error.message || '未知错误'))
  }
}

const formRef = ref(null)
const imageInputType = ref('upload')
const previewUrl = ref('')

const eventForm = ref({
  eventName: '',
  occurrenceTime: '',
  majorRegion: '',
  midRegion: '',
  minorRegion: '',
  eventType: '',
  eventSum: '',
  eventSumSource: '',
  imageUrl: '',
  eventImage: null,
  eventImagePhotographer: '',
  eventImageMedia: '',
  sidebarComment: '',
})

const handleImageChange = (file) => {
  if (file.size > 5 * 1024 * 1024) {
    // 5MB限制
    ElMessage.error('图片大小不能超过5MB')
    return
  }

  eventForm.value.eventImage = file.raw
  const url = URL.createObjectURL(file.raw)
  if (url.length > 500) {
    ElMessage.error('生成的图片URL过长，请使用其他图片或直接输入URL')
    return
  }
  previewUrl.value = url
  eventForm.value.imageUrl = ''
}

const handleUrlInput = (value) => {
  if (value && value.length > 500) {
    ElMessage.warning('图片URL过长，可能无法保存')
  }
  eventForm.value.imageUrl = value
  previewUrl.value = value
}

const submitForm = async () => {
  try {
    // 表单验证
    await formRef.value.validate()

    // 准备提交的数据
    const submitData = {
      ...eventForm.value,
    }

    // 处理图片URL
    if (imageInputType.value === 'url') {
      submitData.eventImage = eventForm.value.imageUrl
    } else if (previewUrl.value) {
      submitData.eventImage = previewUrl.value
    }

    // 确保图片URL不会太长
    if (submitData.eventImage && submitData.eventImage.length > 500) {
      ElMessage.error('图片URL过长，请使用短链接')
      return
    }

    // 调用服务更新事件
    const response = await eventService.updateEvent(eventId.value, submitData)

    if (response.flag) {
      ElMessage.success(response.message || '事件更新成功')
      // 更新成功后返回事件列表页面
      router.push('/eventList')
    } else {
      ElMessage.error(response.message || '事件更新失败')
    }
  } catch (error) {
    console.error('Update event error:', error)
    ElMessage.error('事件更新失败：' + (error.message || '未知错误'))
  }
}

const resetForm = () => {
  formRef.value?.resetFields()
  previewUrl.value = ''
}

// 定义域选项数组
const majorRegions = ref(['中文社会', '国际'])
const midRegions = ref(['亚洲', '中国', '北美', '中东', '欧洲'])
const minorRegions = ref([])
const eventTypes = ref(['政治', '社会', '经济', '国际纷争'])

// 处理新建选项的方法
const handleCreateMajorRegion = (value) => {
  majorRegions.value.push(value)
}

const handleCreateMidRegion = (value) => {
  midRegions.value.push(value)
}

const handleCreateMinorRegion = (value) => {
  minorRegions.value.push(value)
}

// 添加事件类型的处理方法
const handleCreateEventType = (value) => {
  eventTypes.value.push(value)
}
</script>

<style scoped>
.event-content {
  display: flex;
  gap: 30px;
}

.preview-section {
  width: 380px;
  flex-shrink: 0;
  padding: 20px;
}

.form-section {
  flex: 1;
  max-width: 800px;
}

.phone-container {
  background: #fff;
  border-radius: 50px;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
  border: 12px solid #1a1a1a;
  overflow: hidden;
  position: relative;
  height: 80vh;
}

.phone-header {
  height: 35px;
  background: #000;
  position: relative;
}

.notch {
  position: absolute;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 160px;
  height: 30px;
  background: #000;
  border-bottom-left-radius: 24px;
  border-bottom-right-radius: 24px;
  overflow: hidden;
}

.notch-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  padding: 0 12px;
  gap: 8px;
}

.camera {
  width: 12px;
  height: 12px;
  background: #1a1a1a;
  border-radius: 50%;
  margin-right: 8px;
}

.speaker {
  width: 40px;
  height: 4px;
  background: #1a1a1a;
  border-radius: 2px;
}

.sensor {
  width: 12px;
  height: 12px;
  background: #1a1a1a;
  border-radius: 50%;
  margin-left: 8px;
}

.status-bar {
  display: flex;
  justify-content: space-between;
  color: white;
  font-size: 12px;
  padding: 6px 20px;
}

.right-items {
  display: flex;
  gap: 8px;
}

.webpage-container {
  height: calc(100% - 35px);
  overflow-y: auto;
}

.webpage-header {
  padding: 15px;
  background: #fff;
}

.site-title {
  font-size: 20px;
  font-weight: bold;
  text-align: center;
  margin-bottom: 5px;
  font-family: serif;
}

.title-underline,
.nav-underline {
  height: 1px;
  background: #000;
  margin: 8px auto;
  width: 100%;
}

.nav-menu {
  margin: 15px 0;
}

.main-nav {
  font-size: 14px;
  color: #666;
  margin-bottom: 8px;
}

.event-title {
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 8px;
}

.sub-regions {
  display: flex;
  justify-content: center;
  gap: 12px;
  font-size: 13px;
  color: #666;
  margin-bottom: 8px;
}

.preview-content {
  padding: 0 15px;
}

.preview-image-box {
  width: 100%;
  height: 210px;
  margin-bottom: 15px;
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

.image-credits {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 8px 12px;
  background: rgba(0, 0, 0, 0.6);
}

.credits-row {
  display: flex;
  gap: 8px;
  color: white;
  font-size: 12px;
}

.credits-row span {
  color: #fff;
  opacity: 0.9;
}

.preview-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin: 12px 0;
}

.tag {
  display: inline-block;
  padding: 2px 8px;
  background-color: #f0f0f0;
  border-radius: 2px;
  font-size: 12px;
  color: #666;
}

.preview-event-name {
  font-size: 24px;
  font-weight: bold;
  color: #333;
  margin: 16px 0;
  line-height: 1.3;
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
}

.preview-event-description {
  font-size: 14px;
  line-height: 1.6;
  color: #666;
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
}

.webpage-container::-webkit-scrollbar {
  width: 4px;
}

.webpage-container::-webkit-scrollbar-thumb {
  background-color: #ddd;
  border-radius: 2px;
}

.webpage-container::-webkit-scrollbar-track {
  background-color: transparent;
}

.image-related-inputs {
  display: flex;
  gap: 20px;
}

.image-upload-section {
  width: 100%;
}

.image-info-section {
  display: flex;
  gap: 12px;
}

.photographer-input,
.media-input {
  flex: 1;
}

.region-inputs {
  display: flex;
  gap: 12px;
  width: 100%;
}

.region-inputs :deep(.el-select) {
  width: 180px;
}

.mb-10 {
  margin-bottom: 10px;
}

.upload-area,
.url-area {
  margin-top: 8px;
}

:deep(.el-select) {
  width: 180px;
}

:deep(.el-select .el-input__wrapper) {
  width: 100%;
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

/* 自定义输入选项的样式 */
:deep(.el-select__input) {
  margin: 0;
}

.text-center {
  text-align: center;
}
</style>
