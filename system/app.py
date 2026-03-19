from flask import Flask, render_template, request, jsonify, session, redirect, url_for
import os
import datetime

app = Flask(__name__)
app.secret_key = 'mag-net-demo-key'  # 用于 session 加密

# 配置上传文件夹
UPLOAD_FOLDER = 'static/uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# 模拟历史数据（以批次/目录为单位）
MOCK_HISTORY = [
    {
        'id': 'BATCH-20231027-001',
        'source_dir': '/data/raw/satellite_q3',
        'target_dir': '/data/processed/pan_4x_v1',
        'task': 'Pansharpening',
        'scale': '4x',
        'start_time': '2023-10-27 10:30:00',
        'end_time': '2023-10-27 10:45:12',
        'status': 'Completed',
        'metrics': 'PSNR: 32.5 dB / SSIM: 0.92'
    },
    {
        'id': 'BATCH-20231028-005',
        'source_dir': '/data/clinical/mri_brain_t1',
        'target_dir': '/data/processed/mri_sr_4x',
        'task': 'MRI SR',
        'scale': '4x',
        'start_time': '2023-10-28 14:15:00',
        'end_time': '2023-10-28 14:32:05',
        'status': 'Completed',
        'metrics': 'PSNR: 34.1 dB / SSIM: 0.89'
    },
     {
        'id': 'BATCH-20231029-012',
        'source_dir': '/data/scan/indoor_depth',
        'target_dir': '/data/processed/depth_8x',
        'task': 'Depth SR',
        'scale': '8x',
        'start_time': '2023-10-29 09:20:00',
        'end_time': '2023-10-29 09:55:30',
        'status': 'Completed',
        'metrics': 'RMSE: 2.14'
    },
    {
        'id': 'BATCH-20231030-003',
        'source_dir': '/data/raw/test_failed_batch',
        'target_dir': '/data/processed/test_run',
        'task': 'MRI SR',
        'scale': '8x',
        'start_time': '2023-10-30 11:00:00',
        'end_time': '2023-10-30 11:02:15',
        'status': 'Failed',
        'metrics': '--'
    }
]

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # 任意账号密码均可登录
        session['user'] = request.form.get('username')
        return redirect(url_for('index'))
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('index'))

@app.route('/history')
def history():
    if 'user' not in session:
        return redirect(url_for('login'))
    return render_template('history.html', history=MOCK_HISTORY)

@app.route('/batch')
def batch():
    if 'user' not in session:
        return redirect(url_for('login'))
    return render_template('batch.html')

@app.route('/demo')
def demo():
    if 'user' not in session:
        return redirect(url_for('login'))
    return render_template('demo.html')

@app.route('/upload', methods=['POST'])
def upload_file():

    # 模拟文件上传处理
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'})
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'})

    # 这里仅为演示，实际并未保存文件进行处理
    # 真实场景中会保存文件并调用模型
    return jsonify({
        'success': True, 
        'message': 'File uploaded successfully',
        'filename': file.filename
    })

@app.route('/process', methods=['POST'])
def process_image():
    # 模拟模型处理过程
    # 接收参数
    data = request.json
    task_type = data.get('taskType', 'pansharpening')
    scale = data.get('scale', '4x')
    
    # 返回模拟的处理结果路径
    # 在实际演示中，你可以预先放置好处理后的图片在 static/images 中
    # 这里假设前端会根据任务类型显示预设的结果图
    return jsonify({
        'success': True,
        'message': 'Processing complete',
        'result_url': f'/static/images/demo-pansharpening.png'  # 替换为实际结果图路径
    })

if __name__ == '__main__':
    app.run(debug=True, port=5001)
