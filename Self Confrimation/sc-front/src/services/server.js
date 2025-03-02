import express from 'express';
import cors from 'cors';
import { testConnection, saveStoryToDatabase, getUserStories } from './services/db.js';

const app = express();
app.use(cors());
app.use(express.json());

// 测试数据库连接
app.get('/api/test-connection', async (req, res) => {
  try {
    await testConnection();
    res.json({ message: 'Database connection successful' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 保存故事
app.post('/api/stories', async (req, res) => {
  try {
    const { userId, summary } = req.body;
    const result = await saveStoryToDatabase(userId, summary);
    res.json({ id: result });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 获取用户故事
app.get('/api/stories/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const stories = await getUserStories(userId);
    res.json(stories);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});