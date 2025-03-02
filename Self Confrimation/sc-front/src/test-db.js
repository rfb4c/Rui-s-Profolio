import { testConnection } from './services/db.js'

// 测试数据库连接
async function runTest() {
  try {
    await testConnection()
    console.log('数据库连接测试完成')
  } catch (error) {
    console.error('数据库连接测试失败:', error)
  }
}

runTest() 