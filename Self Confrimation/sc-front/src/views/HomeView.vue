<template>
  <div class="home-container">
    <img src="@/assets/home.png" class="home-icon" />
    <div class="avatar"></div>

    <!-- 顶部区域 -->
    <div class="header">
      <div class="logo">
        <i class="icon-butterfly"></i>
      </div>
      <div class="user-icons">
        <i class="icon-bell"></i>
        <div class="avatar"></div>
      </div>
    </div>

    <!-- 心情选择区域 -->
    <div class="section mood-section">
      <h3 class="section-title">选择板块</h3>
      <div class="mood-grid">
        <div class="mood-card" @click="$router.push('/past')">
          <div class="mood-icon">
            <span class="material-symbols-outlined">cloudy_snowing</span>
          </div>
          <span class="mood-text">过去</span>
        </div>
        <div class="mood-card">
          <div class="mood-icon">
            <span class="material-symbols-outlined">conditions</span>
          </div>
          <span class="mood-text">现在</span>
        </div>
        <div class="mood-card">
          <div class="mood-icon">
            <span class="material-symbols-outlined">rocket</span>
          </div>
          <span class="mood-text">未来</span>
        </div>
      </div>
    </div>

    <!-- 正念练习区域 -->
    <div class="section">
      <h3 class="section-title">你的故事</h3>
      <div class="tracks-grid">
        <div class="track-card">
          <div class="track-content">
            <span class="track-name">你的故事</span>
            <span class="track-subtitle">关于过去的回忆</span>
          </div>
          <div class="track-image">
            <img src="@/assets/story1.png" alt="故事" />
          </div>
        </div>
        <div class="track-card">
          <div class="track-content">
            <span class="track-name">你的目标</span>
            <span class="track-subtitle">关于未来的目标</span>
          </div>
          <div class="track-image">
            <img src="@/assets/target1.png" alt="目标" />
          </div>
        </div>
      </div>
    </div>

    <!-- Mini Courses 区域 -->
    <div class="section">
      <h3 class="section-title">你的特质</h3>
      <div class="courses-grid">
        <div class="course-card" v-for="story in stories" :key="story.id">
          <div class="main-content">
            <p class="course-description">
              <span class="quote custom-quote">“</span>{{ story.description }}
            </p>
            <h4 class="course-title">{{ story.title }}</h4>
          </div>
          <!-- <div class="additional-content">
            <div class="story-impact">
              <span class="label">该故事对你的影响：</span>
              <p class="impact-text">{{ story.impact }}</p>
            </div>
            <div class="story-traits">
              <span class="label">该故事表现出你的特质：</span>
              <div class="traits-container">
                <span class="trait-tag" v-for="(trait, index) in story.traits" :key="index">
                  {{ trait }}
                </span>
              </div>
            </div>
          </div> -->
        </div>
      </div>
    </div>

    <!-- 目标卡片区域 -->
    <div class="section">
      <h3 class="section-title">你的目标</h3>
      <div class="goals-container">
        <div class="goal-card">
          <div class="goal-progress">
            <svg class="progress-rings" width="60" height="60" viewBox="0 0 60 60">
              <!-- 背景圆环 -->
              <circle class="ring-bg" cx="30" cy="30" r="25" />
              <circle class="ring-bg" cx="30" cy="30" r="20" />
              <circle class="ring-bg" cx="30" cy="30" r="15" />
              
              <!-- 进度圆环 - 5年目标 -->
              <circle class="ring-progress five-year" 
                      cx="30" cy="30" r="15" 
                      stroke-dasharray="94.2" 
                      stroke-dashoffset="47.1" /> <!-- 50% progress -->
              
              <!-- 进度圆环 - 2年目标 -->
              <circle class="ring-progress two-year" 
                      cx="30" cy="30" r="20" 
                      stroke-dasharray="125.6" 
                      stroke-dashoffset="31.4" /> <!-- 75% progress -->
              
              <!-- 进度圆环 - 1年目标 -->
              <circle class="ring-progress one-year" 
                      cx="30" cy="30" r="25" 
                      stroke-dasharray="157" 
                      stroke-dashoffset="117.75" /> <!-- 25% progress -->
            </svg>
          </div>
          <div class="goal-info">
            <div class="goal-period">
              <span class="period one-year">今年</span>
              <span class="period two-year">两年</span>
              <span class="period five-year">五年</span>
            </div>
            <div class="goal-progress-text">
              <span>25%</span>
              <span>75%</span>
              <span>50%</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'HomeView',
  data() {
    return {
      stories: [
        {
          id: 1,
          title: '《童年的玩具车》',
          description: '那是我五岁时收到的第一辆遥控车，红色的法拉利模型。每天放学后，我都会在院子里开上好几个小时，想象自己是个赛车手。直到有一天，它撞到了墙角再也修不好。',
          impact: '让我明白了珍惜当下的重要性，也让我对机械产生了浓厚的兴趣。',
          traits: ['责任心', '专注', '创造力']
        },
        {
          id: 2,
          title: '《第一次登台表演》',
          description: '初中时参加学校文艺汇演，独自弹奏钢琴。虽然彩排时很完美，但正式演出时却出现了一些小失误。让我明白了台下的一分钟，台上需要十年功。',
          impact: '培养了我面对压力的能力，也让我学会了在失误后继续前进。',
          traits: ['勇气', '坚持', '自我突破']
        },
        {
          id: 3,
          title: '《第一次远行》',
          description: '高中毕业后，独自背包去了云南。在大理的洱海边，遇到了许多有趣的人，听到了很多不同的人生故事。这次旅行让我开始思考自己真正想要的是什么。',
          impact: '开阔了我的视野，让我学会用更包容的心态看待世界。',
          traits: ['独立', '探索精神', '开放']
        }
      ]
    }
  }
}
</script>

<style scoped>
/* 重置默边距 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

/* 修改容器样式，移除padding */
.home-container {
  padding: 0;
  background-color: #F8F9FE;
  min-height: 100vh;
  max-width: 100%;
  margin: 0 auto;
}

/* 添加到 App.vue 或全局样式中 */
html, body {
  margin: 0;
  padding: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.user-icons {
  display: flex;
  align-items: center;
  gap: 16px;
}

.icon-bell {
  width: 24px;
  height: 24px;
  color: #A1A7B3;
}

.avatar {
  width: 32px;
  height: 32px;
  background: linear-gradient(-60deg,
    #7F7FD5 0%,
    #86A8E7 50%,
    #91EAE4 100%
  );
  border-radius: 50%;
  position: absolute;
  top: 16px;
  right: 32px;
}

.section {
  margin-bottom: 20px;
}

.section-title {
  color: #A1A7B3;
  font-size: 14px;
  font-weight: 400;
  margin-bottom: 12px;
  padding: 0 4px;
}

.mood-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 24px;
  padding: 0 4px;
}

.mood-card {
  background: white;
  border-radius: 20px;
  padding: 12px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
  box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.04),
              0px 2px 4px rgba(0, 0, 0, 0.02);
  min-height: 85px;
}

.mood-icon {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: transparent;
}

.material-symbols-outlined {
  font-size: 32px;
  font-variation-settings:
    'FILL' 0,
    'wght' 300,
    'GRAD' 0,
    'opsz' 24;
  background: linear-gradient(-60deg,
    #7F7FD5 0%,     /* 柔和的紫色 */
    #86A8E7 50%,    /* 淡雅的蓝色 */
    #91EAE4 100%    /* 清新的青色 */
  );
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  -webkit-text-fill-color: transparent;
}

.mood-text {
  font-size: 14px;
  font-weight: 500;
  color: #333;
}

.tracks-grid {
  display: flex;
  gap: 16px;
  margin-bottom: 24px;
  padding: 16px 4px;
  margin-top: -16px;
  margin-bottom: 8px;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
  position: relative;
}

.tracks-grid::-webkit-scrollbar {
  display: none;
}

.track-card {
  min-width: 180px;
  min-height: 100px;
  scroll-snap-align: start;
  position: relative;
  padding: 16px;
  box-shadow: 
    0 8px 16px rgba(103, 110, 203, 0.08),
    0 4px 8px rgba(103, 110, 203, 0.06);
}

.track-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.track-name {
  font-size: 14px;
  font-weight: 500;
  color: #333;
}

.track-subtitle {
  font-size: 11px;
  font-weight: 400;
  color: #A1A7B3;
}

.track-image {
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.track-image img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.courses-grid {
  display: flex;
  gap: 12px;
  padding: 12px 4px;
  margin-top: -12px;
  margin-bottom: 8px;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
  position: relative;
}

.courses-grid::-webkit-scrollbar {
  display: none;
}

.course-card {
  min-width: 280px;
  min-height: 120px;
  background: white;
  border-radius: 20px;
  padding: 12px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  box-shadow: 
    8px 8px 24px rgba(103, 110, 203, 0.08),
    4px 4px 8px rgba(103, 110, 203, 0.06);
}

.main-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.course-description {
  font-size: 11px;
  color: #A1A7B3;
  line-height: 1.3;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.course-title {
  font-size: 14px;
  font-weight: 500;
  color: #666;
  margin: 0;
  text-align: right;
  display: flex;
  justify-content: flex-end;
}

/* 破折号也相应调整字重 */
.course-title::before {
  content: "——";
  font-size: 10px;
  margin-right: 4px;
  color: #333;
  font-weight: 400;
}

.additional-content {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-top: 4px;
}

.story-impact, .story-traits {
  font-size: 11px;
}

.label {
  color: #808080;
  display: block;
  margin-bottom: 2px;
  font-size: 11px;
}

.impact-text {
  color: #808080;
  margin: 0;
  padding-left: 8px;
  font-size: 11px;
  line-height: 1.3;
}

.traits-container {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  padding-left: 8px;
}

/* 为不同特质添加不同的背景色 */
.trait-tag:nth-child(3n+1) {
  background-color: #E8F0FF;
  color: #4B7BE5;
}

.trait-tag:nth-child(3n+2) {
  background-color: #FFF0E6;
  color: #FF9966;
}

.trait-tag:nth-child(3n+3) {
  background-color: #E6FFE6;
  color: #66B266;
}

.trait-tag {
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 10px;
  display: inline-block;
}

@media screen and (max-width: 360px) {
  .home-container {
    padding: 20px 16px;
  }
  
  .mood-grid,
  .tracks-grid {
    gap: 12px;
  }
  
  .mood-card {
    padding: 16px 12px;
    min-height: 100px;
  }
}

@supports (padding: max(0px)) {
  .home-container {
    padding: 0;
  }
}

/* 统一的卡片阴影样式 */
.mood-card,
.track-card,
.course-card {
  background: white;
  border-radius: 20px;
  box-shadow: 
    8px 8px 24px rgba(103, 110, 203, 0.08),   /* 主阴影更大的偏移，更淡的透明度 */
    4px 4px 8px rgba(103, 110, 203, 0.06);    /* 近距离阴影也更大偏移 */
  border: none;  /* 移除边框 */
}

/* Mood 卡片具体样式 */
.mood-card {
  padding: 12px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  min-height: 85px;
}

/* Tracks 卡片具体样式 */
.track-card {
  padding: 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  min-height: 70px;
}

/* Course 卡片具体样式 */
.course-card {
  padding: 12px;
  display: flex;
  align-items: flex-start;
  gap: 8px;
  min-height: 72px;
}

/* 为每个卡片保持相同的渐变效果 */
.mood-card:nth-child(1) .material-symbols-outlined,
.mood-card:nth-child(2) .material-symbols-outlined,
.mood-card:nth-child(3) .material-symbols-outlined {
  background: linear-gradient(-60deg,
    #7F7FD5 0%,     /* 柔和的紫色 */
    #86A8E7 50%,    /* 淡雅的蓝色 */
    #91EAE4 100%    /* 清新的青色 */
  );
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  -webkit-text-fill-color: transparent;
}

.home-container .course-card .course-description .quote.custom-quote {
  font-size: 32px;
  font-weight: 400;
  color: #333;
  font-family: "Yuji Mai", serif !important;
  margin-right: 4px;
  position: relative;
  top: 8px;
}

/* 调整卡片高度以适应新内容 */
.course-card {
  min-height: 135px;
  padding: 12px;
}

/* 影响部分样式 */
.story-impact {
  margin-top: 8px;
  font-size: 11px;
}

.story-traits {
  margin-top: 8px;
  font-size: 11px;
}

.label {
  color: #666;
  display: block;
  margin-bottom: 4px;
}

.impact-text {
  color: #666;
  margin: 0;
  padding-left: 8px;
  font-size: 11px;
}

/* 特质标签样式 */
.traits-container {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  padding-left: 8px;
}

.trait-tag {
  background-color: #F0F2F5;
  padding: 2px 8px;
  border-radius: 12px;
  color: #666;
  font-size: 10px;
}

/* 目标卡片样式 */
.goals-container {
  display: flex;
  gap: 16px;
  padding: 12px 4px;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
}

.goal-card {
  min-width: 320px;
  min-height: 120px;
  background: white;
  border-radius: 20px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 24px;
  box-shadow: 
    8px 8px 24px rgba(103, 110, 203, 0.08),
    4px 4px 8px rgba(103, 110, 203, 0.06);
}

.goal-progress {
  width: 80px;
  height: 80px;
}

/* SVG 进度环样式 */
.progress-rings {
  transform: rotate(-90deg);
}

.ring-bg {
  fill: none;
  stroke: #F0F2F5;
  stroke-width: 3;
}

.ring-progress {
  fill: none;
  stroke-width: 3;
  stroke-linecap: round;
  transition: stroke-dashoffset 0.5s ease;
}

/* 不同时期目标的颜色 */
.one-year {
  stroke: #FF6B6B;
  color: #FF6B6B;
}

.two-year {
  stroke: #4ECDC4;
  color: #4ECDC4;
}

.five-year {
  stroke: #45B7D1;
  color: #45B7D1;
}

.goal-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.goal-period {
  display: flex;
  justify-content: space-between;
  font-size: 11px;
}

.goal-progress-text {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  font-weight: 500;
}

.period {
  font-size: 11px;
}

.home-icon {
  width: 32px;
  height: 32px;
  position: absolute;
  top: 16px;
  left: 32px;
}

/* 添加一个导航区域的容器 */
.nav-section {
  margin-bottom: 48px;
  height: 32px;
  position: relative;
}

/* 调整第一个 section 的上边距 */
.section:first-of-type {
  margin-top: 64px;
}
</style> 

<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=cloudy_snowing" />
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@400;500;700&display=swap" rel="stylesheet">