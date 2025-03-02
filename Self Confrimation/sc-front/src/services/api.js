// src/services/api.js
export async function saveStory(storyData) {
    try {
      const response = await fetch('http://localhost:3000/api/stories', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(storyData)
      });
      const data = await response.json();
      if (response.ok) {
        return data;
      } else {
        throw new Error(data.error || '保存失败');
      }
    } catch (error) {
      console.error('保存故事失败:', error);
      throw error;
    }
  }