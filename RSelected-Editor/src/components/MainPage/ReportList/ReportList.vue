<template>
  <el-card class="report-list-container">
    <template #header>
      <div class="main-header">
        <div class="header-content">
          <h2>报道管理</h2>
          <el-button type="primary" @click="onCreateReport">新建报道</el-button>
        </div>
        <div class="phase-info">
          <span>事件名称：{{ eventName }}</span>
          <span>阶段ID：{{ phaseId }}</span>
          <span>阶段名称：{{ phaseName }}</span>
          <span>阶段发生时间：{{ phaseTime }}</span>
        </div>
      </div>
    </template>

    <!-- 搜索表单 -->
    <el-form :inline="true" :model="searchForm" class="search-form">
      <el-form-item label="报道标题">
        <el-input
          v-model="searchForm.reportTitle"
          placeholder="请输入报道标题"
          clearable
          style="width: 110px"
        />
      </el-form-item>
      <el-form-item label="报道媒体">
        <el-input
          v-model="searchForm.reportMedia"
          placeholder="请输入报道媒体"
          clearable
          style="width: 100px"
        />
      </el-form-item>
      <el-form-item label="媒体分类1">
        <el-select
          v-model="searchForm.mediaCategory1"
          placeholder="请选择"
          clearable
          style="width: 110px"
        >
          <el-option label="中央媒体" value="central" />
          <el-option label="地方媒体" value="local" />
          <el-option label="商业媒体" value="commercial" />
        </el-select>
      </el-form-item>
      <el-form-item label="媒体分类2">
        <el-select
          v-model="searchForm.mediaCategory2"
          placeholder="请选择"
          clearable
          style="width: 110px"
        >
          <el-option label="官方媒体" value="official" />
          <el-option label="市场化媒体" value="market" />
        </el-select>
      </el-form-item>
      <el-form-item label="媒体分类3">
        <el-select
          v-model="searchForm.mediaCategory3"
          placeholder="请选择"
          clearable
          style="width: 110px"
        >
          <el-option label="传统媒体" value="traditional" />
          <el-option label="新媒体" value="new" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSearch">搜索</el-button>
        <el-button @click="resetSearch">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 表格 -->
    <el-table
      :data="tableData"
      v-loading="loading"
      style="width: 100%"
      border
      :header-cell-style="{ background: '#f5f7fa' }"
      stripe
    >
      <el-table-column prop="reportId" label="报道ID" width="66" />
      <el-table-column prop="title" label="报道标题" min-width="300" show-overflow-tooltip />
      <el-table-column prop="issuedDate" label="报道发布时间" width="160" sortable>
        <template #default="scope">
          {{
            new Date(scope.row.issuedDate).toLocaleString('zh-CN', {
              year: 'numeric',
              month: '2-digit',
              day: '2-digit',
              hour: '2-digit',
              minute: '2-digit',
            })
          }}
        </template>
      </el-table-column>
      <el-table-column prop="mediaName" label="报道媒体" width="100" />
      <el-table-column prop="firstClass" label="媒体分类1">
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
      <el-table-column label="操作" width="150" fixed="right">
        <template #default="scope">
          <el-button
            type="primary"
            :icon="Edit"
            circle
            @click="onEditReport(scope.row)"
            title="编辑报道"
          />
          <el-button
            type="danger"
            :icon="Delete"
            circle
            @click="onDeleteReport(scope.row)"
            title="删除报道"
          />
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div class="pagination">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 30, 50]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>
  </el-card>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Edit, Delete } from '@element-plus/icons-vue'
import { ElMessageBox, ElMessage } from 'element-plus'
import { reportsService } from '@/services/reportsService'
import { useReportStore } from '@/stores/reportStore'
import { storeToRefs } from 'pinia'

const route = useRoute()
const router = useRouter()
const reportStore = useReportStore()
const { reportList, loading } = storeToRefs(reportStore)

const eventName = ref('')
const eventId = ref('')
const phaseName = ref('')
const phaseId = ref('')
const phaseTime = ref('')

// 搜索表单
const searchForm = ref({
  reportTitle: '',
  reportMedia: '',
  mediaCategory1: '',
  mediaCategory2: '',
  mediaCategory3: '',
})

// 分页相关
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

onMounted(() => {
  // 获取路由参数
  eventName.value = String(route.query.eventName || '')
  eventId.value = String(route.query.eventId || '')
  phaseName.value = String(route.query.phaseName || '')
  phaseId.value = String(route.query.phaseId || '')
  phaseTime.value = String(route.query.phaseTime || '')

  console.log('ReportList mounted with:', {
    eventName: eventName.value,
    eventId: eventId.value,
    phaseName: phaseName.value,
    phaseId: phaseId.value,
    phaseTime: phaseTime.value,
  })

  // 如果有 phaseId，则加载数据
  if (phaseId.value) {
    loadReportList()
  }
})

const loadReportList = async () => {
  try {
    const response = await reportsService.getReportsByPhaseId(phaseId.value)
    if (response.flag) {
      if (Array.isArray(response.data)) {
        reportList.value = response.data
        total.value = response.data.length
        console.log('Loaded reports:', reportList.value)
      } else {
        reportList.value = []
        total.value = 0
        ElMessage.info('没有找到相关报道')
      }
    } else {
      ElMessage.error(response.message || '获取数据失败')
    }
  } catch (error) {
    console.error('Failed to load reports:', error)
    ElMessage.error('获取报道列表失败：' + error.message)
  }
}

// 搜索相关方法
const onSearch = () => {
  console.log('Search form:', searchForm.value)
}

const resetSearch = () => {
  searchForm.value = {
    reportTitle: '',
    reportMedia: '',
    mediaCategory1: '',
    mediaCategory2: '',
    mediaCategory3: '',
  }
}

// 新建报道
const onCreateReport = () => {
  router.push({
    path: '/updateReport',
    query: {
      mode: 'create',
      eventName: eventName.value,
      eventId: eventId.value,
      phaseName: phaseName.value,
      phaseId: phaseId.value,
      phaseTime: phaseTime.value,
    },
  })
}

// 编辑报道
const onEditReport = (row) => {
  console.log('Editing report with data:', row)
  router.push({
    path: '/updateReport',
    query: {
      mode: 'update',
      eventName: eventName.value,
      eventId: eventId.value,
      phaseName: phaseName.value,
      phaseId: phaseId.value,
      phaseTime: phaseTime.value,
      reportId: row.reportId,
    },
  })
}

// 删除报道
const onDeleteReport = (row) => {
  ElMessageBox.confirm(`确定要删除报道"${row.title}"吗？`, '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(async () => {
      try {
        console.log('Deleting report:', row)
        const response = await reportsService.deleteReport(row.reportId)
        if (response.flag) {
          ElMessage.success('删除成功')
          loadReportList()
        } else {
          ElMessage.error(response.data || '删除失败')
        }
      } catch (error) {
        console.error('Delete report failed:', error)
        ElMessage.error('删除失败：' + error.message)
      }
    })
    .catch(() => {
      // 用户点击取消，不做任何操作
    })
}

// 分页方法
const handleSizeChange = (val: number) => {
  pageSize.value = val
  // 重新加载数据
}

const handleCurrentChange = (val: number) => {
  currentPage.value = val
  // 重新加载数据
}

// 媒体分类映射函数
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

// 修改表格数据源
const tableData = computed(() => {
  if (!reportList.value) return []
  return reportList.value.map((report) => ({
    ...report,
    firstClassText: getMediaFirstClass(report.firstClass),
    secondClassText: getMediaSecondClass(report.secondClass),
    thirdClassText: getMediaThirdClass(report.thirdClass),
  }))
})
</script>

<style scoped>
.report-list-container {
  margin: 20px;
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
}

.phase-info {
  display: flex;
  gap: 20px;
  color: #606266;
  font-size: 14px;
}

.search-form {
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

/* 最后一个form-item（按钮组）的margin调整 */
:deep(.el-form-item:last-child) {
  margin-right: 0;
  margin-left: auto;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
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
</style>
