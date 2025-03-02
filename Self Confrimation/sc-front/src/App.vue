<template>
  <router-view></router-view>
</template>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: Arial, sans-serif;
}

:root {
  --background-color: #ffffff;
  --text-color: #333333;
}

#app {
  background-color: #F8F9FE;
  color: var(--text-color);
  min-height: 100vh;
  overflow: hidden;
}

/* 同时修改聊天界面的样式 */
.chat-container {
  background-color: #ffffff;
}

.message-list {
  background: #f5f7fa;
}

.content {
  background: #ffffff;
  color: #333333;
}

.message.user .content {
  background: #409eff;
  color: #ffffff;
}

/* 提高文字可读性 */
body, p, div:not(.quote) {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen,
    Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
}
</style>
