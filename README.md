# Rui's Profolio

  <img src="https://github.com/user-attachments/assets/a0ccf755-3e20-463f-a3e0-d0bbe7a97415" height="150px">
  
こんにちは!  
この GitHub 作品集では、私が開発した Web アプリやモバイルアプリを紹介しています。　　  
現在、主に以下二つの分野で開発を続けています：    
<sub>▪️いかにメディア学研究と情報技術を組み合わせ、メディアレベルで脱フィルターバブルの試みで、新なデジタルメディアモデルを創造  <br>
▪️生成AIをいかに心理カウンセリングの手段として活用できる試み  </sub>


---

## 📂 **Project Overall**
```
Rui's Profiles/
 RSelected-Editor/       # ニュースポータルサイトの編集者用システム
 Self Confirmation/      # 生成AI会話機能搭載のセルフヘルプアプリ
 SpellSnatch/            # スペルの音声認識で英単語を翻訳するiOSアプリ
 README.md               # 本ファイル
 .gitignore              # Git管理ファイル
 ...
```
---

##  **Project Details**

###  🔸**R Selected**

ニュースポータルサイト、および編集者用のシステム。

**Background**  
>  前職記者として、真実を伝え、よい記事出せば社会は変わると信じていました。
しかし、重要なのは「一つの声を伝える」ではなく「多様な視点」に触れられる環境ということです。
現在のマス・メディアはアルゴリズムで情報を優先・排除し、人間をフィルターバブルに閉じ込めているため、
私たちの思考は、限られた情報によって形作られます。より多様な情報にアクセスできれば、視野は広がり、偏見も減るはずです。
だからこそ、多情報源から事件を見られるメディアモデルR Selectedを開発しました。

**Features**
- 事件を進展によりフェーズを分け、そのフェーズにおいて発信された異なるメディアの報道を収集し展示する。
- 多情報源から各マスメディアの報道傾向を視覚的に比較でき、かつ単一情報源やアルゴリズムによるフィルターバブルを回避。
- 編集者用のシステムも開発され、報道、事件の整理・分類をサポート。

**Tech Stack**
- **Front**：`TypeScript` `Angular` `Vue`
- **Back**：`Java` `SpringBoot` `MySQL`
- **Deploy**：`AWS EC2` `Docker` `Nginx`


**Link**  
<https://www.r-selected.com>

**ScreenShot**  

|  ScreenShot   | Description  |
|  ----  | ----  |
| <div align="center"><img src="https://github.com/user-attachments/assets/d9234ec6-445e-467a-82bd-bc5e5db4021c" width="800px"></div>  | ホームページ |
|  <div align="center"><img src="https://github.com/user-attachments/assets/ae6381d3-6c92-455f-b183-4347c89bab51" width="800px"></div>  | 編集システムの事件管理ページ |
| <div align="center"><img src="https://github.com/user-attachments/assets/cf395cac-6656-4ad8-b1cb-5707ef84ac85" width="800px"></div>  | 編集システムの事件編集ページ |
|  ... | ...  |
  
---

###  🔸**Self Confirmation**
ナラティブ・セラピー理論に基づいた生成AI会話機能搭載のセルフヘルプアプリ。

**Background**  
>  生成AIの発展により、私はその心理カウンセリング分野での可能性に注目しました。
ナラティブ・セラピーは、自らの物語を語ることで心を整理し、癒やしを得る手法です。AIを活用すれば、より多くの人が気軽に自己表現し、心のケアができるのではないかと考えました。
その思いから、Self Confirmationを開発しました。

**Features**
-  AIアシスタントの会話ガイダンスを通じて、ユーザーに最近の日常生活における出来事、感情に影響を与えた経験を振り返るよう導く。
- ユーザーが述べた出来事に基づき、その原因や結果、現在の状況への影響を整理。さらに、その出来事から表したユーザーの性格や心理的なニーズを分析。
- 以上の分析結果に基づいて、ユーザーの心理的ニーズや性格を考慮した将来の行動提案を提供。

**Tech Stack**
- **Front**：`TypeScript` `Vue.js`
- **Back**：`Python` `MySQL`
- **AI Model**：`Grok` `OpenAi`（モデルを比較して試している）

**▪️ScreenShot**
 
|  ScreenShot   | Description  |  
|  ----  | ----  |
| <div align="center"><img src="https://github.com/user-attachments/assets/42c9b3dd-0767-4fc5-856c-adfa240f3060" width="800px"></div>  | ホーム、反省履歴、会話ページ |
|  ... | ...  |

---

### 🔸 **SpellSnatch**
スペルの音声認識で英単語を翻訳するiOSアプリ。本アプリは生成AIコーディングツールを活用し開発したものです。

**Background**  
>  英小説の読書を通じて英語を学習する際に、意味分からない単語に頻繁に出てきています。手で単語を入力し調べる方法は、読書のリズムが崩れ、調べ終わるとどこまで読んでいたか忘れてしまうこともよくあります。
そこで、最小限の操作で単語の意味を素早く確認できるSpellSnatchを開発しています。

**Features**
- 単語の発音が分からなくてもアルファベットのスペルだけで音声認識で英単語を翻訳
- 英語書籍を読む際、手で入力するなど読書のリズムが乱されることを避けるため辞書検索の手間を軽減

**Tech Stack**
- **Front**：`Swift` `SwiftUI`
- **Voice Recognition**：`Apple Speech Framework`

**▪️ScreenShot**
 
|  ScreenShot   | Description  |  
|  ----  | ----  |
| <div align="center"><img src="https://github.com/user-attachments/assets/05235745-5ffe-4c7c-bdf7-c3ad3ea5137c" width="400px"></div>  | ホームページ |
|  ... | ...  |


---

## **プロジェクトの実行方法**
このリポジトリには Web と iOS アプリが含まれています。

**🖥️ Web プロジェクトの実行方法**

1. **リポジトリをクローン**
   ```sh
   git clone https://github.com/rfb4c/Rui-s-Profolio.git
   cd Rui-s-Profiles
   ```
2. **対象プロジェクトへ移動**
   ```sh
   cd RSelected-Editor  # または、Self Confirmation 
   ```
3. **依存関係をインストール**
   ```sh
   npm install
   ```
4. **プロジェクトを起動**
   ```sh
   npm run dev
   ```

**📱 iOS プロジェクトの実行方法**

1. **リポジトリをクローン**
   ```sh
   git clone https://github.com/rfb4c/Rui-s-Profolio.git
   cd Rui-s-Profolio
   ```
   
2. **対象プロジェクトへ移動**
   ```sh
   cd SpellSnatch
   ```
   
3. **Xcode の起動**
   ```sh
   open SpellSnatch.xcworkspace
   .xcworkspace がない場合、.xcodeproj を開く
   open SpellSnatch.xcodeproj
   ```

4. **プロジェクトの実行**
- Xcode で シミュレーター (例: iPhone 16) を選択
- Run ▶️ ボタンを押すか Cmd + R
