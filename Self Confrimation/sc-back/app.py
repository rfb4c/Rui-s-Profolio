from flask import Flask, request, jsonify
from flask_cors import CORS
import pymysql
from datetime import datetime
import logging

# 配置日志
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)  # 启用CORS

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '123456',
    'db': 'sc',
    'charset': 'utf8mb4',
    'cursorclass': pymysql.cursors.DictCursor
}

def get_db_connection():
    try:
        connection = pymysql.connect(**DB_CONFIG)
        return connection
    except Exception as e:
        logger.error(f"数据库连接错误: {str(e)}")
        raise

@app.route('/api/stories', methods=['POST'])
def create_story():
    try:
        data = request.get_json()
        
        # 验证必要字段
        if 'user_id' not in data:
            return jsonify({'error': '缺少 user_id'}), 400
            
        # 确保 user_id 是整数
        try:
            user_id = int(data['user_id'])
        except ValueError:
            return jsonify({'error': 'user_id 必须是整数'}), 400

        conn = get_db_connection()
        try:
            with conn.cursor() as cursor:
                sql = """
                    INSERT INTO story_summaries 
                    (user_id, title, content, impacts, traits, recommendations) 
                    VALUES (%s, %s, %s, %s, %s, %s)
                """
                cursor.execute(sql, (
                    user_id,
                    data.get('title'),
                    data.get('content'),
                    data.get('impacts'),
                    data.get('traits'),
                    data.get('recommendations')
                ))
                conn.commit()
                story_id = cursor.lastrowid
                
            return jsonify({'message': '故事保存成功', 'id': story_id}), 201
        except Exception as e:
            logger.error(f"数据库操作错误: {str(e)}")
            return jsonify({'error': f'数据库操作错误: {str(e)}'}), 500
        finally:
            conn.close()

    except Exception as e:
        logger.error(f"创建故事时发生错误: {str(e)}")
        return jsonify({'error': f'服务器内部错误: {str(e)}'}), 500

@app.route('/api/stories/<int:user_id>', methods=['GET'])
def get_user_stories(user_id):
    try:
        conn = get_db_connection()
        with conn.cursor() as cursor:
            sql = "SELECT * FROM story_summaries WHERE user_id = %s ORDER BY created_at DESC"
            cursor.execute(sql, (user_id,))
            stories = cursor.fetchall()
            
            # 转换datetime对象为字符串
            for story in stories:
                story['created_at'] = story['created_at'].strftime('%Y-%m-%d %H:%M:%S')
                
        conn.close()
        return jsonify(stories)

    except Exception as e:
        logger.error(f"获取故事时发生错误: {str(e)}")
        return jsonify({'error': '服务器内部错误'}), 500

@app.errorhandler(404)
def not_found_error(error):
    return jsonify({'error': '未找到请求的资源'}), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({'error': '服务器内部错误'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000, debug=True)