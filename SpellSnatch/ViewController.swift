import UIKit
import AVFoundation
import Speech
import NaturalLanguage
import CommonCrypto

// 首先在类外部定义 String 的 MD5 扩展
extension String {
    var md5: String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = data.withUnsafeBytes { buffer in
            CC_MD5(buffer.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    // UI 组件
    private let lettersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let recordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = true
        
        // 创建录音按钮的外圈
        let outerCircle = UIView()
        outerCircle.backgroundColor = .clear
        outerCircle.layer.borderColor = UIColor.systemIndigo.cgColor
        outerCircle.layer.borderWidth = 3
        outerCircle.layer.cornerRadius = 35
        outerCircle.isUserInteractionEnabled = false
        
        // 创建内部的录音按钮
        let innerCircle = UIView()
        innerCircle.backgroundColor = .systemIndigo
        innerCircle.layer.cornerRadius = 25
        innerCircle.isUserInteractionEnabled = false
        
        // 设置按钮的布局
        button.addSubview(outerCircle)
        button.addSubview(innerCircle)
        
        // 设置约束
        outerCircle.translatesAutoresizingMaskIntoConstraints = false
        innerCircle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            outerCircle.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            outerCircle.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            outerCircle.widthAnchor.constraint(equalToConstant: 70),
            outerCircle.heightAnchor.constraint(equalToConstant: 70),
            
            innerCircle.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            innerCircle.widthAnchor.constraint(equalToConstant: 50),
            innerCircle.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 设置按钮的大小
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        return button
    }()
    
    // 音频相关
    private var audioEngine = AVAudioEngine()
    
    // 语音合成器
    private let synthesizer = AVSpeechSynthesizer()
    
    // 语音识别相关
    private lazy var speechRecognizer: SFSpeechRecognizer? = {
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        recognizer?.delegate = self
        return recognizer
    }()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    // 添加字母识别映射
    private let letterMappings: [String: String] = [
        // A
        "A": "A", "AY": "A", "EI": "A", "EH": "A",
        // B
        "B": "B", "BEE": "B", "BI": "B", "BII": "B", "BE": "B",
        // C
        "C": "C", "SEE": "C", "SI": "C", "SHI": "C", "CE": "C",
        // D
        "D": "D", "DEE": "D", "DI": "D", "DII": "D", "DE": "D",
        // E - 大幅增加 E 的识别变体
        "E": "E", "HE": "E", "EE": "E", "II": "E", "IE": "E", "EA": "E",
        "IH": "E", "EY": "E", "YI": "E", "EEH": "E", "IIH": "E",
        // F
        "F": "F", "EF": "F", "FU": "F", "EFU": "F", "FO": "F",
        // G
        "G": "G", "GEE": "G", "JI": "G", "GI": "G", "GU": "G",
        // H
        "H": "H", "AITCH": "H", "EICH": "H", "EICHU": "H", "EICHI": "H", 
        // I
        "I": "I", "EYE": "I", "AII": "I", "AI": "I", "IY": "I",
        // J
        "J": "J", "JAY": "J", "JEI": "J", "JEY": "J", "JE": "J",
        // K
        "K": "K", "KAY": "K", "KEI": "K", "KEY": "K", "KE": "K", "KA": "K",
        // L - 大幅增加 L 的识别变体
        "L": "L", "EL": "L", "ERU": "L", "LU": "L", "LE": "L", 
        "LAH": "L", "LO": "L", "ELU": "L", "ALU": "L", "ELL": "L", 
        "ELLE": "L", "LA": "L", "LEI": "L", "LEE": "L", "LII": "L",
        // M
        "M": "M", "EM": "M", "EMU": "M", "EMM": "M", "MU": "M",
        // N
        "N": "N", "EN": "N", "ENU": "N", "ENN": "N", "NU": "N",
        // O - 大幅增加 O 的识别变体

        // P
        "P": "P", "PEE": "P", "PI": "P", "PII": "P", "PE": "P",
        // Q
        "Q": "Q", "CUE": "Q", "KYU": "Q", "KIU": "Q", "KU": "Q",
        // R
        "R": "R", "ARE": "R", "ARU": "R", "AA": "R", "RU": "R",
        // S
        "S": "S", "ESS": "S", "ESU": "S", "ESSU": "S", "SU": "S",
        // T
        "T": "T", "TEE": "T", "TI": "T", "TII": "T", "TO": "T",
        // U
        "U": "U", "YOU": "U", "YU": "U", "YUU": "U", "UE": "U",
        // V
        "V": "V", "VEE": "V", "VI": "V", "BUI": "V", "VU": "V",
        // W
        "W": "W", "DOUBLE U": "W", "DABURU": "W", "DABU": "W", "WU": "W",
        // X
        "X": "X", "EX": "X", "EKSU": "X", "IKS": "X", "XU": "X",
        // Y
        "Y": "Y", "WHY": "Y", "WAI": "Y", "WAII": "Y", "YE": "Y",
        // Z
        "Z": "Z", "ZED": "Z", "ZEE": "Z", "ZETTO": "Z", "ZEDDO": "Z", "ZU": "Z",

        "O": "O", "OH": "O"

    ]
    
    private var currentWord = ""
    
    // 添加新的属性
    private var lastProcessedTime: Date = Date()
    private let processingInterval: TimeInterval = 0.5 // 设置识别间隔为0.5秒
    
    // 添加新属性
    private var isListeningForLetter = false
    private let letterTimeout: TimeInterval = 1.0 // 每个字母的识别超时时间
    
    // 添加新的属性
    private var letterTimer: Timer?
    private let letterWaitTimeout: TimeInterval = 5.0 // 等待下一个字母的超时时间
    private var isWaitingForNextLetter = false
    
    // 添加新属性来跟踪最后识别的字母
    private var lastRecognizedLetter: String = ""
    private var lastRecognitionTime: Date = Date()
    private let minimumLetterInterval: TimeInterval = 1.0 // 两个字母之间的最小间隔时间
    
    // 添加百度翻译 API 的常量
    private let appid = Config.baiduAppId
    private let key = Config.baiduSecretKey
    
    // 修改通用翻译响应结构体
    private struct BaiduTranslateResponse: Codable {
        let error_code: Int?
        let error_msg: String?
        let from: String?
        let to: String?
        let trans_result: [TransResult]?
        
        struct TransResult: Codable {
            let src: String
            let dst: String
        }
    }

    // 修改词典响应结构体
    private struct BaiduDictResponse: Codable {
        let error_code: Int?
        let error_msg: String?
        let data: [DictData]?
        
        struct DictData: Codable {
            let word_name: String
            let symbols: [Symbol]
            
            struct Symbol: Codable {
                let ph_en: String?          // 英式音标
                let ph_am: String?          // 美式音标
                let parts: [Part]           // 词性和释义
                let means: [String]?        // 基本释义
                
                struct Part: Codable {
                    let part: String        // 词性
                    let means: [String]     // 该词性下的所有释义
                }
            }
        }
    }
    
    // 添加 Gemini 响应结构体
    private struct GeminiResponse: Codable {
        let candidates: [Candidate]
        
        struct Candidate: Codable {
            let content: Content
            
            struct Content: Codable {
                let parts: [Part]
                
                struct Part: Codable {
                    let text: String
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    // 设置深色背景
    view.backgroundColor = .black

    // 移除之前可能存在的渐变层
    view.layer.sublayers?.forEach { layer in
        if layer is CAGradientLayer {
            layer.removeFromSuperlayer()
        }
    }

    // 创建渐变背景层
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds

    // 使用更浓郁的绿色调（绿色更明显）
    let darkColor = UIColor.black.cgColor
    let darkGreenColor = UIColor(red: 0.0, green: 0.30, blue: 0.02, alpha: 1.0).cgColor  // 更亮的绿色

    // 调整颜色分布（绿色占比更大）
    gradientLayer.colors = [darkGreenColor, darkColor]
    gradientLayer.locations = [0.0, 0.2]  // 绿色覆盖80%的区域，底部渐变为黑色

    // 改为对角线渐变（从左上到右下）
    gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.6, y: 1.5)

    // 确保渐变层在最底层
    view.layer.insertSublayer(gradientLayer, at: 0)

    // 设置暗色模式
    overrideUserInterfaceStyle = .dark
        
        setupUI()
        setupSpeechRecognition()
        
        // 添加长按手势用于清除输入
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(clearCurrentInput))
        recordButton.addGestureRecognizer(longPress)
        
        // 初始化音频引擎
        do {
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: .duckOthers)
        } catch {
            print("音频会话设置失败: \(error.localizedDescription)")
        }
    }
    
    private func setupUI() {
        // 添加UI组件
        [lettersLabel, wordLabel, translationLabel, recordButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            lettersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lettersLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            lettersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            lettersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.topAnchor.constraint(equalTo: lettersLabel.bottomAnchor, constant: 40),
            wordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            wordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            translationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            translationLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 30),
            translationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            translationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            recordButton.widthAnchor.constraint(equalToConstant: 80),
            recordButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
    }
    
    private func setupSpeechRecognition() {
        speechRecognizer?.delegate = self
        
        // 设置语音识别为英语，这样更容易识别字母
        guard let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) else {
            print("Speech recognizer not available for en-US locale")
            return
        }
        
        // 配置识别选项
        if #available(iOS 13.0, *) {
            speechRecognizer.supportsOnDeviceRecognition = true
        }
        
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                case .denied:
                    self.recordButton.isEnabled = false
                    self.lettersLabel.text = "需要语音识别权限"
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.lettersLabel.text = "语音识别不可用"
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.lettersLabel.text = "等待授权"
                @unknown default:
                    break
                }
            }
        }
    }
    
    @objc private func recordButtonTapped() {
        if audioEngine.isRunning {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        // 重置状态
        currentWord = ""
        lettersLabel.text = ""
        wordLabel.text = ""
        translationLabel.text = ""
        isListeningForLetter = false
        isWaitingForNextLetter = false
        letterTimer?.invalidate()
        
        // 重置识别状态
        lastRecognizedLetter = ""
        lastRecognitionTime = Date()
        
        // 配置音频会话
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, 
                                       mode: .measurement, 
                                       options: [.defaultToSpeaker, .duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("音频会话设置失败: \(error.localizedDescription)")
            return
        }
        
        startListeningForNextLetter()
        updateRecordButtonState(isRecording: true)
    }
    
    private func startListeningForNextLetter() {
        // 停止之前的识别任务
        recognitionTask?.cancel()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        // 创建新的识别请求
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest,
              let speechRecognizer = speechRecognizer else { return }
        
        recognitionRequest.shouldReportPartialResults = true
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = true
        }
        
        // 配置音频输入
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 512, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        // 开始识别任务
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                // 添加更多调试信息
                print("完整识别结果: \(result.bestTranscription.formattedString)")
                for segment in result.bestTranscription.segments {
                    print("片段: '\(segment.substring)' (置信度: \(segment.confidence))")
                }
                
                // 只在非最终结果时处理
                if !result.isFinal {
                    // 只处理最后一个识别结果
                    if let lastSegment = result.bestTranscription.segments.last,
                       !lastSegment.substring.isEmpty {
                        let recognizedText = lastSegment.substring.uppercased()
                        
                        // 添加日志
                        print("处理识别文本: '\(recognizedText)'")
                        
                        // 检查命令词
                        switch recognizedText {
                        case "SNATCH":
                            print("检测到 'SNATCH' 命令，开始识别单词")
                            self.stopRecording()
                            return
                        case "RESET":
                            print("检测到 'RESET' 命令，重新开始识别")
                            // 清除当前输入并重新开始
                            self.clearCurrentInput()
                            // 重置识别状态
                            self.lastRecognizedLetter = ""
                            self.lastRecognitionTime = Date()
                            // 播放提示音表示重置
                            AudioServicesPlaySystemSound(1104)
                            return
                        default:
                            // 尝试识别字母
                            if self.tryRecognizeLetter(recognizedText) {
                                // 字母识别成功，重置定时器
                                self.startLetterTimer()
                            }
                        }
                    }
                }
            }
            
            if let error = error {
                print("识别错误: \(error.localizedDescription)")
            }
        }
        
        // 启动音频引擎
        audioEngine.prepare()
        do {
            try audioEngine.start()
            recordButton.isSelected = true
            isWaitingForNextLetter = true
            startLetterTimer()
        } catch {
            print("音频引擎启动失败: \(error.localizedDescription)")
            stopRecording()
        }
    }
    
    private func tryRecognizeLetter(_ text: String) -> Bool {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let now = Date()
        
        // 添加调试日志，显示原始识别文本
        print("原始识别文本: '\(cleanText)'")
        
        // 检查与上一次识别的时间间隔
        let timeSinceLastRecognition = now.timeIntervalSince(lastRecognitionTime)
        
        // 增加容错处理：移除可能的额外元音
        let simplifiedText = cleanText
            .replacingOccurrences(of: "UU", with: "U")
            .replacingOccurrences(of: "II", with: "I")
            .replacingOccurrences(of: "AA", with: "A")
            .replacingOccurrences(of: "EE", with: "E")
            .replacingOccurrences(of: "OO", with: "O")
        
        // 添加简化后的文本日志
        print("简化后的文本: '\(simplifiedText)'")
        
        // 最小识别间隔检查
        if timeSinceLastRecognition < minimumLetterInterval {
            return false
        }
        
        // 首先尝试直接匹配单个字母
        if cleanText.count == 1 && letterMappings[cleanText] != nil {
            // 如果是重复字母，需要更长的间隔
            if cleanText == lastRecognizedLetter && timeSinceLastRecognition < minimumLetterInterval * 1.7 {
                return false
            }
            lastRecognizedLetter = cleanText
            lastRecognitionTime = now
            addLetterToWord(cleanText)
            return true
        }
        
        // 尝试匹配原始文本和简化后的文本
        for text in [cleanText, simplifiedText] {
            if let letter = letterMappings[text] {
                // 如果是重复字母，需要更长的间隔
                if letter == lastRecognizedLetter && timeSinceLastRecognition < minimumLetterInterval * 1.7 {
                    return false
                }
                lastRecognizedLetter = letter
                lastRecognitionTime = now
                addLetterToWord(letter)
                return true
            }
        }
        
        // 模糊匹配：检查是否包含在任何映射中
        for (pronunciation, letter) in letterMappings {
            if cleanText.contains(pronunciation) || simplifiedText.contains(pronunciation) {
                // 如果是重复字母，需要更长的间隔
                if letter == lastRecognizedLetter && timeSinceLastRecognition < minimumLetterInterval * 1.7 {
                    return false
                }
                lastRecognizedLetter = letter
                lastRecognitionTime = now
                addLetterToWord(letter)
                return true
            }
        }
        
        return false
    }
    
    private func startLetterTimer() {
        letterTimer?.invalidate()
        letterTimer = Timer.scheduledTimer(withTimeInterval: letterWaitTimeout, repeats: false) { [weak self] _ in
            self?.handleLetterTimeout()
        }
    }
    
    private func handleLetterTimeout() {
        if !currentWord.isEmpty {
            // 用户超过5秒没有说下一个字母，结束识别
            stopRecording()
        }
    }
    
    private func stopRecording() {
        // 停止定时器
        letterTimer?.invalidate()
        letterTimer = nil
        
        // 停止音频引擎
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        // 结束识别
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        // 清理资源
        recognitionRequest = nil
        recognitionTask = nil
        
        // 更新UI
        recordButton.isSelected = false
        
        // 如果有累积的字母，尝试翻译
        if !currentWord.isEmpty {
            translateWord(currentWord)
            displayRecognizedWord(currentWord)
        }
        
        // 重置状态
        isListeningForLetter = false
        isWaitingForNextLetter = false
        updateRecordButtonState(isRecording: false)
    }
    
    private func processRecognizedText(_ text: String) {
        // 优化字母匹配逻辑
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 首先尝试直接匹配单个字母
        if cleanText.count == 1 && letterMappings[cleanText] != nil {
            addLetterToWord(cleanText)
            return
        }
        
        // 然后尝试匹配字母发音
        for (pronunciation, letter) in letterMappings {
            if cleanText == pronunciation {
                addLetterToWord(letter)
                return
            }
        }
    }
    
    private func addLetterToWord(_ letter: String) {
        // 更新当前单词
        currentWord += letter
        
        // 更新显示
        DispatchQueue.main.async {
            // 更新字母显示
            self.lettersLabel.text = self.currentWord
            
            // 播放提示音
            AudioServicesPlaySystemSound(1104)
            
            print("识别到字母: \(letter)")
        }
    }
    
    // 添加一个新的方法来创建字母动画
    private func createLetterAnimation(for letter: String, at index: Int) -> CAAnimationGroup {
        let group = CAAnimationGroup()
        group.duration = 0.6
        
        // 缩放动画
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1.0, 1.5, 1.0]
        scale.keyTimes = [0, 0.3, 1.0]
        scale.timingFunctions = [
            CAMediaTimingFunction(name: .easeOut),
            CAMediaTimingFunction(name: .easeInEaseOut)
        ]
        
        // 透明度动画
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [0.3, 1.0, 1.0]
        opacity.keyTimes = [0, 0.3, 1.0]
        
        group.animations = [scale, opacity]
        group.isRemovedOnCompletion = true
        group.fillMode = .forwards
        
        return group
    }
    
    private func translateWord(_ word: String) {
        let cleanWord = word.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        wordLabel.text = cleanWord
        
        let apiKey = Config.geminiApiKey
        let urlString = "https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent?key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("URL 创建失败")
            return
        }
        
        // 修改提示词，要求更详细的词性和释义格式
        let prompt = """
        分析英语单词 "\(cleanWord)" 的所有词性和对应释义。
        请按照以下格式返回（只返回存在的词性）：
        词性缩写. （换行）
        对应的中文释义（多个释义用逗号分隔）
        
        如果有多个词性，每个词性之间空一行。
        
        示例格式：
        v.
        提到，谈到，推荐
        
        n.
        提及，说起，表扬
        """
        
        // 更新请求体格式
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        [
                            "text": prompt
                        ]
                    ],
                    "role": "user"  // 添加角色
                ]
            ],
            "generationConfig": [    // 添加生成配置
                "temperature": 0.7,
                "topK": 40,
                "topP": 0.95,
                "maxOutputTokens": 1024
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            print("发送请求到 Gemini API...")
            print("请求 URL: \(urlString)")
            print("请求体: \(String(data: request.httpBody!, encoding: .utf8) ?? "无法读取请求体")")
        } catch {
            print("JSON 序列化错误: \(error)")
            self.translationLabel.text = "翻译服务暂时不可用"
            return
        }

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("API 请求错误: \(error)")
                    self.translationLabel.text = "翻译服务暂时不可用"
                    self.speakWord(cleanWord)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP 响应状态码: \(httpResponse.statusCode)")
                }
                
                if let data = data {
                    print("收到响应数据: \(String(data: data, encoding: .utf8) ?? "无法读取响应数据")")
                    
                    do {
                        let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
                        if let text = response.candidates.first?.content.parts.first?.text,
                           !text.isEmpty {
                            print("解析后的文本: \(text)")
                            
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.alignment = .left
                            paragraphStyle.lineSpacing = 4
                            
                            let attributes: [NSAttributedString.Key: Any] = [
                                .paragraphStyle: paragraphStyle,
                                .font: UIFont.systemFont(ofSize: 17)
                            ]
                            
                            let attributedText = NSAttributedString(string: text, attributes: attributes)
                            self.translationLabel.attributedText = attributedText
                        } else {
                            print("响应数据中没有有效的文本")
                            self.translationLabel.text = "暂时找不到翻译结果"
                        }
                    } catch {
                        print("JSON 解码错误: \(error)")
                        self.translationLabel.text = "翻译结果解析失败"
                    }
                } else {
                    print("没有收到响应数据")
                    self.translationLabel.text = "暂时找不到翻译结果"
                }
                self.speakWord(cleanWord)
            }
        }
        task.resume()
    }
    
    private func speakWord(_ word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
    
    // 添加新方法：清除当前输入
    @objc private func clearCurrentInput() {
        currentWord = ""
        lettersLabel.text = ""
        wordLabel.text = ""
        translationLabel.text = ""
    }
    
    // 添加代理方法
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        recordButton.isEnabled = available
    }
    
    // 修改录音按钮状态变化
    private func updateRecordButtonState(isRecording: Bool) {
        UIView.animate(withDuration: 0.3) {
            if let innerCircle = self.recordButton.subviews.last {
                if isRecording {
                    // 变为方形停止按钮
                    innerCircle.layer.cornerRadius = 8
                    innerCircle.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.recordButton.layer.borderColor = UIColor.systemRed.cgColor
                    innerCircle.backgroundColor = .systemRed
                } else {
                    // 变回圆形录音按钮
                    innerCircle.layer.cornerRadius = 25
                    innerCircle.transform = .identity
                    self.recordButton.layer.borderColor = UIColor.systemIndigo.cgColor
                    innerCircle.backgroundColor = .systemIndigo
                }
            }
        }
    }
    
    // 添加新的方法来显示识别的单词并加上下划线
    private func displayRecognizedWord(_ word: String) {
        let attributedString = NSMutableAttributedString(string: word)
        let range = NSRange(location: 0, length: attributedString.length)
        
        // Use Trajan font if available, otherwise fallback to system font
        if let trajanFont = UIFont(name: "TrajanPro-Regular", size: 36) {
            attributedString.addAttribute(.font, value: trajanFont, range: range)
        } else {
            // Fallback to system font if Trajan is not available
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 36, weight: .bold), range: range)
        }
        
        wordLabel.attributedText = attributedString
    }
}

extension UIBezierPath {
    convenience init(circleWithCenter center: CGPoint, radius: CGFloat) {
        self.init(arcCenter: center,
                 radius: radius,
                 startAngle: 0,
                 endAngle: CGFloat(2 * Double.pi),
                 clockwise: true)
    }
}